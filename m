Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A88C7F63
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 13:14:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3776FAC003
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 11:14:43 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id vYOVZsA8C5EmH1VY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 11:14:39 -0800 (PST)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xti2v-0002p8-HC
	for xfs@oss.sgi.com; Wed, 26 Nov 2014 19:14:38 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] xfs: merge xfs_ag.h into xfs_format.h
Date: Wed, 26 Nov 2014 20:14:25 +0100
Message-Id: <1417029267-20149-3-git-send-email-hch@lst.de>
In-Reply-To: <1417029267-20149-1-git-send-email-hch@lst.de>
References: <1417029267-20149-1-git-send-email-hch@lst.de>
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

More on-disk format consolidation.  A few declarations that weren't on-disk
format related move into better suitable spots.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.h             | 281 -------------------------------------
 fs/xfs/libxfs/xfs_alloc.c          |   1 -
 fs/xfs/libxfs/xfs_alloc.h          |   3 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |   1 -
 fs/xfs/libxfs/xfs_attr.c           |   1 -
 fs/xfs/libxfs/xfs_attr_leaf.c      |   1 -
 fs/xfs/libxfs/xfs_attr_remote.c    |   1 -
 fs/xfs/libxfs/xfs_bmap.c           |   1 -
 fs/xfs/libxfs/xfs_bmap_btree.c     |   1 -
 fs/xfs/libxfs/xfs_btree.c          |   1 -
 fs/xfs/libxfs/xfs_da_btree.c       |   1 -
 fs/xfs/libxfs/xfs_da_format.c      |   1 -
 fs/xfs/libxfs/xfs_dir2.c           |   1 -
 fs/xfs/libxfs/xfs_dir2_block.c     |   1 -
 fs/xfs/libxfs/xfs_dir2_data.c      |   1 -
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   1 -
 fs/xfs/libxfs/xfs_dir2_node.c      |   1 -
 fs/xfs/libxfs/xfs_dir2_sf.c        |   1 -
 fs/xfs/libxfs/xfs_dquot_buf.c      |   1 -
 fs/xfs/libxfs/xfs_format.h         | 243 ++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c         |   1 -
 fs/xfs/libxfs/xfs_ialloc.h         |   4 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   1 -
 fs/xfs/libxfs/xfs_inode_buf.c      |   1 -
 fs/xfs/libxfs/xfs_inode_fork.c     |   1 -
 fs/xfs/libxfs/xfs_log_rlimit.c     |   1 -
 fs/xfs/libxfs/xfs_rtbitmap.c       |   1 -
 fs/xfs/libxfs/xfs_sb.c             |   1 -
 fs/xfs/libxfs/xfs_symlink_remote.c |   1 -
 fs/xfs/libxfs/xfs_trans_resv.c     |   1 -
 fs/xfs/xfs_acl.c                   |   1 -
 fs/xfs/xfs_aops.c                  |   1 -
 fs/xfs/xfs_attr_inactive.c         |   1 -
 fs/xfs/xfs_attr_list.c             |   1 -
 fs/xfs/xfs_bmap_util.c             |   1 -
 fs/xfs/xfs_buf.c                   |   2 +-
 fs/xfs/xfs_buf_item.c              |   2 +-
 fs/xfs/xfs_dir2_readdir.c          |   1 -
 fs/xfs/xfs_discard.c               |   1 -
 fs/xfs/xfs_dquot.c                 |   1 -
 fs/xfs/xfs_dquot_item.c            |   1 -
 fs/xfs/xfs_error.c                 |   1 -
 fs/xfs/xfs_export.c                |   1 -
 fs/xfs/xfs_extent_busy.c           |   1 -
 fs/xfs/xfs_extfree_item.c          |   2 +-
 fs/xfs/xfs_file.c                  |   1 -
 fs/xfs/xfs_filestream.c            |   1 -
 fs/xfs/xfs_fsops.c                 |   1 -
 fs/xfs/xfs_icache.c                |   1 -
 fs/xfs/xfs_icache.h                |   8 ++
 fs/xfs/xfs_icreate_item.c          |   2 +-
 fs/xfs/xfs_inode.c                 |   1 -
 fs/xfs/xfs_inode_item.c            |   1 -
 fs/xfs/xfs_ioctl.c                 |   1 -
 fs/xfs/xfs_ioctl32.c               |   1 -
 fs/xfs/xfs_iomap.c                 |   1 -
 fs/xfs/xfs_iops.c                  |   1 -
 fs/xfs/xfs_itable.c                |   1 -
 fs/xfs/xfs_log.c                   |   1 -
 fs/xfs/xfs_log_cil.c               |   2 +-
 fs/xfs/xfs_log_recover.c           |   1 -
 fs/xfs/xfs_message.c               |   2 +-
 fs/xfs/xfs_mount.c                 |   1 -
 fs/xfs/xfs_mount.h                 |   5 +-
 fs/xfs/xfs_qm.c                    |   1 -
 fs/xfs/xfs_qm_bhv.c                |   1 -
 fs/xfs/xfs_qm_syscalls.c           |   1 -
 fs/xfs/xfs_quotaops.c              |   1 -
 fs/xfs/xfs_rtalloc.c               |   1 -
 fs/xfs/xfs_super.c                 |   1 -
 fs/xfs/xfs_symlink.c               |   1 -
 fs/xfs/xfs_trace.c                 |   1 -
 fs/xfs/xfs_trans.c                 |   1 -
 fs/xfs/xfs_trans_ail.c             |   2 +-
 fs/xfs/xfs_trans_buf.c             |   1 -
 fs/xfs/xfs_trans_dquot.c           |   1 -
 fs/xfs/xfs_trans_extfree.c         |   2 +-
 fs/xfs/xfs_trans_inode.c           |   1 -
 fs/xfs/xfs_xattr.c                 |   1 -
 79 files changed, 267 insertions(+), 358 deletions(-)
 delete mode 100644 fs/xfs/libxfs/xfs_ag.h

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
deleted file mode 100644
index 6e247a9..0000000
--- a/fs/xfs/libxfs/xfs_ag.h
+++ /dev/null
@@ -1,281 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_AG_H__
-#define	__XFS_AG_H__
-
-/*
- * Allocation group header
- * This is divided into three structures, placed in sequential 512-byte
- * buffers after a copy of the superblock (also in a 512-byte buffer).
- */
-
-struct xfs_buf;
-struct xfs_mount;
-struct xfs_trans;
-
-#define	XFS_AGF_MAGIC	0x58414746	/* 'XAGF' */
-#define	XFS_AGI_MAGIC	0x58414749	/* 'XAGI' */
-#define	XFS_AGFL_MAGIC	0x5841464c	/* 'XAFL' */
-#define	XFS_AGF_VERSION	1
-#define	XFS_AGI_VERSION	1
-
-#define	XFS_AGF_GOOD_VERSION(v)	((v) == XFS_AGF_VERSION)
-#define	XFS_AGI_GOOD_VERSION(v)	((v) == XFS_AGI_VERSION)
-
-/*
- * Btree number 0 is bno, 1 is cnt.  This value gives the size of the
- * arrays below.
- */
-#define	XFS_BTNUM_AGF	((int)XFS_BTNUM_CNTi + 1)
-
-/*
- * The second word of agf_levels in the first a.g. overlaps the EFS
- * superblock's magic number.  Since the magic numbers valid for EFS
- * are > 64k, our value cannot be confused for an EFS superblock's.
- */
-
-typedef struct xfs_agf {
-	/*
-	 * Common allocation group header information
-	 */
-	__be32		agf_magicnum;	/* magic number == XFS_AGF_MAGIC */
-	__be32		agf_versionnum;	/* header version == XFS_AGF_VERSION */
-	__be32		agf_seqno;	/* sequence # starting from 0 */
-	__be32		agf_length;	/* size in blocks of a.g. */
-	/*
-	 * Freespace information
-	 */
-	__be32		agf_roots[XFS_BTNUM_AGF];	/* root blocks */
-	__be32		agf_spare0;	/* spare field */
-	__be32		agf_levels[XFS_BTNUM_AGF];	/* btree levels */
-	__be32		agf_spare1;	/* spare field */
-
-	__be32		agf_flfirst;	/* first freelist block's index */
-	__be32		agf_fllast;	/* last freelist block's index */
-	__be32		agf_flcount;	/* count of blocks in freelist */
-	__be32		agf_freeblks;	/* total free blocks */
-
-	__be32		agf_longest;	/* longest free space */
-	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
-	uuid_t		agf_uuid;	/* uuid of filesystem */
-
-	/*
-	 * reserve some contiguous space for future logged fields before we add
-	 * the unlogged fields. This makes the range logging via flags and
-	 * structure offsets much simpler.
-	 */
-	__be64		agf_spare64[16];
-
-	/* unlogged fields, written during buffer writeback. */
-	__be64		agf_lsn;	/* last write sequence */
-	__be32		agf_crc;	/* crc of agf sector */
-	__be32		agf_spare2;
-
-	/* structure must be padded to 64 bit alignment */
-} xfs_agf_t;
-
-#define XFS_AGF_CRC_OFF		offsetof(struct xfs_agf, agf_crc)
-
-#define	XFS_AGF_MAGICNUM	0x00000001
-#define	XFS_AGF_VERSIONNUM	0x00000002
-#define	XFS_AGF_SEQNO		0x00000004
-#define	XFS_AGF_LENGTH		0x00000008
-#define	XFS_AGF_ROOTS		0x00000010
-#define	XFS_AGF_LEVELS		0x00000020
-#define	XFS_AGF_FLFIRST		0x00000040
-#define	XFS_AGF_FLLAST		0x00000080
-#define	XFS_AGF_FLCOUNT		0x00000100
-#define	XFS_AGF_FREEBLKS	0x00000200
-#define	XFS_AGF_LONGEST		0x00000400
-#define	XFS_AGF_BTREEBLKS	0x00000800
-#define	XFS_AGF_UUID		0x00001000
-#define	XFS_AGF_NUM_BITS	13
-#define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
-
-#define XFS_AGF_FLAGS \
-	{ XFS_AGF_MAGICNUM,	"MAGICNUM" }, \
-	{ XFS_AGF_VERSIONNUM,	"VERSIONNUM" }, \
-	{ XFS_AGF_SEQNO,	"SEQNO" }, \
-	{ XFS_AGF_LENGTH,	"LENGTH" }, \
-	{ XFS_AGF_ROOTS,	"ROOTS" }, \
-	{ XFS_AGF_LEVELS,	"LEVELS" }, \
-	{ XFS_AGF_FLFIRST,	"FLFIRST" }, \
-	{ XFS_AGF_FLLAST,	"FLLAST" }, \
-	{ XFS_AGF_FLCOUNT,	"FLCOUNT" }, \
-	{ XFS_AGF_FREEBLKS,	"FREEBLKS" }, \
-	{ XFS_AGF_LONGEST,	"LONGEST" }, \
-	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }, \
-	{ XFS_AGF_UUID,		"UUID" }
-
-/* disk block (xfs_daddr_t) in the AG */
-#define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
-#define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
-#define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)((bp)->b_addr))
-
-extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
-			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
-
-/*
- * Size of the unlinked inode hash table in the agi.
- */
-#define	XFS_AGI_UNLINKED_BUCKETS	64
-
-typedef struct xfs_agi {
-	/*
-	 * Common allocation group header information
-	 */
-	__be32		agi_magicnum;	/* magic number == XFS_AGI_MAGIC */
-	__be32		agi_versionnum;	/* header version == XFS_AGI_VERSION */
-	__be32		agi_seqno;	/* sequence # starting from 0 */
-	__be32		agi_length;	/* size in blocks of a.g. */
-	/*
-	 * Inode information
-	 * Inodes are mapped by interpreting the inode number, so no
-	 * mapping data is needed here.
-	 */
-	__be32		agi_count;	/* count of allocated inodes */
-	__be32		agi_root;	/* root of inode btree */
-	__be32		agi_level;	/* levels in inode btree */
-	__be32		agi_freecount;	/* number of free inodes */
-
-	__be32		agi_newino;	/* new inode just allocated */
-	__be32		agi_dirino;	/* last directory inode chunk */
-	/*
-	 * Hash table of inodes which have been unlinked but are
-	 * still being referenced.
-	 */
-	__be32		agi_unlinked[XFS_AGI_UNLINKED_BUCKETS];
-	/*
-	 * This marks the end of logging region 1 and start of logging region 2.
-	 */
-	uuid_t		agi_uuid;	/* uuid of filesystem */
-	__be32		agi_crc;	/* crc of agi sector */
-	__be32		agi_pad32;
-	__be64		agi_lsn;	/* last write sequence */
-
-	__be32		agi_free_root; /* root of the free inode btree */
-	__be32		agi_free_level;/* levels in free inode btree */
-
-	/* structure must be padded to 64 bit alignment */
-} xfs_agi_t;
-
-#define XFS_AGI_CRC_OFF		offsetof(struct xfs_agi, agi_crc)
-
-#define	XFS_AGI_MAGICNUM	(1 << 0)
-#define	XFS_AGI_VERSIONNUM	(1 << 1)
-#define	XFS_AGI_SEQNO		(1 << 2)
-#define	XFS_AGI_LENGTH		(1 << 3)
-#define	XFS_AGI_COUNT		(1 << 4)
-#define	XFS_AGI_ROOT		(1 << 5)
-#define	XFS_AGI_LEVEL		(1 << 6)
-#define	XFS_AGI_FREECOUNT	(1 << 7)
-#define	XFS_AGI_NEWINO		(1 << 8)
-#define	XFS_AGI_DIRINO		(1 << 9)
-#define	XFS_AGI_UNLINKED	(1 << 10)
-#define	XFS_AGI_NUM_BITS_R1	11	/* end of the 1st agi logging region */
-#define	XFS_AGI_ALL_BITS_R1	((1 << XFS_AGI_NUM_BITS_R1) - 1)
-#define	XFS_AGI_FREE_ROOT	(1 << 11)
-#define	XFS_AGI_FREE_LEVEL	(1 << 12)
-#define	XFS_AGI_NUM_BITS_R2	13
-
-/* disk block (xfs_daddr_t) in the AG */
-#define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
-#define	XFS_AGI_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGI_DADDR(mp))
-#define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)((bp)->b_addr))
-
-extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
-				xfs_agnumber_t agno, struct xfs_buf **bpp);
-
-/*
- * The third a.g. block contains the a.g. freelist, an array
- * of block pointers to blocks owned by the allocation btree code.
- */
-#define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
-#define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
-#define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
-
-#define XFS_BUF_TO_AGFL_BNO(mp, bp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
-		(__be32 *)(bp)->b_addr)
-
-/*
- * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of
- * slots in the beginning of the block for a proper header with the
- * location information and CRC.
- */
-#define XFS_AGFL_SIZE(mp) \
-	(((mp)->m_sb.sb_sectsize - \
-	 (xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-		sizeof(struct xfs_agfl) : 0)) / \
-	  sizeof(xfs_agblock_t))
-
-typedef struct xfs_agfl {
-	__be32		agfl_magicnum;
-	__be32		agfl_seqno;
-	uuid_t		agfl_uuid;
-	__be64		agfl_lsn;
-	__be32		agfl_crc;
-	__be32		agfl_bno[];	/* actually XFS_AGFL_SIZE(mp) */
-} xfs_agfl_t;
-
-#define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
-
-/*
- * tags for inode radix tree
- */
-#define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
-					   in xfs_inode_ag_iterator */
-#define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
-#define XFS_ICI_EOFBLOCKS_TAG	1	/* inode has blocks beyond EOF */
-
-#define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
-#define	XFS_MIN_FREELIST_RAW(bl,cl,mp)	\
-	(MIN(bl + 1, XFS_AG_MAXLEVELS(mp)) + MIN(cl + 1, XFS_AG_MAXLEVELS(mp)))
-#define	XFS_MIN_FREELIST(a,mp)		\
-	(XFS_MIN_FREELIST_RAW(		\
-		be32_to_cpu((a)->agf_levels[XFS_BTNUM_BNOi]), \
-		be32_to_cpu((a)->agf_levels[XFS_BTNUM_CNTi]), mp))
-#define	XFS_MIN_FREELIST_PAG(pag,mp)	\
-	(XFS_MIN_FREELIST_RAW(		\
-		(unsigned int)(pag)->pagf_levels[XFS_BTNUM_BNOi], \
-		(unsigned int)(pag)->pagf_levels[XFS_BTNUM_CNTi], mp))
-
-#define XFS_AGB_TO_FSB(mp,agno,agbno)	\
-	(((xfs_fsblock_t)(agno) << (mp)->m_sb.sb_agblklog) | (agbno))
-#define	XFS_FSB_TO_AGNO(mp,fsbno)	\
-	((xfs_agnumber_t)((fsbno) >> (mp)->m_sb.sb_agblklog))
-#define	XFS_FSB_TO_AGBNO(mp,fsbno)	\
-	((xfs_agblock_t)((fsbno) & xfs_mask32lo((mp)->m_sb.sb_agblklog)))
-#define	XFS_AGB_TO_DADDR(mp,agno,agbno)	\
-	((xfs_daddr_t)XFS_FSB_TO_BB(mp, \
-		(xfs_fsblock_t)(agno) * (mp)->m_sb.sb_agblocks + (agbno)))
-#define	XFS_AG_DADDR(mp,agno,d)		(XFS_AGB_TO_DADDR(mp, agno, 0) + (d))
-
-/*
- * For checking for bad ranges of xfs_daddr_t's, covering multiple
- * allocation groups or a single xfs_daddr_t that's a superblock copy.
- */
-#define	XFS_AG_CHECK_DADDR(mp,d,len)	\
-	((len) == 1 ? \
-	    ASSERT((d) == XFS_SB_DADDR || \
-		   xfs_daddr_to_agbno(mp, d) != XFS_SB_DADDR) : \
-	    ASSERT(xfs_daddr_to_agno(mp, d) == \
-		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
-
-#endif	/* __XFS_AG_H__ */
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index eff3421..a6fbf44 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index feacb06..d1b4b6a 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -231,4 +231,7 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat);	/* output: success/failure */
 
+int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
+			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index e0e83e2..59d521c 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
 #include "xfs_alloc_btree.h"
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4c0e33b..f782d36 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d9a172b..5d38e8b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -24,7 +24,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 7510ab8..4edd4a8 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -24,7 +24,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 427c13f..68d9133 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -24,7 +24,6 @@
 #include "xfs_bit.h"
 #include "xfs_inum.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index b016fc4..91588a5 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 8fe6a93..256d532 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index fd82753..2b88061 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -24,7 +24,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 7e42fdf..927e9eb 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -23,7 +23,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index d6ddb3f..672a29e 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -22,7 +22,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_inum.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index a9afd7e..a6b3a6a 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index fdd803f..2c8f463 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a19174e..777c482 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 2ae6ac2..c0a0e19 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 58133d2..ab99dbc 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -21,7 +21,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index bb96933..cd68926 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -23,7 +23,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e99d329..9b6e424 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -33,6 +33,249 @@ struct xfs_inode;
 struct xfs_buf;
 struct xfs_ifork;
 
+/*
+ * Allocation group header
+ *
+ * This is divided into three structures, placed in sequential 512-byte
+ * buffers after a copy of the superblock (also in a 512-byte buffer).
+ */
+#define	XFS_AGF_MAGIC	0x58414746	/* 'XAGF' */
+#define	XFS_AGI_MAGIC	0x58414749	/* 'XAGI' */
+#define	XFS_AGFL_MAGIC	0x5841464c	/* 'XAFL' */
+#define	XFS_AGF_VERSION	1
+#define	XFS_AGI_VERSION	1
+
+#define	XFS_AGF_GOOD_VERSION(v)	((v) == XFS_AGF_VERSION)
+#define	XFS_AGI_GOOD_VERSION(v)	((v) == XFS_AGI_VERSION)
+
+/*
+ * Btree number 0 is bno, 1 is cnt.  This value gives the size of the
+ * arrays below.
+ */
+#define	XFS_BTNUM_AGF	((int)XFS_BTNUM_CNTi + 1)
+
+/*
+ * The second word of agf_levels in the first a.g. overlaps the EFS
+ * superblock's magic number.  Since the magic numbers valid for EFS
+ * are > 64k, our value cannot be confused for an EFS superblock's.
+ */
+
+typedef struct xfs_agf {
+	/*
+	 * Common allocation group header information
+	 */
+	__be32		agf_magicnum;	/* magic number == XFS_AGF_MAGIC */
+	__be32		agf_versionnum;	/* header version == XFS_AGF_VERSION */
+	__be32		agf_seqno;	/* sequence # starting from 0 */
+	__be32		agf_length;	/* size in blocks of a.g. */
+	/*
+	 * Freespace information
+	 */
+	__be32		agf_roots[XFS_BTNUM_AGF];	/* root blocks */
+	__be32		agf_spare0;	/* spare field */
+	__be32		agf_levels[XFS_BTNUM_AGF];	/* btree levels */
+	__be32		agf_spare1;	/* spare field */
+
+	__be32		agf_flfirst;	/* first freelist block's index */
+	__be32		agf_fllast;	/* last freelist block's index */
+	__be32		agf_flcount;	/* count of blocks in freelist */
+	__be32		agf_freeblks;	/* total free blocks */
+
+	__be32		agf_longest;	/* longest free space */
+	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
+	uuid_t		agf_uuid;	/* uuid of filesystem */
+
+	/*
+	 * reserve some contiguous space for future logged fields before we add
+	 * the unlogged fields. This makes the range logging via flags and
+	 * structure offsets much simpler.
+	 */
+	__be64		agf_spare64[16];
+
+	/* unlogged fields, written during buffer writeback. */
+	__be64		agf_lsn;	/* last write sequence */
+	__be32		agf_crc;	/* crc of agf sector */
+	__be32		agf_spare2;
+
+	/* structure must be padded to 64 bit alignment */
+} xfs_agf_t;
+
+#define XFS_AGF_CRC_OFF		offsetof(struct xfs_agf, agf_crc)
+
+#define	XFS_AGF_MAGICNUM	0x00000001
+#define	XFS_AGF_VERSIONNUM	0x00000002
+#define	XFS_AGF_SEQNO		0x00000004
+#define	XFS_AGF_LENGTH		0x00000008
+#define	XFS_AGF_ROOTS		0x00000010
+#define	XFS_AGF_LEVELS		0x00000020
+#define	XFS_AGF_FLFIRST		0x00000040
+#define	XFS_AGF_FLLAST		0x00000080
+#define	XFS_AGF_FLCOUNT		0x00000100
+#define	XFS_AGF_FREEBLKS	0x00000200
+#define	XFS_AGF_LONGEST		0x00000400
+#define	XFS_AGF_BTREEBLKS	0x00000800
+#define	XFS_AGF_UUID		0x00001000
+#define	XFS_AGF_NUM_BITS	13
+#define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
+
+#define XFS_AGF_FLAGS \
+	{ XFS_AGF_MAGICNUM,	"MAGICNUM" }, \
+	{ XFS_AGF_VERSIONNUM,	"VERSIONNUM" }, \
+	{ XFS_AGF_SEQNO,	"SEQNO" }, \
+	{ XFS_AGF_LENGTH,	"LENGTH" }, \
+	{ XFS_AGF_ROOTS,	"ROOTS" }, \
+	{ XFS_AGF_LEVELS,	"LEVELS" }, \
+	{ XFS_AGF_FLFIRST,	"FLFIRST" }, \
+	{ XFS_AGF_FLLAST,	"FLLAST" }, \
+	{ XFS_AGF_FLCOUNT,	"FLCOUNT" }, \
+	{ XFS_AGF_FREEBLKS,	"FREEBLKS" }, \
+	{ XFS_AGF_LONGEST,	"LONGEST" }, \
+	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }, \
+	{ XFS_AGF_UUID,		"UUID" }
+
+/* disk block (xfs_daddr_t) in the AG */
+#define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
+#define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
+#define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)((bp)->b_addr))
+
+/*
+ * Size of the unlinked inode hash table in the agi.
+ */
+#define	XFS_AGI_UNLINKED_BUCKETS	64
+
+typedef struct xfs_agi {
+	/*
+	 * Common allocation group header information
+	 */
+	__be32		agi_magicnum;	/* magic number == XFS_AGI_MAGIC */
+	__be32		agi_versionnum;	/* header version == XFS_AGI_VERSION */
+	__be32		agi_seqno;	/* sequence # starting from 0 */
+	__be32		agi_length;	/* size in blocks of a.g. */
+	/*
+	 * Inode information
+	 * Inodes are mapped by interpreting the inode number, so no
+	 * mapping data is needed here.
+	 */
+	__be32		agi_count;	/* count of allocated inodes */
+	__be32		agi_root;	/* root of inode btree */
+	__be32		agi_level;	/* levels in inode btree */
+	__be32		agi_freecount;	/* number of free inodes */
+
+	__be32		agi_newino;	/* new inode just allocated */
+	__be32		agi_dirino;	/* last directory inode chunk */
+	/*
+	 * Hash table of inodes which have been unlinked but are
+	 * still being referenced.
+	 */
+	__be32		agi_unlinked[XFS_AGI_UNLINKED_BUCKETS];
+	/*
+	 * This marks the end of logging region 1 and start of logging region 2.
+	 */
+	uuid_t		agi_uuid;	/* uuid of filesystem */
+	__be32		agi_crc;	/* crc of agi sector */
+	__be32		agi_pad32;
+	__be64		agi_lsn;	/* last write sequence */
+
+	__be32		agi_free_root; /* root of the free inode btree */
+	__be32		agi_free_level;/* levels in free inode btree */
+
+	/* structure must be padded to 64 bit alignment */
+} xfs_agi_t;
+
+#define XFS_AGI_CRC_OFF		offsetof(struct xfs_agi, agi_crc)
+
+#define	XFS_AGI_MAGICNUM	(1 << 0)
+#define	XFS_AGI_VERSIONNUM	(1 << 1)
+#define	XFS_AGI_SEQNO		(1 << 2)
+#define	XFS_AGI_LENGTH		(1 << 3)
+#define	XFS_AGI_COUNT		(1 << 4)
+#define	XFS_AGI_ROOT		(1 << 5)
+#define	XFS_AGI_LEVEL		(1 << 6)
+#define	XFS_AGI_FREECOUNT	(1 << 7)
+#define	XFS_AGI_NEWINO		(1 << 8)
+#define	XFS_AGI_DIRINO		(1 << 9)
+#define	XFS_AGI_UNLINKED	(1 << 10)
+#define	XFS_AGI_NUM_BITS_R1	11	/* end of the 1st agi logging region */
+#define	XFS_AGI_ALL_BITS_R1	((1 << XFS_AGI_NUM_BITS_R1) - 1)
+#define	XFS_AGI_FREE_ROOT	(1 << 11)
+#define	XFS_AGI_FREE_LEVEL	(1 << 12)
+#define	XFS_AGI_NUM_BITS_R2	13
+
+/* disk block (xfs_daddr_t) in the AG */
+#define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
+#define	XFS_AGI_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGI_DADDR(mp))
+#define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)((bp)->b_addr))
+
+/*
+ * The third a.g. block contains the a.g. freelist, an array
+ * of block pointers to blocks owned by the allocation btree code.
+ */
+#define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
+#define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
+#define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
+
+#define XFS_BUF_TO_AGFL_BNO(mp, bp) \
+	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
+		(__be32 *)(bp)->b_addr)
+
+/*
+ * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of
+ * slots in the beginning of the block for a proper header with the
+ * location information and CRC.
+ */
+#define XFS_AGFL_SIZE(mp) \
+	(((mp)->m_sb.sb_sectsize - \
+	 (xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+		sizeof(struct xfs_agfl) : 0)) / \
+	  sizeof(xfs_agblock_t))
+
+typedef struct xfs_agfl {
+	__be32		agfl_magicnum;
+	__be32		agfl_seqno;
+	uuid_t		agfl_uuid;
+	__be64		agfl_lsn;
+	__be32		agfl_crc;
+	__be32		agfl_bno[];	/* actually XFS_AGFL_SIZE(mp) */
+} xfs_agfl_t;
+
+#define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
+
+
+#define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
+#define	XFS_MIN_FREELIST_RAW(bl,cl,mp)	\
+	(MIN(bl + 1, XFS_AG_MAXLEVELS(mp)) + MIN(cl + 1, XFS_AG_MAXLEVELS(mp)))
+#define	XFS_MIN_FREELIST(a,mp)		\
+	(XFS_MIN_FREELIST_RAW(		\
+		be32_to_cpu((a)->agf_levels[XFS_BTNUM_BNOi]), \
+		be32_to_cpu((a)->agf_levels[XFS_BTNUM_CNTi]), mp))
+#define	XFS_MIN_FREELIST_PAG(pag,mp)	\
+	(XFS_MIN_FREELIST_RAW(		\
+		(unsigned int)(pag)->pagf_levels[XFS_BTNUM_BNOi], \
+		(unsigned int)(pag)->pagf_levels[XFS_BTNUM_CNTi], mp))
+
+#define XFS_AGB_TO_FSB(mp,agno,agbno)	\
+	(((xfs_fsblock_t)(agno) << (mp)->m_sb.sb_agblklog) | (agbno))
+#define	XFS_FSB_TO_AGNO(mp,fsbno)	\
+	((xfs_agnumber_t)((fsbno) >> (mp)->m_sb.sb_agblklog))
+#define	XFS_FSB_TO_AGBNO(mp,fsbno)	\
+	((xfs_agblock_t)((fsbno) & xfs_mask32lo((mp)->m_sb.sb_agblklog)))
+#define	XFS_AGB_TO_DADDR(mp,agno,agbno)	\
+	((xfs_daddr_t)XFS_FSB_TO_BB(mp, \
+		(xfs_fsblock_t)(agno) * (mp)->m_sb.sb_agblocks + (agbno)))
+#define	XFS_AG_DADDR(mp,agno,d)		(XFS_AGB_TO_DADDR(mp, agno, 0) + (d))
+
+/*
+ * For checking for bad ranges of xfs_daddr_t's, covering multiple
+ * allocation groups or a single xfs_daddr_t that's a superblock copy.
+ */
+#define	XFS_AG_CHECK_DADDR(mp,d,len)	\
+	((len) == 1 ? \
+	    ASSERT((d) == XFS_SB_DADDR || \
+		   xfs_daddr_to_agbno(mp, d) != XFS_SB_DADDR) : \
+	    ASSERT(xfs_daddr_to_agno(mp, d) == \
+		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
+
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7eb2fca..1dae7da 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -24,7 +24,6 @@
 #include "xfs_bit.h"
 #include "xfs_inum.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 95ad1c0..100007d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -160,4 +160,8 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_agnumber_t agno, xfs_agblock_t agbno,
 			  xfs_agblock_t length, unsigned int gen);
 
+int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_agnumber_t agno, struct xfs_buf **bpp);
+
+
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index c9b06f3..4e029cc 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 184c68e..f63c455 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e45d833..ab06599 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -24,7 +24,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_inum.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index ee7e0e8..1c250ee 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -21,7 +21,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index de0fe1e..ad3d1dc 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 1eed436..752915f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 5782f03..87ee299 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_shared.h"
 #include "xfs_trans_resv.h"
-#include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f2bda7c..f2a03e5 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -23,7 +23,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index a65fa5d..66cd043 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -19,7 +19,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e4f27e7..183b634 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -21,7 +21,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 5665f46..b466388 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -24,7 +24,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 143435c..13dce2b 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 6bafbc0..e663822 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -24,7 +24,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 24b4ebe..b0a594e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -34,10 +34,10 @@
 #include <linux/backing-dev.h>
 #include <linux/freezer.h>
 
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index f159695..3f9bd58 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -17,11 +17,11 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 1e937fc..09b0eb7 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 13d08a1..799e5a2 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -20,7 +20,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_quota.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 63c2de4..2221684 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index f33fbaa..1f87bc8 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -21,7 +21,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index b92fd7bc..f5d90ed 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -21,7 +21,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 5a6bd5d..73172e1 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -20,7 +20,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_dir2.h"
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index fd22f69..c263e07 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -24,7 +24,6 @@
 #include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index c432741..e751c60 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -17,10 +17,10 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8fe87bb..69b7dd3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index fe47f3d..c5b06a9 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -20,7 +20,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inum.h"
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 594af19..fdc6422 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b45f7b2..e364723 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -22,7 +22,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_inum.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 46748b8..62f1f91 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -34,6 +34,14 @@ struct xfs_eofblocks {
 #define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
 
 /*
+ * tags for inode radix tree
+ */
+#define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
+					   in xfs_inode_ag_iterator */
+#define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
+#define XFS_ICI_EOFBLOCKS_TAG	1	/* inode has blocks beyond EOF */
+
+/*
  * Flags for xfs_iget()
  */
 #define XFS_IGET_CREATE		0x1
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 7e45492..131b043 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -18,11 +18,11 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8ed049d..229dfde 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -25,7 +25,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_inum.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_da_format.h"
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index efa6e59..0bd3af6 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -21,7 +21,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6a8737b..d2175b6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_ioctl.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 94ce027..9a36ee0 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -26,7 +26,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_itable.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index cf110224..7ab365a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1e72c77..55aa9e8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c3f51f6..8efcdf0 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_inum.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fe88ef6..765f32e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f506c45..951c08f 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -17,11 +17,11 @@
 
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_alloc.h"
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9b3fca6..697073a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -24,7 +24,6 @@
 #include "xfs_bit.h"
 #include "xfs_inum.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 63ca2f0..8abc2d5 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -17,10 +17,10 @@
 
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index faf3e36..e627336 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -24,7 +24,6 @@
 #include "xfs_bit.h"
 #include "xfs_inum.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b0447c8..d27804a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -320,10 +320,7 @@ typedef struct xfs_mod_sb {
 
 /*
  * Per-ag incore structure, copies of information in agf and agi, to improve the
- * performance of allocation group selection. This is defined for the kernel
- * only, and hence is defined here instead of in xfs_ag.h. You need the struct
- * xfs_mount to be defined to look up a xfs_perag anyway (via mp->m_perag_tree),
- * so this doesn't introduce any strange header file dependencies.
+ * performance of allocation group selection.
  */
 typedef struct xfs_perag {
 	struct xfs_mount *pag_mount;	/* owner filesystem */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index cca7445..26d4a8d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 2c61e61..b781dc5 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -21,7 +21,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 80f2d77..0449d93 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -26,7 +26,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index b238027..7638439 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -20,7 +20,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 562dcdf..cb93a72 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8f02647..af4f63e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -23,7 +23,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_inum.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index f38a3f1..99bc129 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -24,7 +24,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 1e85bcd..017051a 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 30e8e34..02df25d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -23,7 +23,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_extent_busy.h"
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 859482f..dd828d6 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -18,10 +18,10 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index e2b2216..f9192b0 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 846e061..6320e28 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 47978ba..a0aaa3e 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -18,10 +18,10 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index cdb4d86..592904b 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 93455b9..30c6158 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -21,7 +21,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
