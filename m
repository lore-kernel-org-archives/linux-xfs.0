Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Jul 2006 21:22:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6T4LtDW024235
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 21:22:01 -0700
Received: from [10.0.0.4] (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id C96D418DE2F33
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 23:21:25 -0500 (CDT)
Message-ID: <44CAE247.6020608@sandeen.net>
Date: Fri, 28 Jul 2006 23:21:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] kill leftover WANT_FUNCS macro indirection
Content-Type: multipart/mixed;
 boundary="------------040402000908070606030002"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------040402000908070606030002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This gets rid of some pointless macro defines... I had a version that 
lower-cased it all too but Nathan liked this better, and he's the man! :)

-Eric

--------------040402000908070606030002
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="kill-wantfuncs-simple"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kill-wantfuncs-simple"

Remove unnecessary macro indirection - left over from old
WANT_FUNCS days

Signed-Off-By: Eric Sandeen <sandeen@sandeen.net>

 xfs_attr_leaf.h    |   24 ++++------------
 xfs_bit.h          |   12 ++------
 xfs_bmap.h         |    6 +---
 xfs_bmap_btree.h   |   12 ++------
 xfs_dir2_block.h   |    6 +---
 xfs_dir2_data.h    |   10 ++----
 xfs_dir2_leaf.h    |   44 +++++++++---------------------
 xfs_dir2_node.h    |    6 +---
 xfs_dir2_sf.h      |   36 ++++++------------------
 xfs_ialloc.h       |    6 +---
 xfs_ialloc_btree.h |    3 --
 xfs_inode_item.h   |    9 ++----
 xfs_mount.h        |   15 +++-------
 xfs_rw.h           |    6 +---
 xfs_sb.h           |   77 +++++++++++++++++------------------------------------
 xfs_trans.h        |   33 +++++++---------------
 16 files changed, 97 insertions(+), 208 deletions(-)


Index: xfs-linux-killwantfuncs/xfs_attr_leaf.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_attr_leaf.h
+++ xfs-linux-killwantfuncs/xfs_attr_leaf.h
@@ -138,27 +138,21 @@ typedef struct xfs_attr_leafblock {
 /*
  * Cast typed pointers for "local" and "remote" name/value structs.
  */
-#define XFS_ATTR_LEAF_NAME_REMOTE(leafp,idx)	\
-	xfs_attr_leaf_name_remote(leafp,idx)
 static inline xfs_attr_leaf_name_remote_t *
-xfs_attr_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
+XFS_ATTR_LEAF_NAME_REMOTE(xfs_attr_leafblock_t *leafp, int idx)
 {
 	return (xfs_attr_leaf_name_remote_t *)
 		&((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
 }
 
-#define XFS_ATTR_LEAF_NAME_LOCAL(leafp,idx)	\
-	xfs_attr_leaf_name_local(leafp,idx)
 static inline xfs_attr_leaf_name_local_t *
-xfs_attr_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
+XFS_ATTR_LEAF_NAME_LOCAL(xfs_attr_leafblock_t *leafp, int idx)
 {
 	return (xfs_attr_leaf_name_local_t *)
 		&((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
 }
 
-#define XFS_ATTR_LEAF_NAME(leafp,idx)		\
-	xfs_attr_leaf_name(leafp,idx)
-static inline char *xfs_attr_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
+static inline char *XFS_ATTR_LEAF_NAME(xfs_attr_leafblock_t *leafp, int idx)
 {
 	return &((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
 }
@@ -168,25 +162,19 @@ static inline char *xfs_attr_leaf_name(x
  * a "local" name/value structure, a "remote" name/value structure, and
  * a pointer which might be either.
  */
-#define XFS_ATTR_LEAF_ENTSIZE_REMOTE(nlen)	\
-	xfs_attr_leaf_entsize_remote(nlen)
-static inline int xfs_attr_leaf_entsize_remote(int nlen)
+static inline int XFS_ATTR_LEAF_ENTSIZE_REMOTE(int nlen)
 {
 	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) + \
 		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
 }
 
-#define XFS_ATTR_LEAF_ENTSIZE_LOCAL(nlen,vlen)	\
-	xfs_attr_leaf_entsize_local(nlen,vlen)
-static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
+static inline int XFS_ATTR_LEAF_ENTSIZE_LOCAL(int nlen, int vlen)
 {
 	return ((uint)sizeof(xfs_attr_leaf_name_local_t) - 1 + (nlen) + (vlen) +
 		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
 }
 
-#define XFS_ATTR_LEAF_ENTSIZE_LOCAL_MAX(bsize)	\
-	xfs_attr_leaf_entsize_local_max(bsize)
-static inline int xfs_attr_leaf_entsize_local_max(int bsize)
+static inline int XFS_ATTR_LEAF_ENTSIZE_LOCAL_MAX(int bsize)
 {
 	return (((bsize) >> 1) + ((bsize) >> 2));
 }
Index: xfs-linux-killwantfuncs/xfs_bit.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_bit.h
+++ xfs-linux-killwantfuncs/xfs_bit.h
@@ -25,23 +25,19 @@
 /*
  * masks with n high/low bits set, 32-bit values & 64-bit values
  */
-#define	XFS_MASK32HI(n)		xfs_mask32hi(n)
-static inline __uint32_t xfs_mask32hi(int n)
+static inline __uint32_t XFS_MASK32HI(int n)
 {
 	return (__uint32_t)-1 << (32 - (n));
 }
-#define	XFS_MASK64HI(n)		xfs_mask64hi(n)
-static inline __uint64_t xfs_mask64hi(int n)
+static inline __uint64_t XFS_MASK64HI(int n)
 {
 	return (__uint64_t)-1 << (64 - (n));
 }
-#define	XFS_MASK32LO(n)		xfs_mask32lo(n)
-static inline __uint32_t xfs_mask32lo(int n)
+static inline __uint32_t XFS_MASK32LO(int n)
 {
 	return ((__uint32_t)1 << (n)) - 1;
 }
-#define	XFS_MASK64LO(n)		xfs_mask64lo(n)
-static inline __uint64_t xfs_mask64lo(int n)
+static inline __uint64_t XFS_MASK64LO(int n)
 {
 	return ((__uint64_t)1 << (n)) - 1;
 }
Index: xfs-linux-killwantfuncs/xfs_bmap.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_bmap.h
+++ xfs-linux-killwantfuncs/xfs_bmap.h
@@ -82,8 +82,7 @@ typedef	struct xfs_bmap_free
 					/* need write cache flushing and no */
 					/* additional allocation alignments */
 
-#define	XFS_BMAPI_AFLAG(w)	xfs_bmapi_aflag(w)
-static inline int xfs_bmapi_aflag(int w)
+static inline int XFS_BMAPI_AFLAG(int w)
 {
 	return (w == XFS_ATTR_FORK ? XFS_BMAPI_ATTRFORK : 0);
 }
@@ -94,8 +93,7 @@ static inline int xfs_bmapi_aflag(int w)
 #define	DELAYSTARTBLOCK		((xfs_fsblock_t)-1LL)
 #define	HOLESTARTBLOCK		((xfs_fsblock_t)-2LL)
 
-#define	XFS_BMAP_INIT(flp,fbp)	xfs_bmap_init(flp,fbp)
-static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
+static inline void XFS_BMAP_INIT(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 {
 	((flp)->xbf_first = NULL, (flp)->xbf_count = 0, \
 		(flp)->xbf_low = 0, *(fbp) = NULLFSBLOCK);
Index: xfs-linux-killwantfuncs/xfs_bmap_btree.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_bmap_btree.h
+++ xfs-linux-killwantfuncs/xfs_bmap_btree.h
@@ -100,27 +100,23 @@ typedef xfs_bmbt_rec_64_t xfs_bmbt_rec_t
 #define DSTARTBLOCKMASK		\
 	(((((xfs_dfsbno_t)1) << DSTARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
 
-#define ISNULLSTARTBLOCK(x)	isnullstartblock(x)
-static inline int isnullstartblock(xfs_fsblock_t x)
+static inline int ISNULLSTARTBLOCK(xfs_fsblock_t x)
 {
 	return ((x) & STARTBLOCKMASK) == STARTBLOCKMASK;
 }
 
-#define ISNULLDSTARTBLOCK(x)	isnulldstartblock(x)
-static inline int isnulldstartblock(xfs_dfsbno_t x)
+static inline int ISNULLDSTARTBLOCK(xfs_dfsbno_t x)
 {
 	return ((x) & DSTARTBLOCKMASK) == DSTARTBLOCKMASK;
 }
 
-#define NULLSTARTBLOCK(k)	nullstartblock(k)
-static inline xfs_fsblock_t nullstartblock(int k)
+static inline xfs_fsblock_t NULLSTARTBLOCK(int k)
 {
 	ASSERT(k < (1 << STARTBLOCKVALBITS));
 	return STARTBLOCKMASK | (k);
 }
 
-#define STARTBLOCKVAL(x)	startblockval(x)
-static inline xfs_filblks_t startblockval(xfs_fsblock_t x)
+static inline xfs_filblks_t STARTBLOCKVAL(xfs_fsblock_t x)
 {
 	return (xfs_filblks_t)((x) & ~STARTBLOCKMASK);
 }
Index: xfs-linux-killwantfuncs/xfs_dir2_block.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_dir2_block.h
+++ xfs-linux-killwantfuncs/xfs_dir2_block.h
@@ -60,9 +60,8 @@ typedef struct xfs_dir2_block {
 /*
  * Pointer to the leaf header embedded in a data block (1-block format)
  */
-#define	XFS_DIR2_BLOCK_TAIL_P(mp,block)	xfs_dir2_block_tail_p(mp,block)
 static inline xfs_dir2_block_tail_t *
-xfs_dir2_block_tail_p(struct xfs_mount *mp, xfs_dir2_block_t *block)
+XFS_DIR2_BLOCK_TAIL_P(struct xfs_mount *mp, xfs_dir2_block_t *block)
 {
 	return (((xfs_dir2_block_tail_t *)
 		((char *)(block) + (mp)->m_dirblksize)) - 1);
@@ -71,9 +70,8 @@ xfs_dir2_block_tail_p(struct xfs_mount *
 /*
  * Pointer to the leaf entries embedded in a data block (1-block format)
  */
-#define	XFS_DIR2_BLOCK_LEAF_P(btp)	xfs_dir2_block_leaf_p(btp)
 static inline struct xfs_dir2_leaf_entry *
-xfs_dir2_block_leaf_p(xfs_dir2_block_tail_t *btp)
+XFS_DIR2_BLOCK_LEAF_P(xfs_dir2_block_tail_t *btp)
 {
 	return ((struct xfs_dir2_leaf_entry *)btp) - be32_to_cpu(btp->count);
 }
Index: xfs-linux-killwantfuncs/xfs_dir2_data.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_dir2_data.h
+++ xfs-linux-killwantfuncs/xfs_dir2_data.h
@@ -123,8 +123,7 @@ typedef struct xfs_dir2_data {
 /*
  * Size of a data entry.
  */
-#define XFS_DIR2_DATA_ENTSIZE(n)	xfs_dir2_data_entsize(n)
-static inline int xfs_dir2_data_entsize(int n)
+static inline int XFS_DIR2_DATA_ENTSIZE(int n)
 {
 	return (int)roundup(offsetof(xfs_dir2_data_entry_t, name[0]) + (n) + \
 		 (uint)sizeof(xfs_dir2_data_off_t), XFS_DIR2_DATA_ALIGN);
@@ -133,9 +132,8 @@ static inline int xfs_dir2_data_entsize(
 /*
  * Pointer to an entry's tag word.
  */
-#define	XFS_DIR2_DATA_ENTRY_TAG_P(dep)	xfs_dir2_data_entry_tag_p(dep)
 static inline __be16 *
-xfs_dir2_data_entry_tag_p(xfs_dir2_data_entry_t *dep)
+XFS_DIR2_DATA_ENTRY_TAG_P(xfs_dir2_data_entry_t *dep)
 {
 	return (__be16 *)((char *)dep +
 		XFS_DIR2_DATA_ENTSIZE(dep->namelen) - sizeof(__be16));
@@ -144,10 +142,8 @@ xfs_dir2_data_entry_tag_p(xfs_dir2_data_
 /*
  * Pointer to a freespace's tag word.
  */
-#define	XFS_DIR2_DATA_UNUSED_TAG_P(dup) \
-	xfs_dir2_data_unused_tag_p(dup)
 static inline __be16 *
-xfs_dir2_data_unused_tag_p(xfs_dir2_data_unused_t *dup)
+XFS_DIR2_DATA_UNUSED_TAG_P(xfs_dir2_data_unused_t *dup)
 {
 	return (__be16 *)((char *)dup +
 			be16_to_cpu(dup->length) - sizeof(__be16));
Index: xfs-linux-killwantfuncs/xfs_dir2_leaf.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_dir2_leaf.h
+++ xfs-linux-killwantfuncs/xfs_dir2_leaf.h
@@ -82,8 +82,7 @@ typedef struct xfs_dir2_leaf {
  * DB blocks here are logical directory block numbers, not filesystem blocks.
  */
 
-#define	XFS_DIR2_MAX_LEAF_ENTS(mp)	xfs_dir2_max_leaf_ents(mp)
-static inline int xfs_dir2_max_leaf_ents(struct xfs_mount *mp)
+static inline int XFS_DIR2_MAX_LEAF_ENTS(struct xfs_mount *mp)
 {
 	return (int)(((mp)->m_dirblksize - (uint)sizeof(xfs_dir2_leaf_hdr_t)) /
 	       (uint)sizeof(xfs_dir2_leaf_entry_t));
@@ -92,9 +91,8 @@ static inline int xfs_dir2_max_leaf_ents
 /*
  * Get address of the bestcount field in the single-leaf block.
  */
-#define	XFS_DIR2_LEAF_TAIL_P(mp,lp)	xfs_dir2_leaf_tail_p(mp, lp)
 static inline xfs_dir2_leaf_tail_t *
-xfs_dir2_leaf_tail_p(struct xfs_mount *mp, xfs_dir2_leaf_t *lp)
+XFS_DIR2_LEAF_TAIL_P(struct xfs_mount *mp, xfs_dir2_leaf_t *lp)
 {
 	return (xfs_dir2_leaf_tail_t *)
 		((char *)(lp) + (mp)->m_dirblksize - 
@@ -104,9 +102,8 @@ xfs_dir2_leaf_tail_p(struct xfs_mount *m
 /*
  * Get address of the bests array in the single-leaf block.
  */
-#define	XFS_DIR2_LEAF_BESTS_P(ltp)	xfs_dir2_leaf_bests_p(ltp)
 static inline __be16 *
-xfs_dir2_leaf_bests_p(xfs_dir2_leaf_tail_t *ltp)
+XFS_DIR2_LEAF_BESTS_P(xfs_dir2_leaf_tail_t *ltp)
 {
 	return (__be16 *)ltp - be32_to_cpu(ltp->bestcount);
 }
@@ -114,9 +111,8 @@ xfs_dir2_leaf_bests_p(xfs_dir2_leaf_tail
 /*
  * Convert dataptr to byte in file space
  */
-#define	XFS_DIR2_DATAPTR_TO_BYTE(mp,dp)	xfs_dir2_dataptr_to_byte(mp, dp)
 static inline xfs_dir2_off_t
-xfs_dir2_dataptr_to_byte(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
+XFS_DIR2_DATAPTR_TO_BYTE(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
 {
 	return (xfs_dir2_off_t)(dp) << XFS_DIR2_DATA_ALIGN_LOG;
 }
@@ -124,9 +120,8 @@ xfs_dir2_dataptr_to_byte(struct xfs_moun
 /*
  * Convert byte in file space to dataptr.  It had better be aligned.
  */
-#define	XFS_DIR2_BYTE_TO_DATAPTR(mp,by)	xfs_dir2_byte_to_dataptr(mp,by)
 static inline xfs_dir2_dataptr_t
-xfs_dir2_byte_to_dataptr(struct xfs_mount *mp, xfs_dir2_off_t by)
+XFS_DIR2_BYTE_TO_DATAPTR(struct xfs_mount *mp, xfs_dir2_off_t by)
 {
 	return (xfs_dir2_dataptr_t)((by) >> XFS_DIR2_DATA_ALIGN_LOG);
 }
@@ -134,9 +129,8 @@ xfs_dir2_byte_to_dataptr(struct xfs_moun
 /*
  * Convert byte in space to (DB) block
  */
-#define	XFS_DIR2_BYTE_TO_DB(mp,by)	xfs_dir2_byte_to_db(mp, by)
 static inline xfs_dir2_db_t
-xfs_dir2_byte_to_db(struct xfs_mount *mp, xfs_dir2_off_t by)
+XFS_DIR2_BYTE_TO_DB(struct xfs_mount *mp, xfs_dir2_off_t by)
 {
 	return (xfs_dir2_db_t)((by) >> \
 		 ((mp)->m_sb.sb_blocklog + (mp)->m_sb.sb_dirblklog));
@@ -145,9 +139,8 @@ xfs_dir2_byte_to_db(struct xfs_mount *mp
 /*
  * Convert dataptr to a block number
  */
-#define	XFS_DIR2_DATAPTR_TO_DB(mp,dp)	xfs_dir2_dataptr_to_db(mp, dp)
 static inline xfs_dir2_db_t
-xfs_dir2_dataptr_to_db(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
+XFS_DIR2_DATAPTR_TO_DB(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
 {
 	return XFS_DIR2_BYTE_TO_DB(mp, XFS_DIR2_DATAPTR_TO_BYTE(mp, dp));
 }
@@ -155,9 +148,8 @@ xfs_dir2_dataptr_to_db(struct xfs_mount 
 /*
  * Convert byte in space to offset in a block
  */
-#define	XFS_DIR2_BYTE_TO_OFF(mp,by)	xfs_dir2_byte_to_off(mp, by)
 static inline xfs_dir2_data_aoff_t
-xfs_dir2_byte_to_off(struct xfs_mount *mp, xfs_dir2_off_t by)
+XFS_DIR2_BYTE_TO_OFF(struct xfs_mount *mp, xfs_dir2_off_t by)
 {
 	return (xfs_dir2_data_aoff_t)((by) & \
 		((1 << ((mp)->m_sb.sb_blocklog + (mp)->m_sb.sb_dirblklog)) - 1));
@@ -176,10 +168,8 @@ xfs_dir2_dataptr_to_off(struct xfs_mount
 /*
  * Convert block and offset to byte in space
  */
-#define	XFS_DIR2_DB_OFF_TO_BYTE(mp,db,o)	\
-	xfs_dir2_db_off_to_byte(mp, db, o)
 static inline xfs_dir2_off_t
-xfs_dir2_db_off_to_byte(struct xfs_mount *mp, xfs_dir2_db_t db,
+XFS_DIR2_DB_OFF_TO_BYTE(struct xfs_mount *mp, xfs_dir2_db_t db,
 			xfs_dir2_data_aoff_t o)
 {
 	return ((xfs_dir2_off_t)(db) << \
@@ -189,9 +179,8 @@ xfs_dir2_db_off_to_byte(struct xfs_mount
 /*
  * Convert block (DB) to block (dablk)
  */
-#define	XFS_DIR2_DB_TO_DA(mp,db)	xfs_dir2_db_to_da(mp, db)
 static inline xfs_dablk_t
-xfs_dir2_db_to_da(struct xfs_mount *mp, xfs_dir2_db_t db)
+XFS_DIR2_DB_TO_DA(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
 	return (xfs_dablk_t)((db) << (mp)->m_sb.sb_dirblklog);
 }
@@ -199,9 +188,8 @@ xfs_dir2_db_to_da(struct xfs_mount *mp, 
 /*
  * Convert byte in space to (DA) block
  */
-#define	XFS_DIR2_BYTE_TO_DA(mp,by)	xfs_dir2_byte_to_da(mp, by)
 static inline xfs_dablk_t
-xfs_dir2_byte_to_da(struct xfs_mount *mp, xfs_dir2_off_t by)
+XFS_DIR2_BYTE_TO_DA(struct xfs_mount *mp, xfs_dir2_off_t by)
 {
 	return XFS_DIR2_DB_TO_DA(mp, XFS_DIR2_BYTE_TO_DB(mp, by));
 }
@@ -209,10 +197,8 @@ xfs_dir2_byte_to_da(struct xfs_mount *mp
 /*
  * Convert block and offset to dataptr
  */
-#define	XFS_DIR2_DB_OFF_TO_DATAPTR(mp,db,o)	\
-	xfs_dir2_db_off_to_dataptr(mp, db, o)
 static inline xfs_dir2_dataptr_t
-xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
+XFS_DIR2_DB_OFF_TO_DATAPTR(struct xfs_mount *mp, xfs_dir2_db_t db,
 			   xfs_dir2_data_aoff_t o)
 {
 	return XFS_DIR2_BYTE_TO_DATAPTR(mp, XFS_DIR2_DB_OFF_TO_BYTE(mp, db, o));
@@ -221,9 +207,8 @@ xfs_dir2_db_off_to_dataptr(struct xfs_mo
 /*
  * Convert block (dablk) to block (DB)
  */
-#define	XFS_DIR2_DA_TO_DB(mp,da)	xfs_dir2_da_to_db(mp, da)
 static inline xfs_dir2_db_t
-xfs_dir2_da_to_db(struct xfs_mount *mp, xfs_dablk_t da)
+XFS_DIR2_DA_TO_DB(struct xfs_mount *mp, xfs_dablk_t da)
 {
 	return (xfs_dir2_db_t)((da) >> (mp)->m_sb.sb_dirblklog);
 }
@@ -231,9 +216,8 @@ xfs_dir2_da_to_db(struct xfs_mount *mp, 
 /*
  * Convert block (dablk) to byte offset in space
  */
-#define XFS_DIR2_DA_TO_BYTE(mp,da)	xfs_dir2_da_to_byte(mp, da)
 static inline xfs_dir2_off_t
-xfs_dir2_da_to_byte(struct xfs_mount *mp, xfs_dablk_t da)
+XFS_DIR2_DA_TO_BYTE(struct xfs_mount *mp, xfs_dablk_t da)
 {
 	return XFS_DIR2_DB_OFF_TO_BYTE(mp, XFS_DIR2_DA_TO_DB(mp, da), 0);
 }
Index: xfs-linux-killwantfuncs/xfs_dir2_node.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_dir2_node.h
+++ xfs-linux-killwantfuncs/xfs_dir2_node.h
@@ -60,9 +60,8 @@ typedef struct xfs_dir2_free {
 /*
  * Convert data space db to the corresponding free db.
  */
-#define	XFS_DIR2_DB_TO_FDB(mp,db)	xfs_dir2_db_to_fdb(mp, db)
 static inline xfs_dir2_db_t
-xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
+XFS_DIR2_DB_TO_FDB(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
 	return (XFS_DIR2_FREE_FIRSTDB(mp) + (db) / XFS_DIR2_MAX_FREE_BESTS(mp));
 }
@@ -70,9 +69,8 @@ xfs_dir2_db_to_fdb(struct xfs_mount *mp,
 /*
  * Convert data space db to the corresponding index in a free db.
  */
-#define	XFS_DIR2_DB_TO_FDINDEX(mp,db)	xfs_dir2_db_to_fdindex(mp, db)
 static inline int
-xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
+XFS_DIR2_DB_TO_FDINDEX(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
 	return ((db) % XFS_DIR2_MAX_FREE_BESTS(mp));
 }
Index: xfs-linux-killwantfuncs/xfs_dir2_sf.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_dir2_sf.h
+++ xfs-linux-killwantfuncs/xfs_dir2_sf.h
@@ -90,33 +90,27 @@ typedef struct xfs_dir2_sf {
 	xfs_dir2_sf_entry_t	list[1];	/* shortform entries */
 } xfs_dir2_sf_t;
 
-#define	XFS_DIR2_SF_HDR_SIZE(i8count)	xfs_dir2_sf_hdr_size(i8count)
-static inline int xfs_dir2_sf_hdr_size(int i8count)
+static inline int XFS_DIR2_SF_HDR_SIZE(int i8count)
 {
 	return ((uint)sizeof(xfs_dir2_sf_hdr_t) - \
 		((i8count) == 0) * \
 		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
 }
 
-#define	XFS_DIR2_SF_INUMBERP(sfep)	xfs_dir2_sf_inumberp(sfep)
-static inline xfs_dir2_inou_t *xfs_dir2_sf_inumberp(xfs_dir2_sf_entry_t *sfep)
+static inline xfs_dir2_inou_t *XFS_DIR2_SF_INUMBERP(xfs_dir2_sf_entry_t *sfep)
 {
 	return (xfs_dir2_inou_t *)&(sfep)->name[(sfep)->namelen];
 }
 
-#define	XFS_DIR2_SF_GET_INUMBER(sfp, from) \
-	xfs_dir2_sf_get_inumber(sfp, from)
 static inline xfs_intino_t
-xfs_dir2_sf_get_inumber(xfs_dir2_sf_t *sfp, xfs_dir2_inou_t *from)
+XFS_DIR2_SF_GET_INUMBER(xfs_dir2_sf_t *sfp, xfs_dir2_inou_t *from)
 {
 	return ((sfp)->hdr.i8count == 0 ? \
 		(xfs_intino_t)XFS_GET_DIR_INO4((from)->i4) : \
 		(xfs_intino_t)XFS_GET_DIR_INO8((from)->i8));
 }
 
-#define	XFS_DIR2_SF_PUT_INUMBER(sfp,from,to) \
-	xfs_dir2_sf_put_inumber(sfp,from,to)
-static inline void xfs_dir2_sf_put_inumber(xfs_dir2_sf_t *sfp, xfs_ino_t *from,
+static inline void XFS_DIR2_SF_PUT_INUMBER(xfs_dir2_sf_t *sfp, xfs_ino_t *from,
 						xfs_dir2_inou_t *to)
 {
 	if ((sfp)->hdr.i8count == 0)
@@ -125,51 +119,41 @@ static inline void xfs_dir2_sf_put_inumb
 		XFS_PUT_DIR_INO8(*(from), (to)->i8);
 }
 
-#define	XFS_DIR2_SF_GET_OFFSET(sfep)	\
-	xfs_dir2_sf_get_offset(sfep)
 static inline xfs_dir2_data_aoff_t
-xfs_dir2_sf_get_offset(xfs_dir2_sf_entry_t *sfep)
+XFS_DIR2_SF_GET_OFFSET(xfs_dir2_sf_entry_t *sfep)
 {
 	return INT_GET_UNALIGNED_16_BE(&(sfep)->offset.i);
 }
 
-#define	XFS_DIR2_SF_PUT_OFFSET(sfep,off) \
-	xfs_dir2_sf_put_offset(sfep,off)
 static inline void
-xfs_dir2_sf_put_offset(xfs_dir2_sf_entry_t *sfep, xfs_dir2_data_aoff_t off)
+XFS_DIR2_SF_PUT_OFFSET(xfs_dir2_sf_entry_t *sfep, xfs_dir2_data_aoff_t off)
 {
 	INT_SET_UNALIGNED_16_BE(&(sfep)->offset.i, off);
 }
 
-#define XFS_DIR2_SF_ENTSIZE_BYNAME(sfp,len)	\
-	xfs_dir2_sf_entsize_byname(sfp,len)
-static inline int xfs_dir2_sf_entsize_byname(xfs_dir2_sf_t *sfp, int len)
+static inline int XFS_DIR2_SF_ENTSIZE_BYNAME(xfs_dir2_sf_t *sfp, int len)
 {
 	return ((uint)sizeof(xfs_dir2_sf_entry_t) - 1 + (len) - \
 		((sfp)->hdr.i8count == 0) * \
 		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
 }
 
-#define XFS_DIR2_SF_ENTSIZE_BYENTRY(sfp,sfep)	\
-	xfs_dir2_sf_entsize_byentry(sfp,sfep)
 static inline int
-xfs_dir2_sf_entsize_byentry(xfs_dir2_sf_t *sfp, xfs_dir2_sf_entry_t *sfep)
+XFS_DIR2_SF_ENTSIZE_BYENTRY(xfs_dir2_sf_t *sfp, xfs_dir2_sf_entry_t *sfep)
 {
 	return ((uint)sizeof(xfs_dir2_sf_entry_t) - 1 + (sfep)->namelen - \
 		((sfp)->hdr.i8count == 0) * \
 		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
 }
 
-#define XFS_DIR2_SF_FIRSTENTRY(sfp)	xfs_dir2_sf_firstentry(sfp)
-static inline xfs_dir2_sf_entry_t *xfs_dir2_sf_firstentry(xfs_dir2_sf_t *sfp)
+static inline xfs_dir2_sf_entry_t *XFS_DIR2_SF_FIRSTENTRY(xfs_dir2_sf_t *sfp)
 {
 	return ((xfs_dir2_sf_entry_t *) \
 		((char *)(sfp) + XFS_DIR2_SF_HDR_SIZE(sfp->hdr.i8count)));
 }
 
-#define XFS_DIR2_SF_NEXTENTRY(sfp,sfep)	xfs_dir2_sf_nextentry(sfp,sfep)
 static inline xfs_dir2_sf_entry_t *
-xfs_dir2_sf_nextentry(xfs_dir2_sf_t *sfp, xfs_dir2_sf_entry_t *sfep)
+XFS_DIR2_SF_NEXTENTRY(xfs_dir2_sf_t *sfp, xfs_dir2_sf_entry_t *sfep)
 {
 	return ((xfs_dir2_sf_entry_t *) \
 		((char *)(sfep) + XFS_DIR2_SF_ENTSIZE_BYENTRY(sfp,sfep)));
Index: xfs-linux-killwantfuncs/xfs_ialloc.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_ialloc.h
+++ xfs-linux-killwantfuncs/xfs_ialloc.h
@@ -43,9 +43,8 @@ struct xfs_trans;
 /*
  * Make an inode pointer out of the buffer/offset.
  */
-#define	XFS_MAKE_IPTR(mp,b,o)		xfs_make_iptr(mp,b,o)
 static inline struct xfs_dinode *
-xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
+XFS_MAKE_IPTR(struct xfs_mount *mp, struct xfs_buf *b, int o)
 {
 	return (xfs_dinode_t *)
 		(xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog));
@@ -54,8 +53,7 @@ xfs_make_iptr(struct xfs_mount *mp, stru
 /*
  * Find a free (set) bit in the inode bitmask.
  */
-#define	XFS_IALLOC_FIND_FREE(fp)	xfs_ialloc_find_free(fp)
-static inline int xfs_ialloc_find_free(xfs_inofree_t *fp)
+static inline int XFS_IALLOC_FIND_FREE(xfs_inofree_t *fp)
 {
 	return xfs_lowbit64(*fp);
 }
Index: xfs-linux-killwantfuncs/xfs_ialloc_btree.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_ialloc_btree.h
+++ xfs-linux-killwantfuncs/xfs_ialloc_btree.h
@@ -37,8 +37,7 @@ typedef	__uint64_t	xfs_inofree_t;
 #define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
 #define	XFS_INOBT_ALL_FREE	((xfs_inofree_t)-1)
 
-#define	XFS_INOBT_MASKN(i,n)		xfs_inobt_maskn(i,n)
-static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
+static inline xfs_inofree_t XFS_INOBT_MASKN(int i, int n)
 {
 	return (((n) >= XFS_INODES_PER_CHUNK ? \
 		(xfs_inofree_t)0 : ((xfs_inofree_t)1 << (n))) - 1) << (i);
Index: xfs-linux-killwantfuncs/xfs_inode_item.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_inode_item.h
+++ xfs-linux-killwantfuncs/xfs_inode_item.h
@@ -148,22 +148,19 @@ typedef struct xfs_inode_log_item {
 } xfs_inode_log_item_t;
 
 
-#define	XFS_ILOG_FDATA(w)	xfs_ilog_fdata(w)
-static inline int xfs_ilog_fdata(int w)
+static inline int XFS_ILOG_FDATA(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DDATA : XFS_ILOG_ADATA);
 }
 
 #endif	/* __KERNEL__ */
 
-#define	XFS_ILOG_FBROOT(w)	xfs_ilog_fbroot(w)
-static inline int xfs_ilog_fbroot(int w)
+static inline int XFS_ILOG_FBROOT(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DBROOT : XFS_ILOG_ABROOT);
 }
 
-#define	XFS_ILOG_FEXT(w)	xfs_ilog_fext(w)
-static inline int xfs_ilog_fext(int w)
+static inline int XFS_ILOG_FEXT(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
 }
Index: xfs-linux-killwantfuncs/xfs_mount.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_mount.h
+++ xfs-linux-killwantfuncs/xfs_mount.h
@@ -526,36 +526,31 @@ xfs_preferred_iosize(xfs_mount_t *mp)
 /*
  * Macros for getting from mount to vfs and back.
  */
-#define	XFS_MTOVFS(mp)		xfs_mtovfs(mp)
-static inline struct bhv_vfs *xfs_mtovfs(xfs_mount_t *mp)
+static inline struct bhv_vfs *XFS_MTOVFS(xfs_mount_t *mp)
 {
 	return bhvtovfs(&mp->m_bhv);
 }
 
-#define	XFS_BHVTOM(bdp)	xfs_bhvtom(bdp)
-static inline xfs_mount_t *xfs_bhvtom(bhv_desc_t *bdp)
+static inline xfs_mount_t *XFS_BHVTOM(bhv_desc_t *bdp)
 {
 	return (xfs_mount_t *)BHV_PDATA(bdp);
 }
 
-#define XFS_VFSTOM(vfs) xfs_vfstom(vfs)
-static inline xfs_mount_t *xfs_vfstom(bhv_vfs_t *vfs)
+static inline xfs_mount_t *XFS_VFSTOM(bhv_vfs_t *vfs)
 {
 	return XFS_BHVTOM(bhv_lookup(VFS_BHVHEAD(vfs), &xfs_vfsops));
 }
 
-#define XFS_DADDR_TO_AGNO(mp,d)         xfs_daddr_to_agno(mp,d)
 static inline xfs_agnumber_t
-xfs_daddr_to_agno(struct xfs_mount *mp, xfs_daddr_t d)
+XFS_DADDR_TO_AGNO(struct xfs_mount *mp, xfs_daddr_t d)
 {
 	xfs_daddr_t ld = XFS_BB_TO_FSBT(mp, d);
 	do_div(ld, mp->m_sb.sb_agblocks);
 	return (xfs_agnumber_t) ld;
 }
 
-#define XFS_DADDR_TO_AGBNO(mp,d)        xfs_daddr_to_agbno(mp,d)
 static inline xfs_agblock_t
-xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
+XFS_DADDR_TO_AGBNO(struct xfs_mount *mp, xfs_daddr_t d)
 {
 	xfs_daddr_t ld = XFS_BB_TO_FSBT(mp, d);
 	return (xfs_agblock_t) do_div(ld, mp->m_sb.sb_agblocks);
Index: xfs-linux-killwantfuncs/xfs_rw.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_rw.h
+++ xfs-linux-killwantfuncs/xfs_rw.h
@@ -54,17 +54,15 @@ struct xfs_mount;
  * file is a real time file or not, because the bmap code
  * does.
  */
-#define	XFS_FSB_TO_DB(ip,fsb)	xfs_fsb_to_db(ip,fsb)
 static inline xfs_daddr_t
-xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
+XFS_FSB_TO_DB(struct xfs_inode *ip, xfs_fsblock_t fsb)
 {
 	return (((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME) ? \
 		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
 		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
 }
-#define XFS_FSB_TO_DB_IO(io,fsb) xfs_fsb_to_db_io(io,fsb)
 static inline xfs_daddr_t
-xfs_fsb_to_db_io(struct xfs_iocore *io, xfs_fsblock_t fsb)
+XFS_FSB_TO_DB_IO(struct xfs_iocore *io, xfs_fsblock_t fsb)
 {
 	return (((io)->io_flags & XFS_IOCORE_RT) ? \
 		 XFS_FSB_TO_BB((io)->io_mount, (fsb)) : \
Index: xfs-linux-killwantfuncs/xfs_sb.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_sb.h
+++ xfs-linux-killwantfuncs/xfs_sb.h
@@ -212,9 +212,8 @@ typedef enum {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-#define	XFS_SB_GOOD_VERSION(sbp)	xfs_sb_good_version(sbp)
 #ifdef __KERNEL__
-static inline int xfs_sb_good_version(xfs_sb_t *sbp)
+static inline int XFS_SB_GOOD_VERSION(xfs_sb_t *sbp)
 {
 	return (((sbp->sb_versionnum >= XFS_SB_VERSION_1) && \
 		  (sbp->sb_versionnum <= XFS_SB_VERSION_3)) || \
@@ -225,7 +224,7 @@ static inline int xfs_sb_good_version(xf
 	  	    (sbp->sb_shared_vn <= XFS_SB_MAX_SHARED_VN)));
 }
 #else
-static inline int xfs_sb_good_version(xfs_sb_t *sbp)
+static inline int XFS_SB_GOOD_VERSION(xfs_sb_t *sbp)
 {
 	return (((sbp->sb_versionnum >= XFS_SB_VERSION_1) && \
 		  (sbp->sb_versionnum <= XFS_SB_VERSION_3)) || \
@@ -244,8 +243,7 @@ static inline int xfs_sb_good_version(xf
 	 ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 	  !((sbp)->sb_versionnum & ~XFS_SB_VERSION_OKSASHBITS)))
 
-#define	XFS_SB_VERSION_TONEW(v)	xfs_sb_version_tonew(v)
-static inline unsigned xfs_sb_version_tonew(unsigned v)
+static inline unsigned XFS_SB_VERSION_TONEW(unsigned v)
 {
 	return ((((v) == XFS_SB_VERSION_1) ? \
 		0 : \
@@ -255,8 +253,7 @@ static inline unsigned xfs_sb_version_to
 		XFS_SB_VERSION_4);
 }
 
-#define	XFS_SB_VERSION_TOOLD(v)	xfs_sb_version_toold(v)
-static inline unsigned xfs_sb_version_toold(unsigned v)
+static inline unsigned XFS_SB_VERSION_TOOLD(unsigned v)
 {
 	return (((v) & (XFS_SB_VERSION_QUOTABIT | XFS_SB_VERSION_ALIGNBIT)) ? \
 		0 : \
@@ -267,8 +264,7 @@ static inline unsigned xfs_sb_version_to
 				XFS_SB_VERSION_1)));
 }
 
-#define	XFS_SB_VERSION_HASATTR(sbp)	xfs_sb_version_hasattr(sbp)
-static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASATTR(xfs_sb_t *sbp)
 {
 	return ((sbp)->sb_versionnum == XFS_SB_VERSION_2) || \
 		 ((sbp)->sb_versionnum == XFS_SB_VERSION_3) || \
@@ -276,8 +272,7 @@ static inline int xfs_sb_version_hasattr
 		  ((sbp)->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
 }
 
-#define	XFS_SB_VERSION_ADDATTR(sbp)	xfs_sb_version_addattr(sbp)
-static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
+static inline void XFS_SB_VERSION_ADDATTR(xfs_sb_t *sbp)
 {
 	(sbp)->sb_versionnum = (((sbp)->sb_versionnum == XFS_SB_VERSION_1) ? \
 		XFS_SB_VERSION_2 : \
@@ -286,31 +281,27 @@ static inline void xfs_sb_version_addatt
 			(XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT)));
 }
 
-#define	XFS_SB_VERSION_HASNLINK(sbp)	xfs_sb_version_hasnlink(sbp)
-static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASNLINK(xfs_sb_t *sbp)
 {
 	return ((sbp)->sb_versionnum == XFS_SB_VERSION_3) || \
 		 ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		  ((sbp)->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
 }
 
-#define	XFS_SB_VERSION_ADDNLINK(sbp)	xfs_sb_version_addnlink(sbp)
-static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
+static inline void XFS_SB_VERSION_ADDNLINK(xfs_sb_t *sbp)
 {
 	(sbp)->sb_versionnum = ((sbp)->sb_versionnum <= XFS_SB_VERSION_2 ? \
 		XFS_SB_VERSION_3 : \
 		((sbp)->sb_versionnum | XFS_SB_VERSION_NLINKBIT));
 }
 
-#define	XFS_SB_VERSION_HASQUOTA(sbp)	xfs_sb_version_hasquota(sbp)
-static inline int xfs_sb_version_hasquota(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASQUOTA(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
 }
 
-#define	XFS_SB_VERSION_ADDQUOTA(sbp)	xfs_sb_version_addquota(sbp)
-static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
+static inline void XFS_SB_VERSION_ADDQUOTA(xfs_sb_t *sbp)
 {
 	(sbp)->sb_versionnum = \
 		 (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 ? \
@@ -319,99 +310,85 @@ static inline void xfs_sb_version_addquo
 			 XFS_SB_VERSION_QUOTABIT));
 }
 
-#define	XFS_SB_VERSION_HASALIGN(sbp)	xfs_sb_version_hasalign(sbp)
-static inline int xfs_sb_version_hasalign(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASALIGN(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
 }
 
-#define	XFS_SB_VERSION_SUBALIGN(sbp)	xfs_sb_version_subalign(sbp)
-static inline void xfs_sb_version_subalign(xfs_sb_t *sbp)
+static inline void XFS_SB_VERSION_SUBALIGN(xfs_sb_t *sbp)
 {
 	(sbp)->sb_versionnum = \
 	 XFS_SB_VERSION_TOOLD((sbp)->sb_versionnum & ~XFS_SB_VERSION_ALIGNBIT);
 }
 
-#define XFS_SB_VERSION_HASDALIGN(sbp)	xfs_sb_version_hasdalign(sbp)
-static inline int xfs_sb_version_hasdalign(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASDALIGN(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
 }
 
-#define XFS_SB_VERSION_ADDDALIGN(sbp)	xfs_sb_version_adddalign(sbp)
-static inline int xfs_sb_version_adddalign(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_ADDDALIGN(xfs_sb_t *sbp)
 {
 	return (sbp)->sb_versionnum = \
 		((sbp)->sb_versionnum | XFS_SB_VERSION_DALIGNBIT);
 }
 
-#define XFS_SB_VERSION_HASSHARED(sbp)	xfs_sb_version_hasshared(sbp)
-static inline int xfs_sb_version_hasshared(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASSHARED(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_SHAREDBIT);
 }
 
-#define XFS_SB_VERSION_ADDSHARED(sbp)	xfs_sb_version_addshared(sbp)
-static inline int xfs_sb_version_addshared(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_ADDSHARED(xfs_sb_t *sbp)
 {
 	return (sbp)->sb_versionnum = \
 		((sbp)->sb_versionnum | XFS_SB_VERSION_SHAREDBIT);
 }
 
-#define XFS_SB_VERSION_SUBSHARED(sbp)	xfs_sb_version_subshared(sbp)
-static inline int xfs_sb_version_subshared(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_SUBSHARED(xfs_sb_t *sbp)
 {
 	return (sbp)->sb_versionnum = \
 		((sbp)->sb_versionnum & ~XFS_SB_VERSION_SHAREDBIT);
 }
 
-#define XFS_SB_VERSION_HASDIRV2(sbp)	xfs_sb_version_hasdirv2(sbp)
-static inline int xfs_sb_version_hasdirv2(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASDIRV2(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 }
 
-#define XFS_SB_VERSION_HASLOGV2(sbp)   xfs_sb_version_haslogv2(sbp)
-static inline int xfs_sb_version_haslogv2(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASLOGV2(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
 }
 
-#define XFS_SB_VERSION_HASEXTFLGBIT(sbp)	xfs_sb_version_hasextflgbit(sbp)
-static inline int xfs_sb_version_hasextflgbit(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASEXTFLGBIT(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
 }
 
-#define XFS_SB_VERSION_ADDEXTFLGBIT(sbp)	xfs_sb_version_addextflgbit(sbp)
-static inline int xfs_sb_version_addextflgbit(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_ADDEXTFLGBIT(xfs_sb_t *sbp)
 {
 	return (sbp)->sb_versionnum = \
 		((sbp)->sb_versionnum | XFS_SB_VERSION_EXTFLGBIT);
 }
 
-#define XFS_SB_VERSION_SUBEXTFLGBIT(sbp)	xfs_sb_version_subextflgbit(sbp)
-static inline int xfs_sb_version_subextflgbit(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_SUBEXTFLGBIT(xfs_sb_t *sbp)
 {
 	return (sbp)->sb_versionnum = \
 		((sbp)->sb_versionnum & ~XFS_SB_VERSION_EXTFLGBIT);
 }
 
-#define XFS_SB_VERSION_HASSECTOR(sbp)   xfs_sb_version_hassector(sbp)
-static inline int xfs_sb_version_hassector(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASSECTOR(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 
-#define XFS_SB_VERSION_HASMOREBITS(sbp)	xfs_sb_version_hasmorebits(sbp)
-static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASMOREBITS(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
@@ -427,15 +404,13 @@ static inline int xfs_sb_version_hasmore
  *	 ((sbp)->sb_features2 & XFS_SB_VERSION2_FUNBIT)
  */
 
-#define XFS_SB_VERSION_HASATTR2(sbp)	xfs_sb_version_hasattr2(sbp)
-static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
+static inline int XFS_SB_VERSION_HASATTR2(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_HASMOREBITS(sbp)) &&	\
 		((sbp)->sb_features2 & XFS_SB_VERSION2_ATTR2BIT);
 }
 
-#define XFS_SB_VERSION_ADDATTR2(sbp)	xfs_sb_version_addattr2(sbp)
-static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
+static inline void XFS_SB_VERSION_ADDATTR2(xfs_sb_t *sbp)
 {
 	((sbp)->sb_versionnum =	\
 		((sbp)->sb_versionnum | XFS_SB_VERSION_MOREBITSBIT),	\
Index: xfs-linux-killwantfuncs/xfs_trans.h
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_trans.h
+++ xfs-linux-killwantfuncs/xfs_trans.h
@@ -220,63 +220,53 @@ typedef struct xfs_log_item_chunk {
  * lic_unused to the right value (0 matches all free).  The
  * lic_descs.lid_index values are set up as each desc is allocated.
  */
-#define	XFS_LIC_INIT(cp)	xfs_lic_init(cp)
-static inline void xfs_lic_init(xfs_log_item_chunk_t *cp)
+static inline void XFS_LIC_INIT(xfs_log_item_chunk_t *cp)
 {
 	cp->lic_free = XFS_LIC_FREEMASK;
 }
 
-#define	XFS_LIC_INIT_SLOT(cp,slot)	xfs_lic_init_slot(cp, slot)
-static inline void xfs_lic_init_slot(xfs_log_item_chunk_t *cp, int slot)
+static inline void XFS_LIC_INIT_SLOT(xfs_log_item_chunk_t *cp, int slot)
 {
 	cp->lic_descs[slot].lid_index = (unsigned char)(slot);
 }
 
-#define	XFS_LIC_VACANCY(cp)		xfs_lic_vacancy(cp)
-static inline int xfs_lic_vacancy(xfs_log_item_chunk_t *cp)
+static inline int XFS_LIC_VACANCY(xfs_log_item_chunk_t *cp)
 {
 	return cp->lic_free & XFS_LIC_FREEMASK;
 }
 
-#define	XFS_LIC_ALL_FREE(cp)		xfs_lic_all_free(cp)
-static inline void xfs_lic_all_free(xfs_log_item_chunk_t *cp)
+static inline void XFS_LIC_ALL_FREE(xfs_log_item_chunk_t *cp)
 {
 	cp->lic_free = XFS_LIC_FREEMASK;
 }
 
-#define	XFS_LIC_ARE_ALL_FREE(cp)	xfs_lic_are_all_free(cp)
-static inline int xfs_lic_are_all_free(xfs_log_item_chunk_t *cp)
+static inline int XFS_LIC_ARE_ALL_FREE(xfs_log_item_chunk_t *cp)
 {
 	return ((cp->lic_free & XFS_LIC_FREEMASK) == XFS_LIC_FREEMASK);
 }
 
-#define	XFS_LIC_ISFREE(cp,slot)	xfs_lic_isfree(cp,slot)
-static inline int xfs_lic_isfree(xfs_log_item_chunk_t *cp, int slot)
+static inline int XFS_LIC_ISFREE(xfs_log_item_chunk_t *cp, int slot)
 {
 	return (cp->lic_free & (1 << slot));
 }
 
-#define	XFS_LIC_CLAIM(cp,slot)		xfs_lic_claim(cp,slot)
-static inline void xfs_lic_claim(xfs_log_item_chunk_t *cp, int slot)
+static inline void XFS_LIC_CLAIM(xfs_log_item_chunk_t *cp, int slot)
 {
 	cp->lic_free &= ~(1 << slot);
 }
 
-#define	XFS_LIC_RELSE(cp,slot)		xfs_lic_relse(cp,slot)
-static inline void xfs_lic_relse(xfs_log_item_chunk_t *cp, int slot)
+static inline void XFS_LIC_RELSE(xfs_log_item_chunk_t *cp, int slot)
 {
 	cp->lic_free |= 1 << slot;
 }
 
-#define	XFS_LIC_SLOT(cp,slot)		xfs_lic_slot(cp,slot)
 static inline xfs_log_item_desc_t *
-xfs_lic_slot(xfs_log_item_chunk_t *cp, int slot)
+XFS_LIC_SLOT(xfs_log_item_chunk_t *cp, int slot)
 {
 	return &(cp->lic_descs[slot]);
 }
 
-#define	XFS_LIC_DESC_TO_SLOT(dp)	xfs_lic_desc_to_slot(dp)
-static inline int xfs_lic_desc_to_slot(xfs_log_item_desc_t *dp)
+static inline int XFS_LIC_DESC_TO_SLOT(xfs_log_item_desc_t *dp)
 {
 	return (uint)dp->lid_index;
 }
@@ -288,9 +278,8 @@ static inline int xfs_lic_desc_to_slot(x
  * All of this yields the address of the chunk, which is
  * cast to a chunk pointer.
  */
-#define	XFS_LIC_DESC_TO_CHUNK(dp)	xfs_lic_desc_to_chunk(dp)
 static inline xfs_log_item_chunk_t *
-xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
+XFS_LIC_DESC_TO_CHUNK(xfs_log_item_desc_t *dp)
 {
 	return (xfs_log_item_chunk_t*) \
 		(((xfs_caddr_t)((dp) - (dp)->lid_index)) - \

--------------040402000908070606030002--
