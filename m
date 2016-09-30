Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43099 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932259AbcI3DKw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:10:52 -0400
Subject: [PATCH 47/63] xfs: create a separate cow extent size hint for the
 allocator
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:10:46 -0700
Message-ID: <147520504603.29434.2895637557591026336.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

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
 fs/xfs/libxfs/xfs_bmap.c       |    9 ++++-
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
 fs/xfs/xfs_iomap.c             |    2 +
 fs/xfs/xfs_iomap.h             |    1 +
 fs/xfs/xfs_itable.c            |    8 ++++-
 fs/xfs/xfs_reflink.c           |   41 ++++++++++++++++++++----
 15 files changed, 167 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0ef7fb4..69a6ae6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3666,7 +3666,9 @@ xfs_bmap_btalloc(
 	else if (mp->m_dalign)
 		stripe_align = mp->m_dalign;
 
-	if (xfs_alloc_is_userdata(ap->datatype))
+	if (ap->flags & XFS_BMAPI_COWFORK)
+		align = xfs_get_cowextsz_hint(ap->ip);
+	else if (xfs_alloc_is_userdata(ap->datatype))
 		align = xfs_get_extsz_hint(ap->ip);
 	if (unlikely(align)) {
 		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
@@ -4184,7 +4186,10 @@ xfs_bmapi_reserve_delalloc(
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
index a7ae738..94f610a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -901,7 +901,8 @@ typedef struct xfs_dinode {
 	__be64		di_changecount;	/* number of attribute changes */
 	__be64		di_lsn;		/* flush sequence */
 	__be64		di_flags2;	/* more random flags */
-	__u8		di_pad2[16];	/* more padding for future expansion */
+	__be32		di_cowextsize;	/* basic cow extent size for file */
+	__u8		di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_timestamp_t	di_crtime;	/* time created */
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 3d1efe5..b72dc82 100644
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
index 4b9769e..a3e8038 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -256,6 +256,7 @@ xfs_inode_from_disk(
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
+		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
 }
 
@@ -305,7 +306,7 @@ xfs_inode_to_disk(
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
-
+		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
@@ -357,6 +358,7 @@ xfs_log_dinode_to_disk(
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
+		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
 		to->di_lsn = cpu_to_be64(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 7c4dd32..62d9d46 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -47,6 +47,7 @@ struct xfs_icdinode {
 	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 
 	__uint64_t	di_flags2;	/* more random flags */
+	__uint32_t	di_cowextsize;	/* basic cow extent size for file */
 
 	xfs_ictimestamp_t di_crtime;	/* time created */
 };
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 5dd7c2e..364ce6f 100644
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
index a835e12..d91f406 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -574,8 +574,13 @@ xfs_getbmap(
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
index 8c971fd..a4b061e 100644
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
@@ -652,6 +673,8 @@ _xfs_dic2xflags(
 	if (di_flags2 & XFS_DIFLAG2_ANY) {
 		if (di_flags2 & XFS_DIFLAG2_DAX)
 			flags |= FS_XFLAG_DAX;
+		if (di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+			flags |= FS_XFLAG_COWEXTSIZE;
 	}
 
 	if (has_attr)
@@ -835,6 +858,7 @@ xfs_ialloc(
 	if (ip->i_d.di_version == 3) {
 		inode->i_version = 1;
 		ip->i_d.di_flags2 = 0;
+		ip->i_d.di_cowextsize = 0;
 		ip->i_d.di_crtime.t_sec = (__int32_t)tv.tv_sec;
 		ip->i_d.di_crtime.t_nsec = (__int32_t)tv.tv_nsec;
 	}
@@ -897,6 +921,15 @@ xfs_ialloc(
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
index 1af1d8d..b1c32d4 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -426,6 +426,7 @@ int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
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
index 96a70fd..1388a127 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -903,6 +903,8 @@ xfs_ioc_fsgetxattr(
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	fa.fsx_xflags = xfs_ip2xflags(ip);
 	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
+	fa.fsx_cowextsize = ip->i_d.di_cowextsize <<
+			ip->i_mount->m_sb.sb_blocklog;
 	fa.fsx_projid = xfs_get_projid(ip);
 
 	if (attr) {
@@ -973,12 +975,13 @@ xfs_set_diflags(
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
@@ -1219,6 +1222,56 @@ xfs_ioctl_setattr_check_extsize(
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
@@ -1311,6 +1364,10 @@ xfs_ioctl_setattr(
 	if (code)
 		goto error_trans_cancel;
 
+	code = xfs_ioctl_setattr_check_cowextsize(ip, fa);
+	if (code)
+		goto error_trans_cancel;
+
 	code = xfs_ioctl_setattr_xflags(tp, ip, fa);
 	if (code)
 		goto error_trans_cancel;
@@ -1346,6 +1403,12 @@ xfs_ioctl_setattr(
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
index 765849e..d907eb9 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -71,7 +71,7 @@ xfs_bmbt_to_iomap(
 	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
 }
 
-static xfs_extlen_t
+xfs_extlen_t
 xfs_eof_alignment(
 	struct xfs_inode	*ip,
 	xfs_extlen_t		extsize)
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index a16b956..6d45cf0 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -31,6 +31,7 @@ int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
 
 void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
 		struct xfs_bmbt_irec *);
+xfs_extlen_t xfs_eof_alignment(struct xfs_inode *ip, xfs_extlen_t extsize);
 
 extern struct iomap_ops xfs_iomap_ops;
 extern struct iomap_ops xfs_xattr_iomap_ops;
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
index 065e836..75d49df 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -255,6 +255,7 @@ __xfs_reflink_reserve_cow(
 	int			nimaps, eof = 0, error = 0;
 	bool			shared = false, trimmed = false;
 	xfs_extnum_t		idx;
+	xfs_extlen_t		align;
 
 	/* Already reserved?  Skip the refcount btree access. */
 	xfs_bmap_search_extents(ip, *offset_fsb, XFS_COW_FORK, &eof, &idx,
@@ -294,6 +295,10 @@ __xfs_reflink_reserve_cow(
 	if (error)
 		goto out_unlock;
 
+	align = xfs_eof_alignment(ip, xfs_get_cowextsz_hint(ip));
+	if (align)
+		end_fsb = roundup_64(end_fsb, align);
+
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, *offset_fsb,
 			end_fsb - *offset_fsb, &got,
@@ -1057,18 +1062,19 @@ xfs_reflink_set_inode_flag(
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
@@ -1078,9 +1084,17 @@ xfs_reflink_update_dest(
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
@@ -1397,6 +1411,7 @@ xfs_reflink_remap_range(
 	xfs_fileoff_t		sfsbno, dfsbno;
 	xfs_filblks_t		fsblen;
 	int			error;
+	xfs_extlen_t		cowextsize;
 	bool			is_same;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
@@ -1457,7 +1472,19 @@ xfs_reflink_remap_range(
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
 

