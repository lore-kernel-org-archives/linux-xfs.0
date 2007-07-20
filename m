Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Jul 2007 09:33:07 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6KGX1bm003671
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2007 09:33:03 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6KGX3A5007338
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2007 18:33:03 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6KGX3kt007336
	for xfs@oss.sgi.com; Fri, 20 Jul 2007 18:33:03 +0200
Date: Fri, 20 Jul 2007 18:33:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] superblock endianess annotations
Message-ID: <20070720163303.GB6902@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Creates a new xfs_dsb_t that is __be annotated and keeps xfs_sb_t for
the incore one.  xfs_xlatesb is renamed to xfs_sb_to_disk and only
handles the incore -> disk conversion.  A new helper xfs_sb_from_disk
handles the other direction and doesn't need the slightly hacky
table-driven approach because we only ever read the full sb from disk.

The handling of shared r/o filesystems has been buggy on little endian
system and fixing this required shuffling around of some code in that
area.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fsops.c	2007-07-15 21:02:15.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_fsops.c	2007-07-17 07:54:42.000000000 +0200
@@ -136,7 +136,6 @@ xfs_growfs_data_private(
 	xfs_rfsblock_t		nfree;
 	xfs_agnumber_t		oagcount;
 	int			pct;
-	xfs_sb_t		*sbp;
 	xfs_trans_t		*tp;
 
 	nb = in->newblocks;
@@ -377,8 +376,7 @@ xfs_growfs_data_private(
 				error, agno);
 			break;
 		}
-		sbp = XFS_BUF_TO_SBP(bp);
-		xfs_xlatesb(sbp, &mp->m_sb, -1, XFS_SB_ALL_BITS);
+		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);
 		/*
 		 * If we get an error writing out the alternate superblocks,
 		 * just issue a warning and continue.  The real work is
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-07-15 21:02:15.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-07-17 07:54:42.000000000 +0200
@@ -407,37 +407,79 @@ xfs_initialize_perag(
 	return index;
 }
 
+void
+xfs_sb_from_disk(
+	xfs_sb_t	*to,
+	xfs_dsb_t	*from)
+{
+	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
+	to->sb_blocksize = be32_to_cpu(from->sb_blocksize);
+	to->sb_dblocks = be64_to_cpu(from->sb_dblocks);
+	to->sb_rblocks = be64_to_cpu(from->sb_rblocks);
+	to->sb_rextents = be64_to_cpu(from->sb_rextents);
+	memcpy(&to->sb_uuid, &from->sb_uuid, sizeof(to->sb_uuid));
+	to->sb_logstart = be64_to_cpu(from->sb_logstart);
+	to->sb_rootino = be64_to_cpu(from->sb_rootino);
+	to->sb_rbmino = be64_to_cpu(from->sb_rbmino);
+	to->sb_rsumino = be64_to_cpu(from->sb_rsumino);
+	to->sb_rextsize = be32_to_cpu(from->sb_rextsize);
+	to->sb_agblocks = be32_to_cpu(from->sb_agblocks);
+	to->sb_agcount = be32_to_cpu(from->sb_agcount);
+	to->sb_rbmblocks = be32_to_cpu(from->sb_rbmblocks);
+	to->sb_logblocks = be32_to_cpu(from->sb_logblocks);
+	to->sb_versionnum = be16_to_cpu(from->sb_versionnum);
+	to->sb_sectsize = be16_to_cpu(from->sb_sectsize);
+	to->sb_inodesize = be16_to_cpu(from->sb_inodesize);
+	to->sb_inopblock = be16_to_cpu(from->sb_inopblock);
+	memcpy(&to->sb_fname, &from->sb_fname, sizeof(to->sb_fname));
+	to->sb_blocklog = from->sb_blocklog;
+	to->sb_sectlog = from->sb_sectlog;
+	to->sb_inodelog = from->sb_inodelog;
+	to->sb_inopblog = from->sb_inopblog;
+	to->sb_agblklog = from->sb_agblklog;
+	to->sb_rextslog = from->sb_rextslog;
+	to->sb_inprogress = from->sb_inprogress;
+	to->sb_imax_pct = from->sb_imax_pct;
+	to->sb_icount = be64_to_cpu(from->sb_icount);
+	to->sb_ifree = be64_to_cpu(from->sb_ifree);
+	to->sb_fdblocks = be64_to_cpu(from->sb_fdblocks);
+	to->sb_frextents = be64_to_cpu(from->sb_frextents);
+	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
+	to->sb_gquotino = be64_to_cpu(from->sb_gquotino);
+	to->sb_qflags = be16_to_cpu(from->sb_qflags);
+	to->sb_flags = from->sb_flags;
+	to->sb_shared_vn = from->sb_shared_vn;
+	to->sb_inoalignmt = be32_to_cpu(from->sb_inoalignmt);
+	to->sb_unit = be32_to_cpu(from->sb_unit);
+	to->sb_width = be32_to_cpu(from->sb_width);
+	to->sb_dirblklog = from->sb_dirblklog;
+	to->sb_logsectlog = from->sb_logsectlog;
+	to->sb_logsectsize = be16_to_cpu(from->sb_logsectsize);
+	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
+	to->sb_features2 = be32_to_cpu(from->sb_features2);
+}
+
 /*
- * xfs_xlatesb
+ * Copy in core superblock to ondisk one.
  *
- *     data       - on disk version of sb
- *     sb         - a superblock
- *     dir        - conversion direction: <0 - convert sb to buf
- *                                        >0 - convert buf to sb
- *     fields     - which fields to copy (bitmask)
+ * The fields argument is mask of superblock fields to copy.
  */
 void
-xfs_xlatesb(
-	void		*data,
-	xfs_sb_t	*sb,
-	int		dir,
+xfs_sb_to_disk(
+	xfs_dsb_t	*to,
+	xfs_sb_t	*from,
 	__int64_t	fields)
 {
-	xfs_caddr_t	buf_ptr;
-	xfs_caddr_t	mem_ptr;
+	xfs_caddr_t	to_ptr = (xfs_caddr_t)to;
+	xfs_caddr_t	from_ptr = (xfs_caddr_t)from;
 	xfs_sb_field_t	f;
 	int		first;
 	int		size;
 
-	ASSERT(dir);
 	ASSERT(fields);
-
 	if (!fields)
 		return;
 
-	buf_ptr = (xfs_caddr_t)data;
-	mem_ptr = (xfs_caddr_t)sb;
-
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 		first = xfs_sb_info[f].offset;
@@ -446,26 +488,20 @@ xfs_xlatesb(
 		ASSERT(xfs_sb_info[f].type == 0 || xfs_sb_info[f].type == 1);
 
 		if (size == 1 || xfs_sb_info[f].type == 1) {
-			if (dir > 0) {
-				memcpy(mem_ptr + first, buf_ptr + first, size);
-			} else {
-				memcpy(buf_ptr + first, mem_ptr + first, size);
-			}
+			memcpy(to_ptr + first, from_ptr + first, size);
 		} else {
 			switch (size) {
 			case 2:
-				INT_XLATE(*(__uint16_t*)(buf_ptr+first),
-					  *(__uint16_t*)(mem_ptr+first),
-					  dir, ARCH_CONVERT);
+				*(__be16 *)(to_ptr + first) =
+					cpu_to_be16(*(__u16 *)(from_ptr + first));
 				break;
 			case 4:
-				INT_XLATE(*(__uint32_t*)(buf_ptr+first),
-					  *(__uint32_t*)(mem_ptr+first),
-					  dir, ARCH_CONVERT);
+				*(__be32 *)(to_ptr + first) =
+					cpu_to_be32(*(__u32 *)(from_ptr + first));
 				break;
 			case 8:
-				INT_XLATE(*(__uint64_t*)(buf_ptr+first),
-					  *(__uint64_t*)(mem_ptr+first), dir, ARCH_CONVERT);
+				*(__be64 *)(to_ptr + first) =
+					cpu_to_be64(*(__u64 *)(from_ptr + first));
 				break;
 			default:
 				ASSERT(0);
@@ -487,7 +523,6 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	unsigned int	sector_size;
 	unsigned int	extra_flags;
 	xfs_buf_t	*bp;
-	xfs_sb_t	*sbp;
 	int		error;
 
 	ASSERT(mp->m_sb_bp == NULL);
@@ -515,8 +550,7 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	 * Initialize the mount structure from the superblock.
 	 * But first do some basic consistency checking.
 	 */
-	sbp = XFS_BUF_TO_SBP(bp);
-	xfs_xlatesb(XFS_BUF_PTR(bp), &(mp->m_sb), 1, XFS_SB_ALL_BITS);
+	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
 
 	error = xfs_mount_validate_sb(mp, &(mp->m_sb), flags);
 	if (error) {
@@ -1348,11 +1382,28 @@ xfs_log_sbcount(
 	return 0;
 }
 
+STATIC void
+xfs_mark_shared_ro(
+	xfs_mount_t	*mp,
+	xfs_buf_t	*bp)
+{
+	xfs_dsb_t	*sb = XFS_BUF_TO_SBP(bp);
+	__uint16_t	version;
+
+	if (!(sb->sb_flags & XFS_SBF_READONLY))
+		sb->sb_flags |= XFS_SBF_READONLY;
+
+	version = be16_to_cpu(sb->sb_versionnum);
+	if ((version & XFS_SB_VERSION_NUMBITS) != XFS_SB_VERSION_4 ||
+	    !(version & XFS_SB_VERSION_SHAREDBIT))
+		version |= XFS_SB_VERSION_SHAREDBIT;
+	sb->sb_versionnum = cpu_to_be16(version);
+}
+
 int
 xfs_unmountfs_writesb(xfs_mount_t *mp)
 {
 	xfs_buf_t	*sbp;
-	xfs_sb_t	*sb;
 	int		error = 0;
 
 	/*
@@ -1363,19 +1414,12 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 		XFS_FORCED_SHUTDOWN(mp))) {
 
 		sbp = xfs_getsb(mp, 0);
- 		sb = XFS_BUF_TO_SBP(sbp);
 
 		/*
 		 * mark shared-readonly if desired
 		 */
-		if (mp->m_mk_sharedro) {
-			if (!(sb->sb_flags & XFS_SBF_READONLY))
-				sb->sb_flags |= XFS_SBF_READONLY;
-			if (!XFS_SB_VERSION_HASSHARED(sb))
-				XFS_SB_VERSION_ADDSHARED(sb);
-			xfs_fs_cmn_err(CE_NOTE, mp,
-				"Unmounting, marking shared read-only");
-		}
+		if (mp->m_mk_sharedro)
+			xfs_mark_shared_ro(mp, sbp);
 
 		XFS_BUF_UNDONE(sbp);
 		XFS_BUF_UNREAD(sbp);
@@ -1410,7 +1454,6 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fi
 	int		first;
 	int		last;
 	xfs_mount_t	*mp;
-	xfs_sb_t	*sbp;
 	xfs_sb_field_t	f;
 
 	ASSERT(fields);
@@ -1418,13 +1461,12 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fi
 		return;
 	mp = tp->t_mountp;
 	bp = xfs_trans_getsb(tp, mp, 0);
-	sbp = XFS_BUF_TO_SBP(bp);
 	first = sizeof(xfs_sb_t);
 	last = 0;
 
 	/* translate/copy */
 
-	xfs_xlatesb(XFS_BUF_PTR(bp), &(mp->m_sb), -1, fields);
+	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
 
 	/* find modified range */
 
Index: linux-2.6-xfs/fs/xfs/xfs_sb.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_sb.h	2007-07-15 21:02:15.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_sb.h	2007-07-17 07:54:42.000000000 +0200
@@ -87,8 +87,10 @@ struct xfs_mount;
 	(XFS_SB_VERSION2_OKREALFBITS |	\
 	 XFS_SB_VERSION2_OKSASHFBITS )
 
-typedef struct xfs_sb
-{
+/*
+ * Superblock - in core version.  Must match the ondisk version below.
+ */
+typedef struct xfs_sb {
 	__uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
 	__uint32_t	sb_blocksize;	/* logical block size, bytes */
 	xfs_drfsbno_t	sb_dblocks;	/* number of data blocks */
@@ -146,6 +148,66 @@ typedef struct xfs_sb
 } xfs_sb_t;
 
 /*
+ * Superblock - on disk version.  Must match the in core version below.
+ */
+typedef struct xfs_dsb {
+	__be32		sb_magicnum;	/* magic number == XFS_SB_MAGIC */
+	__be32		sb_blocksize;	/* logical block size, bytes */
+	__be64		sb_dblocks;	/* number of data blocks */
+	__be64		sb_rblocks;	/* number of realtime blocks */
+	__be64		sb_rextents;	/* number of realtime extents */
+	uuid_t		sb_uuid;	/* file system unique id */
+	__be64		sb_logstart;	/* starting block of log if internal */
+	__be64		sb_rootino;	/* root inode number */
+	__be64		sb_rbmino;	/* bitmap inode for realtime extents */
+	__be64		sb_rsumino;	/* summary inode for rt bitmap */
+	__be32		sb_rextsize;	/* realtime extent size, blocks */
+	__be32		sb_agblocks;	/* size of an allocation group */
+	__be32		sb_agcount;	/* number of allocation groups */
+	__be32		sb_rbmblocks;	/* number of rt bitmap blocks */
+	__be32		sb_logblocks;	/* number of log blocks */
+	__be16		sb_versionnum;	/* header version == XFS_SB_VERSION */
+	__be16		sb_sectsize;	/* volume sector size, bytes */
+	__be16		sb_inodesize;	/* inode size, bytes */
+	__be16		sb_inopblock;	/* inodes per block */
+	char		sb_fname[12];	/* file system name */
+	__u8		sb_blocklog;	/* log2 of sb_blocksize */
+	__u8		sb_sectlog;	/* log2 of sb_sectsize */
+	__u8		sb_inodelog;	/* log2 of sb_inodesize */
+	__u8		sb_inopblog;	/* log2 of sb_inopblock */
+	__u8		sb_agblklog;	/* log2 of sb_agblocks (rounded up) */
+	__u8		sb_rextslog;	/* log2 of sb_rextents */
+	__u8		sb_inprogress;	/* mkfs is in progress, don't mount */
+	__u8		sb_imax_pct;	/* max % of fs for inode space */
+					/* statistics */
+	/*
+	 * These fields must remain contiguous.  If you really
+	 * want to change their layout, make sure you fix the
+	 * code in xfs_trans_apply_sb_deltas().
+	 */
+	__be64		sb_icount;	/* allocated inodes */
+	__be64		sb_ifree;	/* free inodes */
+	__be64		sb_fdblocks;	/* free data blocks */
+	__be64		sb_frextents;	/* free realtime extents */
+	/*
+	 * End contiguous fields.
+	 */
+	__be64		sb_uquotino;	/* user quota inode */
+	__be64		sb_gquotino;	/* group quota inode */
+	__be16		sb_qflags;	/* quota flags */
+	__u8		sb_flags;	/* misc. flags */
+	__u8		sb_shared_vn;	/* shared version number */
+	__be32		sb_inoalignmt;	/* inode chunk alignment, fsblocks */
+	__be32		sb_unit;	/* stripe or raid unit */
+	__be32		sb_width;	/* stripe or raid width */
+	__u8		sb_dirblklog;	/* log2 of dir block size (fsbs) */
+	__u8		sb_logsectlog;	/* log2 of the log sector size */
+	__be16		sb_logsectsize;	/* sector size for the log, bytes */
+	__be32		sb_logsunit;	/* stripe unit size for the log */
+	__be32		sb_features2;	/* additional feature bits */
+} xfs_dsb_t;
+
+/*
  * Sequence number values for the fields.
  */
 typedef enum {
@@ -446,7 +508,7 @@ static inline void xfs_sb_version_addatt
 
 #define XFS_SB_DADDR		((xfs_daddr_t)0) /* daddr in filesystem/ag */
 #define	XFS_SB_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_SB_DADDR)
-#define XFS_BUF_TO_SBP(bp)	((xfs_sb_t *)XFS_BUF_PTR(bp))
+#define XFS_BUF_TO_SBP(bp)	((xfs_dsb_t *)XFS_BUF_PTR(bp))
 
 #define	XFS_HDR_BLOCK(mp,d)	((xfs_agblock_t)XFS_BB_TO_FSBT(mp,d))
 #define	XFS_DADDR_TO_FSB(mp,d)	XFS_AGB_TO_FSB(mp, \
Index: linux-2.6-xfs/fs/xfs/xfs_trans.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_trans.c	2007-07-15 21:02:15.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_trans.c	2007-07-17 07:54:42.000000000 +0200
@@ -548,7 +548,7 @@ STATIC void
 xfs_trans_apply_sb_deltas(
 	xfs_trans_t	*tp)
 {
-	xfs_sb_t	*sbp;
+	xfs_dsb_t	*sbp;
 	xfs_buf_t	*bp;
 	int		whole = 0;
 
@@ -566,57 +566,51 @@ xfs_trans_apply_sb_deltas(
 	 * Only update the superblock counters if we are logging them
 	 */
 	if (!xfs_sb_version_haslazysbcount(&(tp->t_mountp->m_sb))) {
-		if (tp->t_icount_delta != 0) {
-			INT_MOD(sbp->sb_icount, ARCH_CONVERT, tp->t_icount_delta);
-		}
-		if (tp->t_ifree_delta != 0) {
-			INT_MOD(sbp->sb_ifree, ARCH_CONVERT, tp->t_ifree_delta);
-		}
-
-		if (tp->t_fdblocks_delta != 0) {
-			INT_MOD(sbp->sb_fdblocks, ARCH_CONVERT, tp->t_fdblocks_delta);
-		}
-		if (tp->t_res_fdblocks_delta != 0) {
-			INT_MOD(sbp->sb_fdblocks, ARCH_CONVERT, tp->t_res_fdblocks_delta);
-		}
-	}
+		if (tp->t_icount_delta)
+			be64_add(&sbp->sb_icount, tp->t_icount_delta);
+		if (tp->t_ifree_delta)
+			be64_add(&sbp->sb_ifree, tp->t_ifree_delta);
+		if (tp->t_fdblocks_delta)
+			be64_add(&sbp->sb_fdblocks, tp->t_fdblocks_delta);
+		if (tp->t_res_fdblocks_delta)
+			be64_add(&sbp->sb_fdblocks, tp->t_res_fdblocks_delta);
+	}
+
+	if (tp->t_frextents_delta)
+		be64_add(&sbp->sb_frextents, tp->t_frextents_delta);
+	if (tp->t_res_frextents_delta)
+		be64_add(&sbp->sb_frextents, tp->t_res_frextents_delta);
 
-	if (tp->t_frextents_delta != 0) {
-		INT_MOD(sbp->sb_frextents, ARCH_CONVERT, tp->t_frextents_delta);
-	}
-	if (tp->t_res_frextents_delta != 0) {
-		INT_MOD(sbp->sb_frextents, ARCH_CONVERT, tp->t_res_frextents_delta);
-	}
-	if (tp->t_dblocks_delta != 0) {
-		INT_MOD(sbp->sb_dblocks, ARCH_CONVERT, tp->t_dblocks_delta);
+	if (tp->t_dblocks_delta) {
+		be64_add(&sbp->sb_dblocks, tp->t_dblocks_delta);
 		whole = 1;
 	}
-	if (tp->t_agcount_delta != 0) {
-		INT_MOD(sbp->sb_agcount, ARCH_CONVERT, tp->t_agcount_delta);
+	if (tp->t_agcount_delta) {
+		be32_add(&sbp->sb_agcount, tp->t_agcount_delta);
 		whole = 1;
 	}
-	if (tp->t_imaxpct_delta != 0) {
-		INT_MOD(sbp->sb_imax_pct, ARCH_CONVERT, tp->t_imaxpct_delta);
+	if (tp->t_imaxpct_delta) {
+		sbp->sb_imax_pct += tp->t_imaxpct_delta;
 		whole = 1;
 	}
-	if (tp->t_rextsize_delta != 0) {
-		INT_MOD(sbp->sb_rextsize, ARCH_CONVERT, tp->t_rextsize_delta);
+	if (tp->t_rextsize_delta) {
+		be32_add(&sbp->sb_rextsize, tp->t_rextsize_delta);
 		whole = 1;
 	}
-	if (tp->t_rbmblocks_delta != 0) {
-		INT_MOD(sbp->sb_rbmblocks, ARCH_CONVERT, tp->t_rbmblocks_delta);
+	if (tp->t_rbmblocks_delta) {
+		be32_add(&sbp->sb_rbmblocks, tp->t_rbmblocks_delta);
 		whole = 1;
 	}
-	if (tp->t_rblocks_delta != 0) {
-		INT_MOD(sbp->sb_rblocks, ARCH_CONVERT, tp->t_rblocks_delta);
+	if (tp->t_rblocks_delta) {
+		be64_add(&sbp->sb_rblocks, tp->t_rblocks_delta);
 		whole = 1;
 	}
-	if (tp->t_rextents_delta != 0) {
-		INT_MOD(sbp->sb_rextents, ARCH_CONVERT, tp->t_rextents_delta);
+	if (tp->t_rextents_delta) {
+		be64_add(&sbp->sb_rextents, tp->t_rextents_delta);
 		whole = 1;
 	}
-	if (tp->t_rextslog_delta != 0) {
-		INT_MOD(sbp->sb_rextslog, ARCH_CONVERT, tp->t_rextslog_delta);
+	if (tp->t_rextslog_delta) {
+		sbp->sb_rextslog += tp->t_rextslog_delta;
 		whole = 1;
 	}
 
@@ -624,14 +618,14 @@ xfs_trans_apply_sb_deltas(
 		/*
 		 * Log the whole thing, the fields are noncontiguous.
 		 */
-		xfs_trans_log_buf(tp, bp, 0, sizeof(xfs_sb_t) - 1);
+		xfs_trans_log_buf(tp, bp, 0, sizeof(xfs_dsb_t) - 1);
 	else
 		/*
 		 * Since all the modifiable fields are contiguous, we
 		 * can get away with this.
 		 */
-		xfs_trans_log_buf(tp, bp, offsetof(xfs_sb_t, sb_icount),
-				  offsetof(xfs_sb_t, sb_frextents) +
+		xfs_trans_log_buf(tp, bp, offsetof(xfs_dsb_t, sb_icount),
+				  offsetof(xfs_dsb_t, sb_frextents) +
 				  sizeof(sbp->sb_frextents) - 1);
 
 	XFS_MTOVFS(tp->t_mountp)->vfs_super->s_dirt = 1;
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-07-17 07:54:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-07-17 07:54:42.000000000 +0200
@@ -170,7 +170,7 @@ static void	xfsidbg_xqm_mplist(xfs_mount
 static void	xfsidbg_xqm_qinfo(xfs_mount_t *mp);
 static void	xfsidbg_xqm_tpdqinfo(xfs_trans_t *tp);
 static void	xfsidbg_xsb(xfs_sb_t *);
-static void	xfsidbg_xsb_convert(xfs_sb_t *);
+static void	xfsidbg_xsb_convert(xfs_dsb_t *);
 static void	xfsidbg_xtp(xfs_trans_t *);
 static void	xfsidbg_xtrans_res(xfs_mount_t *);
 #ifdef CONFIG_XFS_QUOTA
@@ -1719,7 +1719,7 @@ static int	kdbm_xfs_xsb(
 	}
 
 	if (convert)
-		xfsidbg_xsb_convert((xfs_sb_t *) addr);
+		xfsidbg_xsb_convert((xfs_dsb_t *) addr);
 	else
 		xfsidbg_xsb((xfs_sb_t *) addr);
 	return 0;
@@ -4980,7 +4980,7 @@ xfsidbg_xbuf_real(xfs_buf_t *bp, int sum
 	void *d;
 	xfs_agf_t *agf;
 	xfs_agi_t *agi;
-	xfs_sb_t *sb;
+	xfs_dsb_t *sb;
 	xfs_alloc_block_t *bta;
 	xfs_bmbt_block_t *btb;
 	xfs_inobt_block_t *bti;
@@ -5065,7 +5065,7 @@ xfsidbg_xbuf_real(xfs_buf_t *bp, int sum
 			kdb_printf("buf 0x%p dinode 0x%p\n", bp, di);
 			xfs_inodebuf(bp);
 		}
-	} else if (INT_GET((sb = d)->sb_magicnum, ARCH_CONVERT) == XFS_SB_MAGIC) {
+	} else if (be32_to_cpu((sb = d)->sb_magicnum) == XFS_SB_MAGIC) {
 		if (summary) {
 			kdb_printf("Superblock (at 0x%p)\n", sb);
 		} else {
@@ -7359,11 +7359,11 @@ xfsidbg_xsb(xfs_sb_t *sbp)
 }
 
 static void
-xfsidbg_xsb_convert(xfs_sb_t *sbp)
+xfsidbg_xsb_convert(xfs_dsb_t *sbp)
 {
 	xfs_sb_t sb;
 
-	xfs_xlatesb(sbp, &sb, 1, XFS_SB_ALL_BITS);
+	xfs_sb_from_disk(&sb, sbp);
 
 	kdb_printf("<converted>\n");
 	xfsidbg_xsb(&sb);
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2007-07-17 07:54:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2007-07-17 07:54:42.000000000 +0200
@@ -3846,7 +3846,7 @@ xlog_do_recover(
 
 	/* Convert superblock from on-disk format */
 	sbp = &log->l_mp->m_sb;
-	xfs_xlatesb(XFS_BUF_TO_SBP(bp), sbp, 1, XFS_SB_ALL_BITS);
+	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
 	ASSERT(sbp->sb_magicnum == XFS_SB_MAGIC);
 	ASSERT(XFS_SB_GOOD_VERSION(sbp));
 	xfs_buf_relse(bp);
@@ -4024,7 +4024,7 @@ xlog_recover_check_summary(
 	sbbp = xfs_getsb(mp, 0);
 #ifdef XFS_LOUD_RECOVERY
 	sbp = &mp->m_sb;
-	xfs_xlatesb(XFS_BUF_TO_SBP(sbbp), sbp, 1, XFS_SB_ALL_BITS);
+	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(sbbp));
 	cmn_err(CE_NOTE,
 		"xlog_recover_check_summary: sb_icount %Lu itotal %Lu",
 		sbp->sb_icount, itotal);
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-07-15 21:02:15.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-07-17 07:54:42.000000000 +0200
@@ -631,7 +631,8 @@ extern int	xfs_syncsub(xfs_mount_t *, in
 extern int	xfs_sync_inodes(xfs_mount_t *, int, int *);
 extern xfs_agnumber_t	xfs_initialize_perag(struct bhv_vfs *, xfs_mount_t *,
 						xfs_agnumber_t);
-extern void	xfs_xlatesb(void *, struct xfs_sb *, int, __int64_t);
+extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
+extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
 extern struct xfs_dmops xfs_dmcore_stub;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-07-17 07:54:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-07-17 07:55:11.000000000 +0200
@@ -326,7 +326,7 @@ EXPORT_SYMBOL(xfs_vnodeops);
 EXPORT_SYMBOL(xfs_vtoi);
 EXPORT_SYMBOL(xfs_write_clear_setuid);
 EXPORT_SYMBOL(xfs_dinode_from_disk);
-EXPORT_SYMBOL(xfs_xlatesb);
+EXPORT_SYMBOL(xfs_sb_from_disk);
 EXPORT_SYMBOL(xfs_zero_eof);
 EXPORT_SYMBOL(xlog_recover_process_iunlinks);
 EXPORT_SYMBOL(xfs_ichgtime_fast);
