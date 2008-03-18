Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 17:39:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2I0cwxp006945
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 17:39:01 -0700
Received: from mta4.srv.hcvlny.cv.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72464FBE060
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 17:39:29 -0700 (PDT)
Received: from mta4.srv.hcvlny.cv.net (mta4.srv.hcvlny.cv.net [167.206.4.199]) by cuda.sgi.com with ESMTP id EExhNqNN5odEZr7r for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 17:39:29 -0700 (PDT)
Received: from freyr.home (ool-44c218a8.dyn.optonline.net [68.194.24.168])
 by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JXW00684HTG1HT0@mta4.srv.hcvlny.cv.net> for xfs@oss.sgi.com;
 Mon, 17 Mar 2008 20:39:24 -0400 (EDT)
Date: Mon, 17 Mar 2008 20:39:05 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: [RFC][PATCH 1/1] XFS: annotate all on-disk structures with __ondisk
In-reply-to: <20080317202853.GC16500@josefsipek.net>
Message-id: <1205800745-9217-1-git-send-email-jeffpc@josefsipek.net>
Content-transfer-encoding: 7BIT
References: <20080317202853.GC16500@josefsipek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sandeen@sandeen.net, xfs@oss.sgi.com, tes@sgi.com, dgc@sgi.com
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

Currently, the annotation just forces the structures to be packed, and
4-byte aligned.

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

---
This is just an RFC, and the alignment needs to be verified against the
offsets within the pages read from disk, and more xfsqa runs on various
architectures are needed. (I don't want to be responsible for something like
the bitops regression on ppc!)

The .text segment shrinks on x86 and s390x, but grows in ia64 (3776 bytes ==
0.3%).

   text    data     bss     dec     hex filename
 542054    3171    3084  548309   85dd5 xfs-x86-original.ko
 542026    3171    3084  548281   85db9 xfs-x86-packed-aligned4.ko
1244057   70858    2480 1317395  141a13 xfs-ia64-original.ko
1247833   70858    2480 1321171  1428d3 xfs-ia64-packed-aligned4.ko
 679901   19374    3112  702387   ab7b3 xfs-s390x-original.ko
 679781   19374    3112  702267   ab73b xfs-s390x-packed-aligned4.ko

The approximate number of instructions effectively stays the same on x86
(goes up by 2), s390x gets smaller (by 12 instructions), but ia64 bloats by
708 instructions (0.34%).

$ for x in *.ko; do objdump -d $x > `basename $x .ko`.dis ; done
$ wc -l *.dis
  141494 xfs-x86-original.dis
  141496 xfs-x86-packed-aligned4.dis
  208514 xfs-ia64-original.dis
  209222 xfs-ia64-packed-aligned4.dis
  121544 xfs-s390x-original.dis
  121532 xfs-s390x-packed-aligned4.dis

I could try to compile things on a sparc64, mips, and x86_64, but that's for
another day - and depending on where this thread will lead.

The patch keeps xfsqa happy on x86 - well, it dies in the 100-range, but I
haven't had the time to check if that happens without this patch. Someone
(not it!) should nurse xfsqa back to health :)

Jeff.

---
 fs/xfs/linux-2.6/xfs_linux.h |    1 +
 fs/xfs/xfs_ag.h              |    6 +++---
 fs/xfs/xfs_alloc_btree.h     |    2 +-
 fs/xfs/xfs_attr_leaf.h       |   14 +++++++-------
 fs/xfs/xfs_attr_sf.h         |    9 +++++----
 fs/xfs/xfs_bmap_btree.h      |    8 ++++----
 fs/xfs/xfs_btree.h           |   12 ++++++------
 fs/xfs/xfs_da_btree.h        |    8 ++++----
 fs/xfs/xfs_dinode.h          |    6 +++---
 fs/xfs/xfs_dir2_block.h      |    4 ++--
 fs/xfs/xfs_dir2_data.h       |   10 +++++-----
 fs/xfs/xfs_dir2_leaf.h       |    9 +++++----
 fs/xfs/xfs_dir2_node.h       |    5 +++--
 fs/xfs/xfs_dir2_sf.h         |   14 +++++++-------
 fs/xfs/xfs_ialloc_btree.h    |    4 ++--
 fs/xfs/xfs_log_priv.h        |    6 +++---
 fs/xfs/xfs_quota.h           |    4 ++--
 fs/xfs/xfs_sb.h              |    2 +-
 fs/xfs/xfs_trans.h           |    2 +-
 19 files changed, 65 insertions(+), 61 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 284460f..f06199c 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -186,6 +186,7 @@
 #define xfs_itruncate_data(ip, off)	\
 	(-vmtruncate(vn_to_inode(XFS_ITOV(ip)), (off)))
 
+#define __ondisk	__attribute__((packed,aligned(4)))
 
 /* Move the kernel do_div definition off to one side */
 
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 61b292a..20f3291 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -69,7 +69,7 @@ typedef struct xfs_agf {
 	__be32		agf_freeblks;	/* total free blocks */
 	__be32		agf_longest;	/* longest free space */
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
-} xfs_agf_t;
+} __ondisk xfs_agf_t;
 
 #define	XFS_AGF_MAGICNUM	0x00000001
 #define	XFS_AGF_VERSIONNUM	0x00000002
@@ -121,7 +121,7 @@ typedef struct xfs_agi {
 	 * still being referenced.
 	 */
 	__be32		agi_unlinked[XFS_AGI_UNLINKED_BUCKETS];
-} xfs_agi_t;
+} __ondisk xfs_agi_t;
 
 #define	XFS_AGI_MAGICNUM	0x00000001
 #define	XFS_AGI_VERSIONNUM	0x00000002
@@ -153,7 +153,7 @@ typedef struct xfs_agi {
 
 typedef struct xfs_agfl {
 	__be32		agfl_bno[1];	/* actually XFS_AGFL_SIZE(mp) */
-} xfs_agfl_t;
+} __ondisk xfs_agfl_t;
 
 /*
  * Busy block/extent entry.  Used in perag to mark blocks that have been freed
diff --git a/fs/xfs/xfs_alloc_btree.h b/fs/xfs/xfs_alloc_btree.h
index 5bd1a2c..f7c5bba 100644
--- a/fs/xfs/xfs_alloc_btree.h
+++ b/fs/xfs/xfs_alloc_btree.h
@@ -41,7 +41,7 @@ struct xfs_mount;
 typedef struct xfs_alloc_rec {
 	__be32		ar_startblock;	/* starting block number */
 	__be32		ar_blockcount;	/* count of free blocks */
-} xfs_alloc_rec_t, xfs_alloc_key_t;
+} __ondisk xfs_alloc_rec_t, xfs_alloc_key_t;
 
 typedef struct xfs_alloc_rec_incore {
 	xfs_agblock_t	ar_startblock;	/* starting block number */
diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
index 040f732..792d2a9 100644
--- a/fs/xfs/xfs_attr_leaf.h
+++ b/fs/xfs/xfs_attr_leaf.h
@@ -75,7 +75,7 @@ struct xfs_trans;
 typedef struct xfs_attr_leaf_map {	/* RLE map of free bytes */
 	__be16	base;			  /* base of free region */
 	__be16	size;			  /* length of free region */
-} xfs_attr_leaf_map_t;
+} __ondisk xfs_attr_leaf_map_t;
 
 typedef struct xfs_attr_leaf_hdr {	/* constant-structure header block */
 	xfs_da_blkinfo_t info;		/* block type, links, etc. */
@@ -86,34 +86,34 @@ typedef struct xfs_attr_leaf_hdr {	/* constant-structure header block */
 	__u8	pad1;
 	xfs_attr_leaf_map_t freemap[XFS_ATTR_LEAF_MAPSIZE];
 					/* N largest free regions */
-} xfs_attr_leaf_hdr_t;
+} __ondisk xfs_attr_leaf_hdr_t;
 
 typedef struct xfs_attr_leaf_entry {	/* sorted on key, not name */
 	__be32	hashval;		/* hash value of name */
  	__be16	nameidx;		/* index into buffer of name/value */
 	__u8	flags;			/* LOCAL/ROOT/SECURE/INCOMPLETE flag */
 	__u8	pad2;			/* unused pad byte */
-} xfs_attr_leaf_entry_t;
+} __ondisk xfs_attr_leaf_entry_t;
 
 typedef struct xfs_attr_leaf_name_local {
 	__be16	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
 	__u8	nameval[1];		/* name/value bytes */
-} xfs_attr_leaf_name_local_t;
+} __ondisk xfs_attr_leaf_name_local_t;
 
 typedef struct xfs_attr_leaf_name_remote {
 	__be32	valueblk;		/* block number of value bytes */
 	__be32	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
-	__u8	name[1];		/* name bytes */
-} xfs_attr_leaf_name_remote_t;
+	__u8	name[3];		/* name bytes */
+} __ondisk xfs_attr_leaf_name_remote_t;
 
 typedef struct xfs_attr_leafblock {
 	xfs_attr_leaf_hdr_t	hdr;	/* constant-structure header block */
 	xfs_attr_leaf_entry_t	entries[1];	/* sorted on key, not name */
 	xfs_attr_leaf_name_local_t namelist;	/* grows from bottom of buf */
 	xfs_attr_leaf_name_remote_t valuelist;	/* grows from bottom of buf */
-} xfs_attr_leafblock_t;
+} __ondisk xfs_attr_leafblock_t;
 
 /*
  * Flags used in the leaf_entry[i].flags field.
diff --git a/fs/xfs/xfs_attr_sf.h b/fs/xfs/xfs_attr_sf.h
index f67f917..a13afb7 100644
--- a/fs/xfs/xfs_attr_sf.h
+++ b/fs/xfs/xfs_attr_sf.h
@@ -33,15 +33,16 @@ struct xfs_inode;
 typedef struct xfs_attr_shortform {
 	struct xfs_attr_sf_hdr {	/* constant-structure header block */
 		__be16	totsize;	/* total bytes in shortform list */
-		__u8	count;	/* count of active entries */
-	} hdr;
+		__u8	count;		/* count of active entries */
+		__u8	pad;
+	} __ondisk hdr;
 	struct xfs_attr_sf_entry {
 		__uint8_t namelen;	/* actual length of name (no NULL) */
 		__uint8_t valuelen;	/* actual length of value (no NULL) */
 		__uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
 		__uint8_t nameval[1];	/* name & value bytes concatenated */
-	} list[1];			/* variable sized array */
-} xfs_attr_shortform_t;
+	} __ondisk list[1];			/* variable sized array */
+} __ondisk xfs_attr_shortform_t;
 typedef struct xfs_attr_sf_hdr xfs_attr_sf_hdr_t;
 typedef struct xfs_attr_sf_entry xfs_attr_sf_entry_t;
 
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index cd0d4b4..3c749c8 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -31,7 +31,7 @@ struct xfs_inode;
 typedef struct xfs_bmdr_block {
 	__be16		bb_level;	/* 0 is a leaf */
 	__be16		bb_numrecs;	/* current # of data records */
-} xfs_bmdr_block_t;
+} __ondisk xfs_bmdr_block_t;
 
 /*
  * Bmap btree record and extent descriptor.
@@ -51,11 +51,11 @@ typedef struct xfs_bmdr_block {
 typedef struct xfs_bmbt_rec_32
 {
 	__uint32_t		l0, l1, l2, l3;
-} xfs_bmbt_rec_32_t;
+} __ondisk xfs_bmbt_rec_32_t;
 typedef struct xfs_bmbt_rec_64
 {
 	__be64			l0, l1;
-} xfs_bmbt_rec_64_t;
+} __ondisk xfs_bmbt_rec_64_t;
 
 typedef __uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
 typedef xfs_bmbt_rec_64_t xfs_bmbt_rec_t, xfs_bmdr_rec_t;
@@ -140,7 +140,7 @@ typedef struct xfs_bmbt_irec
  */
 typedef struct xfs_bmbt_key {
 	__be64		br_startoff;	/* starting file offset */
-} xfs_bmbt_key_t, xfs_bmdr_key_t;
+} __ondisk xfs_bmbt_key_t, xfs_bmdr_key_t;
 
 /* btree pointer type */
 typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 7440b78..40ac5b8 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -47,7 +47,7 @@ typedef struct xfs_btree_sblock {
 	__be16		bb_numrecs;	/* current # of data records */
 	__be32		bb_leftsib;	/* left sibling block or NULLAGBLOCK */
 	__be32		bb_rightsib;	/* right sibling block or NULLAGBLOCK */
-} xfs_btree_sblock_t;
+} __ondisk xfs_btree_sblock_t;
 
 /*
  * Long form header: bmap btrees.
@@ -58,7 +58,7 @@ typedef struct xfs_btree_lblock {
 	__be16		bb_numrecs;	/* current # of data records */
 	__be64		bb_leftsib;	/* left sibling block or NULLDFSBNO */
 	__be64		bb_rightsib;	/* right sibling block or NULLDFSBNO */
-} xfs_btree_lblock_t;
+} __ondisk xfs_btree_lblock_t;
 
 /*
  * Combined header and structure, used by common code.
@@ -68,7 +68,7 @@ typedef struct xfs_btree_hdr
 	__be32		bb_magic;	/* magic number for block type */
 	__be16		bb_level;	/* 0 is a leaf */
 	__be16		bb_numrecs;	/* current # of data records */
-} xfs_btree_hdr_t;
+} __ondisk xfs_btree_hdr_t;
 
 typedef struct xfs_btree_block {
 	xfs_btree_hdr_t	bb_h;		/* header */
@@ -76,13 +76,13 @@ typedef struct xfs_btree_block {
 		struct {
 			__be32		bb_leftsib;
 			__be32		bb_rightsib;
-		} s;			/* short form pointers */
+		} __ondisk s;		/* short form pointers */
 		struct	{
 			__be64		bb_leftsib;
 			__be64		bb_rightsib;
-		} l;			/* long form pointers */
+		} __ondisk l;		/* long form pointers */
 	} bb_u;				/* rest */
-} xfs_btree_block_t;
+} __ondisk xfs_btree_block_t;
 
 /*
  * For logging record fields.
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 7facf86..36901d7 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -45,7 +45,7 @@ typedef struct xfs_da_blkinfo {
 	__be32		back;			/* following block in list */
 	__be16		magic;			/* validity check on block */
 	__be16		pad;			/* unused */
-} xfs_da_blkinfo_t;
+} __ondisk xfs_da_blkinfo_t;
 
 /*
  * This is the structure of the root and intermediate nodes in the Btree.
@@ -63,12 +63,12 @@ typedef struct xfs_da_intnode {
 		xfs_da_blkinfo_t info;	/* block type, links, etc. */
 		__be16	count;		/* count of active entries */
 		__be16	level;		/* level above leaves (leaf == 0) */
-	} hdr;
+	} __ondisk hdr;
 	struct xfs_da_node_entry {
 		__be32	hashval;	/* hash value for this descendant */
 		__be32	before;		/* Btree block before this key */
-	} btree[1];			/* variable sized array of keys */
-} xfs_da_intnode_t;
+	} __ondisk btree[1];		/* variable sized array of keys */
+} __ondisk xfs_da_intnode_t;
 typedef struct xfs_da_node_hdr xfs_da_node_hdr_t;
 typedef struct xfs_da_node_entry xfs_da_node_entry_t;
 
diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
index c9065ea..9a24755 100644
--- a/fs/xfs/xfs_dinode.h
+++ b/fs/xfs/xfs_dinode.h
@@ -36,7 +36,7 @@ struct xfs_mount;
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
-} xfs_timestamp_t;
+} __ondisk xfs_timestamp_t;
 
 /*
  * Note: Coordinate changes to this structure with the XFS_DI_* #defines
@@ -69,7 +69,7 @@ typedef struct xfs_dinode_core {
 	__be16		di_dmstate;	/* DMIG state info */
 	__be16		di_flags;	/* random flags, XFS_DIFLAG_... */
 	__be32		di_gen;		/* generation number */
-} xfs_dinode_core_t;
+} __ondisk xfs_dinode_core_t;
 
 #define DI_MAX_FLUSH 0xffff
 
@@ -96,7 +96,7 @@ typedef struct xfs_dinode
 		xfs_bmbt_rec_32_t di_abmx[1];	/* extent list */
 		xfs_attr_shortform_t di_attrsf;	/* shortform attribute list */
 	}		di_a;
-} xfs_dinode_t;
+} __ondisk xfs_dinode_t;
 
 /*
  * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
diff --git a/fs/xfs/xfs_dir2_block.h b/fs/xfs/xfs_dir2_block.h
index 10e6896..a85f98d 100644
--- a/fs/xfs/xfs_dir2_block.h
+++ b/fs/xfs/xfs_dir2_block.h
@@ -45,7 +45,7 @@ struct xfs_trans;
 typedef struct xfs_dir2_block_tail {
 	__be32		count;			/* count of leaf entries */
 	__be32		stale;			/* count of stale lf entries */
-} xfs_dir2_block_tail_t;
+} __ondisk xfs_dir2_block_tail_t;
 
 /*
  * Generic single-block structure, for xfs_db.
@@ -55,7 +55,7 @@ typedef struct xfs_dir2_block {
 	xfs_dir2_data_union_t	u[1];
 	xfs_dir2_leaf_entry_t	leaf[1];
 	xfs_dir2_block_tail_t	tail;
-} xfs_dir2_block_t;
+} __ondisk xfs_dir2_block_t;
 
 /*
  * Pointer to the leaf header embedded in a data block (1-block format)
diff --git a/fs/xfs/xfs_dir2_data.h b/fs/xfs/xfs_dir2_data.h
index b816e02..e7ae1db 100644
--- a/fs/xfs/xfs_dir2_data.h
+++ b/fs/xfs/xfs_dir2_data.h
@@ -67,7 +67,7 @@ struct xfs_trans;
 typedef struct xfs_dir2_data_free {
 	__be16			offset;		/* start of freespace */
 	__be16			length;		/* length of freespace */
-} xfs_dir2_data_free_t;
+} __ondisk xfs_dir2_data_free_t;
 
 /*
  * Header for the data blocks.
@@ -78,7 +78,7 @@ typedef struct xfs_dir2_data_hdr {
 	__be32			magic;		/* XFS_DIR2_DATA_MAGIC */
 						/* or XFS_DIR2_BLOCK_MAGIC */
 	xfs_dir2_data_free_t	bestfree[XFS_DIR2_DATA_FD_COUNT];
-} xfs_dir2_data_hdr_t;
+} __ondisk xfs_dir2_data_hdr_t;
 
 /*
  * Active entry in a data block.  Aligned to 8 bytes.
@@ -90,7 +90,7 @@ typedef struct xfs_dir2_data_entry {
 	__u8			name[1];	/* name bytes, no null */
 						/* variable offset */
 	__be16			tag;		/* starting offset of us */
-} xfs_dir2_data_entry_t;
+} __ondisk xfs_dir2_data_entry_t;
 
 /*
  * Unused entry in a data block.  Aligned to 8 bytes.
@@ -101,7 +101,7 @@ typedef struct xfs_dir2_data_unused {
 	__be16			length;		/* total free length */
 						/* variable offset */
 	__be16			tag;		/* starting offset of us */
-} xfs_dir2_data_unused_t;
+} __ondisk xfs_dir2_data_unused_t;
 
 typedef union {
 	xfs_dir2_data_entry_t	entry;
@@ -114,7 +114,7 @@ typedef union {
 typedef struct xfs_dir2_data {
 	xfs_dir2_data_hdr_t	hdr;		/* magic XFS_DIR2_DATA_MAGIC */
 	xfs_dir2_data_union_t	u[1];
-} xfs_dir2_data_t;
+} __ondisk xfs_dir2_data_t;
 
 /*
  * Macros.
diff --git a/fs/xfs/xfs_dir2_leaf.h b/fs/xfs/xfs_dir2_leaf.h
index 6c9539f..01a6091 100644
--- a/fs/xfs/xfs_dir2_leaf.h
+++ b/fs/xfs/xfs_dir2_leaf.h
@@ -48,7 +48,7 @@ typedef struct xfs_dir2_leaf_hdr {
 	xfs_da_blkinfo_t	info;		/* header for da routines */
 	__be16			count;		/* count of entries */
 	__be16			stale;		/* count of stale entries */
-} xfs_dir2_leaf_hdr_t;
+} __ondisk xfs_dir2_leaf_hdr_t;
 
 /*
  * Leaf block entry.
@@ -56,14 +56,14 @@ typedef struct xfs_dir2_leaf_hdr {
 typedef struct xfs_dir2_leaf_entry {
 	__be32			hashval;	/* hash value of name */
 	__be32			address;	/* address of data entry */
-} xfs_dir2_leaf_entry_t;
+} __ondisk xfs_dir2_leaf_entry_t;
 
 /*
  * Leaf block tail.
  */
 typedef struct xfs_dir2_leaf_tail {
 	__be32			bestcount;
-} xfs_dir2_leaf_tail_t;
+} __ondisk xfs_dir2_leaf_tail_t;
 
 /*
  * Leaf block.
@@ -75,8 +75,9 @@ typedef struct xfs_dir2_leaf {
 	xfs_dir2_leaf_entry_t	ents[1];	/* entries */
 						/* ... */
 	xfs_dir2_data_off_t	bests[1];	/* best free counts */
+	__u8			pad[2];
 	xfs_dir2_leaf_tail_t	tail;		/* leaf tail */
-} xfs_dir2_leaf_t;
+} __ondisk xfs_dir2_leaf_t;
 
 /*
  * DB blocks here are logical directory block numbers, not filesystem blocks.
diff --git a/fs/xfs/xfs_dir2_node.h b/fs/xfs/xfs_dir2_node.h
index dde72db..78ab236 100644
--- a/fs/xfs/xfs_dir2_node.h
+++ b/fs/xfs/xfs_dir2_node.h
@@ -45,13 +45,14 @@ typedef	struct xfs_dir2_free_hdr {
 	__be32			firstdb;	/* db of first entry */
 	__be32			nvalid;		/* count of valid entries */
 	__be32			nused;		/* count of used entries */
-} xfs_dir2_free_hdr_t;
+} __ondisk xfs_dir2_free_hdr_t;
 
 typedef struct xfs_dir2_free {
 	xfs_dir2_free_hdr_t	hdr;		/* block header */
 	__be16			bests[1];	/* best free counts */
 						/* unused entries are -1 */
-} xfs_dir2_free_t;
+	__u8			pad[2];
+} __ondisk xfs_dir2_free_t;
 
 #define	XFS_DIR2_MAX_FREE_BESTS(mp)	\
 	(((mp)->m_dirblksize - (uint)sizeof(xfs_dir2_free_hdr_t)) / \
diff --git a/fs/xfs/xfs_dir2_sf.h b/fs/xfs/xfs_dir2_sf.h
index 005629d..5229bf2 100644
--- a/fs/xfs/xfs_dir2_sf.h
+++ b/fs/xfs/xfs_dir2_sf.h
@@ -43,26 +43,26 @@ struct xfs_trans;
 /*
  * Inode number stored as 8 8-bit values.
  */
-typedef	struct { __uint8_t i[8]; } xfs_dir2_ino8_t;
+typedef	struct { __uint8_t i[8]; } __ondisk xfs_dir2_ino8_t;
 
 /*
  * Inode number stored as 4 8-bit values.
  * Works a lot of the time, when all the inode numbers in a directory
  * fit in 32 bits.
  */
-typedef struct { __uint8_t i[4]; } xfs_dir2_ino4_t;
+typedef struct { __uint8_t i[4]; } __ondisk xfs_dir2_ino4_t;
 
 typedef union {
 	xfs_dir2_ino8_t	i8;
 	xfs_dir2_ino4_t	i4;
-} xfs_dir2_inou_t;
+} __ondisk xfs_dir2_inou_t;
 #define	XFS_DIR2_MAX_SHORT_INUM	((xfs_ino_t)0xffffffffULL)
 
 /*
  * Normalized offset (in a data block) of the entry, really xfs_dir2_data_off_t.
  * Only need 16 bits, this is the byte offset into the single block form.
  */
-typedef struct { __uint8_t i[2]; } xfs_dir2_sf_off_t;
+typedef struct { __uint8_t i[2]; } __ondisk xfs_dir2_sf_off_t;
 
 /*
  * The parent directory has a dedicated field, and the self-pointer must
@@ -76,19 +76,19 @@ typedef struct xfs_dir2_sf_hdr {
 	__uint8_t		count;		/* count of entries */
 	__uint8_t		i8count;	/* count of 8-byte inode #s */
 	xfs_dir2_inou_t		parent;		/* parent dir inode number */
-} xfs_dir2_sf_hdr_t;
+} __ondisk xfs_dir2_sf_hdr_t;
 
 typedef struct xfs_dir2_sf_entry {
 	__uint8_t		namelen;	/* actual name length */
 	xfs_dir2_sf_off_t	offset;		/* saved offset */
 	__uint8_t		name[1];	/* name, variable size */
 	xfs_dir2_inou_t		inumber;	/* inode number, var. offset */
-} xfs_dir2_sf_entry_t;
+} __ondisk xfs_dir2_sf_entry_t;
 
 typedef struct xfs_dir2_sf {
 	xfs_dir2_sf_hdr_t	hdr;		/* shortform header */
 	xfs_dir2_sf_entry_t	list[1];	/* shortform entries */
-} xfs_dir2_sf_t;
+} __ondisk xfs_dir2_sf_t;
 
 static inline int xfs_dir2_sf_hdr_size(int i8count)
 {
diff --git a/fs/xfs/xfs_ialloc_btree.h b/fs/xfs/xfs_ialloc_btree.h
index 8efc4a5..036cdd0 100644
--- a/fs/xfs/xfs_ialloc_btree.h
+++ b/fs/xfs/xfs_ialloc_btree.h
@@ -51,7 +51,7 @@ typedef struct xfs_inobt_rec {
 	__be32		ir_startino;	/* starting inode number */
 	__be32		ir_freecount;	/* count of free inodes (set bits) */
 	__be64		ir_free;	/* free inode mask */
-} xfs_inobt_rec_t;
+} __ondisk xfs_inobt_rec_t;
 
 typedef struct xfs_inobt_rec_incore {
 	xfs_agino_t	ir_startino;	/* starting inode number */
@@ -65,7 +65,7 @@ typedef struct xfs_inobt_rec_incore {
  */
 typedef struct xfs_inobt_key {
 	__be32		ir_startino;	/* starting inode number */
-} xfs_inobt_key_t;
+} __ondisk xfs_inobt_key_t;
 
 /* btree pointer type */
 typedef __be32 xfs_inobt_ptr_t;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 01c63db..81c5a2d 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -270,7 +270,7 @@ typedef struct xlog_op_header {
 	__u8	   oh_clientid;	/* who sent me this		:  1 b */
 	__u8	   oh_flags;	/*				:  1 b */
 	__u16	   oh_res2;	/* 32 bit align			:  2 b */
-} xlog_op_header_t;
+} __ondisk xlog_op_header_t;
 
 
 /* valid values for h_fmt */
@@ -301,12 +301,12 @@ typedef struct xlog_rec_header {
 	__be32    h_fmt;        /* format of log record                 :  4 */
 	uuid_t	  h_fs_uuid;    /* uuid of FS                           : 16 */
 	__be32	  h_size;	/* iclog size				:  4 */
-} xlog_rec_header_t;
+} __ondisk xlog_rec_header_t;
 
 typedef struct xlog_rec_ext_header {
 	__be32	  xh_cycle;	/* write cycle of log			: 4 */
 	__be32	  xh_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE]; /*	: 256 */
-} xlog_rec_ext_header_t;
+} __ondisk xlog_rec_ext_header_t;
 
 #ifdef __KERNEL__
 /*
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 12c4ec7..f5b9c30 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -67,7 +67,7 @@ typedef struct	xfs_disk_dquot {
 	__be32		d_rtbtimer;	/* similar to above; for RT disk blocks */
 	__be16		d_rtbwarns;	/* warnings issued wrt RT disk blocks */
 	__be16		d_pad;
-} xfs_disk_dquot_t;
+} __ondisk xfs_disk_dquot_t;
 
 /*
  * This is what goes on disk. This is separated from the xfs_disk_dquot because
@@ -76,7 +76,7 @@ typedef struct	xfs_disk_dquot {
 typedef struct xfs_dqblk {
 	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
 	char		  dd_fill[32];	/* filling for posterity */
-} xfs_dqblk_t;
+} __ondisk xfs_dqblk_t;
 
 /*
  * flags for q_flags field in the dquot.
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index b1a83f8..beee35e 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -226,7 +226,7 @@ typedef struct xfs_dsb {
 	__be32	sb_bad_features2;
 
 	/* must be padded to 64 bit alignment */
-} xfs_dsb_t;
+} __ondisk xfs_dsb_t;
 
 /*
  * Sequence number values for the fields.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 0804207..2fbe465 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -32,7 +32,7 @@ typedef struct xfs_trans_header {
 	uint		th_type;		/* transaction type */
 	__int32_t	th_tid;			/* transaction id (unused) */
 	uint		th_num_items;		/* num items logged by trans */
-} xfs_trans_header_t;
+} __ondisk xfs_trans_header_t;
 
 #define	XFS_TRANS_HEADER_MAGIC	0x5452414e	/* TRAN */
 
-- 
1.5.4.rc2.85.g9de45-dirty
