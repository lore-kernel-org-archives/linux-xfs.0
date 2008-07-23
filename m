Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 13:08:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NK8AV2016269
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:08:10 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58B9831C281
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:09:20 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id RF5UjtZq3MkYEjBG for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:09:20 -0700 (PDT)
Date: Wed, 23 Jul 2008 22:09:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/15] add new btree statistics
Message-ID: <20080723200910.GJ7401@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-stats
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <dgc@sgi.com>

From: Dave Chinner <dgc@sgi.com>

Introduce statistics coverage of all the btrees and cover
all the btree operations, not just some.

Invaluable for determining test code coverage of all the btree
operations....


Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_stats.c	2008-07-14 17:24:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.c	2008-07-14 17:29:17.000000000 +0200
@@ -53,6 +53,10 @@ xfs_read_xfsstats(
 		{ "icluster",		XFSSTAT_END_INODE_CLUSTER	},
 		{ "vnodes",		XFSSTAT_END_VNODE_OPS		},
 		{ "buf",		XFSSTAT_END_BUF			},
+		{ "abtb2",		XFSSTAT_END_ABTB_V2		},
+		{ "abtc2",		XFSSTAT_END_ABTC_V2		},
+		{ "bmbt2",		XFSSTAT_END_BMBT_V2		},
+		{ "ibt2",		XFSSTAT_END_IBT_V2		},
 	};
 
 	/* Loop over all stats groups */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_stats.h	2008-07-14 17:24:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.h	2008-07-14 17:29:17.000000000 +0200
@@ -118,6 +118,71 @@ struct xfsstats {
 	__uint32_t		xb_page_retries;
 	__uint32_t		xb_page_found;
 	__uint32_t		xb_get_read;
+/* Version 2 btree counters */
+#define XFSSTAT_END_ABTB_V2		(XFSSTAT_END_BUF+15)
+	__uint32_t		xs_abtb_2_lookup;
+	__uint32_t		xs_abtb_2_compare;
+	__uint32_t		xs_abtb_2_insrec;
+	__uint32_t		xs_abtb_2_delrec;
+	__uint32_t		xs_abtb_2_newroot;
+	__uint32_t		xs_abtb_2_killroot;
+	__uint32_t		xs_abtb_2_increment;
+	__uint32_t		xs_abtb_2_decrement;
+	__uint32_t		xs_abtb_2_lshift;
+	__uint32_t		xs_abtb_2_rshift;
+	__uint32_t		xs_abtb_2_split;
+	__uint32_t		xs_abtb_2_join;
+	__uint32_t		xs_abtb_2_alloc;
+	__uint32_t		xs_abtb_2_free;
+	__uint32_t		xs_abtb_2_moves;
+#define XFSSTAT_END_ABTC_V2		(XFSSTAT_END_ABTB_V2+15)
+	__uint32_t		xs_abtc_2_lookup;
+	__uint32_t		xs_abtc_2_compare;
+	__uint32_t		xs_abtc_2_insrec;
+	__uint32_t		xs_abtc_2_delrec;
+	__uint32_t		xs_abtc_2_newroot;
+	__uint32_t		xs_abtc_2_killroot;
+	__uint32_t		xs_abtc_2_increment;
+	__uint32_t		xs_abtc_2_decrement;
+	__uint32_t		xs_abtc_2_lshift;
+	__uint32_t		xs_abtc_2_rshift;
+	__uint32_t		xs_abtc_2_split;
+	__uint32_t		xs_abtc_2_join;
+	__uint32_t		xs_abtc_2_alloc;
+	__uint32_t		xs_abtc_2_free;
+	__uint32_t		xs_abtc_2_moves;
+#define XFSSTAT_END_BMBT_V2		(XFSSTAT_END_ABTC_V2+15)
+	__uint32_t		xs_bmbt_2_lookup;
+	__uint32_t		xs_bmbt_2_compare;
+	__uint32_t		xs_bmbt_2_insrec;
+	__uint32_t		xs_bmbt_2_delrec;
+	__uint32_t		xs_bmbt_2_newroot;
+	__uint32_t		xs_bmbt_2_killroot;
+	__uint32_t		xs_bmbt_2_increment;
+	__uint32_t		xs_bmbt_2_decrement;
+	__uint32_t		xs_bmbt_2_lshift;
+	__uint32_t		xs_bmbt_2_rshift;
+	__uint32_t		xs_bmbt_2_split;
+	__uint32_t		xs_bmbt_2_join;
+	__uint32_t		xs_bmbt_2_alloc;
+	__uint32_t		xs_bmbt_2_free;
+	__uint32_t		xs_bmbt_2_moves;
+#define XFSSTAT_END_IBT_V2		(XFSSTAT_END_BMBT_V2+15)
+	__uint32_t		xs_ibt_2_lookup;
+	__uint32_t		xs_ibt_2_compare;
+	__uint32_t		xs_ibt_2_insrec;
+	__uint32_t		xs_ibt_2_delrec;
+	__uint32_t		xs_ibt_2_newroot;
+	__uint32_t		xs_ibt_2_killroot;
+	__uint32_t		xs_ibt_2_increment;
+	__uint32_t		xs_ibt_2_decrement;
+	__uint32_t		xs_ibt_2_lshift;
+	__uint32_t		xs_ibt_2_rshift;
+	__uint32_t		xs_ibt_2_split;
+	__uint32_t		xs_ibt_2_join;
+	__uint32_t		xs_ibt_2_alloc;
+	__uint32_t		xs_ibt_2_free;
+	__uint32_t		xs_ibt_2_moves;
 /* Extra precision counters */
 	__uint64_t		xs_xstrat_bytes;
 	__uint64_t		xs_write_bytes;
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-14 17:28:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-14 17:29:17.000000000 +0200
@@ -126,6 +126,34 @@ union xfs_btree_rec {
 extern const __uint32_t	xfs_magics[];
 
 /*
+ * Generic stats interface
+ */
+#define __XFS_BTREE_STATS_INC(type, stat) \
+	XFS_STATS_INC(xs_ ## type ## _2_ ## stat)
+#define XFS_BTREE_STATS_INC(cur, stat)  \
+do {    \
+	switch (cur->bc_btnum) {  \
+	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_INC(abtb, stat); break;	\
+	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_INC(abtc, stat); break;	\
+	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
+	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
+	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	}       \
+} while (0)
+
+#define __XFS_BTREE_STATS_ADD(type, stat, val) \
+	XFS_STATS_ADD(xs_ ## type ## _2_ ## stat, val)
+#define XFS_BTREE_STATS_ADD(cur, stat, val)  \
+do {    \
+	switch (cur->bc_btnum) {  \
+	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_ADD(abtb, stat, val); break; \
+	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_ADD(abtc, stat, val); break; \
+	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
+	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
+	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	}       \
+} while (0)
+/*
  * Maximum and minimum records in a btree block.
  * Given block size, type prefix, and leaf flag (0 or 1).
  * The divisor below is equivalent to lf ? (e1) : (e2) but that produces

-- 
