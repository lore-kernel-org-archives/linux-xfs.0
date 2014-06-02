Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 534647F54
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 19:28:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 047A18F8039
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 17:28:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Vv0SqXgvLbC9eZIq for <xfs@oss.sgi.com>;
	Sun, 01 Jun 2014 17:28:27 -0700 (PDT)
Date: Mon, 2 Jun 2014 10:28:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140602002822.GQ14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<5389252A.5050503@zytor.com> <20140531011450.GJ14410@dastard>
	<5507340.nVBP5LFtqn@wuerfel> <20140601002437.GL14410@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140601002437.GL14410@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, lftan@altera.com, hch@infradead.org, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com

On Sun, Jun 01, 2014 at 10:24:37AM +1000, Dave Chinner wrote:
> On Sat, May 31, 2014 at 05:37:52PM +0200, Arnd Bergmann wrote:
> > In my list at http://kernelnewbies.org/y2038, I found that almost
> > all file systems at least times until 2106, because they treat
> > the on-disk value as unsigned on 64-bit systems, or they use
> > a completely different representation. My guess is that somebody
> > earlier spent a lot of work on making that happen.
> > 
> > The exceptions are:
> > 
> > * exofs uses signed values, which can probably be changed to be
> >   consistent with the others.
> > * isofs has a bug that limits it until 2027 on architectures with
> >   a signed 'char' type (otherwise it's 2155).
> > * udf can represent times for many thousands of years through a
> >   16-bit year representation, but the code to convert to epoch
> >   uses a const array that ends at 2038.
> > * afs uses signed seconds and can probably be fixed
> > * coda relies on user space time representation getting passed
> >   through an ioctl.
> > * I miscategorized xfs/ext2/ext3 as having unsigned 32-bit seconds,
> >   where they really use signed.
> > 
> > I was confused about XFS since I didn't noticed that there are
> > separate xfs_ictimestamp_t and xfs_timestamp_t types, so I expected
> > XFS to also use the 1970-2106 time range on 64-bit systems today.
> 
> You've missed an awful lot more than just the implications for the
> core kernel code.
> 
> There's a good chance such changes propagate to APIs elsewhere in
> the filesystems, because something you haven't realised is that XFS
> effectively exposes the on-disk timestamp format directly to
> userspace via the bulkstat interface (see struct xfs_bstat). It also
> affects the XFS open-by-handle ioctl and the swap extent ioctl used
> by the online defragmenter.
> 
> IOWs, if we are changing the on-disk timestamp format then this
> affects several ioctl()s and hence quite a few of the XFS userspace
> utilities. The hardest to fix will be xfsdump which would need a new
> dump format to store the extended timestamp ranges, and then
> xfs_restore will need to be able to handle restoring such timestamps
> on filesystems that don't have extended timestamp support...
> 
> Put simply, changing the structure of system time isn't as straight
> forward as changing the kernel structures. System time gets stored
> permanently, and that has a cascade effect through the kernel all
> to all of the filesystem utilities that know about that permanent
> storage in some way....
> 
> So yes, you can change the kernel definition, but until the
> permanent storage of system time can be extended to support the same
> range as the kernel the *system* will still have nasty, silent epoch
> overflow, truncation or corruption issues.

Just to put that in context, here's the kernel patch to add extended
epoch support to XFS. It's completely untested as I haven't done any
userspace code changes to enable the feature. However, it should
give you an indication of how far the simple act of changing the
kernel time representation spread through the filesystem. This does
not include any of the VFS infrastructure to specifying the range of
supported timestamps.  It survives some smoke testing, but dies when
the online defragmenter starts using the bulkstat and swap extent
ioctls (the assert in xfs_inode_time_from_epoch() fires), so I
probably don't have that all sorted correctly yet...

To test extended epoch support, however, I need to some fstests that
define and validate the behaviour of the new syscalls - until we get
those we can't validate that the filesystem follows the spec
properly. I also suspect we are going to need an interface to query
the supported range of timestamps from a filesystem so that we can
test boundary conditions in an automated fashion....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: support timestamps beyond Unix epochs

From: Dave Chinner <dchinner@redhat.com>

The 32 bit second counters in timestamps are too small to represent
time beyond the unix epoch (jan 2038) correctly. Extend the on-disk
format for a timestamp to include an 8-bit epoch counter so that we
can extend time for up to 255 Unix epochs. This should be good for
representing timestamps from 1970 to somewhere around 19,000 A.D....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/time.h            |  7 ------
 fs/xfs/xfs_bmap_util.c   | 35 +++++++++++++++++-----------
 fs/xfs/xfs_dinode.h      | 48 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_fs.h          |  9 +++++++-
 fs/xfs/xfs_fsops.c       |  5 +++-
 fs/xfs/xfs_inode.c       | 16 ++++++++++---
 fs/xfs/xfs_inode_buf.c   |  8 +++++++
 fs/xfs/xfs_ioctl32.c     |  3 +++
 fs/xfs/xfs_ioctl32.h     |  5 +++-
 fs/xfs/xfs_iops.c        | 59 +++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_itable.c      | 12 ++++++++++
 fs/xfs/xfs_log_format.h  |  4 ++++
 fs/xfs/xfs_sb.h          | 12 +++++++++-
 fs/xfs/xfs_trans_inode.c |  2 +-
 14 files changed, 175 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/time.h b/fs/xfs/time.h
index 387e695..9f38d60 100644
--- a/fs/xfs/time.h
+++ b/fs/xfs/time.h
@@ -21,16 +21,9 @@
 #include <linux/sched.h>
 #include <linux/time.h>
 
-typedef struct timespec timespec_t;
-
 static inline void delay(long ticks)
 {
 	schedule_timeout_uninterruptible(ticks);
 }
 
-static inline void nanotime(struct timespec *tvp)
-{
-	*tvp = CURRENT_TIME;
-}
-
 #endif /* __XFS_SUPPORT_TIME_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 703b3ec..dbc9a74 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1686,6 +1686,7 @@ xfs_swap_extents(
 	int		aforkblks = 0;
 	int		taforkblks = 0;
 	__uint64_t	tmp;
+	struct timespec tv;
 
 	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
 	if (!tempifp) {
@@ -1746,25 +1747,33 @@ xfs_swap_extents(
 	}
 
 	/*
-	 * Compare the current change & modify times with that
-	 * passed in.  If they differ, we abort this swap.
-	 * This is the mechanism used to ensure the calling
-	 * process that the file was not changed out from
+	 * Compare the current change & modify times with that passed in.  If
+	 * they differ, we abort this swap.  This is the mechanism used to
+	 * ensure the calling process that the file was not changed out from
 	 * under it.
 	 */
-	if ((sbp->bs_ctime.tv_sec != VFS_I(ip)->i_ctime.tv_sec) ||
-	    (sbp->bs_ctime.tv_nsec != VFS_I(ip)->i_ctime.tv_nsec) ||
-	    (sbp->bs_mtime.tv_sec != VFS_I(ip)->i_mtime.tv_sec) ||
-	    (sbp->bs_mtime.tv_nsec != VFS_I(ip)->i_mtime.tv_nsec)) {
+	tv.tv_sec = xfs_inode_time_from_epoch(sbp->bs_ctime.tv_sec,
+						sbp->bs_ctime_epoch);
+	tv.tv_nsec = sbp->bs_ctime.tv_nsec;
+	if (timespec_compare(&tv, &VFS_I(ip)->i_ctime)) {
 		error = XFS_ERROR(EBUSY);
 		goto out_unlock;
 	}
 
-	/* We need to fail if the file is memory mapped.  Once we have tossed
-	 * all existing pages, the page fault will have no option
-	 * but to go to the filesystem for pages. By making the page fault call
-	 * vop_read (or write in the case of autogrow) they block on the iolock
-	 * until we have switched the extents.
+	tv.tv_sec = xfs_inode_time_from_epoch(sbp->bs_mtime.tv_sec,
+						sbp->bs_mtime_epoch);
+	tv.tv_nsec = sbp->bs_mtime.tv_nsec;
+	if (timespec_compare(&tv, &VFS_I(ip)->i_mtime)) {
+		error = XFS_ERROR(EBUSY);
+		goto out_unlock;
+	}
+
+	/*
+	 * We need to fail if the file is memory mapped.  Once we have tossed
+	 * all existing pages, the page fault will have no option but to go to
+	 * the filesystem for pages. By making the page fault call vop_read (or
+	 * write in the case of autogrow) they block on the iolock until we have
+	 * switched the extents.
 	 */
 	if (VN_MAPPED(VFS_I(ip))) {
 		error = XFS_ERROR(EBUSY);
diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
index 623bbe8..79f94722 100644
--- a/fs/xfs/xfs_dinode.h
+++ b/fs/xfs/xfs_dinode.h
@@ -21,11 +21,53 @@
 #define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
 #define XFS_DINODE_GOOD_VERSION(v)	((v) >= 1 && (v) <= 3)
 
+/*
+ * Inode timestamps get more complex when we consider supporting times beyond
+ * the standard unix epoch of Jan 2038. The struct xfs_timestamp cannot support
+ * more than a single extension by playing sign games, and that is still not
+ * reliable. We also can't extend the timestamp structure because there is no
+ * free space around them in the on-disk inode.
+ *
+ * Hence the simplest thing to do is to add an epoch counter for each timestamp
+ * in the inode. This can be a single byte for each timestamp and make use of
+ * a hole we currently pad. This gives us another 255 epochs range for the
+ * timestamps, but requires a superblock feature bit to indicate that these
+ * fields have meaning and can be non-zero.
+ *
+ * Provide wrapper functions for converting the kernel inode time format to
+ * the on-disk fields. The nanosecond counter is unlikely to change in future,
+ * so it's mostly just for the second+epoch counter conversion.
+ */
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
 } xfs_timestamp_t;
 
+static inline __uint8_t
+xfs_timestamp_epoch(
+	struct timespec		*time)
+{
+	/* will be zero until the extended struct inode_time is introduced */
+	return 0;
+}
+
+static inline __int32_t
+xfs_timestamp_sec(
+	struct timespec		*time)
+{
+	return time->tv_sec;
+}
+
+static inline __kernel_time_t
+xfs_inode_time_from_epoch(
+	__uint8_t	epoch,
+	__int32_t	seconds)
+{
+	/* need to handle non-zero epoch when struct inode_time is introduced */
+	ASSERT(epoch == 0);
+	return seconds;
+}
+
 /*
  * On-disk inode structure.
  *
@@ -54,7 +96,11 @@ typedef struct xfs_dinode {
 	__be32		di_nlink;	/* number of links to file */
 	__be16		di_projid_lo;	/* lower part of owner's project id */
 	__be16		di_projid_hi;	/* higher part owner's project id */
-	__u8		di_pad[6];	/* unused, zeroed space */
+	__u8		di_atime_epoch;	/* access time epoch */
+	__u8		di_mtime_epoch;	/* modify time epoch */
+	__u8		di_ctime_epoch;	/* change time epoch */
+	__u8		di_crtime_epoch;/* create time epoch */
+	__u8		di_pad[2];	/* unused, zeroed space */
 	__be16		di_flushiter;	/* incremented on flush */
 	xfs_timestamp_t	di_atime;	/* time last accessed */
 	xfs_timestamp_t	di_mtime;	/* time last modified */
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index d34703d..fb0a0ea 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
 #define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
 #define XFS_FSOP_GEOM_FLAGS_FINOBT	0x20000	/* free inode btree */
+#define XFS_FSOP_GEOM_FLAGS_EPOCH	0x40000	/* timestamp epochs */
 
 /*
  * Minimum and maximum sizes need for growth checks.
@@ -280,6 +281,9 @@ typedef struct xfs_growfs_rt {
 
 /*
  * Structures returned from ioctl XFS_IOC_FSBULKSTAT & XFS_IOC_FSBULKSTAT_SINGLE
+ *
+ * Time epoch structures are only used if the XFS_FSOP_GEOM_FLAGS_EPOCH flag is
+ * asserted in the geometry output.
  */
 typedef struct xfs_bstime {
 	time_t		tv_sec;		/* seconds		*/
@@ -307,7 +311,10 @@ typedef struct xfs_bstat {
 #define	bs_projid	bs_projid_lo	/* (previously just bs_projid)	*/
 	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
 	__u16		bs_projid_hi;	/* higher part of project id	*/
-	unsigned char	bs_pad[10];	/* pad space, unused		*/
+	__u8		bs_atime_epoch;	/* access time epoch */
+	__u8		bs_mtime_epoch;	/* modify time epoch */
+	__u8		bs_ctime_epoch;	/* change time epoch */
+	unsigned char	bs_pad[7];	/* pad space, unused		*/
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index d229556..7b8db57 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -103,7 +103,10 @@ xfs_fs_geometry(
 			(xfs_sb_version_hasftype(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_FTYPE : 0) |
 			(xfs_sb_version_hasfinobt(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_FINOBT : 0);
+				XFS_FSOP_GEOM_FLAGS_FINOBT : 0) |
+			(xfs_sb_version_hasepoch(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_EPOCH : 0);
+
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a6115fe..eecae93 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -654,7 +654,8 @@ xfs_ialloc(
 	xfs_inode_t	*ip;
 	uint		flags;
 	int		error;
-	timespec_t	tv;
+	struct timespec	tv;
+	bool		has_epoch;
 
 	/*
 	 * Call the space management code to pick
@@ -720,12 +721,19 @@ xfs_ialloc(
 	ip->i_d.di_nextents = 0;
 	ASSERT(ip->i_d.di_nblocks == 0);
 
-	nanotime(&tv);
-	ip->i_d.di_mtime.t_sec = (__int32_t)tv.tv_sec;
+	has_epoch = xfs_sb_version_hasepoch(&mp->m_sb);
+	tv = current_fs_time(mp->m_super);
+	ip->i_d.di_mtime.t_sec = xfs_timestamp_sec(&tv);
 	ip->i_d.di_mtime.t_nsec = (__int32_t)tv.tv_nsec;
 	ip->i_d.di_atime = ip->i_d.di_mtime;
 	ip->i_d.di_ctime = ip->i_d.di_mtime;
 
+	if (has_epoch) {
+		ip->i_d.di_mtime_epoch = xfs_timestamp_epoch(&tv);
+		ip->i_d.di_atime_epoch = ip->i_d.di_mtime_epoch;
+		ip->i_d.di_ctime_epoch = ip->i_d.di_mtime_epoch;
+	}
+
 	/*
 	 * di_gen will have been taken care of in xfs_iread.
 	 */
@@ -743,6 +751,8 @@ xfs_ialloc(
 		ip->i_d.di_flags2 = 0;
 		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
 		ip->i_d.di_crtime = ip->i_d.di_mtime;
+		if (has_epoch)
+			ip->i_d.di_crtime_epoch = ip->i_d.di_mtime_epoch;
 	}
 
 
diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
index cb35ae4..0459e3d 100644
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -208,6 +208,10 @@ xfs_dinode_from_disk(
 	to->di_nlink = be32_to_cpu(from->di_nlink);
 	to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
 	to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
+	to->di_atime_epoch = from->di_atime_epoch;
+	to->di_mtime_epoch = from->di_mtime_epoch;
+	to->di_ctime_epoch = from->di_ctime_epoch;
+	to->di_crtime_epoch = from->di_crtime_epoch;
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 	to->di_atime.t_sec = be32_to_cpu(from->di_atime.t_sec);
@@ -255,6 +259,10 @@ xfs_dinode_to_disk(
 	to->di_nlink = cpu_to_be32(from->di_nlink);
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
+	to->di_atime_epoch = from->di_atime_epoch;
+	to->di_mtime_epoch = from->di_mtime_epoch;
+	to->di_ctime_epoch = from->di_ctime_epoch;
+	to->di_crtime_epoch = from->di_crtime_epoch;
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
 	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 944d5ba..215324f 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -161,6 +161,9 @@ xfs_ioctl32_bstat_copyin(
 	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
 	    get_user(bstat->bs_projid_lo, &bstat32->bs_projid_lo) ||
 	    get_user(bstat->bs_projid_hi, &bstat32->bs_projid_hi) ||
+	    get_user(bstat->bs_atime_epoch, &bstat32->bs_atime_epoch) ||
+	    get_user(bstat->bs_mtime_epoch, &bstat32->bs_mtime_epoch) ||
+	    get_user(bstat->bs_ctime_epoch, &bstat32->bs_ctime_epoch) ||
 	    get_user(bstat->bs_dmevmask, &bstat32->bs_dmevmask)	||
 	    get_user(bstat->bs_dmstate,	&bstat32->bs_dmstate)	||
 	    get_user(bstat->bs_aextents, &bstat32->bs_aextents))
diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
index 80f4060..2a35c62 100644
--- a/fs/xfs/xfs_ioctl32.h
+++ b/fs/xfs/xfs_ioctl32.h
@@ -68,7 +68,10 @@ typedef struct compat_xfs_bstat {
 	__u16		bs_projid_lo;	/* lower part of project id	*/
 #define	bs_projid	bs_projid_lo	/* (previously just bs_projid)	*/
 	__u16		bs_projid_hi;	/* high part of project id	*/
-	unsigned char	bs_pad[12];	/* pad space, unused		*/
+	__u8		bs_atime_epoch;	/* access time epoch */
+	__u8		bs_mtime_epoch;	/* modify time epoch */
+	__u8		bs_ctime_epoch;	/* change time epoch */
+	unsigned char	bs_pad[9];	/* pad space, unused		*/
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 205613a..0588381 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -505,23 +505,34 @@ xfs_setattr_time(
 	struct iattr		*iattr)
 {
 	struct inode		*inode = VFS_I(ip);
+	bool			has_epoch;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
+	has_epoch = xfs_sb_version_hasepoch(&ip->i_mount->m_sb);
 	if (iattr->ia_valid & ATTR_ATIME) {
 		inode->i_atime = iattr->ia_atime;
-		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
-		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
+		ip->i_d.di_atime.t_sec = xfs_timestamp_sec(&iattr->ia_atime);
+		ip->i_d.di_atime.t_nsec = (__int32_t)iattr->ia_atime.tv_nsec;
+		if (has_epoch)
+			ip->i_d.di_atime_epoch =
+					xfs_timestamp_epoch(&iattr->ia_atime);
 	}
 	if (iattr->ia_valid & ATTR_CTIME) {
 		inode->i_ctime = iattr->ia_ctime;
-		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
-		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
+		ip->i_d.di_ctime.t_sec = xfs_timestamp_sec(&iattr->ia_ctime);
+		ip->i_d.di_ctime.t_nsec = (__int32_t)iattr->ia_ctime.tv_nsec;
+		if (has_epoch)
+			ip->i_d.di_ctime_epoch =
+					xfs_timestamp_epoch(&iattr->ia_ctime);
 	}
 	if (iattr->ia_valid & ATTR_MTIME) {
 		inode->i_mtime = iattr->ia_mtime;
-		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
-		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
+		ip->i_d.di_mtime.t_sec = xfs_timestamp_sec(&iattr->ia_mtime);
+		ip->i_d.di_mtime.t_nsec = (__int32_t)iattr->ia_mtime.tv_nsec;
+		if (has_epoch)
+			ip->i_d.di_mtime_epoch =
+					xfs_timestamp_epoch(&iattr->ia_mtime);
 	}
 }
 
@@ -963,6 +974,7 @@ xfs_vn_update_time(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	int			error;
+	struct iattr		iattr = {0};
 
 	trace_xfs_update_time(ip);
 
@@ -975,20 +987,19 @@ xfs_vn_update_time(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (flags & S_CTIME) {
-		inode->i_ctime = *now;
-		ip->i_d.di_ctime.t_sec = (__int32_t)now->tv_sec;
-		ip->i_d.di_ctime.t_nsec = (__int32_t)now->tv_nsec;
+		iattr.ia_valid |= ATTR_CTIME;
+		iattr.ia_ctime = *now;
 	}
 	if (flags & S_MTIME) {
-		inode->i_mtime = *now;
-		ip->i_d.di_mtime.t_sec = (__int32_t)now->tv_sec;
-		ip->i_d.di_mtime.t_nsec = (__int32_t)now->tv_nsec;
+		iattr.ia_valid |= ATTR_MTIME;
+		iattr.ia_mtime = *now;
 	}
 	if (flags & S_ATIME) {
-		inode->i_atime = *now;
-		ip->i_d.di_atime.t_sec = (__int32_t)now->tv_sec;
-		ip->i_d.di_atime.t_nsec = (__int32_t)now->tv_nsec;
+		iattr.ia_valid |= ATTR_ATIME;
+		iattr.ia_atime = *now;
 	}
+	xfs_setattr_time(ip, &iattr);
+
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
 	return -xfs_trans_commit(tp, 0);
@@ -1239,12 +1250,18 @@ xfs_setup_inode(
 
 	inode->i_generation = ip->i_d.di_gen;
 	i_size_write(inode, ip->i_d.di_size);
-	inode->i_atime.tv_sec	= ip->i_d.di_atime.t_sec;
-	inode->i_atime.tv_nsec	= ip->i_d.di_atime.t_nsec;
-	inode->i_mtime.tv_sec	= ip->i_d.di_mtime.t_sec;
-	inode->i_mtime.tv_nsec	= ip->i_d.di_mtime.t_nsec;
-	inode->i_ctime.tv_sec	= ip->i_d.di_ctime.t_sec;
-	inode->i_ctime.tv_nsec	= ip->i_d.di_ctime.t_nsec;
+	inode->i_atime.tv_sec = xfs_inode_time_from_epoch(
+						ip->i_d.di_atime_epoch,
+						ip->i_d.di_atime.t_sec);
+	inode->i_atime.tv_nsec = ip->i_d.di_atime.t_nsec;
+	inode->i_mtime.tv_sec = xfs_inode_time_from_epoch(
+						ip->i_d.di_mtime_epoch,
+						ip->i_d.di_mtime.t_sec);
+	inode->i_mtime.tv_nsec = ip->i_d.di_mtime.t_nsec;
+	inode->i_ctime.tv_sec = xfs_inode_time_from_epoch(
+						ip->i_d.di_ctime_epoch,
+						ip->i_d.di_ctime.t_sec);
+	inode->i_ctime.tv_nsec = ip->i_d.di_ctime.t_nsec;
 	xfs_diflags_to_iflags(inode, ip);
 
 	ip->d_ops = ip->i_mount->m_nondir_inode_ops;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index cb64f22..e902418 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -97,12 +97,24 @@ xfs_bulkstat_one_int(
 	buf->bs_uid = dic->di_uid;
 	buf->bs_gid = dic->di_gid;
 	buf->bs_size = dic->di_size;
+
+	/* timestamp epochs are emitted only when configured */
 	buf->bs_atime.tv_sec = dic->di_atime.t_sec;
 	buf->bs_atime.tv_nsec = dic->di_atime.t_nsec;
 	buf->bs_mtime.tv_sec = dic->di_mtime.t_sec;
 	buf->bs_mtime.tv_nsec = dic->di_mtime.t_nsec;
 	buf->bs_ctime.tv_sec = dic->di_ctime.t_sec;
 	buf->bs_ctime.tv_nsec = dic->di_ctime.t_nsec;
+	if (xfs_sb_version_hasepoch(&mp->m_sb)) {
+		buf->bs_atime_epoch = dic->di_atime_epoch;
+		buf->bs_mtime_epoch = dic->di_mtime_epoch;
+		buf->bs_ctime_epoch = dic->di_ctime_epoch;
+	} else {
+		buf->bs_atime_epoch = 0;
+		buf->bs_mtime_epoch = 0;
+		buf->bs_ctime_epoch = 0;
+	}
+
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize = dic->di_extsize << mp->m_sb.sb_blocklog;
 	buf->bs_extents = dic->di_nextents;
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index f0969c7..abac6ad 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -374,6 +374,10 @@ typedef struct xfs_icdinode {
 	__uint32_t	di_nlink;	/* number of links to file */
 	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
+	__uint8_t	di_atime_epoch;	/* access time epoch */
+	__uint8_t	di_mtime_epoch;	/* modify time epoch */
+	__uint8_t	di_ctime_epoch;	/* change time epoch */
+	__uint8_t	di_crtime_epoch;/* create time epoch */
 	__uint8_t	di_pad[6];	/* unused, zeroed space */
 	__uint16_t	di_flushiter;	/* incremented on flush */
 	xfs_ictimestamp_t di_atime;	/* time last accessed */
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index c43c2d6..1b3ccd8 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -509,8 +509,11 @@ xfs_sb_has_ro_compat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
+#define XFS_SB_FEAT_INCOMPAT_EPOCH	(1 << 1)	/* Time beyond 2038 */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
-		(XFS_SB_FEAT_INCOMPAT_FTYPE)
+		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
+		 XFS_SB_FEAT_INCOMPAT_EPOCH | \
+		 0)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
@@ -558,6 +561,13 @@ static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
 }
 
+static inline int xfs_sb_version_hasepoch(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_EPOCH);
+}
+
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 50c3f56..cdb4d86 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -70,7 +70,7 @@ xfs_trans_ichgtime(
 	int			flags)
 {
 	struct inode		*inode = VFS_I(ip);
-	timespec_t		tv;
+	struct timespec		tv;
 
 	ASSERT(tp);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
