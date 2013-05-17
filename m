Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D2E229E14
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:13:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3833AC001
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:13:53 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XFq6CfEfDjBdbnYM for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 04:13:49 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UdIbW-0008Rf-VI
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:42 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UdIbM-0005EL-Ro
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/30] xfs: add CRC checks to block format directory blocks
Date: Fri, 17 May 2013 21:13:04 +1000
Message-Id: <1368789205-19969-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

Now that directory buffers are made from a single struct xfs_buf, we
can add CRC calculation and checking callbacks. While there, add all
the fields to the on disk structures for future functionality such
as d_type support, uuids, block numbers, owner inode, etc.

To distinguish between the different on disk formats, change the
magic numbers for the new format directory blocks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_dir2_format.h |  155 +++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_dir2_block.c   |  126 +++++++++++++++++++++++++----------
 libxfs/xfs_dir2_data.c    |  160 ++++++++++++++++++++++++++++-----------------
 libxfs/xfs_dir2_leaf.c    |    6 +-
 libxfs/xfs_dir2_node.c    |    2 +-
 libxfs/xfs_dir2_priv.h    |    4 +-
 libxfs/xfs_dir2_sf.c      |    2 +-
 7 files changed, 346 insertions(+), 109 deletions(-)

diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
index f5c264a..da928c7 100644
--- a/include/xfs_dir2_format.h
+++ b/include/xfs_dir2_format.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -36,6 +37,37 @@
 #define	XFS_DIR2_FREE_MAGIC	0x58443246	/* XD2F: free index blocks */
 
 /*
+ * Directory Version 3 With CRCs.
+ *
+ * The tree formats are the same as for version 2 directories.  The difference
+ * is in the block header and dirent formats. In many cases the v3 structures
+ * use v2 definitions as they are no different and this makes code sharing much
+ * easier.
+ *
+ * Also, the xfs_dir3_*() functions handle both v2 and v3 formats - if the
+ * format is v2 then they switch to the existing v2 code, or the format is v3
+ * they implement the v3 functionality. This means the existing dir2 is a mix of
+ * xfs_dir2/xfs_dir3 calls and functions. The xfs_dir3 functions are called
+ * where there is a difference in the formats, otherwise the code is unchanged.
+ *
+ * Where it is possible, the code decides what to do based on the magic numbers
+ * in the blocks rather than feature bits in the superblock. This means the code
+ * is as independent of the external XFS code as possible as doesn't require
+ * passing struct xfs_mount pointers into places where it isn't really
+ * necessary.
+ *
+ * Version 3 includes:
+ *
+ *	- a larger block header for CRC and identification purposes and so the
+ *	offsets of all the structures inside the blocks are different.
+ *
+ *	- new magic numbers to be able to detect the v2/v3 types on the fly.
+ */
+
+#define	XFS_DIR3_BLOCK_MAGIC	0x58444233	/* XDB3: single block dirs */
+#define	XFS_DIR3_DATA_MAGIC	0x58444433	/* XDD3: multiblock dirs */
+
+/*
  * Byte offset in data block and shortform entry.
  */
 typedef	__uint16_t	xfs_dir2_data_off_t;
@@ -111,19 +143,19 @@ static inline int xfs_dir2_sf_hdr_size(int i8count)
 		(sizeof(xfs_dir2_ino8_t) - sizeof(xfs_dir2_ino4_t));
 }
 
-static inline xfs_dir2_data_aoff_t
+	static inline xfs_dir2_data_aoff_t
 xfs_dir2_sf_get_offset(xfs_dir2_sf_entry_t *sfep)
 {
 	return get_unaligned_be16(&sfep->offset.i);
 }
 
-static inline void
+	static inline void
 xfs_dir2_sf_put_offset(xfs_dir2_sf_entry_t *sfep, xfs_dir2_data_aoff_t off)
 {
 	put_unaligned_be16(off, &sfep->offset.i);
 }
 
-static inline int
+	static inline int
 xfs_dir2_sf_entsize(struct xfs_dir2_sf_hdr *hdr, int len)
 {
 	return sizeof(struct xfs_dir2_sf_entry) +	/* namelen + offset */
@@ -133,14 +165,14 @@ xfs_dir2_sf_entsize(struct xfs_dir2_sf_hdr *hdr, int len)
 		 sizeof(xfs_dir2_ino4_t));
 }
 
-static inline struct xfs_dir2_sf_entry *
+	static inline struct xfs_dir2_sf_entry *
 xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
 {
 	return (struct xfs_dir2_sf_entry *)
 		((char *)hdr + xfs_dir2_sf_hdr_size(hdr->i8count));
 }
 
-static inline struct xfs_dir2_sf_entry *
+	static inline struct xfs_dir2_sf_entry *
 xfs_dir2_sf_nextentry(struct xfs_dir2_sf_hdr *hdr,
 		struct xfs_dir2_sf_entry *sfep)
 {
@@ -215,11 +247,43 @@ typedef struct xfs_dir2_data_free {
  */
 typedef struct xfs_dir2_data_hdr {
 	__be32			magic;		/* XFS_DIR2_DATA_MAGIC or */
-						/* XFS_DIR2_BLOCK_MAGIC */
+	/* XFS_DIR2_BLOCK_MAGIC */
 	xfs_dir2_data_free_t	bestfree[XFS_DIR2_DATA_FD_COUNT];
 } xfs_dir2_data_hdr_t;
 
 /*
+ * define a structure for all the verification fields we are adding to the
+ * directory block structures. This will be used in several structures.
+ * The magic number must be the first entry to align with all the dir2
+ * structures so we determine how to decode them just by the magic number.
+ */
+struct xfs_dir3_blk_hdr {
+	__be32			magic;	/* magic number */
+	__be32			crc;	/* CRC of block */
+	__be64			blkno;	/* first block of the buffer */
+	__be64			lsn;	/* sequence number of last write */
+	uuid_t			uuid;	/* filesystem we belong to */
+	__be64			owner;	/* inode that owns the block */
+};
+
+struct xfs_dir3_data_hdr {
+	struct xfs_dir3_blk_hdr	hdr;
+	xfs_dir2_data_free_t	best_free[XFS_DIR2_DATA_FD_COUNT];
+};
+
+#define XFS_DIR3_DATA_CRC_OFF  offsetof(struct xfs_dir3_data_hdr, hdr.crc)
+
+	static inline struct xfs_dir2_data_free *
+xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
+{
+	if (hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
+		struct xfs_dir3_data_hdr *hdr3 = (struct xfs_dir3_data_hdr *)hdr;
+		return hdr3->best_free;
+	}
+	return hdr->bestfree;
+}
+
+/*
  * Active entry in a data block.
  *
  * Aligned to 8 bytes.  After the variable length name field there is a
@@ -274,6 +338,85 @@ xfs_dir2_data_unused_tag_p(struct xfs_dir2_data_unused *dup)
 			be16_to_cpu(dup->length) - sizeof(__be16));
 }
 
+static inline struct xfs_dir2_data_unused *
+xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
+{
+	if (hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
+		return (struct xfs_dir2_data_unused *)
+			((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
+	}
+	return (struct xfs_dir2_data_unused *)
+		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
+}
+
+static inline size_t
+xfs_dir3_data_hdr_size(bool dir3)
+{
+	if (dir3)
+		return sizeof(struct xfs_dir3_data_hdr);
+	return sizeof(struct xfs_dir2_data_hdr);
+}
+
+static inline size_t
+xfs_dir3_data_entry_offset(struct xfs_dir2_data_hdr *hdr)
+{
+	bool dir3 = hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
+		    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
+	return xfs_dir3_data_hdr_size(dir3);
+}
+
+static inline struct xfs_dir2_data_entry *
+xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir3_data_entry_offset(hdr));
+}
+
+/*
+ * Offsets of . and .. in data space (always block 0)
+ */
+static inline xfs_dir2_data_aoff_t
+xfs_dir3_data_dot_offset(struct xfs_dir2_data_hdr *hdr)
+{
+	return xfs_dir3_data_entry_offset(hdr);
+}
+
+static inline xfs_dir2_data_aoff_t
+xfs_dir3_data_dotdot_offset(struct xfs_dir2_data_hdr *hdr)
+{
+	return xfs_dir3_data_dot_offset(hdr) + xfs_dir2_data_entsize(1);
+}
+
+static inline xfs_dir2_data_aoff_t
+xfs_dir3_data_first_offset(struct xfs_dir2_data_hdr *hdr)
+{
+	return xfs_dir3_data_dotdot_offset(hdr) + xfs_dir2_data_entsize(2);
+}
+
+/*
+ * location of . and .. in data space (always block 0)
+ */
+static inline struct xfs_dir2_data_entry *
+xfs_dir3_data_dot_entry_p(struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir3_data_dot_offset(hdr));
+}
+
+static inline struct xfs_dir2_data_entry *
+xfs_dir3_data_dotdot_entry_p(struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir3_data_dotdot_offset(hdr));
+}
+
+static inline struct xfs_dir2_data_entry *
+xfs_dir3_data_first_entry_p(struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir3_data_first_offset(hdr));
+}
+
 /*
  * Leaf block structures.
  *
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 2a99dea..c79199a 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -40,44 +41,74 @@ xfs_dir_startup(void)
 	xfs_dir_hash_dotdot = xfs_da_hashname((unsigned char *)"..", 2);
 }
 
-static void
-xfs_dir2_block_verify(
+static bool
+xfs_dir3_block_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
-	int			block_ok = 0;
-
-	block_ok = hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
-	block_ok = block_ok && __xfs_dir2_data_check(NULL, bp) == 0;
-
-	if (!block_ok) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
+			return false;
+		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
+			return false;
+		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
+			return false;
+	} else {
+		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
+			return false;
 	}
+	if (__xfs_dir2_data_check(NULL, bp))
+		return false;
+	return true;
 }
 
 static void
-xfs_dir2_block_read_verify(
+xfs_dir3_block_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dir2_block_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+					  XFS_DIR3_DATA_CRC_OFF)) ||
+	    !xfs_dir3_block_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
 }
 
 static void
-xfs_dir2_block_write_verify(
+xfs_dir3_block_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dir2_block_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+
+	if (!xfs_dir3_block_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (bip)
+		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
+
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_DATA_CRC_OFF);
 }
 
-const struct xfs_buf_ops xfs_dir2_block_buf_ops = {
-	.verify_read = xfs_dir2_block_read_verify,
-	.verify_write = xfs_dir2_block_write_verify,
+const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
+	.verify_read = xfs_dir3_block_read_verify,
+	.verify_write = xfs_dir3_block_write_verify,
 };
 
 static int
-xfs_dir2_block_read(
+xfs_dir3_block_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	struct xfs_buf		**bpp)
@@ -85,7 +116,29 @@ xfs_dir2_block_read(
 	struct xfs_mount	*mp = dp->i_mount;
 
 	return xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, bpp,
-				XFS_DATA_FORK, &xfs_dir2_block_buf_ops);
+				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
+}
+
+static void
+xfs_dir3_block_init(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	struct xfs_inode	*dp)
+{
+	struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
+
+	bp->b_ops = &xfs_dir3_block_buf_ops;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		memset(hdr3, 0, sizeof(*hdr3));
+		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
+		hdr3->blkno = cpu_to_be64(bp->b_bn);
+		hdr3->owner = cpu_to_be64(dp->i_ino);
+		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
+		return;
+
+	}
+	hdr3->magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
 }
 
 static void
@@ -105,7 +158,7 @@ xfs_dir2_block_need_space(
 	struct xfs_dir2_data_unused	*enddup = NULL;
 
 	*compact = 0;
-	bf = hdr->bestfree;
+	bf = xfs_dir3_data_bestfree_p(hdr);
 
 	/*
 	 * If there are stale entries we'll use one for the leaf.
@@ -287,7 +340,7 @@ xfs_dir2_block_addname(
 	mp = dp->i_mount;
 
 	/* Read the (one and only) directory block into bp. */
-	error = xfs_dir2_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, &bp);
 	if (error)
 		return error;
 
@@ -597,7 +650,7 @@ xfs_dir2_block_lookup_int(
 	tp = args->trans;
 	mp = dp->i_mount;
 
-	error = xfs_dir2_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, &bp);
 	if (error)
 		return error;
 
@@ -860,9 +913,12 @@ xfs_dir2_leaf_to_block(
 	 * These will show up in the leaf bests table.
 	 */
 	while (dp->i_d.di_size > mp->m_dirblksize) {
+		int hdrsz;
+
+		hdrsz = xfs_dir3_data_hdr_size(xfs_sb_version_hascrc(&mp->m_sb));
 		bestsp = xfs_dir2_leaf_bests_p(ltp);
 		if (be16_to_cpu(bestsp[be32_to_cpu(ltp->bestcount) - 1]) ==
-		    mp->m_dirblksize - (uint)sizeof(*hdr)) {
+					    mp->m_dirblksize - hdrsz) {
 			if ((error =
 			    xfs_dir2_leaf_trim_data(args, lbp,
 				    (xfs_dir2_db_t)(be32_to_cpu(ltp->bestcount) - 1))))
@@ -900,8 +956,8 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Start converting it to block form.
 	 */
-	dbp->b_ops = &xfs_dir2_block_buf_ops;
-	hdr->magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
+	xfs_dir3_block_init(mp, dbp, dp);
+
 	needlog = 1;
 	needscan = 0;
 	/*
@@ -1023,16 +1079,16 @@ xfs_dir2_sf_to_block(
 		return error;
 	}
 	/*
-	 * Initialize the data block.
+	 * Initialize the data block, then convert it to block format.
 	 */
-	error = xfs_dir2_data_init(args, blkno, &bp);
+	error = xfs_dir3_data_init(args, blkno, &bp);
 	if (error) {
 		kmem_free(sfp);
 		return error;
 	}
-	bp->b_ops = &xfs_dir2_block_buf_ops;
+	xfs_dir3_block_init(mp, bp, dp);
 	hdr = bp->b_addr;
-	hdr->magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
+
 	/*
 	 * Compute size of block "tail" area.
 	 */
@@ -1042,7 +1098,7 @@ xfs_dir2_sf_to_block(
 	 * The whole thing is initialized to free by the init routine.
 	 * Say we're using the leaf and tail area.
 	 */
-	dup = (xfs_dir2_data_unused_t *)(hdr + 1);
+	dup = xfs_dir3_data_unused_p(hdr);
 	needlog = needscan = 0;
 	xfs_dir2_data_use_free(tp, bp, dup, mp->m_dirblksize - i, i, &needlog,
 		&needscan);
@@ -1064,8 +1120,7 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Create entry for .
 	 */
-	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)hdr + XFS_DIR2_DATA_DOT_OFFSET);
+	dep = xfs_dir3_data_dot_entry_p(hdr);
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
@@ -1078,8 +1133,7 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Create entry for ..
 	 */
-	dep = (xfs_dir2_data_entry_t *)
-		((char *)hdr + XFS_DIR2_DATA_DOTDOT_OFFSET);
+	dep = xfs_dir3_data_dotdot_entry_p(hdr);
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
@@ -1089,7 +1143,7 @@ xfs_dir2_sf_to_block(
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
 	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 				(char *)dep - (char *)hdr));
-	offset = XFS_DIR2_DATA_FIRST_OFFSET;
+	offset = xfs_dir3_data_first_offset(hdr);
 	/*
 	 * Loop over existing entries, stuff them in.
 	 */
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index eb86739..66aab07 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -49,11 +50,12 @@ __xfs_dir2_data_check(
 
 	mp = bp->b_target->bt_mount;
 	hdr = bp->b_addr;
-	bf = hdr->bestfree;
-	p = (char *)(hdr + 1);
+	bf = xfs_dir3_data_bestfree_p(hdr);
+	p = (char *)xfs_dir3_data_entry_p(hdr);
 
 	switch (be32_to_cpu(hdr->magic)) {
 	case XFS_DIR2_BLOCK_MAGIC:
+	case XFS_DIR3_BLOCK_MAGIC:
 		btp = xfs_dir2_block_tail_p(mp, hdr);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
@@ -132,7 +134,8 @@ __xfs_dir2_data_check(
 					       (char *)dep - (char *)hdr);
 		count++;
 		lastfree = 0;
-		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
+		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+		    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 			addr = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)hdr));
@@ -152,7 +155,8 @@ __xfs_dir2_data_check(
 	 * Need to have seen all the entries and all the bestfree slots.
 	 */
 	XFS_WANT_CORRUPTED_RETURN(freeseen == 7);
-	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 		for (i = stale = 0; i < be32_to_cpu(btp->count); i++) {
 			if (lep[i].address ==
 			    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
@@ -200,7 +204,8 @@ xfs_dir2_data_reada_verify(
 
 	switch (be32_to_cpu(hdr->magic)) {
 	case XFS_DIR2_BLOCK_MAGIC:
-		bp->b_ops = &xfs_dir2_block_buf_ops;
+	case XFS_DIR3_BLOCK_MAGIC:
+		bp->b_ops = &xfs_dir3_block_buf_ops;
 		bp->b_ops->verify_read(bp);
 		return;
 	case XFS_DIR2_DATA_MAGIC:
@@ -272,12 +277,15 @@ xfs_dir2_data_freefind(
 {
 	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
 	xfs_dir2_data_aoff_t	off;		/* offset value needed */
+	struct xfs_dir2_data_free *bf;
 #if defined(DEBUG) && defined(__KERNEL__)
 	int			matched;	/* matched the value */
 	int			seenzero;	/* saw a 0 bestfree entry */
 #endif
 
 	off = (xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr);
+	bf = xfs_dir3_data_bestfree_p(hdr);
+
 #if defined(DEBUG) && defined(__KERNEL__)
 	/*
 	 * Validate some consistency in the bestfree table.
@@ -285,9 +293,10 @@ xfs_dir2_data_freefind(
 	 * one we're looking for it has to be exact.
 	 */
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
-	for (dfp = &hdr->bestfree[0], seenzero = matched = 0;
-	     dfp < &hdr->bestfree[XFS_DIR2_DATA_FD_COUNT];
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
+	for (dfp = &bf[0], seenzero = matched = 0;
+	     dfp < &bf[XFS_DIR2_DATA_FD_COUNT];
 	     dfp++) {
 		if (!dfp->offset) {
 			ASSERT(!dfp->length);
@@ -303,7 +312,7 @@ xfs_dir2_data_freefind(
 		else
 			ASSERT(be16_to_cpu(dfp->offset) + be16_to_cpu(dfp->length) <= off);
 		ASSERT(matched || be16_to_cpu(dfp->length) >= be16_to_cpu(dup->length));
-		if (dfp > &hdr->bestfree[0])
+		if (dfp > &bf[0])
 			ASSERT(be16_to_cpu(dfp[-1].length) >= be16_to_cpu(dfp[0].length));
 	}
 #endif
@@ -312,14 +321,12 @@ xfs_dir2_data_freefind(
 	 * it can't be there since they're sorted.
 	 */
 	if (be16_to_cpu(dup->length) <
-	    be16_to_cpu(hdr->bestfree[XFS_DIR2_DATA_FD_COUNT - 1].length))
+	    be16_to_cpu(bf[XFS_DIR2_DATA_FD_COUNT - 1].length))
 		return NULL;
 	/*
 	 * Look at the three bestfree entries for our guy.
 	 */
-	for (dfp = &hdr->bestfree[0];
-	     dfp < &hdr->bestfree[XFS_DIR2_DATA_FD_COUNT];
-	     dfp++) {
+	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
 		if (!dfp->offset)
 			return NULL;
 		if (be16_to_cpu(dfp->offset) == off)
@@ -343,11 +350,12 @@ xfs_dir2_data_freeinsert(
 	xfs_dir2_data_free_t	*dfp;		/* bestfree table pointer */
 	xfs_dir2_data_free_t	new;		/* new bestfree entry */
 
-#ifdef __KERNEL__
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
-#endif
-	dfp = hdr->bestfree;
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
+
+	dfp = xfs_dir3_data_bestfree_p(hdr);
 	new.length = dup->length;
 	new.offset = cpu_to_be16((char *)dup - (char *)hdr);
 
@@ -384,32 +392,36 @@ xfs_dir2_data_freeremove(
 	xfs_dir2_data_free_t	*dfp,		/* bestfree entry pointer */
 	int			*loghead)	/* out: log data header */
 {
-#ifdef __KERNEL__
+	struct xfs_dir2_data_free *bf;
+
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
-#endif
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
+
 	/*
 	 * It's the first entry, slide the next 2 up.
 	 */
-	if (dfp == &hdr->bestfree[0]) {
-		hdr->bestfree[0] = hdr->bestfree[1];
-		hdr->bestfree[1] = hdr->bestfree[2];
+	bf = xfs_dir3_data_bestfree_p(hdr);
+	if (dfp == &bf[0]) {
+		bf[0] = bf[1];
+		bf[1] = bf[2];
 	}
 	/*
 	 * It's the second entry, slide the 3rd entry up.
 	 */
-	else if (dfp == &hdr->bestfree[1])
-		hdr->bestfree[1] = hdr->bestfree[2];
+	else if (dfp == &bf[1])
+		bf[1] = bf[2];
 	/*
 	 * Must be the last entry.
 	 */
 	else
-		ASSERT(dfp == &hdr->bestfree[2]);
+		ASSERT(dfp == &bf[2]);
 	/*
 	 * Clear the 3rd entry, must be zero now.
 	 */
-	hdr->bestfree[2].length = 0;
-	hdr->bestfree[2].offset = 0;
+	bf[2].length = 0;
+	bf[2].offset = 0;
 	*loghead = 1;
 }
 
@@ -425,23 +437,26 @@ xfs_dir2_data_freescan(
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* active data entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused data entry */
+	struct xfs_dir2_data_free *bf;
 	char			*endp;		/* end of block's data */
 	char			*p;		/* current entry pointer */
 
-#ifdef __KERNEL__
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
-#endif
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
+
 	/*
 	 * Start by clearing the table.
 	 */
-	memset(hdr->bestfree, 0, sizeof(hdr->bestfree));
+	bf = xfs_dir3_data_bestfree_p(hdr);
+	memset(bf, 0, sizeof(*bf) * XFS_DIR2_DATA_FD_COUNT);
 	*loghead = 1;
 	/*
 	 * Set up pointers.
 	 */
-	p = (char *)(hdr + 1);
-	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
+	p = (char *)xfs_dir3_data_entry_p(hdr);
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 		btp = xfs_dir2_block_tail_p(mp, hdr);
 		endp = (char *)xfs_dir2_block_leaf_p(btp);
 	} else
@@ -477,7 +492,7 @@ xfs_dir2_data_freescan(
  * Give back the buffer for the created block.
  */
 int						/* error */
-xfs_dir2_data_init(
+xfs_dir3_data_init(
 	xfs_da_args_t		*args,		/* directory operation args */
 	xfs_dir2_db_t		blkno,		/* logical dir block number */
 	struct xfs_buf		**bpp)		/* output block buffer */
@@ -486,6 +501,7 @@ xfs_dir2_data_init(
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry pointer */
+	struct xfs_dir2_data_free *bf;
 	int			error;		/* error return value */
 	int			i;		/* bestfree index */
 	xfs_mount_t		*mp;		/* filesystem mount point */
@@ -508,21 +524,34 @@ xfs_dir2_data_init(
 	 * Initialize the header.
 	 */
 	hdr = bp->b_addr;
-	hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
-	hdr->bestfree[0].offset = cpu_to_be16(sizeof(*hdr));
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
+
+		memset(hdr3, 0, sizeof(*hdr3));
+		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
+		hdr3->blkno = cpu_to_be64(bp->b_bn);
+		hdr3->owner = cpu_to_be64(dp->i_ino);
+		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
+
+	} else
+		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
+
+	bf = xfs_dir3_data_bestfree_p(hdr);
+	bf[0].offset = cpu_to_be16(xfs_dir3_data_entry_offset(hdr));
 	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
-		hdr->bestfree[i].length = 0;
-		hdr->bestfree[i].offset = 0;
+		bf[i].length = 0;
+		bf[i].offset = 0;
 	}
 
 	/*
 	 * Set up an unused entry for the block's body.
 	 */
-	dup = (xfs_dir2_data_unused_t *)(hdr + 1);
+	dup = xfs_dir3_data_unused_p(hdr);
 	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 
-	t = mp->m_dirblksize - (uint)sizeof(*hdr);
-	hdr->bestfree[0].length = cpu_to_be16(t);
+	t = mp->m_dirblksize - (uint)xfs_dir3_data_entry_offset(hdr);
+	bf[0].length = cpu_to_be16(t);
 	dup->length = cpu_to_be16(t);
 	*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16((char *)dup - (char *)hdr);
 	/*
@@ -546,7 +575,8 @@ xfs_dir2_data_log_entry(
 	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
 	xfs_trans_log_buf(tp, bp, (uint)((char *)dep - (char *)hdr),
 		(uint)((char *)(xfs_dir2_data_entry_tag_p(dep) + 1) -
@@ -564,9 +594,10 @@ xfs_dir2_data_log_header(
 	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
-	xfs_trans_log_buf(tp, bp, 0, sizeof(*hdr) - 1);
+	xfs_trans_log_buf(tp, bp, 0, xfs_dir3_data_entry_offset(hdr) - 1);
 }
 
 /*
@@ -581,7 +612,8 @@ xfs_dir2_data_log_unused(
 	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
 	/*
 	 * Log the first part of the unused entry.
@@ -619,6 +651,7 @@ xfs_dir2_data_make_free(
 	xfs_dir2_data_unused_t	*newdup;	/* new unused entry */
 	xfs_dir2_data_unused_t	*postdup;	/* unused entry after us */
 	xfs_dir2_data_unused_t	*prevdup;	/* unused entry before us */
+	struct xfs_dir2_data_free *bf;
 
 	mp = tp->t_mountp;
 	hdr = bp->b_addr;
@@ -631,7 +664,8 @@ xfs_dir2_data_make_free(
 	else {
 		xfs_dir2_block_tail_t	*btp;	/* block tail */
 
-		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
+		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+			hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 		btp = xfs_dir2_block_tail_p(mp, hdr);
 		endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	}
@@ -639,7 +673,7 @@ xfs_dir2_data_make_free(
 	 * If this isn't the start of the block, then back up to
 	 * the previous entry and see if it's free.
 	 */
-	if (offset > sizeof(*hdr)) {
+	if (offset > xfs_dir3_data_entry_offset(hdr)) {
 		__be16			*tagp;	/* tag just before us */
 
 		tagp = (__be16 *)((char *)hdr + offset) - 1;
@@ -665,6 +699,7 @@ xfs_dir2_data_make_free(
 	 * Previous and following entries are both free,
 	 * merge everything into a single free entry.
 	 */
+	bf = xfs_dir3_data_bestfree_p(hdr);
 	if (prevdup && postdup) {
 		xfs_dir2_data_free_t	*dfp2;	/* another bestfree pointer */
 
@@ -679,7 +714,7 @@ xfs_dir2_data_make_free(
 		 * since the third bestfree is there, there might be more
 		 * entries.
 		 */
-		needscan = (hdr->bestfree[2].length != 0);
+		needscan = (bf[2].length != 0);
 		/*
 		 * Fix up the new big freespace.
 		 */
@@ -695,10 +730,10 @@ xfs_dir2_data_make_free(
 			 * Remove entry 1 first then entry 0.
 			 */
 			ASSERT(dfp && dfp2);
-			if (dfp == &hdr->bestfree[1]) {
-				dfp = &hdr->bestfree[0];
+			if (dfp == &bf[1]) {
+				dfp = &bf[0];
 				ASSERT(dfp2 == dfp);
-				dfp2 = &hdr->bestfree[1];
+				dfp2 = &bf[1];
 			}
 			xfs_dir2_data_freeremove(hdr, dfp2, needlogp);
 			xfs_dir2_data_freeremove(hdr, dfp, needlogp);
@@ -706,7 +741,7 @@ xfs_dir2_data_make_free(
 			 * Now insert the new entry.
 			 */
 			dfp = xfs_dir2_data_freeinsert(hdr, prevdup, needlogp);
-			ASSERT(dfp == &hdr->bestfree[0]);
+			ASSERT(dfp == &bf[0]);
 			ASSERT(dfp->length == prevdup->length);
 			ASSERT(!dfp[1].length);
 			ASSERT(!dfp[2].length);
@@ -735,7 +770,7 @@ xfs_dir2_data_make_free(
 		 */
 		else {
 			needscan = be16_to_cpu(prevdup->length) >
-				   be16_to_cpu(hdr->bestfree[2].length);
+				   be16_to_cpu(bf[2].length);
 		}
 	}
 	/*
@@ -763,7 +798,7 @@ xfs_dir2_data_make_free(
 		 */
 		else {
 			needscan = be16_to_cpu(newdup->length) >
-				   be16_to_cpu(hdr->bestfree[2].length);
+				   be16_to_cpu(bf[2].length);
 		}
 	}
 	/*
@@ -802,10 +837,12 @@ xfs_dir2_data_use_free(
 	xfs_dir2_data_unused_t	*newdup;	/* new unused entry */
 	xfs_dir2_data_unused_t	*newdup2;	/* another new unused entry */
 	int			oldlen;		/* old unused entry's length */
+	struct xfs_dir2_data_free *bf;
 
 	hdr = bp->b_addr;
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 	ASSERT(be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG);
 	ASSERT(offset >= (char *)dup - (char *)hdr);
 	ASSERT(offset + len <= (char *)dup + be16_to_cpu(dup->length) - (char *)hdr);
@@ -815,7 +852,8 @@ xfs_dir2_data_use_free(
 	 */
 	dfp = xfs_dir2_data_freefind(hdr, dup);
 	oldlen = be16_to_cpu(dup->length);
-	ASSERT(dfp || oldlen <= be16_to_cpu(hdr->bestfree[2].length));
+	bf = xfs_dir3_data_bestfree_p(hdr);
+	ASSERT(dfp || oldlen <= be16_to_cpu(bf[2].length));
 	/*
 	 * Check for alignment with front and back of the entry.
 	 */
@@ -829,7 +867,7 @@ xfs_dir2_data_use_free(
 	 */
 	if (matchfront && matchback) {
 		if (dfp) {
-			needscan = (hdr->bestfree[2].offset != 0);
+			needscan = (bf[2].offset != 0);
 			if (!needscan)
 				xfs_dir2_data_freeremove(hdr, dfp, needlogp);
 		}
@@ -859,7 +897,7 @@ xfs_dir2_data_use_free(
 			 * that means we don't know if there was a better
 			 * choice for the last slot, or not.  Rescan.
 			 */
-			needscan = dfp == &hdr->bestfree[2];
+			needscan = dfp == &bf[2];
 		}
 	}
 	/*
@@ -886,7 +924,7 @@ xfs_dir2_data_use_free(
 			 * that means we don't know if there was a better
 			 * choice for the last slot, or not.  Rescan.
 			 */
-			needscan = dfp == &hdr->bestfree[2];
+			needscan = dfp == &bf[2];
 		}
 	}
 	/*
@@ -914,7 +952,7 @@ xfs_dir2_data_use_free(
 		 * the 2 new will work.
 		 */
 		if (dfp) {
-			needscan = (hdr->bestfree[2].length != 0);
+			needscan = (bf[2].length != 0);
 			if (!needscan) {
 				xfs_dir2_data_freeremove(hdr, dfp, needlogp);
 				xfs_dir2_data_freeinsert(hdr, newdup, needlogp);
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index d303813..d83fce4 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -133,6 +133,7 @@ xfs_dir2_block_to_leaf(
 	int			needlog;	/* need to log block header */
 	int			needscan;	/* need to rescan bestfree */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir2_data_free	*bf;
 
 	trace_xfs_dir2_block_to_leaf(args);
 
@@ -161,6 +162,7 @@ xfs_dir2_block_to_leaf(
 	xfs_dir2_data_check(dp, dbp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
+	bf = xfs_dir3_data_bestfree_p(hdr);
 	/*
 	 * Set the counts in the leaf header.
 	 */
@@ -196,7 +198,7 @@ xfs_dir2_block_to_leaf(
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	ltp->bestcount = cpu_to_be32(1);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	bestsp[0] =  hdr->bestfree[0].length;
+	bestsp[0] =  bf[0].length;
 	/*
 	 * Log the data header and leaf bests table.
 	 */
@@ -528,7 +530,7 @@ xfs_dir2_leaf_addname(
 		/*
 		 * Initialize the block.
 		 */
-		if ((error = xfs_dir2_data_init(args, use_block, &dbp))) {
+		if ((error = xfs_dir3_data_init(args, use_block, &dbp))) {
 			xfs_trans_brelse(tp, lbp);
 			return error;
 		}
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 649f677..e7820b2 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -1573,7 +1573,7 @@ xfs_dir2_node_addname_int(
 		if (unlikely((error = xfs_dir2_grow_inode(args,
 							 XFS_DIR2_DATA_SPACE,
 							 &dbno)) ||
-		    (error = xfs_dir2_data_init(args, dbno, &dbp))))
+		    (error = xfs_dir3_data_init(args, dbno, &dbp))))
 			return error;
 
 		/*
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 7da79f6..e6f2e0a 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -30,7 +30,7 @@ extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 				const unsigned char *name, int len);
 
 /* xfs_dir2_block.c */
-extern const struct xfs_buf_ops xfs_dir2_block_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
 extern int xfs_dir2_block_getdents(struct xfs_inode *dp, void *dirent,
@@ -61,7 +61,7 @@ xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
 		struct xfs_dir2_data_unused *dup, int *loghead);
 extern void xfs_dir2_data_freescan(struct xfs_mount *mp,
 		struct xfs_dir2_data_hdr *hdr, int *loghead);
-extern int xfs_dir2_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
+extern int xfs_dir3_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
 		struct xfs_buf **bpp);
 extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_buf *bp,
 		struct xfs_dir2_data_entry *dep);
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index a96be76..6848d05 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -262,7 +262,7 @@ xfs_dir2_block_to_sf(
 	 * Set up to loop over the block's entries.
 	 */
 	btp = xfs_dir2_block_tail_p(mp, hdr);
-	ptr = (char *)(hdr + 1);
+	ptr = (char *)xfs_dir3_data_entry_p(hdr);
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	/*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
