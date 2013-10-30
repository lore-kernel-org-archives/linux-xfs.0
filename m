Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D2E57F6D
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:31:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DC38DAC0A4
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:31:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4W07wkOC4lrm9FoX for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:31:34 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VbNRF-0002yO-Ji
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VbNRF-0007dm-J4
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/30] xfs: decouple inode and bmap btree header files
Date: Wed, 30 Oct 2013 15:30:56 +1100
Message-Id: <1383107481-28937-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1383107481-28937-1-git-send-email-david@fromorbit.com>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
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

Currently the xfs_inode.h header has a dependency on the definition
of the BMAP btree records as the inode fork includes an array of
xfs_bmbt_rec_host_t objects in it's definition.

Move all the btree format definitions from xfs_btree.h,
xfs_bmap_btree.h, xfs_alloc_btree.h and xfs_ialloc_btree.h to
xfs_format.h to continue the process of centralising the on-disk
format definitions. With this done, the xfs inode definitions are no
longer dependent on btree header files.

The enables a massive culling of unnecessary includes, with close to
200 #include directives removed from the XFS kernel code base.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_alloc_btree.h  |  33 ------
 include/xfs_bmap_btree.h   | 103 -----------------
 include/xfs_btree.h        |  80 -------------
 include/xfs_format.h       | 281 +++++++++++++++++++++++++++++++++++++++++++++
 include/xfs_ialloc.h       |   3 +-
 include/xfs_ialloc_btree.h |  49 --------
 include/xfs_inode_fork.h   |   1 +
 7 files changed, 284 insertions(+), 266 deletions(-)

diff --git a/include/xfs_alloc_btree.h b/include/xfs_alloc_btree.h
index 72676c3..45e189e 100644
--- a/include/xfs_alloc_btree.h
+++ b/include/xfs_alloc_btree.h
@@ -27,39 +27,6 @@ struct xfs_btree_cur;
 struct xfs_mount;
 
 /*
- * There are two on-disk btrees, one sorted by blockno and one sorted
- * by blockcount and blockno.  All blocks look the same to make the code
- * simpler; if we have time later, we'll make the optimizations.
- */
-#define	XFS_ABTB_MAGIC		0x41425442	/* 'ABTB' for bno tree */
-#define	XFS_ABTB_CRC_MAGIC	0x41423342	/* 'AB3B' */
-#define	XFS_ABTC_MAGIC		0x41425443	/* 'ABTC' for cnt tree */
-#define	XFS_ABTC_CRC_MAGIC	0x41423343	/* 'AB3C' */
-
-/*
- * Data record/key structure
- */
-typedef struct xfs_alloc_rec {
-	__be32		ar_startblock;	/* starting block number */
-	__be32		ar_blockcount;	/* count of free blocks */
-} xfs_alloc_rec_t, xfs_alloc_key_t;
-
-typedef struct xfs_alloc_rec_incore {
-	xfs_agblock_t	ar_startblock;	/* starting block number */
-	xfs_extlen_t	ar_blockcount;	/* count of free blocks */
-} xfs_alloc_rec_incore_t;
-
-/* btree pointer type */
-typedef __be32 xfs_alloc_ptr_t;
-
-/*
- * Block numbers in the AG:
- * SB is sector 0, AGF is sector 1, AGI is sector 2, AGFL is sector 3.
- */
-#define	XFS_BNO_BLOCK(mp)	((xfs_agblock_t)(XFS_AGFL_BLOCK(mp) + 1))
-#define	XFS_CNT_BLOCK(mp)	((xfs_agblock_t)(XFS_BNO_BLOCK(mp) + 1))
-
-/*
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_ALLOC_BLOCK_LEN(mp) \
diff --git a/include/xfs_bmap_btree.h b/include/xfs_bmap_btree.h
index e307978..2379d33 100644
--- a/include/xfs_bmap_btree.h
+++ b/include/xfs_bmap_btree.h
@@ -18,9 +18,6 @@
 #ifndef __XFS_BMAP_BTREE_H__
 #define __XFS_BMAP_BTREE_H__
 
-#define XFS_BMAP_MAGIC		0x424d4150	/* 'BMAP' */
-#define XFS_BMAP_CRC_MAGIC	0x424d4133	/* 'BMA3' */
-
 struct xfs_btree_cur;
 struct xfs_btree_block;
 struct xfs_mount;
@@ -28,85 +25,6 @@ struct xfs_inode;
 struct xfs_trans;
 
 /*
- * Bmap root header, on-disk form only.
- */
-typedef struct xfs_bmdr_block {
-	__be16		bb_level;	/* 0 is a leaf */
-	__be16		bb_numrecs;	/* current # of data records */
-} xfs_bmdr_block_t;
-
-/*
- * Bmap btree record and extent descriptor.
- *  l0:63 is an extent flag (value 1 indicates non-normal).
- *  l0:9-62 are startoff.
- *  l0:0-8 and l1:21-63 are startblock.
- *  l1:0-20 are blockcount.
- */
-#define BMBT_EXNTFLAG_BITLEN	1
-#define BMBT_STARTOFF_BITLEN	54
-#define BMBT_STARTBLOCK_BITLEN	52
-#define BMBT_BLOCKCOUNT_BITLEN	21
-
-typedef struct xfs_bmbt_rec {
-	__be64			l0, l1;
-} xfs_bmbt_rec_t;
-
-typedef __uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
-typedef xfs_bmbt_rec_t xfs_bmdr_rec_t;
-
-typedef struct xfs_bmbt_rec_host {
-	__uint64_t		l0, l1;
-} xfs_bmbt_rec_host_t;
-
-/*
- * Values and macros for delayed-allocation startblock fields.
- */
-#define STARTBLOCKVALBITS	17
-#define STARTBLOCKMASKBITS	(15 + XFS_BIG_BLKNOS * 20)
-#define DSTARTBLOCKMASKBITS	(15 + 20)
-#define STARTBLOCKMASK		\
-	(((((xfs_fsblock_t)1) << STARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
-#define DSTARTBLOCKMASK		\
-	(((((xfs_dfsbno_t)1) << DSTARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
-
-static inline int isnullstartblock(xfs_fsblock_t x)
-{
-	return ((x) & STARTBLOCKMASK) == STARTBLOCKMASK;
-}
-
-static inline int isnulldstartblock(xfs_dfsbno_t x)
-{
-	return ((x) & DSTARTBLOCKMASK) == DSTARTBLOCKMASK;
-}
-
-static inline xfs_fsblock_t nullstartblock(int k)
-{
-	ASSERT(k < (1 << STARTBLOCKVALBITS));
-	return STARTBLOCKMASK | (k);
-}
-
-static inline xfs_filblks_t startblockval(xfs_fsblock_t x)
-{
-	return (xfs_filblks_t)((x) & ~STARTBLOCKMASK);
-}
-
-/*
- * Possible extent formats.
- */
-typedef enum {
-	XFS_EXTFMT_NOSTATE = 0,
-	XFS_EXTFMT_HASSTATE
-} xfs_exntfmt_t;
-
-/*
- * Possible extent states.
- */
-typedef enum {
-	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
-	XFS_EXT_DMAPI_OFFLINE, XFS_EXT_INVALID
-} xfs_exntst_t;
-
-/*
  * Extent state and extent format macros.
  */
 #define XFS_EXTFMT_INODE(x)	\
@@ -115,27 +33,6 @@ typedef enum {
 #define ISUNWRITTEN(x)	((x)->br_state == XFS_EXT_UNWRITTEN)
 
 /*
- * Incore version of above.
- */
-typedef struct xfs_bmbt_irec
-{
-	xfs_fileoff_t	br_startoff;	/* starting file offset */
-	xfs_fsblock_t	br_startblock;	/* starting block number */
-	xfs_filblks_t	br_blockcount;	/* number of blocks */
-	xfs_exntst_t	br_state;	/* extent state */
-} xfs_bmbt_irec_t;
-
-/*
- * Key structure for non-leaf levels of the tree.
- */
-typedef struct xfs_bmbt_key {
-	__be64		br_startoff;	/* starting file offset */
-} xfs_bmbt_key_t, xfs_bmdr_key_t;
-
-/* btree pointer type */
-typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
-
-/*
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_BMBT_BLOCK_LEN(mp) \
diff --git a/include/xfs_btree.h b/include/xfs_btree.h
index b55af99..227bfa5 100644
--- a/include/xfs_btree.h
+++ b/include/xfs_btree.h
@@ -39,86 +39,6 @@ extern kmem_zone_t	*xfs_btree_cur_zone;
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
 
 /*
- * Generic btree header.
- *
- * This is a combination of the actual format used on disk for short and long
- * format btrees.  The first three fields are shared by both format, but the
- * pointers are different and should be used with care.
- *
- * To get the size of the actual short or long form headers please use the size
- * macros below.  Never use sizeof(xfs_btree_block).
- *
- * The blkno, crc, lsn, owner and uuid fields are only available in filesystems
- * with the crc feature bit, and all accesses to them must be conditional on
- * that flag.
- */
-struct xfs_btree_block {
-	__be32		bb_magic;	/* magic number for block type */
-	__be16		bb_level;	/* 0 is a leaf */
-	__be16		bb_numrecs;	/* current # of data records */
-	union {
-		struct {
-			__be32		bb_leftsib;
-			__be32		bb_rightsib;
-
-			__be64		bb_blkno;
-			__be64		bb_lsn;
-			uuid_t		bb_uuid;
-			__be32		bb_owner;
-			__le32		bb_crc;
-		} s;			/* short form pointers */
-		struct	{
-			__be64		bb_leftsib;
-			__be64		bb_rightsib;
-
-			__be64		bb_blkno;
-			__be64		bb_lsn;
-			uuid_t		bb_uuid;
-			__be64		bb_owner;
-			__le32		bb_crc;
-			__be32		bb_pad; /* padding for alignment */
-		} l;			/* long form pointers */
-	} bb_u;				/* rest */
-};
-
-#define XFS_BTREE_SBLOCK_LEN	16	/* size of a short form block */
-#define XFS_BTREE_LBLOCK_LEN	24	/* size of a long form block */
-
-/* sizes of CRC enabled btree blocks */
-#define XFS_BTREE_SBLOCK_CRC_LEN	(XFS_BTREE_SBLOCK_LEN + 40)
-#define XFS_BTREE_LBLOCK_CRC_LEN	(XFS_BTREE_LBLOCK_LEN + 48)
-
-#define XFS_BTREE_SBLOCK_CRC_OFF \
-	offsetof(struct xfs_btree_block, bb_u.s.bb_crc)
-#define XFS_BTREE_LBLOCK_CRC_OFF \
-	offsetof(struct xfs_btree_block, bb_u.l.bb_crc)
-
-/*
- * Generic key, ptr and record wrapper structures.
- *
- * These are disk format structures, and are converted where necessary
- * by the btree specific code that needs to interpret them.
- */
-union xfs_btree_ptr {
-	__be32			s;	/* short form ptr */
-	__be64			l;	/* long form ptr */
-};
-
-union xfs_btree_key {
-	xfs_bmbt_key_t		bmbt;
-	xfs_bmdr_key_t		bmbr;	/* bmbt root block */
-	xfs_alloc_key_t		alloc;
-	xfs_inobt_key_t		inobt;
-};
-
-union xfs_btree_rec {
-	xfs_bmbt_rec_t		bmbt;
-	xfs_bmdr_rec_t		bmbr;	/* bmbt root block */
-	xfs_alloc_rec_t		alloc;
-	xfs_inobt_rec_t		inobt;
-};
-
-/*
  * For logging record fields.
  */
 #define	XFS_BB_MAGIC		0x01
diff --git a/include/xfs_format.h b/include/xfs_format.h
index a790428..997c770 100644
--- a/include/xfs_format.h
+++ b/include/xfs_format.h
@@ -156,4 +156,285 @@ struct xfs_dsymlink_hdr {
 	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
 			sizeof(struct xfs_dsymlink_hdr) : 0))
 
+
+/*
+ * Allocation Btree format definitions
+ *
+ * There are two on-disk btrees, one sorted by blockno and one sorted
+ * by blockcount and blockno.  All blocks look the same to make the code
+ * simpler; if we have time later, we'll make the optimizations.
+ */
+#define	XFS_ABTB_MAGIC		0x41425442	/* 'ABTB' for bno tree */
+#define	XFS_ABTB_CRC_MAGIC	0x41423342	/* 'AB3B' */
+#define	XFS_ABTC_MAGIC		0x41425443	/* 'ABTC' for cnt tree */
+#define	XFS_ABTC_CRC_MAGIC	0x41423343	/* 'AB3C' */
+
+/*
+ * Data record/key structure
+ */
+typedef struct xfs_alloc_rec {
+	__be32		ar_startblock;	/* starting block number */
+	__be32		ar_blockcount;	/* count of free blocks */
+} xfs_alloc_rec_t, xfs_alloc_key_t;
+
+typedef struct xfs_alloc_rec_incore {
+	xfs_agblock_t	ar_startblock;	/* starting block number */
+	xfs_extlen_t	ar_blockcount;	/* count of free blocks */
+} xfs_alloc_rec_incore_t;
+
+/* btree pointer type */
+typedef __be32 xfs_alloc_ptr_t;
+
+/*
+ * Block numbers in the AG:
+ * SB is sector 0, AGF is sector 1, AGI is sector 2, AGFL is sector 3.
+ */
+#define	XFS_BNO_BLOCK(mp)	((xfs_agblock_t)(XFS_AGFL_BLOCK(mp) + 1))
+#define	XFS_CNT_BLOCK(mp)	((xfs_agblock_t)(XFS_BNO_BLOCK(mp) + 1))
+
+
+/*
+ * Inode Allocation Btree format definitions
+ *
+ * There is a btree for the inode map per allocation group.
+ */
+#define	XFS_IBT_MAGIC		0x49414254	/* 'IABT' */
+#define	XFS_IBT_CRC_MAGIC	0x49414233	/* 'IAB3' */
+
+typedef	__uint64_t	xfs_inofree_t;
+#define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
+#define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
+#define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
+#define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
+
+static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
+{
+	return ((n >= XFS_INODES_PER_CHUNK ? 0 : XFS_INOBT_MASK(n)) - 1) << i;
+}
+
+/*
+ * Data record structure
+ */
+typedef struct xfs_inobt_rec {
+	__be32		ir_startino;	/* starting inode number */
+	__be32		ir_freecount;	/* count of free inodes (set bits) */
+	__be64		ir_free;	/* free inode mask */
+} xfs_inobt_rec_t;
+
+typedef struct xfs_inobt_rec_incore {
+	xfs_agino_t	ir_startino;	/* starting inode number */
+	__int32_t	ir_freecount;	/* count of free inodes (set bits) */
+	xfs_inofree_t	ir_free;	/* free inode mask */
+} xfs_inobt_rec_incore_t;
+
+
+/*
+ * Key structure
+ */
+typedef struct xfs_inobt_key {
+	__be32		ir_startino;	/* starting inode number */
+} xfs_inobt_key_t;
+
+/* btree pointer type */
+typedef __be32 xfs_inobt_ptr_t;
+
+/*
+ * block numbers in the AG.
+ */
+#define	XFS_IBT_BLOCK(mp)		((xfs_agblock_t)(XFS_CNT_BLOCK(mp) + 1))
+#define	XFS_PREALLOC_BLOCKS(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
+
+
+
+/*
+ * BMAP Btree format definitions
+ *
+ * This includes both the root block definition that sits inside an inode fork
+ * and the record/pointer formats for the leaf/node in the blocks.
+ */
+#define XFS_BMAP_MAGIC		0x424d4150	/* 'BMAP' */
+#define XFS_BMAP_CRC_MAGIC	0x424d4133	/* 'BMA3' */
+
+/*
+ * Bmap root header, on-disk form only.
+ */
+typedef struct xfs_bmdr_block {
+	__be16		bb_level;	/* 0 is a leaf */
+	__be16		bb_numrecs;	/* current # of data records */
+} xfs_bmdr_block_t;
+
+/*
+ * Bmap btree record and extent descriptor.
+ *  l0:63 is an extent flag (value 1 indicates non-normal).
+ *  l0:9-62 are startoff.
+ *  l0:0-8 and l1:21-63 are startblock.
+ *  l1:0-20 are blockcount.
+ */
+#define BMBT_EXNTFLAG_BITLEN	1
+#define BMBT_STARTOFF_BITLEN	54
+#define BMBT_STARTBLOCK_BITLEN	52
+#define BMBT_BLOCKCOUNT_BITLEN	21
+
+typedef struct xfs_bmbt_rec {
+	__be64			l0, l1;
+} xfs_bmbt_rec_t;
+
+typedef __uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
+typedef xfs_bmbt_rec_t xfs_bmdr_rec_t;
+
+typedef struct xfs_bmbt_rec_host {
+	__uint64_t		l0, l1;
+} xfs_bmbt_rec_host_t;
+
+/*
+ * Values and macros for delayed-allocation startblock fields.
+ */
+#define STARTBLOCKVALBITS	17
+#define STARTBLOCKMASKBITS	(15 + XFS_BIG_BLKNOS * 20)
+#define DSTARTBLOCKMASKBITS	(15 + 20)
+#define STARTBLOCKMASK		\
+	(((((xfs_fsblock_t)1) << STARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
+#define DSTARTBLOCKMASK		\
+	(((((xfs_dfsbno_t)1) << DSTARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
+
+static inline int isnullstartblock(xfs_fsblock_t x)
+{
+	return ((x) & STARTBLOCKMASK) == STARTBLOCKMASK;
+}
+
+static inline int isnulldstartblock(xfs_dfsbno_t x)
+{
+	return ((x) & DSTARTBLOCKMASK) == DSTARTBLOCKMASK;
+}
+
+static inline xfs_fsblock_t nullstartblock(int k)
+{
+	ASSERT(k < (1 << STARTBLOCKVALBITS));
+	return STARTBLOCKMASK | (k);
+}
+
+static inline xfs_filblks_t startblockval(xfs_fsblock_t x)
+{
+	return (xfs_filblks_t)((x) & ~STARTBLOCKMASK);
+}
+
+/*
+ * Possible extent formats.
+ */
+typedef enum {
+	XFS_EXTFMT_NOSTATE = 0,
+	XFS_EXTFMT_HASSTATE
+} xfs_exntfmt_t;
+
+/*
+ * Possible extent states.
+ */
+typedef enum {
+	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
+	XFS_EXT_DMAPI_OFFLINE, XFS_EXT_INVALID
+} xfs_exntst_t;
+
+/*
+ * Incore version of above.
+ */
+typedef struct xfs_bmbt_irec
+{
+	xfs_fileoff_t	br_startoff;	/* starting file offset */
+	xfs_fsblock_t	br_startblock;	/* starting block number */
+	xfs_filblks_t	br_blockcount;	/* number of blocks */
+	xfs_exntst_t	br_state;	/* extent state */
+} xfs_bmbt_irec_t;
+
+/*
+ * Key structure for non-leaf levels of the tree.
+ */
+typedef struct xfs_bmbt_key {
+	__be64		br_startoff;	/* starting file offset */
+} xfs_bmbt_key_t, xfs_bmdr_key_t;
+
+/* btree pointer type */
+typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
+
+
+/*
+ * Generic Btree block format definitions
+ *
+ * This is a combination of the actual format used on disk for short and long
+ * format btrees.  The first three fields are shared by both format, but the
+ * pointers are different and should be used with care.
+ *
+ * To get the size of the actual short or long form headers please use the size
+ * macros below.  Never use sizeof(xfs_btree_block).
+ *
+ * The blkno, crc, lsn, owner and uuid fields are only available in filesystems
+ * with the crc feature bit, and all accesses to them must be conditional on
+ * that flag.
+ */
+struct xfs_btree_block {
+	__be32		bb_magic;	/* magic number for block type */
+	__be16		bb_level;	/* 0 is a leaf */
+	__be16		bb_numrecs;	/* current # of data records */
+	union {
+		struct {
+			__be32		bb_leftsib;
+			__be32		bb_rightsib;
+
+			__be64		bb_blkno;
+			__be64		bb_lsn;
+			uuid_t		bb_uuid;
+			__be32		bb_owner;
+			__le32		bb_crc;
+		} s;			/* short form pointers */
+		struct	{
+			__be64		bb_leftsib;
+			__be64		bb_rightsib;
+
+			__be64		bb_blkno;
+			__be64		bb_lsn;
+			uuid_t		bb_uuid;
+			__be64		bb_owner;
+			__le32		bb_crc;
+			__be32		bb_pad; /* padding for alignment */
+		} l;			/* long form pointers */
+	} bb_u;				/* rest */
+};
+
+#define XFS_BTREE_SBLOCK_LEN	16	/* size of a short form block */
+#define XFS_BTREE_LBLOCK_LEN	24	/* size of a long form block */
+
+/* sizes of CRC enabled btree blocks */
+#define XFS_BTREE_SBLOCK_CRC_LEN	(XFS_BTREE_SBLOCK_LEN + 40)
+#define XFS_BTREE_LBLOCK_CRC_LEN	(XFS_BTREE_LBLOCK_LEN + 48)
+
+#define XFS_BTREE_SBLOCK_CRC_OFF \
+	offsetof(struct xfs_btree_block, bb_u.s.bb_crc)
+#define XFS_BTREE_LBLOCK_CRC_OFF \
+	offsetof(struct xfs_btree_block, bb_u.l.bb_crc)
+
+/*
+ * Generic key, ptr and record wrapper structures.
+ *
+ * These are disk format structures, and are converted where necessary
+ * by the btree specific code that needs to interpret them.
+ */
+union xfs_btree_ptr {
+	__be32			s;	/* short form ptr */
+	__be64			l;	/* long form ptr */
+};
+
+union xfs_btree_key {
+	xfs_bmbt_key_t		bmbt;
+	xfs_bmdr_key_t		bmbr;	/* bmbt root block */
+	xfs_alloc_key_t		alloc;
+	xfs_inobt_key_t		inobt;
+};
+
+union xfs_btree_rec {
+	xfs_bmbt_rec_t		bmbt;
+	xfs_bmdr_rec_t		bmbr;	/* bmbt root block */
+	xfs_alloc_rec_t		alloc;
+	xfs_inobt_rec_t		inobt;
+};
+
+
 #endif /* __XFS_FORMAT_H__ */
diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
index 1557798..a8f76a5 100644
--- a/include/xfs_ialloc.h
+++ b/include/xfs_ialloc.h
@@ -23,6 +23,7 @@ struct xfs_dinode;
 struct xfs_imap;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_btree_cur;
 
 /*
  * Allocation parameters for inode allocation.
@@ -42,7 +43,7 @@ struct xfs_trans;
 static inline struct xfs_dinode *
 xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 {
-	return (xfs_dinode_t *)
+	return (struct xfs_dinode *)
 		(xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog));
 }
 
diff --git a/include/xfs_ialloc_btree.h b/include/xfs_ialloc_btree.h
index cfbfe46..f38b220 100644
--- a/include/xfs_ialloc_btree.h
+++ b/include/xfs_ialloc_btree.h
@@ -27,55 +27,6 @@ struct xfs_btree_cur;
 struct xfs_mount;
 
 /*
- * There is a btree for the inode map per allocation group.
- */
-#define	XFS_IBT_MAGIC		0x49414254	/* 'IABT' */
-#define	XFS_IBT_CRC_MAGIC	0x49414233	/* 'IAB3' */
-
-typedef	__uint64_t	xfs_inofree_t;
-#define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
-#define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
-#define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
-#define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
-
-static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
-{
-	return ((n >= XFS_INODES_PER_CHUNK ? 0 : XFS_INOBT_MASK(n)) - 1) << i;
-}
-
-/*
- * Data record structure
- */
-typedef struct xfs_inobt_rec {
-	__be32		ir_startino;	/* starting inode number */
-	__be32		ir_freecount;	/* count of free inodes (set bits) */
-	__be64		ir_free;	/* free inode mask */
-} xfs_inobt_rec_t;
-
-typedef struct xfs_inobt_rec_incore {
-	xfs_agino_t	ir_startino;	/* starting inode number */
-	__int32_t	ir_freecount;	/* count of free inodes (set bits) */
-	xfs_inofree_t	ir_free;	/* free inode mask */
-} xfs_inobt_rec_incore_t;
-
-
-/*
- * Key structure
- */
-typedef struct xfs_inobt_key {
-	__be32		ir_startino;	/* starting inode number */
-} xfs_inobt_key_t;
-
-/* btree pointer type */
-typedef __be32 xfs_inobt_ptr_t;
-
-/*
- * block numbers in the AG.
- */
-#define	XFS_IBT_BLOCK(mp)		((xfs_agblock_t)(XFS_CNT_BLOCK(mp) + 1))
-#define	XFS_PREALLOC_BLOCKS(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
-
-/*
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_INOBT_BLOCK_LEN(mp) \
diff --git a/include/xfs_inode_fork.h b/include/xfs_inode_fork.h
index 28661a0..eb329a1 100644
--- a/include/xfs_inode_fork.h
+++ b/include/xfs_inode_fork.h
@@ -19,6 +19,7 @@
 #define	__XFS_INODE_FORK_H__
 
 struct xfs_inode_log_item;
+struct xfs_dinode;
 
 /*
  * The following xfs_ext_irec_t struct introduces a second (top) level
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
