Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7535A7F4E
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64CBE8F8033
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:23 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	mIwZJExc2BTKBiYh for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:20 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004m8-TF
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00014w-SJ
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/15] xfs: mode di_mode to vfs inode
Date: Wed, 17 Feb 2016 18:20:52 +1100
Message-Id: <1455693652-3899-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1455693652-3899-1-git-send-email-david@fromorbit.com>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit c19b3b05ae440de50fffe2ac2a9b27392a7448e9

Move the di_mode value from the xfs_icdinode to the VFS inode, reducing
the xfs_icdinode byte another 2 bytes and collapsing another 2 byte hole
in the structure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 db/check.c              | 18 ++++++++++--------
 include/xfs_inode.h     | 16 +++++++++++++++-
 libxfs/rdwr.c           |  4 ++--
 libxfs/util.c           | 17 ++++++++---------
 libxfs/xfs_bmap.c       |  6 +++---
 libxfs/xfs_dir2.c       | 12 ++++++------
 libxfs/xfs_inode_buf.c  |  8 ++++----
 libxfs/xfs_inode_buf.h  |  1 -
 libxfs/xfs_inode_fork.c |  2 +-
 mkfs/proto.c            |  6 +++---
 repair/phase6.c         |  8 ++++----
 11 files changed, 56 insertions(+), 42 deletions(-)

diff --git a/db/check.c b/db/check.c
index 412ab3d..36a0f64 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2636,6 +2636,7 @@ process_inode(
 	xfs_qcnt_t		rc = 0;
 	xfs_dqid_t		dqprid;
 	int			v = 0;
+	mode_t			mode;
 	static char		okfmts[] = {
 		0,				/* type 0 unused */
 		1 << XFS_DINODE_FMT_DEV,	/* FIFO */
@@ -2699,10 +2700,10 @@ process_inode(
 					be32_to_cpu(dip->di_nlink), ino);
 			error++;
 		}
-		if (xino.i_d.di_mode != 0) {
+		if (dip->di_mode != 0) {
 			if (v)
 				dbprintf(_("bad mode %#o for free inode %lld\n"),
-					xino.i_d.di_mode, ino);
+					be16_to_cpu(dip->di_mode), ino);
 			error++;
 		}
 		return;
@@ -2717,11 +2718,12 @@ process_inode(
 	/*
 	 * di_mode is a 16-bit uint so no need to check the < 0 case
 	 */
-	if ((((xino.i_d.di_mode & S_IFMT) >> 12) > 15) ||
-	    (!(okfmts[(xino.i_d.di_mode & S_IFMT) >> 12] & (1 << xino.i_d.di_format)))) {
+	mode = be16_to_cpu(dip->di_mode);
+	if ((((mode & S_IFMT) >> 12) > 15) ||
+	    (!(okfmts[(mode & S_IFMT) >> 12] & (1 << xino.i_d.di_format)))) {
 		if (v)
 			dbprintf(_("bad format %d for inode %lld type %#o\n"),
-				xino.i_d.di_format, id->ino, xino.i_d.di_mode & S_IFMT);
+				xino.i_d.di_format, id->ino, mode & S_IFMT);
 		error++;
 		return;
 	}
@@ -2744,7 +2746,7 @@ process_inode(
 		dbprintf(_("inode %lld mode %#o fmt %s "
 			 "afmt %s "
 			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
-			id->ino, xino.i_d.di_mode, fmtnames[(int)xino.i_d.di_format],
+			id->ino, mode, fmtnames[(int)xino.i_d.di_format],
 			fmtnames[(int)xino.i_d.di_aformat],
 			xino.i_d.di_nextents,
 			xino.i_d.di_anextents,
@@ -2757,7 +2759,7 @@ process_inode(
 			xino.i_d.di_flags & XFS_DIFLAG_NOATIME  ? " noa" : "",
 			xino.i_d.di_flags & XFS_DIFLAG_NODUMP   ? " nod" : "");
 	security = 0;
-	switch (xino.i_d.di_mode & S_IFMT) {
+	switch (mode & S_IFMT) {
 	case S_IFDIR:
 		type = DBM_DIR;
 		if (xino.i_d.di_format == XFS_DINODE_FMT_LOCAL)
@@ -2785,7 +2787,7 @@ process_inode(
 		}
 		else
 			type = DBM_DATA;
-		if (xino.i_d.di_mode & (S_ISUID | S_ISGID))
+		if (mode & (S_ISUID | S_ISGID))
 			security = 1;
 		break;
 	case S_IFLNK:
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 0290f97..d6990e5 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -34,6 +34,7 @@ struct xfs_dir_ops;
  * metadata.
  */
 struct inode {
+	mode_t		i_mode;
 	uint32_t	i_nlink;
 	uint32_t	i_generation;
 	uint64_t	i_version;
@@ -65,13 +66,26 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 }
 
 /*
+ * wrappers around the mode checks to simplify code
+ */
+static inline bool XFS_ISREG(struct xfs_inode *ip)
+{
+	return S_ISREG(VFS_I(ip)->i_mode);
+}
+
+static inline bool XFS_ISDIR(struct xfs_inode *ip)
+{
+	return S_ISDIR(VFS_I(ip)->i_mode);
+}
+
+/*
  * For regular files we only update the on-disk filesize when actually
  * writing data back to disk.  Until then only the copy in the VFS inode
  * is uptodate.
  */
 static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
 {
-	if (S_ISREG(ip->i_d.di_mode))
+	if (XFS_ISREG(ip))
 		return ip->i_size;
 	return ip->i_d.di_size;
 }
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 3522c26..0ec38c5 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1351,7 +1351,7 @@ libxfs_iget(xfs_mount_t *mp, xfs_trans_t *tp, xfs_ino_t ino, uint lock_flags,
 	/*
 	 * set up the inode ops structure that the libxfs code relies on
 	 */
-	if (S_ISDIR(ip->i_d.di_mode))
+	if (XFS_ISDIR(ip))
 		ip->d_ops = mp->m_dir_inode_ops;
 	else
 		ip->d_ops = mp->m_nondir_inode_ops;
@@ -1363,7 +1363,7 @@ libxfs_iget(xfs_mount_t *mp, xfs_trans_t *tp, xfs_ino_t ino, uint lock_flags,
 static void
 libxfs_idestroy(xfs_inode_t *ip)
 {
-	switch (ip->i_d.di_mode & S_IFMT) {
+	switch (VFS_I(ip)->i_mode & S_IFMT) {
 		case S_IFREG:
 		case S_IFDIR:
 		case S_IFLNK:
diff --git a/libxfs/util.c b/libxfs/util.c
index 9c2f1d2..576f954 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -217,7 +217,7 @@ libxfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 
-	ip->i_d.di_mode = (__uint16_t)mode;
+	VFS_I(ip)->i_mode = mode;
 	set_nlink(VFS_I(ip), nlink);
 	ip->i_d.di_uid = cr->cr_uid;
 	ip->i_d.di_gid = cr->cr_gid;
@@ -238,10 +238,10 @@ libxfs_ialloc(
 		 */
 	}
 
-	if (pip && (pip->i_d.di_mode & S_ISGID)) {
+	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
-		if ((pip->i_d.di_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR)
-			ip->i_d.di_mode |= S_ISGID;
+		if ((VFS_I(pip)->i_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR)
+			VFS_I(ip)->i_mode |= S_ISGID;
 	}
 
 	ip->i_d.di_size = 0;
@@ -316,7 +316,7 @@ libxfs_ialloc(
 	/*
 	 * set up the inode ops structure that the libxfs code relies on
 	 */
-	if (S_ISDIR(ip->i_d.di_mode))
+	if (XFS_ISDIR(ip))
 		ip->d_ops = ip->i_mount->m_dir_inode_ops;
 	else
 		ip->d_ops = ip->i_mount->m_nondir_inode_ops;
@@ -367,7 +367,7 @@ libxfs_iprint(
 
 	dip = &ip->i_d;
 	printf("\nOn disk portion\n");
-	printf("    di_mode %o\n", dip->di_mode);
+	printf("    di_mode %o\n", VFS_I(ip)->i_mode);
 	printf("    di_version %x\n", (uint)dip->di_version);
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -417,11 +417,10 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	ASSERT(ip->i_d.di_magic == XFS_DINODE_MAGIC);
-	if ((ip->i_d.di_mode & S_IFMT) == S_IFREG) {
+	if (XFS_ISREG(ip)) {
 		ASSERT( (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS) ||
 			(ip->i_d.di_format == XFS_DINODE_FMT_BTREE) );
-	}
-	else if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR) {
+	} else if (XFS_ISDIR(ip) == S_IFDIR) {
 		ASSERT( (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS) ||
 			(ip->i_d.di_format == XFS_DINODE_FMT_BTREE)   ||
 			(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) );
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8cb89bc..40286e4 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -904,7 +904,7 @@ xfs_bmap_local_to_extents(
 	 * We don't want to deal with the case of keeping inode data inline yet.
 	 * So sending the data fork of a regular inode is invalid.
 	 */
-	ASSERT(!(S_ISREG(ip->i_d.di_mode) && whichfork == XFS_DATA_FORK));
+	ASSERT(!(S_ISREG(VFS_I(ip)->i_mode) && whichfork == XFS_DATA_FORK));
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
 
@@ -1071,7 +1071,7 @@ xfs_bmap_add_attrfork_local(
 	if (ip->i_df.if_bytes <= XFS_IFORK_DSIZE(ip))
 		return 0;
 
-	if (S_ISDIR(ip->i_d.di_mode)) {
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
 		memset(&dargs, 0, sizeof(dargs));
 		dargs.geo = ip->i_mount->m_dir_geo;
 		dargs.dp = ip;
@@ -1083,7 +1083,7 @@ xfs_bmap_add_attrfork_local(
 		return xfs_dir2_sf_to_block(&dargs);
 	}
 
-	if (S_ISLNK(ip->i_d.di_mode))
+	if (S_ISLNK(VFS_I(ip)->i_mode))
 		return xfs_bmap_local_to_extents(tp, ip, firstblock, 1,
 						 flags, XFS_DATA_FORK,
 						 xfs_symlink_local_to_remote);
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 89b4781..723b267 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -174,7 +174,7 @@ xfs_dir_isempty(
 {
 	xfs_dir2_sf_hdr_t	*sfp;
 
-	ASSERT(S_ISDIR(dp->i_d.di_mode));
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	if (dp->i_d.di_size == 0)	/* might happen during shutdown. */
 		return 1;
 	if (dp->i_d.di_size > XFS_IFORK_DSIZE(dp))
@@ -229,7 +229,7 @@ xfs_dir_init(
 	struct xfs_da_args *args;
 	int		error;
 
-	ASSERT(S_ISDIR(dp->i_d.di_mode));
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	error = xfs_dir_ino_validate(tp->t_mountp, pdp->i_ino);
 	if (error)
 		return error;
@@ -264,7 +264,7 @@ xfs_dir_createname(
 	int			rval;
 	int			v;		/* type-checking value */
 
-	ASSERT(S_ISDIR(dp->i_d.di_mode));
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	if (inum) {
 		rval = xfs_dir_ino_validate(tp->t_mountp, inum);
 		if (rval)
@@ -362,7 +362,7 @@ xfs_dir_lookup(
 	int		v;		/* type-checking value */
 	int		lock_mode;
 
-	ASSERT(S_ISDIR(dp->i_d.di_mode));
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_lookup);
 
 	/*
@@ -441,7 +441,7 @@ xfs_dir_removename(
 	int		rval;
 	int		v;		/* type-checking value */
 
-	ASSERT(S_ISDIR(dp->i_d.di_mode));
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
 	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
@@ -503,7 +503,7 @@ xfs_dir_replace(
 	int		rval;
 	int		v;		/* type-checking value */
 
-	ASSERT(S_ISDIR(dp->i_d.di_mode));
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 
 	rval = xfs_dir_ino_validate(tp->t_mountp, inum);
 	if (rval)
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index da9edcd..e3d674d 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -211,13 +211,12 @@ xfs_inode_from_disk(
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
-	to->di_mode = be16_to_cpu(from->di_mode);
-	to->di_version = from ->di_version;
 
 	/*
 	 * Convert v1 inodes immediately to v2 inode format as this is the
 	 * minimum inode version format we support in the rest of the code.
 	 */
+	to->di_version = from->di_version;
 	if (to->di_version == 1) {
 		set_nlink(inode, be16_to_cpu(from->di_onlink));
 		to->di_projid_lo = 0;
@@ -247,6 +246,7 @@ xfs_inode_from_disk(
 	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
 	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
 	inode->i_generation = be32_to_cpu(from->di_gen);
+	inode->i_mode = be16_to_cpu(from->di_mode);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -279,7 +279,6 @@ xfs_inode_to_disk(
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 	to->di_onlink = 0;
 
-	to->di_mode = cpu_to_be16(from->di_mode);
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
 	to->di_uid = cpu_to_be32(from->di_uid);
@@ -296,6 +295,7 @@ xfs_inode_to_disk(
 	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
 	to->di_gen = cpu_to_be32(inode->i_generation);
+	to->di_mode = cpu_to_be16(inode->i_mode);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -510,7 +510,7 @@ xfs_iread(
 		 * the inode is already free and not try to mess
 		 * with the uninitialized part of it.
 		 */
-		ip->i_d.di_mode = 0;
+		VFS_I(ip)->i_mode = 0;
 	}
 
 	ASSERT(ip->i_d.di_version >= 2);
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index ad98fdd..4ece9bf 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -28,7 +28,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	__uint16_t	di_mode;	/* mode and type of file */
 	__int8_t	di_version;	/* inode version */
 	__int8_t	di_format;	/* format of di_c data */
 	__uint16_t	di_flushiter;	/* incremented on flush */
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index f40649e..2af1dba 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -117,7 +117,7 @@ xfs_iformat_fork(
 		return -EFSCORRUPTED;
 	}
 
-	switch (ip->i_d.di_mode & S_IFMT) {
+	switch (VFS_I(ip)->i_mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFBLK:
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 9550859..4fc1f3c 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -198,7 +198,7 @@ rsvfile(
 
 	libxfs_trans_ijoin(tp, ip, 0);
 
-	ip->i_d.di_mode &= ~S_ISUID;
+	VFS_I(ip)->i_mode &= ~S_ISUID;
 
 	/*
 	 * Note that we don't have to worry about mandatory
@@ -207,8 +207,8 @@ rsvfile(
 	 * on, but if it was on then mandatory locking wouldn't
 	 * have been enabled.
 	 */
-	if (ip->i_d.di_mode & S_IXGRP)
-		ip->i_d.di_mode &= ~S_ISGID;
+	if (VFS_I(ip)->i_mode & S_IXGRP)
+		VFS_I(ip)->i_mode &= ~S_ISGID;
 
 	libxfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 7415199..0a71164 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -510,7 +510,7 @@ mk_rbmino(xfs_mount_t *mp)
 	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
-	ip->i_d.di_mode = S_IFREG;
+	VFS_I(ip)->i_mode = S_IFREG;
 	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
@@ -763,7 +763,7 @@ mk_rsumino(xfs_mount_t *mp)
 	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 1;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
-	ip->i_d.di_mode = S_IFREG;
+	VFS_I(ip)->i_mode = S_IFREG;
 	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
@@ -872,7 +872,7 @@ mk_root_dir(xfs_mount_t *mp)
 	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
-	ip->i_d.di_mode = (__uint16_t) mode|S_IFDIR;
+	VFS_I(ip)->i_mode = mode|S_IFDIR;
 	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
@@ -1097,7 +1097,7 @@ mv_orphanage(
 	if ((err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, 0)))
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
-	xname.type = xfs_mode_to_ftype[(ino_p->i_d.di_mode & S_IFMT)>>S_SHIFT];
+	xname.type = xfs_mode_to_ftype[(VFS_I(ino_p)->i_mode & S_IFMT)>>S_SHIFT];
 
 	if (isa_dir)  {
 		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, orphanage_ino),
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
