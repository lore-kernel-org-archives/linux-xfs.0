Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:39:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDdEQt022851
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:16 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55881ADE678
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id LYAdcoo3K7Tl5QpN for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSJM-0000Ir-CT
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:39:12 +0000
Date: Mon, 27 Oct 2008 09:39:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/7] kill xfs_dinode_core_t
Message-ID: <20081027133912.GF1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-kill-xfs_dinode_core_t
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Now that we have a separate xfs_icdinode_t for the in-core inode which
gets logged there is no need anymore for the xfs_dinode vs xfs_dinode_core
split - the fact that part of the structure gets logged through the inode
log item and a small part not can better be described in a comment.

All sizeof operations on the dinode_core either really wanted the
icdinode and are switched to that one, or had already added the size
of the agi unlinked list pointer.  Later both will be replaced with
helpers once we get the larger CRC-enabled dinode.

Removing the data and attribute fork unions also has the advantage that
xfs_dinode.h doesn't need to pull in every header under the sun.

While we're at it also add some more comments describing the dinode
structure.

(First sent on October 7th)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-10-25 13:22:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-10-25 13:22:29.000000000 +0200
@@ -302,7 +302,7 @@ STATIC uint
 xfs_dic2dmflags(
 	xfs_dinode_t	*dip)
 {
-	return _xfs_dic2dmflags(be16_to_cpu(dip->di_core.di_flags)) |
+	return _xfs_dic2dmflags(be16_to_cpu(dip->di_flags)) |
 			(XFS_DFORK_Q(dip) ? DM_XFLAG_HASATTR : 0);
 }
 
@@ -316,11 +316,9 @@ STATIC void
 xfs_dip_to_stat(
 	xfs_mount_t		*mp,
 	xfs_ino_t		ino,
-	xfs_dinode_t		*dip,
+	xfs_dinode_t		*dic,
 	dm_stat_t		*buf)
 {
-	xfs_dinode_core_t	*dic = &dip->di_core;
-
 	/*
 	 * The inode format changed when we moved the link count and
 	 * made it 32 bits long.  If this is an old format inode,
@@ -348,7 +346,7 @@ xfs_dip_to_stat(
 	buf->dt_atime = be32_to_cpu(dic->di_atime.t_sec);
 	buf->dt_mtime = be32_to_cpu(dic->di_mtime.t_sec);
 	buf->dt_ctime = be32_to_cpu(dic->di_ctime.t_sec);
-	buf->dt_xfs_xflags = xfs_dic2dmflags(dip);
+	buf->dt_xfs_xflags = xfs_dic2dmflags(dic);
 	buf->dt_xfs_extsize =
 		be32_to_cpu(dic->di_extsize) << mp->m_sb.sb_blocklog;
 	buf->dt_xfs_extents = be32_to_cpu(dic->di_nextents);
@@ -358,7 +356,7 @@ xfs_dip_to_stat(
 
 	switch (dic->di_format) {
 	case XFS_DINODE_FMT_DEV:
-		buf->dt_rdev = be32_to_cpu(dip->di_u.di_dev);
+		buf->dt_rdev = xfs_dinode_get_rdev(dic);
 		buf->dt_blksize = BLKDEV_IOSIZE;
 		buf->dt_blocks = 0;
 		break;
@@ -542,7 +540,7 @@ xfs_dm_inline_attr(
 	caddr_t		attr_buf,
 	int		*value_lenp)
 {
-	if (dip->di_core.di_aformat == XFS_DINODE_FMT_LOCAL) {
+	if (dip->di_aformat == XFS_DINODE_FMT_LOCAL) {
 		xfs_attr_shortform_t	*sf;
 		xfs_attr_sf_entry_t	*sfe;
 		unsigned int		namelen = strlen(attr_name);
@@ -584,7 +582,7 @@ dm_dip_to_handle(
 	fid.dm_fid_len = sizeof(struct dm_fid) - sizeof(fid.dm_fid_len);
 	fid.dm_fid_pad = 0;
 	fid.dm_fid_ino = ino;
-	fid.dm_fid_gen = be32_to_cpu(dip->di_core.di_gen);
+	fid.dm_fid_gen = be32_to_cpu(dip->di_gen);
 
 	memcpy(&handlep->ha_fsid, fsid, sizeof(*fsid));
 	memcpy(&handlep->ha_fid, &fid, fid.dm_fid_len + sizeof(fid.dm_fid_len));
@@ -609,7 +607,7 @@ xfs_dm_bulkall_inline_one(
 	int		value_len = *value_lenp;
 	int		error;
 
-	if (dip->di_core.di_mode == 0)
+	if (dip->di_mode == 0)
 		return ENOENT;
 
 	xfs_dip_to_stat(mp, ino, dip, &xbuf->dx_statinfo);
@@ -781,7 +779,7 @@ xfs_dm_bulkattr_inline_one(
 {
 	dm_handle_t	handle;
 
-	if (dip->di_core.di_mode == 0)
+	if (dip->di_mode == 0)
 		return ENOENT;
 	xfs_dip_to_stat(mp, ino, dip, sbuf);
 	dm_dip_to_handle(ino, dip, fsid, &handle);
Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h	2008-10-25 13:22:24.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dinode.h	2008-10-25 13:22:29.000000000 +0200
@@ -18,32 +18,32 @@
 #ifndef __XFS_DINODE_H__
 #define	__XFS_DINODE_H__
 
-struct xfs_buf;
-struct xfs_mount;
-
 #define	XFS_DINODE_VERSION_1	1
 #define	XFS_DINODE_VERSION_2	2
 #define XFS_DINODE_GOOD_VERSION(v)	\
 	(((v) == XFS_DINODE_VERSION_1 || (v) == XFS_DINODE_VERSION_2))
 #define	XFS_DINODE_MAGIC	0x494e	/* 'IN' */
 
-/*
- * Disk inode structure.
- * This is just the header; the inode is expanded to fill a variable size
- * with the last field expanding.  It is split into the core and "other"
- * because we only need the core part in the in-core inode.
- */
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
 } xfs_timestamp_t;
 
 /*
- * Note: Coordinate changes to this structure with the XFS_DI_* #defines
- * below, the offsets table in xfs_ialloc_log_di() and struct xfs_icdinode
- * in xfs_inode.h.
+ * On-disk inode structure.
+ *
+ * This is just the header or "dinode core", the inode is expanded to fill a
+ * variable size the leftover area split into a data and an attribute fork.
+ * The format of the data and attribute fork depends on the format of the
+ * inode as indicated by di_format and di_aformat.  To access the data and
+ * attribute use the XFS_DFORK_PTR, XFS_DFORK_DPTR, and XFS_DFORK_PTR macros
+ * below.
+ *
+ * There is a very similar struct icdinode in xfs_inode which matches the
+ * layout of the first 96 bytes of this structure, but is kept in native
+ * format instead of big endian.
  */
-typedef struct xfs_dinode_core {
+typedef struct xfs_dinode {
 	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
 	__be16		di_mode;	/* mode and type of file */
 	__u8		di_version;	/* inode version */
@@ -69,34 +69,13 @@ typedef struct xfs_dinode_core {
 	__be16		di_dmstate;	/* DMIG state info */
 	__be16		di_flags;	/* random flags, XFS_DIFLAG_... */
 	__be32		di_gen;		/* generation number */
-} xfs_dinode_core_t;
-
-#define DI_MAX_FLUSH 0xffff
 
-typedef struct xfs_dinode
-{
-	xfs_dinode_core_t	di_core;
-	/*
-	 * In adding anything between the core and the union, be
-	 * sure to update the macros like XFS_LITINO below.
-	 */
-	__be32			di_next_unlinked;/* agi unlinked list ptr */
-	union {
-		xfs_bmdr_block_t di_bmbt;	/* btree root block */
-		xfs_bmbt_rec_32_t di_bmx[1];	/* extent list */
-		xfs_dir2_sf_t	di_dir2sf;	/* shortform directory v2 */
-		char		di_c[1];	/* local contents */
-		__be32		di_dev;		/* device for S_IFCHR/S_IFBLK */
-		uuid_t		di_muuid;	/* mount point value */
-		char		di_symlink[1];	/* local symbolic link */
-	}		di_u;
-	union {
-		xfs_bmdr_block_t di_abmbt;	/* btree root block */
-		xfs_bmbt_rec_32_t di_abmx[1];	/* extent list */
-		xfs_attr_shortform_t di_attrsf;	/* shortform attribute list */
-	}		di_a;
+	/* di_next_unlinked is the only non-core field in the old dinode */
+	__be32		di_next_unlinked;/* agi unlinked list ptr */
 } xfs_dinode_t;
 
+#define DI_MAX_FLUSH 0xffff
+
 /*
  * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
  * Since the pathconf interface is signed, we use 2^31 - 1 instead.
@@ -108,14 +87,12 @@ typedef struct xfs_dinode
 /*
  * Values for di_format
  */
-typedef enum xfs_dinode_fmt
-{
-	XFS_DINODE_FMT_DEV,		/* CHR, BLK: di_dev */
-	XFS_DINODE_FMT_LOCAL,		/* DIR, REG: di_c */
-					/* LNK: di_symlink */
-	XFS_DINODE_FMT_EXTENTS,		/* DIR, REG, LNK: di_bmx */
-	XFS_DINODE_FMT_BTREE,		/* DIR, REG, LNK: di_bmbt */
-	XFS_DINODE_FMT_UUID		/* MNT: di_uuid */
+typedef enum xfs_dinode_fmt {
+	XFS_DINODE_FMT_DEV,		/* xfs_dev_t */
+	XFS_DINODE_FMT_LOCAL,		/* bulk data */
+	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
+	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
+	XFS_DINODE_FMT_UUID		/* uuid_t */
 } xfs_dinode_fmt_t;
 
 /*
@@ -136,8 +113,8 @@ typedef enum xfs_dinode_fmt
 /*
  * Inode data & attribute fork sizes, per inode.
  */
-#define XFS_DFORK_Q(dip)		((dip)->di_core.di_forkoff != 0)
-#define XFS_DFORK_BOFF(dip)		((int)((dip)->di_core.di_forkoff << 3))
+#define XFS_DFORK_Q(dip)		((dip)->di_forkoff != 0)
+#define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
 
 #define XFS_DFORK_DSIZE(dip,mp) \
 	(XFS_DFORK_Q(dip) ? \
@@ -152,23 +129,42 @@ typedef enum xfs_dinode_fmt
 		XFS_DFORK_DSIZE(dip, mp) : \
 		XFS_DFORK_ASIZE(dip, mp))
 
-#define XFS_DFORK_DPTR(dip)		    ((dip)->di_u.di_c)
+/*
+ * Return pointers to the data or attribute forks.
+ */
+#define XFS_DFORK_DPTR(dip) \
+	((char *)dip + sizeof(struct xfs_dinode))
 #define XFS_DFORK_APTR(dip)	\
-	((dip)->di_u.di_c + XFS_DFORK_BOFF(dip))
+	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\
 	((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : XFS_DFORK_APTR(dip))
+
 #define XFS_DFORK_FORMAT(dip,w) \
 	((w) == XFS_DATA_FORK ? \
-		(dip)->di_core.di_format : \
-		(dip)->di_core.di_aformat)
+		(dip)->di_format : \
+		(dip)->di_aformat)
 #define XFS_DFORK_NEXTENTS(dip,w) \
 	((w) == XFS_DATA_FORK ? \
-	 	be32_to_cpu((dip)->di_core.di_nextents) : \
-	 	be16_to_cpu((dip)->di_core.di_anextents))
+	 	be32_to_cpu((dip)->di_nextents) : \
+	 	be16_to_cpu((dip)->di_anextents))
 
 #define	XFS_BUF_TO_DINODE(bp)	((xfs_dinode_t *)XFS_BUF_PTR(bp))
 
 /*
+ * For block and character special files the 32bit dev_t is stored at the
+ * beginning of the data fork.
+ */
+static inline xfs_dev_t xfs_dinode_get_rdev(struct xfs_dinode *dip)
+{
+	return be32_to_cpu(*(__be32 *)XFS_DFORK_DPTR(dip));
+}
+
+static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
+{
+	*(__be32 *)XFS_DFORK_DPTR(dip) = cpu_to_be32(rdev);
+}
+
+/*
  * Values for di_flags
  * There should be a one-to-one correspondence between these flags and the
  * XFS_XFLAG_s.
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-10-25 13:22:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-10-25 13:23:00.000000000 +0200
@@ -174,8 +174,8 @@ xfs_imap_to_bp(
 
 		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
 					(i << mp->m_sb.sb_inodelog));
-		di_ok = be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC &&
-			    XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
+		di_ok = be16_to_cpu(dip->di_magic) == XFS_DINODE_MAGIC &&
+			    XFS_DINODE_GOOD_VERSION(dip->di_version);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP,
 						XFS_RANDOM_ITOBP_INOTOBP))) {
@@ -191,7 +191,7 @@ xfs_imap_to_bp(
 					"daddr %lld #%d (magic=%x)",
 				XFS_BUFTARG_NAME(mp->m_ddev_targp),
 				(unsigned long long)imap->im_blkno, i,
-				be16_to_cpu(dip->di_core.di_magic));
+				be16_to_cpu(dip->di_magic));
 #endif
 			xfs_trans_brelse(tp, bp);
 			return XFS_ERROR(EFSCORRUPTED);
@@ -350,26 +350,26 @@ xfs_iformat(
 		XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	error = 0;
 
-	if (unlikely(be32_to_cpu(dip->di_core.di_nextents) +
-		     be16_to_cpu(dip->di_core.di_anextents) >
-		     be64_to_cpu(dip->di_core.di_nblocks))) {
+	if (unlikely(be32_to_cpu(dip->di_nextents) +
+		     be16_to_cpu(dip->di_anextents) >
+		     be64_to_cpu(dip->di_nblocks))) {
 		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 			"corrupt dinode %Lu, extent total = %d, nblocks = %Lu.",
 			(unsigned long long)ip->i_ino,
-			(int)(be32_to_cpu(dip->di_core.di_nextents) +
-			      be16_to_cpu(dip->di_core.di_anextents)),
+			(int)(be32_to_cpu(dip->di_nextents) +
+			      be16_to_cpu(dip->di_anextents)),
 			(unsigned long long)
-				be64_to_cpu(dip->di_core.di_nblocks));
+				be64_to_cpu(dip->di_nblocks));
 		XFS_CORRUPTION_ERROR("xfs_iformat(1)", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
-	if (unlikely(dip->di_core.di_forkoff > ip->i_mount->m_sb.sb_inodesize)) {
+	if (unlikely(dip->di_forkoff > ip->i_mount->m_sb.sb_inodesize)) {
 		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 			"corrupt dinode %Lu, forkoff = 0x%x.",
 			(unsigned long long)ip->i_ino,
-			dip->di_core.di_forkoff);
+			dip->di_forkoff);
 		XFS_CORRUPTION_ERROR("xfs_iformat(2)", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
 		return XFS_ERROR(EFSCORRUPTED);
@@ -380,25 +380,25 @@ xfs_iformat(
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFSOCK:
-		if (unlikely(dip->di_core.di_format != XFS_DINODE_FMT_DEV)) {
+		if (unlikely(dip->di_format != XFS_DINODE_FMT_DEV)) {
 			XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
 					      ip->i_mount, dip);
 			return XFS_ERROR(EFSCORRUPTED);
 		}
 		ip->i_d.di_size = 0;
 		ip->i_size = 0;
-		ip->i_df.if_u2.if_rdev = be32_to_cpu(dip->di_u.di_dev);
+		ip->i_df.if_u2.if_rdev = xfs_dinode_get_rdev(dip);
 		break;
 
 	case S_IFREG:
 	case S_IFLNK:
 	case S_IFDIR:
-		switch (dip->di_core.di_format) {
+		switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
 			/*
 			 * no local regular files yet
 			 */
-			if (unlikely((be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFREG)) {
+			if (unlikely((be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFREG)) {
 				xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 					"corrupt inode %Lu "
 					"(local format for regular file).",
@@ -409,7 +409,7 @@ xfs_iformat(
 				return XFS_ERROR(EFSCORRUPTED);
 			}
 
-			di_size = be64_to_cpu(dip->di_core.di_size);
+			di_size = be64_to_cpu(dip->di_size);
 			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
 				xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 					"corrupt inode %Lu "
@@ -451,7 +451,7 @@ xfs_iformat(
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
 	ip->i_afp->if_ext_max =
 		XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
-	switch (dip->di_core.di_aformat) {
+	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
 		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		size = be16_to_cpu(atp->hdr.totsize);
@@ -663,7 +663,7 @@ xfs_iformat_btree(
 void
 xfs_dinode_from_disk(
 	xfs_icdinode_t		*to,
-	xfs_dinode_core_t	*from)
+	xfs_dinode_t		*from)
 {
 	to->di_magic = be16_to_cpu(from->di_magic);
 	to->di_mode = be16_to_cpu(from->di_mode);
@@ -697,7 +697,7 @@ xfs_dinode_from_disk(
 
 void
 xfs_dinode_to_disk(
-	xfs_dinode_core_t	*to,
+	xfs_dinode_t		*to,
 	xfs_icdinode_t		*from)
 {
 	to->di_magic = cpu_to_be16(from->di_magic);
@@ -784,9 +784,7 @@ uint
 xfs_dic2xflags(
 	xfs_dinode_t		*dip)
 {
-	xfs_dinode_core_t	*dic = &dip->di_core;
-
-	return _xfs_dic2xflags(be16_to_cpu(dic->di_flags)) |
+	return _xfs_dic2xflags(be16_to_cpu(dip->di_flags)) |
 				(XFS_DFORK_Q(dip) ? XFS_XFLAG_HASATTR : 0);
 }
 
@@ -905,12 +903,12 @@ xfs_iread(
 	 * If we got something that isn't an inode it means someone
 	 * (nfs or dmi) has a stale handle.
 	 */
-	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC) {
+	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC) {
 #ifdef DEBUG
 		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
-				"dip->di_core.di_magic (0x%x) != "
+				"dip->di_magic (0x%x) != "
 				"XFS_DINODE_MAGIC (0x%x)",
-				be16_to_cpu(dip->di_core.di_magic),
+				be16_to_cpu(dip->di_magic),
 				XFS_DINODE_MAGIC);
 #endif /* DEBUG */
 		error = XFS_ERROR(EINVAL);
@@ -924,8 +922,8 @@ xfs_iread(
 	 * specific information.
 	 * Otherwise, just get the truly permanent information.
 	 */
-	if (dip->di_core.di_mode) {
-		xfs_dinode_from_disk(&ip->i_d, &dip->di_core);
+	if (dip->di_mode) {
+		xfs_dinode_from_disk(&ip->i_d, dip);
 		error = xfs_iformat(ip, dip);
 		if (error)  {
 #ifdef DEBUG
@@ -936,10 +934,10 @@ xfs_iread(
 			goto out_brelse;
 		}
 	} else {
-		ip->i_d.di_magic = be16_to_cpu(dip->di_core.di_magic);
-		ip->i_d.di_version = dip->di_core.di_version;
-		ip->i_d.di_gen = be32_to_cpu(dip->di_core.di_gen);
-		ip->i_d.di_flushiter = be16_to_cpu(dip->di_core.di_flushiter);
+		ip->i_d.di_magic = be16_to_cpu(dip->di_magic);
+		ip->i_d.di_version = dip->di_version;
+		ip->i_d.di_gen = be32_to_cpu(dip->di_gen);
+		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
 		/*
 		 * Make sure to pull in the mode here as well in
 		 * case the inode is released without being used.
@@ -2292,7 +2290,7 @@ xfs_ifree(
 	* This is a temporary hack that would require a proper fix
 	* in the future.
 	*/
-	dip->di_core.di_mode = 0;
+	dip->di_mode = 0;
 
 	if (delete) {
 		xfs_ifree_cluster(ip, tp, first_ino);
@@ -2906,15 +2904,16 @@ xfs_iflush_fork(
 	case XFS_DINODE_FMT_DEV:
 		if (iip->ili_format.ilf_fields & XFS_ILOG_DEV) {
 			ASSERT(whichfork == XFS_DATA_FORK);
-			dip->di_u.di_dev = cpu_to_be32(ip->i_df.if_u2.if_rdev);
+			xfs_dinode_put_rdev(dip, ip->i_df.if_u2.if_rdev);
 		}
 		break;
 
 	case XFS_DINODE_FMT_UUID:
 		if (iip->ili_format.ilf_fields & XFS_ILOG_UUID) {
 			ASSERT(whichfork == XFS_DATA_FORK);
-			memcpy(&dip->di_u.di_muuid, &ip->i_df.if_u2.if_uuid,
-				sizeof(uuid_t));
+			memcpy(XFS_DFORK_DPTR(dip),
+			       &ip->i_df.if_u2.if_uuid,
+			       sizeof(uuid_t));
 		}
 		break;
 
@@ -3292,11 +3291,11 @@ xfs_iflush_int(
 	 */
 	xfs_synchronize_atime(ip);
 
-	if (XFS_TEST_ERROR(be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC,
+	if (XFS_TEST_ERROR(be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC,
 			       mp, XFS_ERRTAG_IFLUSH_1, XFS_RANDOM_IFLUSH_1)) {
 		xfs_cmn_err(XFS_PTAG_IFLUSH, CE_ALERT, mp,
 		    "xfs_iflush: Bad inode %Lu magic number 0x%x, ptr 0x%p",
-			ip->i_ino, be16_to_cpu(dip->di_core.di_magic), dip);
+			ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto corrupt_out;
 	}
 	if (XFS_TEST_ERROR(ip->i_d.di_magic != XFS_DINODE_MAGIC,
@@ -3359,7 +3358,7 @@ xfs_iflush_int(
 	 * because if the inode is dirty at all the core must
 	 * be.
 	 */
-	xfs_dinode_to_disk(&dip->di_core, &ip->i_d);
+	xfs_dinode_to_disk(dip, &ip->i_d);
 
 	/* Wrap, we never let the log put out DI_MAX_FLUSH */
 	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
@@ -3379,7 +3378,7 @@ xfs_iflush_int(
 			 * Convert it back.
 			 */
 			ASSERT(ip->i_d.di_nlink <= XFS_MAXLINK_1);
-			dip->di_core.di_onlink = cpu_to_be16(ip->i_d.di_nlink);
+			dip->di_onlink = cpu_to_be16(ip->i_d.di_nlink);
 		} else {
 			/*
 			 * The superblock version has already been bumped,
@@ -3387,12 +3386,12 @@ xfs_iflush_int(
 			 * format permanent.
 			 */
 			ip->i_d.di_version = XFS_DINODE_VERSION_2;
-			dip->di_core.di_version =  XFS_DINODE_VERSION_2;
+			dip->di_version =  XFS_DINODE_VERSION_2;
 			ip->i_d.di_onlink = 0;
-			dip->di_core.di_onlink = 0;
+			dip->di_onlink = 0;
 			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
-			memset(&(dip->di_core.di_pad[0]), 0,
-			      sizeof(dip->di_core.di_pad));
+			memset(&(dip->di_pad[0]), 0,
+			      sizeof(dip->di_pad));
 			ASSERT(ip->i_d.di_projid == 0);
 		}
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-10-25 13:22:23.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-10-25 13:22:29.000000000 +0200
@@ -2320,7 +2320,7 @@ xlog_recover_do_inode_trans(
 	 * Make sure the place we're flushing out to really looks
 	 * like an inode!
 	 */
-	if (unlikely(be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC)) {
+	if (unlikely(be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC)) {
 		xfs_buf_relse(bp);
 		xfs_fs_cmn_err(CE_ALERT, mp,
 			"xfs_inode_recover: Bad inode magic number, dino ptr = 0x%p, dino bp = 0x%p, ino = %Ld",
@@ -2343,12 +2343,12 @@ xlog_recover_do_inode_trans(
 	}
 
 	/* Skip replay when the on disk inode is newer than the log one */
-	if (dicp->di_flushiter < be16_to_cpu(dip->di_core.di_flushiter)) {
+	if (dicp->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
 		/*
 		 * Deal with the wrap case, DI_MAX_FLUSH is less
 		 * than smaller numbers
 		 */
-		if (be16_to_cpu(dip->di_core.di_flushiter) == DI_MAX_FLUSH &&
+		if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
 		    dicp->di_flushiter < (DI_MAX_FLUSH >> 1)) {
 			/* do nothing */
 		} else {
@@ -2408,7 +2408,7 @@ xlog_recover_do_inode_trans(
 		error = EFSCORRUPTED;
 		goto error;
 	}
-	if (unlikely(item->ri_buf[1].i_len > sizeof(xfs_dinode_core_t))) {
+	if (unlikely(item->ri_buf[1].i_len > sizeof(struct xfs_icdinode))) {
 		XFS_CORRUPTION_ERROR("xlog_recover_do_inode_trans(7)",
 				     XFS_ERRLEVEL_LOW, mp, dicp);
 		xfs_buf_relse(bp);
@@ -2420,23 +2420,24 @@ xlog_recover_do_inode_trans(
 	}
 
 	/* The core is in in-core format */
-	xfs_dinode_to_disk(&dip->di_core,
-		(xfs_icdinode_t *)item->ri_buf[1].i_addr);
+	xfs_dinode_to_disk(dip, (xfs_icdinode_t *)item->ri_buf[1].i_addr);
 
 	/* the rest is in on-disk format */
-	if (item->ri_buf[1].i_len > sizeof(xfs_dinode_core_t)) {
-		memcpy((xfs_caddr_t) dip + sizeof(xfs_dinode_core_t),
-			item->ri_buf[1].i_addr + sizeof(xfs_dinode_core_t),
-			item->ri_buf[1].i_len  - sizeof(xfs_dinode_core_t));
+	if (item->ri_buf[1].i_len > sizeof(struct xfs_icdinode)) {
+		memcpy((xfs_caddr_t) dip + sizeof(struct xfs_icdinode),
+			item->ri_buf[1].i_addr + sizeof(struct xfs_icdinode),
+			item->ri_buf[1].i_len  - sizeof(struct xfs_icdinode));
 	}
 
 	fields = in_f->ilf_fields;
 	switch (fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
 	case XFS_ILOG_DEV:
-		dip->di_u.di_dev = cpu_to_be32(in_f->ilf_u.ilfu_rdev);
+		xfs_dinode_put_rdev(dip, in_f->ilf_u.ilfu_rdev);
 		break;
 	case XFS_ILOG_UUID:
-		dip->di_u.di_muuid = in_f->ilf_u.ilfu_uuid;
+		memcpy(XFS_DFORK_DPTR(dip),
+		       &in_f->ilf_u.ilfu_uuid,
+		       sizeof(uuid_t));
 		break;
 	}
 
@@ -2452,12 +2453,12 @@ xlog_recover_do_inode_trans(
 	switch (fields & XFS_ILOG_DFORK) {
 	case XFS_ILOG_DDATA:
 	case XFS_ILOG_DEXT:
-		memcpy(&dip->di_u, src, len);
+		memcpy(XFS_DFORK_DPTR(dip), src, len);
 		break;
 
 	case XFS_ILOG_DBROOT:
 		xfs_bmbt_to_bmdr(mp, (struct xfs_btree_block *)src, len,
-				 &dip->di_u.di_bmbt,
+				 (xfs_bmdr_block_t *)XFS_DFORK_DPTR(dip),
 				 XFS_DFORK_DSIZE(dip, mp));
 		break;
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-10-25 13:15:42.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-10-25 13:22:29.000000000 +0200
@@ -19,7 +19,6 @@
 #define	__XFS_INODE_H__
 
 struct xfs_dinode;
-struct xfs_dinode_core;
 struct xfs_inode;
 
 /*
@@ -112,7 +111,7 @@ typedef struct xfs_ictimestamp {
 } xfs_ictimestamp_t;
 
 /*
- * NOTE:  This structure must be kept identical to struct xfs_dinode_core
+ * NOTE:  This structure must be kept identical to struct xfs_dinode
  * 	  in xfs_dinode.h except for the endianess annotations.
  */
 typedef struct xfs_icdinode {
@@ -549,8 +548,8 @@ int		xfs_itobp(struct xfs_mount *, struc
 			  struct xfs_inode *, struct xfs_dinode **,
 			  struct xfs_buf **, xfs_daddr_t, uint, uint);
 void		xfs_dinode_from_disk(struct xfs_icdinode *,
-				     struct xfs_dinode_core *);
-void		xfs_dinode_to_disk(struct xfs_dinode_core *,
+				     struct xfs_dinode *);
+void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
 void		xfs_idata_realloc(struct xfs_inode *, int, int);
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2008-10-25 13:02:57.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2008-10-25 13:22:29.000000000 +0200
@@ -125,13 +125,9 @@ STATIC void
 xfs_bulkstat_one_dinode(
 	xfs_mount_t	*mp,		/* mount point for filesystem */
 	xfs_ino_t	ino,		/* inode number to get data for */
-	xfs_dinode_t	*dip,		/* dinode inode pointer */
+	xfs_dinode_t	*dic,		/* dinode inode pointer */
 	xfs_bstat_t	*buf)		/* return buffer */
 {
-	xfs_dinode_core_t *dic;		/* dinode core info pointer */
-
-	dic = &dip->di_core;
-
 	/*
 	 * The inode format changed when we moved the link count and
 	 * made it 32 bits long.  If this is an old format inode,
@@ -162,7 +158,7 @@ xfs_bulkstat_one_dinode(
 	buf->bs_mtime.tv_nsec = be32_to_cpu(dic->di_mtime.t_nsec);
 	buf->bs_ctime.tv_sec = be32_to_cpu(dic->di_ctime.t_sec);
 	buf->bs_ctime.tv_nsec = be32_to_cpu(dic->di_ctime.t_nsec);
-	buf->bs_xflags = xfs_dic2xflags(dip);
+	buf->bs_xflags = xfs_dic2xflags(dic);
 	buf->bs_extsize = be32_to_cpu(dic->di_extsize) << mp->m_sb.sb_blocklog;
 	buf->bs_extents = be32_to_cpu(dic->di_nextents);
 	buf->bs_gen = be32_to_cpu(dic->di_gen);
@@ -173,7 +169,7 @@ xfs_bulkstat_one_dinode(
 
 	switch (dic->di_format) {
 	case XFS_DINODE_FMT_DEV:
-		buf->bs_rdev = be32_to_cpu(dip->di_u.di_dev);
+		buf->bs_rdev = xfs_dinode_get_rdev(dic);
 		buf->bs_blksize = BLKDEV_IOSIZE;
 		buf->bs_blocks = 0;
 		break;
@@ -287,19 +283,19 @@ xfs_bulkstat_use_dinode(
 	 * to disk yet. This is a temporary hack that would require a proper
 	 * fix in the future.
 	 */
-	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC ||
-	    !XFS_DINODE_GOOD_VERSION(dip->di_core.di_version) ||
-	    !dip->di_core.di_mode)
+	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC ||
+	    !XFS_DINODE_GOOD_VERSION(dip->di_version) ||
+	    !dip->di_mode)
 		return 0;
 	if (flags & BULKSTAT_FG_QUICK) {
 		*dipp = dip;
 		return 1;
 	}
 	/* BULKSTAT_FG_INLINE: if attr fork is local, or not there, use it */
-	aformat = dip->di_core.di_aformat;
+	aformat = dip->di_aformat;
 	if ((XFS_DFORK_Q(dip) == 0) ||
 	    (aformat == XFS_DINODE_FMT_LOCAL) ||
-	    (aformat == XFS_DINODE_FMT_EXTENTS && !dip->di_core.di_anextents)) {
+	    (aformat == XFS_DINODE_FMT_EXTENTS && !dip->di_anextents)) {
 		*dipp = dip;
 		return 1;
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_dir2_sf.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dir2_sf.h	2008-10-25 13:00:19.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dir2_sf.h	2008-10-25 13:22:29.000000000 +0200
@@ -34,13 +34,6 @@ struct xfs_mount;
 struct xfs_trans;
 
 /*
- * Maximum size of a shortform directory.
- */
-#define	XFS_DIR2_SF_MAX_SIZE	\
-	(XFS_DINODE_MAX_SIZE - (uint)sizeof(xfs_dinode_core_t) - \
-	 (uint)sizeof(xfs_agino_t))
-
-/*
  * Inode number stored as 8 8-bit values.
  */
 typedef	struct { __uint8_t i[8]; } xfs_dir2_ino8_t;
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-10-25 13:22:24.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-10-25 13:22:29.000000000 +0200
@@ -355,12 +355,12 @@ xfs_ialloc_ag_alloc(
 		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
 		for (i = 0; i < ninodes; i++) {
 			int	ioffset = i << args.mp->m_sb.sb_inodelog;
-			uint	isize = sizeof(xfs_dinode_t) + sizeof(__be32);
+			uint	isize = sizeof(struct xfs_dinode);
 
 			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
-			free->di_core.di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
-			free->di_core.di_version = version;
-			free->di_core.di_gen = cpu_to_be32(gen);
+			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+			free->di_version = version;
+			free->di_gen = cpu_to_be32(gen);
 			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
 		}
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-10-25 13:18:54.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-10-25 13:22:29.000000000 +0200
@@ -575,8 +575,7 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
 	mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-	mp->m_litino = sbp->sb_inodesize -
-		((uint)sizeof(xfs_dinode_core_t) + (uint)sizeof(xfs_agino_t));
+	mp->m_litino = sbp->sb_inodesize - sizeof(struct xfs_dinode);
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-10-25 13:22:23.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-10-25 13:22:29.000000000 +0200
@@ -3635,10 +3635,11 @@ xfs_inodebuf(xfs_buf_t *bp)
 		di = (xfs_dinode_t *)xfs_buf_offset(bp,
 					i * 256);
 
-		xfs_dinode_from_disk(&dic, &di->di_core);
+		xfs_dinode_from_disk(&dic, di);
 		xfs_prdinode_incore(&dic);
 		kdb_printf("next_unlinked 0x%x u@0x%p\n",
-			   be32_to_cpu(di->di_next_unlinked), &di->di_u);
+			   be32_to_cpu(di->di_next_unlinked),
+			   XFS_DFORK_DPTR(di));
 	}
 }
 
@@ -4847,7 +4848,7 @@ xfsidbg_xbuf_real(xfs_buf_t *bp, int sum
 			kdb_printf("buf 0x%p dir/attr node 0x%p\n", bp, node);
 			xfsidbg_xdanode(node);
 		}
-	} else if (be16_to_cpu((di = d)->di_core.di_magic) == XFS_DINODE_MAGIC) {
+	} else if (be16_to_cpu((di = d)->di_magic) == XFS_DINODE_MAGIC) {
 		if (summary) {
 			kdb_printf("Disk Inode (at 0x%p)\n", di);
 		} else {
Index: linux-2.6-xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode_item.c	2008-10-25 13:00:19.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode_item.c	2008-10-25 13:22:29.000000000 +0200
@@ -281,7 +281,7 @@ xfs_inode_item_format(
 	xfs_mark_inode_dirty_sync(ip);
 
 	vecp->i_addr = (xfs_caddr_t)&ip->i_d;
-	vecp->i_len  = sizeof(xfs_dinode_core_t);
+	vecp->i_len  = sizeof(struct xfs_icdinode);
 	XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_ICORE);
 	vecp++;
 	nvecs++;

-- 
