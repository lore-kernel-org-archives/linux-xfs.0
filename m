Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4898C7E37
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:37:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1E3EAC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:49 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id taS9qcAhY5GZiF1f (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:47 -0700 (PDT)
Subject: [PATCH 53/71] xfs: create a separate cow extent size hint for the
	allocator
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:37:42 -0700
Message-ID: <147216826262.867.2724089755289094058.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Create a per-inode extent size allocator hint for copy-on-write.  This
hint is separate from the existing extent size hint so that CoW can
take advantage of the fragmentation-reducing properties of extent size
hints without disabling delalloc for regular writes.

The extent size hint that's fed to the allocator during a copy on
write operation is the greater of the cowextsize and regular extsize
hint.

During reflink, if we're sharing the entire source file to the entire
destination file and the destination file doesn't already have a
cowextsize hint, propagate the source file's cowextsize hint to the
destination file.

Furthermore, zero the bulkstat buffer prior to setting the fields
so that we don't copy kernel memory contents into userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |   13 +++++++-
 fs/xfs/libxfs/xfs_format.h     |    3 +-
 fs/xfs/libxfs/xfs_fs.h         |    3 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |    4 ++
 fs/xfs/libxfs/xfs_inode_buf.h  |    1 +
 fs/xfs/libxfs/xfs_log_format.h |    3 +-
 fs/xfs/xfs_bmap_util.c         |    9 ++++-
 fs/xfs/xfs_inode.c             |   33 ++++++++++++++++++++
 fs/xfs/xfs_inode.h             |    1 +
 fs/xfs/xfs_inode_item.c        |    2 +
 fs/xfs/xfs_ioctl.c             |   67 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_iomap.c             |    5 ++-
 fs/xfs/xfs_itable.c            |    8 ++++-
 fs/xfs/xfs_reflink.c           |   36 +++++++++++++++++----
 14 files changed, 168 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7c5d0b1..76b3a0f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3665,7 +3665,13 @@ xfs_bmap_btalloc(
 	else if (mp->m_dalign)
 		stripe_align = mp->m_dalign;
 
-	align = ap->userdata ? xfs_get_extsz_hint(ap->ip) : 0;
+	if (ap->userdata) {
+		if (ap->flags & XFS_BMAPI_COWFORK)
+			align = xfs_get_cowextsz_hint(ap->ip);
+		else
+			align = xfs_get_extsz_hint(ap->ip);
+	} else
+		align = 0;
 	if (unlikely(align)) {
 		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 						align, 0, ap->eof, 0, ap->conv,
@@ -4179,7 +4185,10 @@ xfs_bmapi_reserve_delalloc(
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 
 	/* Figure out the extent size, adjust alen */
-	extsz = xfs_get_extsz_hint(ip);
+	if (whichfork == XFS_COW_FORK)
+		extsz = xfs_get_cowextsz_hint(ip);
+	else
+		extsz = xfs_get_extsz_hint(ip);
 	if (extsz) {
 		error = xfs_bmap_extsize_align(mp, got, prev, extsz, rt, eof,
 					       1, 0, &aoff, &alen);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 022ae27..4f2a354 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -900,7 +900,8 @@ typedef struct xfs_dinode {
 	__be64		di_changecount;	/* number of attribute changes */
 	__be64		di_lsn;		/* flush sequence */
 	__be64		di_flags2;	/* more random flags */
-	__u8		di_pad2[16];	/* more padding for future expansion */
+	__be32		di_cowextsize;	/* basic cow extent size for file */
+	__u8		di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_timestamp_t	di_crtime;	/* time created */
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b1af423..10ebf99 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -278,7 +278,8 @@ typedef struct xfs_bstat {
 #define	bs_projid	bs_projid_lo	/* (previously just bs_projid)	*/
 	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
 	__u16		bs_projid_hi;	/* higher part of project id	*/
-	unsigned char	bs_pad[10];	/* pad space, unused		*/
+	unsigned char	bs_pad[6];	/* pad space, unused		*/
+	__u32		bs_cowextsize;	/* cow extent size		*/
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 44f325c..2efa42c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -267,6 +267,7 @@ xfs_inode_from_disk(
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
+		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
 }
 
@@ -316,7 +317,7 @@ xfs_inode_to_disk(
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
-
+		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
@@ -368,6 +369,7 @@ xfs_log_dinode_to_disk(
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
+		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
 		to->di_lsn = cpu_to_be64(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 958c543..6848a0a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -47,6 +47,7 @@ struct xfs_icdinode {
 	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 
 	__uint64_t	di_flags2;	/* more random flags */
+	__uint32_t	di_cowextsize;	/* basic cow extent size for file */
 
 	xfs_ictimestamp_t di_crtime;	/* time created */
 };
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index fffcc0f..d788d01 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -423,7 +423,8 @@ struct xfs_log_dinode {
 	__uint64_t	di_changecount;	/* number of attribute changes */
 	xfs_lsn_t	di_lsn;		/* flush sequence */
 	__uint64_t	di_flags2;	/* more random flags */
-	__uint8_t	di_pad2[16];	/* more padding for future expansion */
+	__uint32_t	di_cowextsize;	/* basic cow extent size for file */
+	__uint8_t	di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_ictimestamp_t di_crtime;	/* time created */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2ca62d1..62217e7 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -502,8 +502,13 @@ xfs_getbmap(
 		if (ip->i_cformat != XFS_DINODE_FMT_EXTENTS)
 			return -EINVAL;
 
-		prealloced = 0;
-		fixlen = XFS_ISIZE(ip);
+		if (xfs_get_cowextsz_hint(ip)) {
+			prealloced = 1;
+			fixlen = mp->m_super->s_maxbytes;
+		} else {
+			prealloced = 0;
+			fixlen = XFS_ISIZE(ip);
+		}
 		break;
 	default:
 		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d6ec1ec..26ce555 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -78,6 +78,27 @@ xfs_get_extsz_hint(
 }
 
 /*
+ * Helper function to extract CoW extent size hint from inode.
+ * Between the extent size hint and the CoW extent size hint, we
+ * return the greater of the two.
+ */
+xfs_extlen_t
+xfs_get_cowextsz_hint(
+	struct xfs_inode	*ip)
+{
+	xfs_extlen_t		a, b;
+
+	a = 0;
+	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+		a = ip->i_d.di_cowextsize;
+	b = xfs_get_extsz_hint(ip);
+
+	if (a > b)
+		return a;
+	return b;
+}
+
+/*
  * These two are wrapper routines around the xfs_ilock() routine used to
  * centralize some grungy code.  They are used in places that wish to lock the
  * inode solely for reading the extents.  The reason these places can't just
@@ -654,6 +675,8 @@ _xfs_dic2xflags(
 			flags |= FS_XFLAG_DAX;
 		if (di_flags2 & XFS_DIFLAG2_REFLINK)
 			flags |= FS_XFLAG_REFLINK;
+		if (di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+			flags |= FS_XFLAG_COWEXTSIZE;
 	}
 
 	if (has_attr)
@@ -837,6 +860,7 @@ xfs_ialloc(
 	if (ip->i_d.di_version == 3) {
 		inode->i_version = 1;
 		ip->i_d.di_flags2 = 0;
+		ip->i_d.di_cowextsize = 0;
 		ip->i_d.di_crtime.t_sec = (__int32_t)tv.tv_sec;
 		ip->i_d.di_crtime.t_nsec = (__int32_t)tv.tv_nsec;
 	}
@@ -899,6 +923,15 @@ xfs_ialloc(
 			ip->i_d.di_flags |= di_flags;
 			ip->i_d.di_flags2 |= di_flags2;
 		}
+		if (pip &&
+		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
+		    pip->i_d.di_version == 3 &&
+		    ip->i_d.di_version == 3) {
+			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
+				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
+			}
+		}
 		/* FALLTHROUGH */
 	case S_IFLNK:
 		ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7b2e858..73fc4ff 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -425,6 +425,7 @@ int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
 xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
+xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
 
 int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
 			       xfs_nlink_t, xfs_dev_t, prid_t, int,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 892c2ac..9610e9c 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -368,7 +368,7 @@ xfs_inode_to_log_dinode(
 		to->di_crtime.t_sec = from->di_crtime.t_sec;
 		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
 		to->di_flags2 = from->di_flags2;
-
+		to->di_cowextsize = from->di_cowextsize;
 		to->di_ino = ip->i_ino;
 		to->di_lsn = lsn;
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 97bb5b6..4d4531ee 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -904,6 +904,8 @@ xfs_ioc_fsgetxattr(
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	fa.fsx_xflags = xfs_ip2xflags(ip);
 	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
+	fa.fsx_cowextsize = ip->i_d.di_cowextsize <<
+			ip->i_mount->m_sb.sb_blocklog;
 	fa.fsx_projid = xfs_get_projid(ip);
 
 	if (attr) {
@@ -974,12 +976,13 @@ xfs_set_diflags(
 	if (ip->i_d.di_version < 3)
 		return;
 
-	di_flags2 = 0;
+	di_flags2 = (ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
 	if (xflags & FS_XFLAG_DAX)
 		di_flags2 |= XFS_DIFLAG2_DAX;
+	if (xflags & FS_XFLAG_COWEXTSIZE)
+		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 
 	ip->i_d.di_flags2 = di_flags2;
-
 }
 
 STATIC void
@@ -1220,6 +1223,56 @@ xfs_ioctl_setattr_check_extsize(
 	return 0;
 }
 
+/*
+ * CoW extent size hint validation rules are:
+ *
+ * 1. CoW extent size hint can only be set if reflink is enabled on the fs.
+ *    The inode does not have to have any shared blocks, but it must be a v3.
+ * 2. FS_XFLAG_COWEXTSIZE is only valid for directories and regular files;
+ *    for a directory, the hint is propagated to new files.
+ * 3. Can be changed on files & directories at any time.
+ * 4. CoW extsize hint of 0 turns off hints, clears inode flags.
+ * 5. Extent size must be a multiple of the appropriate block size.
+ * 6. The extent size hint must be limited to half the AG size to avoid
+ *    alignment extending the extent beyond the limits of the AG.
+ */
+static int
+xfs_ioctl_setattr_check_cowextsize(
+	struct xfs_inode	*ip,
+	struct fsxattr		*fa)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
+		return 0;
+
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
+	    ip->i_d.di_version != 3)
+		return -EINVAL;
+
+	if (!S_ISREG(VFS_I(ip)->i_mode) && !S_ISDIR(VFS_I(ip)->i_mode))
+		return -EINVAL;
+
+	if (fa->fsx_cowextsize != 0) {
+		xfs_extlen_t    size;
+		xfs_fsblock_t   cowextsize_fsb;
+
+		cowextsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
+		if (cowextsize_fsb > MAXEXTLEN)
+			return -EINVAL;
+
+		size = mp->m_sb.sb_blocksize;
+		if (cowextsize_fsb > mp->m_sb.sb_agblocks / 2)
+			return -EINVAL;
+
+		if (fa->fsx_cowextsize % size)
+			return -EINVAL;
+	} else
+		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
+
+	return 0;
+}
+
 static int
 xfs_ioctl_setattr_check_projid(
 	struct xfs_inode	*ip,
@@ -1316,6 +1369,10 @@ xfs_ioctl_setattr(
 	if (code)
 		goto error_trans_cancel;
 
+	code = xfs_ioctl_setattr_check_cowextsize(ip, fa);
+	if (code)
+		goto error_trans_cancel;
+
 	code = xfs_ioctl_setattr_xflags(tp, ip, fa);
 	if (code)
 		goto error_trans_cancel;
@@ -1351,6 +1408,12 @@ xfs_ioctl_setattr(
 		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
 	else
 		ip->i_d.di_extsize = 0;
+	if (ip->i_d.di_version == 3 &&
+	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
+		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
+				mp->m_sb.sb_blocklog;
+	else
+		ip->i_d.di_cowextsize = 0;
 
 	code = xfs_trans_commit(tp);
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 130010a..666bafc 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -591,7 +591,10 @@ __xfs_iomap_write_delay(
 	if (error)
 		return error;
 
-	extsz = xfs_get_extsz_hint(ip);
+	if (whichfork == XFS_COW_FORK)
+		extsz = xfs_get_cowextsz_hint(ip);
+	else
+		extsz = xfs_get_extsz_hint(ip);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
 	if (whichfork == XFS_DATA_FORK) {
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index ce73eb3..66e8817 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -66,7 +66,7 @@ xfs_bulkstat_one_int(
 	if (!buffer || xfs_internal_inum(mp, ino))
 		return -EINVAL;
 
-	buf = kmem_alloc(sizeof(*buf), KM_SLEEP | KM_MAYFAIL);
+	buf = kmem_zalloc(sizeof(*buf), KM_SLEEP | KM_MAYFAIL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -111,6 +111,12 @@ xfs_bulkstat_one_int(
 	buf->bs_aextents = dic->di_anextents;
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
 
+	if (dic->di_version == 3) {
+		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+			buf->bs_cowextsize = dic->di_cowextsize <<
+					mp->m_sb.sb_blocklog;
+	}
+
 	switch (dic->di_format) {
 	case XFS_DINODE_FMT_DEV:
 		buf->bs_rdev = ip->i_df.if_u2.if_rdev;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 368cc17..2caed8c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1049,18 +1049,19 @@ out_error:
 }
 
 /*
- * Update destination inode size, if necessary.
+ * Update destination inode size & cowextsize hint, if necessary.
  */
 STATIC int
 xfs_reflink_update_dest(
 	struct xfs_inode	*dest,
-	xfs_off_t		newlen)
+	xfs_off_t		newlen,
+	xfs_extlen_t		cowextsize)
 {
 	struct xfs_mount	*mp = dest->i_mount;
 	struct xfs_trans	*tp;
 	int			error;
 
-	if (newlen <= i_size_read(VFS_I(dest)))
+	if (newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0)
 		return 0;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
@@ -1070,9 +1071,17 @@ xfs_reflink_update_dest(
 	xfs_ilock(dest, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
 
-	trace_xfs_reflink_update_inode_size(dest, newlen);
-	i_size_write(VFS_I(dest), newlen);
-	dest->i_d.di_size = newlen;
+	if (newlen > i_size_read(VFS_I(dest))) {
+		trace_xfs_reflink_update_inode_size(dest, newlen);
+		i_size_write(VFS_I(dest), newlen);
+		dest->i_d.di_size = newlen;
+	}
+
+	if (cowextsize) {
+		dest->i_d.di_cowextsize = cowextsize;
+		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+	}
+
 	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
 
 	error = xfs_trans_commit(tp);
@@ -1389,6 +1398,7 @@ xfs_reflink_remap_range(
 	xfs_fileoff_t		sfsbno, dfsbno;
 	xfs_filblks_t		fsblen;
 	int			error;
+	xfs_extlen_t		cowextsize;
 	bool			is_same;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
@@ -1449,7 +1459,19 @@ xfs_reflink_remap_range(
 	if (error)
 		goto out_error;
 
-	error = xfs_reflink_update_dest(dest, destoff + len);
+	/*
+	 * Carry the cowextsize hint from src to dest if we're sharing the
+	 * entire source file to the entire destination file, the source file
+	 * has a cowextsize hint, and the destination file does not.
+	 */
+	cowextsize = 0;
+	if (srcoff == 0 && len == i_size_read(VFS_I(src)) &&
+	    (src->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    destoff == 0 && len >= i_size_read(VFS_I(dest)) &&
+	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
+		cowextsize = src->i_d.di_cowextsize;
+
+	error = xfs_reflink_update_dest(dest, destoff + len, cowextsize);
 	if (error)
 		goto out_error;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
