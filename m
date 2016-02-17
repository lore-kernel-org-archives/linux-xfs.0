Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD73F7F52
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D23C8F8035
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:23 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9L7fMs6hoFBjYRcm for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:19 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004m0-QF
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00014S-PO
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/15] xfs: remove timestamps from incore inode
Date: Wed, 17 Feb 2016 18:20:46 +1100
Message-Id: <1455693652-3899-10-git-send-email-david@fromorbit.com>
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

Source kernel commit 3987848c7c2be112e03c82d03821b044f1c0edec

The struct xfs_inode has two copies of the current timestamps in it,
one in the vfs inode and one in the struct xfs_icdinode. Now that we
no longer log the struct xfs_icdinode directly, we don't need to
keep the timestamps in this structure. instead we can copy them
straight out of the VFS inode when formatting the inode log item or
the on-disk inode.

This reduces the struct xfs_inode in size by 24 bytes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 db/check.c               | 106 +++++++++++++++++++++++------------------------
 include/xfs_inode.h      |  16 ++++++-
 libxfs/libxfs_api_defs.h |   4 +-
 libxfs/util.c            |  17 ++++----
 libxfs/xfs_inode_buf.c   |  91 ++++++++++++++++++++++++++++++++++------
 libxfs/xfs_inode_buf.h   |   9 ++--
 libxfs/xfs_rtbitmap.c    |   2 +-
 mkfs/proto.c             |   2 +-
 8 files changed, 162 insertions(+), 85 deletions(-)

diff --git a/db/check.c b/db/check.c
index d6d1d57..2203f41 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2619,7 +2619,7 @@ process_inode(
 {
 	blkmap_t		*blkmap;
 	xfs_fsblock_t		bno = 0;
-	struct xfs_icdinode	idic;
+	struct xfs_inode	xino;
 	inodata_t		*id = NULL;
 	xfs_ino_t		ino;
 	xfs_extnum_t		nextents = 0;
@@ -2663,7 +2663,7 @@ process_inode(
 		"dev", "local", "extents", "btree", "uuid"
 	};
 
-	libxfs_dinode_from_disk(&idic, dip);
+	libxfs_inode_from_disk(&xino, dip);
 
 	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
 	if (!isfree) {
@@ -2672,42 +2672,42 @@ process_inode(
 		blkmap = NULL;
 	}
 	v = (!sflag || (id && id->ilist) || CHECK_BLIST(bno));
-	if (idic.di_magic != XFS_DINODE_MAGIC) {
+	if (xino.i_d.di_magic != XFS_DINODE_MAGIC) {
 		if (isfree || v)
 			dbprintf(_("bad magic number %#x for inode %lld\n"),
-				idic.di_magic, ino);
+				xino.i_d.di_magic, ino);
 		error++;
 		return;
 	}
-	if (!xfs_dinode_good_version(mp, idic.di_version)) {
+	if (!xfs_dinode_good_version(mp, xino.i_d.di_version)) {
 		if (isfree || v)
 			dbprintf(_("bad version number %#x for inode %lld\n"),
-				idic.di_version, ino);
+				xino.i_d.di_version, ino);
 		error++;
 		return;
 	}
 	if (isfree) {
-		if (idic.di_nblocks != 0) {
+		if (xino.i_d.di_nblocks != 0) {
 			if (v)
 				dbprintf(_("bad nblocks %lld for free inode "
 					 "%lld\n"),
-					idic.di_nblocks, ino);
+					xino.i_d.di_nblocks, ino);
 			error++;
 		}
-		if (idic.di_version == 1)
-			nlink = idic.di_onlink;
+		if (xino.i_d.di_version == 1)
+			nlink = xino.i_d.di_onlink;
 		else
-			nlink = idic.di_nlink;
+			nlink = xino.i_d.di_nlink;
 		if (nlink != 0) {
 			if (v)
 				dbprintf(_("bad nlink %d for free inode %lld\n"),
 					nlink, ino);
 			error++;
 		}
-		if (idic.di_mode != 0) {
+		if (xino.i_d.di_mode != 0) {
 			if (v)
 				dbprintf(_("bad mode %#o for free inode %lld\n"),
-					idic.di_mode, ino);
+					xino.i_d.di_mode, ino);
 			error++;
 		}
 		return;
@@ -2722,26 +2722,26 @@ process_inode(
 	/*
 	 * di_mode is a 16-bit uint so no need to check the < 0 case
 	 */
-	if ((((idic.di_mode & S_IFMT) >> 12) > 15) ||
-	    (!(okfmts[(idic.di_mode & S_IFMT) >> 12] & (1 << idic.di_format)))) {
+	if ((((xino.i_d.di_mode & S_IFMT) >> 12) > 15) ||
+	    (!(okfmts[(xino.i_d.di_mode & S_IFMT) >> 12] & (1 << xino.i_d.di_format)))) {
 		if (v)
 			dbprintf(_("bad format %d for inode %lld type %#o\n"),
-				idic.di_format, id->ino, idic.di_mode & S_IFMT);
+				xino.i_d.di_format, id->ino, xino.i_d.di_mode & S_IFMT);
 		error++;
 		return;
 	}
 	if ((unsigned int)XFS_DFORK_ASIZE(dip, mp) >=
-					XFS_LITINO(mp, idic.di_version))  {
+					XFS_LITINO(mp, xino.i_d.di_version))  {
 		if (v)
 			dbprintf(_("bad fork offset %d for inode %lld\n"),
-				idic.di_forkoff, id->ino);
+				xino.i_d.di_forkoff, id->ino);
 		error++;
 		return;
 	}
-	if ((unsigned int)idic.di_aformat > XFS_DINODE_FMT_BTREE)  {
+	if ((unsigned int)xino.i_d.di_aformat > XFS_DINODE_FMT_BTREE)  {
 		if (v)
 			dbprintf(_("bad attribute format %d for inode %lld\n"),
-				idic.di_aformat, id->ino);
+				xino.i_d.di_aformat, id->ino);
 		error++;
 		return;
 	}
@@ -2749,48 +2749,48 @@ process_inode(
 		dbprintf(_("inode %lld mode %#o fmt %s "
 			 "afmt %s "
 			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
-			id->ino, idic.di_mode, fmtnames[(int)idic.di_format],
-			fmtnames[(int)idic.di_aformat],
-			idic.di_nextents,
-			idic.di_anextents,
-			idic.di_nblocks, idic.di_size,
-			idic.di_flags & XFS_DIFLAG_REALTIME ? " rt" : "",
-			idic.di_flags & XFS_DIFLAG_PREALLOC ? " pre" : "",
-			idic.di_flags & XFS_DIFLAG_IMMUTABLE? " imm" : "",
-			idic.di_flags & XFS_DIFLAG_APPEND   ? " app" : "",
-			idic.di_flags & XFS_DIFLAG_SYNC     ? " syn" : "",
-			idic.di_flags & XFS_DIFLAG_NOATIME  ? " noa" : "",
-			idic.di_flags & XFS_DIFLAG_NODUMP   ? " nod" : "");
+			id->ino, xino.i_d.di_mode, fmtnames[(int)xino.i_d.di_format],
+			fmtnames[(int)xino.i_d.di_aformat],
+			xino.i_d.di_nextents,
+			xino.i_d.di_anextents,
+			xino.i_d.di_nblocks, xino.i_d.di_size,
+			xino.i_d.di_flags & XFS_DIFLAG_REALTIME ? " rt" : "",
+			xino.i_d.di_flags & XFS_DIFLAG_PREALLOC ? " pre" : "",
+			xino.i_d.di_flags & XFS_DIFLAG_IMMUTABLE? " imm" : "",
+			xino.i_d.di_flags & XFS_DIFLAG_APPEND   ? " app" : "",
+			xino.i_d.di_flags & XFS_DIFLAG_SYNC     ? " syn" : "",
+			xino.i_d.di_flags & XFS_DIFLAG_NOATIME  ? " noa" : "",
+			xino.i_d.di_flags & XFS_DIFLAG_NODUMP   ? " nod" : "");
 	security = 0;
-	switch (idic.di_mode & S_IFMT) {
+	switch (xino.i_d.di_mode & S_IFMT) {
 	case S_IFDIR:
 		type = DBM_DIR;
-		if (idic.di_format == XFS_DINODE_FMT_LOCAL)
+		if (xino.i_d.di_format == XFS_DINODE_FMT_LOCAL)
 			break;
-		blkmap = blkmap_alloc(idic.di_nextents);
+		blkmap = blkmap_alloc(xino.i_d.di_nextents);
 		break;
 	case S_IFREG:
-		if (idic.di_flags & XFS_DIFLAG_REALTIME)
+		if (xino.i_d.di_flags & XFS_DIFLAG_REALTIME)
 			type = DBM_RTDATA;
 		else if (id->ino == mp->m_sb.sb_rbmino) {
 			type = DBM_RTBITMAP;
-			blkmap = blkmap_alloc(idic.di_nextents);
+			blkmap = blkmap_alloc(xino.i_d.di_nextents);
 			addlink_inode(id);
 		} else if (id->ino == mp->m_sb.sb_rsumino) {
 			type = DBM_RTSUM;
-			blkmap = blkmap_alloc(idic.di_nextents);
+			blkmap = blkmap_alloc(xino.i_d.di_nextents);
 			addlink_inode(id);
 		}
 		else if (id->ino == mp->m_sb.sb_uquotino ||
 			 id->ino == mp->m_sb.sb_gquotino ||
 			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
-			blkmap = blkmap_alloc(idic.di_nextents);
+			blkmap = blkmap_alloc(xino.i_d.di_nextents);
 			addlink_inode(id);
 		}
 		else
 			type = DBM_DATA;
-		if (idic.di_mode & (S_ISUID | S_ISGID))
+		if (xino.i_d.di_mode & (S_ISUID | S_ISGID))
 			security = 1;
 		break;
 	case S_IFLNK:
@@ -2801,13 +2801,13 @@ process_inode(
 		type = DBM_UNKNOWN;
 		break;
 	}
-	if (idic.di_version == 1)
-		setlink_inode(id, idic.di_onlink, type == DBM_DIR, security);
+	if (xino.i_d.di_version == 1)
+		setlink_inode(id, xino.i_d.di_onlink, type == DBM_DIR, security);
 	else {
 		sbversion |= XFS_SB_VERSION_NLINKBIT;
-		setlink_inode(id, idic.di_nlink, type == DBM_DIR, security);
+		setlink_inode(id, xino.i_d.di_nlink, type == DBM_DIR, security);
 	}
-	switch (idic.di_format) {
+	switch (xino.i_d.di_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		process_lclinode(id, dip, type, &totdblocks, &totiblocks,
 			&nextents, &blkmap, XFS_DATA_FORK);
@@ -2823,7 +2823,7 @@ process_inode(
 	}
 	if (XFS_DFORK_Q(dip)) {
 		sbversion |= XFS_SB_VERSION_ATTRBIT;
-		switch (idic.di_aformat) {
+		switch (xino.i_d.di_aformat) {
 		case XFS_DINODE_FMT_LOCAL:
 			process_lclinode(id, dip, DBM_ATTR, &atotdblocks,
 				&atotiblocks, &anextents, NULL, XFS_ATTR_FORK);
@@ -2859,30 +2859,30 @@ process_inode(
 			break;
 		}
 		if (ic) {
-			dqprid = xfs_get_projid(&idic);	/* dquot ID is u32 */
-			quota_add(&dqprid, &idic.di_gid, &idic.di_uid,
+			dqprid = xfs_get_projid(&xino.i_d);	/* dquot ID is u32 */
+			quota_add(&dqprid, &xino.i_d.di_gid, &xino.i_d.di_uid,
 				  0, bc, ic, rc);
 		}
 	}
 	totblocks = totdblocks + totiblocks + atotdblocks + atotiblocks;
-	if (totblocks != idic.di_nblocks) {
+	if (totblocks != xino.i_d.di_nblocks) {
 		if (v)
 			dbprintf(_("bad nblocks %lld for inode %lld, counted "
 				 "%lld\n"),
-				idic.di_nblocks, id->ino, totblocks);
+				xino.i_d.di_nblocks, id->ino, totblocks);
 		error++;
 	}
-	if (nextents != idic.di_nextents) {
+	if (nextents != xino.i_d.di_nextents) {
 		if (v)
 			dbprintf(_("bad nextents %d for inode %lld, counted %d\n"),
-				idic.di_nextents, id->ino, nextents);
+				xino.i_d.di_nextents, id->ino, nextents);
 		error++;
 	}
-	if (anextents != idic.di_anextents) {
+	if (anextents != xino.i_d.di_anextents) {
 		if (v)
 			dbprintf(_("bad anextents %d for inode %lld, counted "
 				 "%d\n"),
-				idic.di_anextents, id->ino, anextents);
+				xino.i_d.di_anextents, id->ino, anextents);
 		error++;
 	}
 	if (type == DBM_DIR)
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 71c0fb4..1efff0f 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -29,8 +29,16 @@ struct xfs_inode_log_item;
 struct xfs_dir_ops;
 
 /*
- * Inode interface
+ * Inode interface. This fakes up a "VFS inode" to make the xfs_inode appear
+ * similar to the kernel which now is used tohold certain parts of the on-disk
+ * metadata.
  */
+struct inode {
+	struct timespec	i_atime;
+	struct timespec	i_mtime;
+	struct timespec	i_ctime;
+};
+
 typedef struct xfs_inode {
 	struct cache_node	i_node;
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
@@ -45,8 +53,14 @@ typedef struct xfs_inode {
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 	xfs_fsize_t		i_size;		/* in-memory size */
 	const struct xfs_dir_ops *d_ops;	/* directory ops vector */
+	struct inode		i_vnode;
 } xfs_inode_t;
 
+static inline struct inode *VFS_I(struct xfs_inode *ip)
+{
+	return &ip->i_vnode;
+}
+
 /*
  * For regular files we only update the on-disk filesize when actually
  * writing data back to disk.  Until then only the copy in the VFS inode
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 3a649e3..685c7a7 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -92,8 +92,8 @@
 #define xfs_dir2_data_use_free		libxfs_dir2_data_use_free
 #define xfs_dir2_shrink_inode		libxfs_dir2_shrink_inode
 
-#define xfs_dinode_from_disk		libxfs_dinode_from_disk
-#define xfs_dinode_to_disk		libxfs_dinode_to_disk
+#define xfs_inode_from_disk		libxfs_inode_from_disk
+#define xfs_inode_to_disk		libxfs_inode_to_disk
 #define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
diff --git a/libxfs/util.c b/libxfs/util.c
index 787fd5d..86fadc3 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -161,14 +161,10 @@ libxfs_trans_ichgtime(
 	gettimeofday(&stv, (struct timezone *)0);
 	tv.tv_sec = stv.tv_sec;
 	tv.tv_nsec = stv.tv_usec * 1000;
-	if (flags & XFS_ICHGTIME_MOD) {
-		ip->i_d.di_mtime.t_sec = (__int32_t)tv.tv_sec;
-		ip->i_d.di_mtime.t_nsec = (__int32_t)tv.tv_nsec;
-	}
-	if (flags & XFS_ICHGTIME_CHG) {
-		ip->i_d.di_ctime.t_sec = (__int32_t)tv.tv_sec;
-		ip->i_d.di_ctime.t_nsec = (__int32_t)tv.tv_nsec;
-	}
+	if (flags & XFS_ICHGTIME_MOD)
+		VFS_I(ip)->i_mtime = tv;
+	if (flags & XFS_ICHGTIME_CHG)
+		VFS_I(ip)->i_ctime = tv;
 	if (flags & XFS_ICHGTIME_CREATE) {
 		ip->i_d.di_crtime.t_sec = (__int32_t)tv.tv_sec;
 		ip->i_d.di_crtime.t_nsec = (__int32_t)tv.tv_nsec;
@@ -270,7 +266,8 @@ libxfs_ialloc(
 		ip->i_d.di_lsn = 0;
 		ip->i_d.di_flags2 = 0;
 		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
-		ip->i_d.di_crtime = ip->i_d.di_mtime;
+		ip->i_d.di_crtime.t_sec = (__int32_t)VFS_I(ip)->i_mtime.tv_sec;
+		ip->i_d.di_crtime.t_nsec = (__int32_t)VFS_I(ip)->i_mtime.tv_nsec;
 	}
 
 	flags = XFS_ILOG_CORE;
@@ -452,7 +449,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	 * because if the inode is dirty at all the core must
 	 * be.
 	 */
-	xfs_dinode_to_disk(dip, &ip->i_d);
+	xfs_inode_to_disk(ip, dip);
 
 	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
 	if (XFS_IFORK_Q(ip))
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index dbea592..f546b41 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -204,10 +204,13 @@ xfs_imap_to_bp(
 }
 
 void
-xfs_dinode_from_disk(
-	struct xfs_icdinode	*to,
+xfs_inode_from_disk(
+	struct xfs_inode	*ip,
 	struct xfs_dinode	*from)
 {
+	struct xfs_icdinode	*to = &ip->i_d;
+	struct inode		*inode = VFS_I(ip);
+
 	to->di_magic = be16_to_cpu(from->di_magic);
 	to->di_mode = be16_to_cpu(from->di_mode);
 	to->di_version = from ->di_version;
@@ -220,12 +223,20 @@ xfs_dinode_from_disk(
 	to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
-	to->di_atime.t_sec = be32_to_cpu(from->di_atime.t_sec);
-	to->di_atime.t_nsec = be32_to_cpu(from->di_atime.t_nsec);
-	to->di_mtime.t_sec = be32_to_cpu(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = be32_to_cpu(from->di_mtime.t_nsec);
-	to->di_ctime.t_sec = be32_to_cpu(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = be32_to_cpu(from->di_ctime.t_nsec);
+
+	/*
+	 * Time is signed, so need to convert to signed 32 bit before
+	 * storing in inode timestamp which may be 64 bit. Otherwise
+	 * a time before epoch is converted to a time long after epoch
+	 * on 64 bit systems.
+	 */
+	inode->i_atime.tv_sec = (int)be32_to_cpu(from->di_atime.t_sec);
+	inode->i_atime.tv_nsec = (int)be32_to_cpu(from->di_atime.t_nsec);
+	inode->i_mtime.tv_sec = (int)be32_to_cpu(from->di_mtime.t_sec);
+	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
+	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
+	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
+
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
 	to->di_extsize = be32_to_cpu(from->di_extsize);
@@ -251,9 +262,63 @@ xfs_dinode_from_disk(
 }
 
 void
-xfs_dinode_to_disk(
-	struct xfs_dinode	*to,
-	struct xfs_icdinode	*from)
+xfs_inode_to_disk(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*to)
+{
+	struct xfs_icdinode	*from = &ip->i_d;
+	struct inode		*inode = VFS_I(ip);
+
+	to->di_magic = cpu_to_be16(from->di_magic);
+	to->di_mode = cpu_to_be16(from->di_mode);
+	to->di_version = from ->di_version;
+	to->di_format = from->di_format;
+	to->di_onlink = cpu_to_be16(from->di_onlink);
+	to->di_uid = cpu_to_be32(from->di_uid);
+	to->di_gid = cpu_to_be32(from->di_gid);
+	to->di_nlink = cpu_to_be32(from->di_nlink);
+	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
+	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
+	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
+
+	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
+	to->di_atime.t_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
+	to->di_mtime.t_sec = cpu_to_be32(inode->i_mtime.tv_sec);
+	to->di_mtime.t_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
+	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
+	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
+
+	to->di_size = cpu_to_be64(from->di_size);
+	to->di_nblocks = cpu_to_be64(from->di_nblocks);
+	to->di_extsize = cpu_to_be32(from->di_extsize);
+	to->di_nextents = cpu_to_be32(from->di_nextents);
+	to->di_anextents = cpu_to_be16(from->di_anextents);
+	to->di_forkoff = from->di_forkoff;
+	to->di_aformat = from->di_aformat;
+	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
+	to->di_dmstate = cpu_to_be16(from->di_dmstate);
+	to->di_flags = cpu_to_be16(from->di_flags);
+	to->di_gen = cpu_to_be32(from->di_gen);
+
+	if (from->di_version == 3) {
+		to->di_changecount = cpu_to_be64(from->di_changecount);
+		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
+		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		to->di_flags2 = cpu_to_be64(from->di_flags2);
+		to->di_ino = cpu_to_be64(from->di_ino);
+		to->di_lsn = cpu_to_be64(from->di_lsn);
+		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
+		uuid_copy(&to->di_uuid, &from->di_uuid);
+		to->di_flushiter = 0;
+	} else {
+		to->di_flushiter = cpu_to_be16(from->di_flushiter);
+	}
+}
+
+void
+xfs_log_dinode_to_disk(
+	struct xfs_log_dinode	*from,
+	struct xfs_dinode	*to)
 {
 	to->di_magic = cpu_to_be16(from->di_magic);
 	to->di_mode = cpu_to_be16(from->di_mode);
@@ -266,12 +331,14 @@ xfs_dinode_to_disk(
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
+
 	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
 	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
 	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
 	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
 	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
 	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
+
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
@@ -412,7 +479,7 @@ xfs_iread(
 	 * Otherwise, just get the truly permanent information.
 	 */
 	if (dip->di_mode) {
-		xfs_dinode_from_disk(&ip->i_d, dip);
+		xfs_inode_from_disk(ip, dip);
 		error = xfs_iformat_fork(ip, dip);
 		if (error)  {
 #ifdef DEBUG
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index da66458..6242974 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -40,9 +40,6 @@ struct xfs_icdinode {
 	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
 	__uint8_t	di_pad[6];	/* unused, zeroed space */
 	__uint16_t	di_flushiter;	/* incremented on flush */
-	xfs_ictimestamp_t di_atime;	/* time last accessed */
-	xfs_ictimestamp_t di_mtime;	/* time last modified */
-	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
@@ -89,8 +86,10 @@ int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
 		  struct xfs_inode *, uint);
 void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
-void	xfs_dinode_to_disk(struct xfs_dinode *to, struct xfs_icdinode *from);
-void	xfs_dinode_from_disk(struct xfs_icdinode *to, struct xfs_dinode *from);
+void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to);
+void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
+void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
+			       struct xfs_dinode *to);
 bool	xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 			  struct xfs_dinode *dip);
 
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 684a18b..70ea975 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1006,7 +1006,7 @@ xfs_rtfree_extent(
 	    mp->m_sb.sb_rextents) {
 		if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM))
 			mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
-		*(__uint64_t *)&mp->m_rbmip->i_d.di_atime = 0;
+		*(__uint64_t *)&VFS_I(mp->m_rbmip)->i_atime = 0;
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 	}
 	return 0;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 21960d5..72a1576 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -653,7 +653,7 @@ rtinit(
 	mp->m_sb.sb_rbmino = rbmip->i_ino;
 	rbmip->i_d.di_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
 	rbmip->i_d.di_flags = XFS_DIFLAG_NEWRTBM;
-	*(__uint64_t *)&rbmip->i_d.di_atime = 0;
+	*(__uint64_t *)&VFS_I(mp->m_rbmip)->i_atime = 0;
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
