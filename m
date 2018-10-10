Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbeJJT7S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 15:59:18 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F6F3307D852
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 12:37:19 +0000 (UTC)
Received: from odin.usersys.redhat.com (unknown [10.40.205.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EE93798D7
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 12:37:18 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/2] xfs: use offsetof() in place of offset macros for __xfsstats
Date: Wed, 10 Oct 2018 14:37:08 +0200
Message-Id: <20181010123708.7632-3-cmaiolino@redhat.com>
In-Reply-To: <20181010123708.7632-1-cmaiolino@redhat.com>
References: <20181010123708.7632-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Most offset macro mess is used in xfs_stats_format() only, and we can
simply get the right offsets using offsetof(), instead of several macros
to mark the offsets inside __xfsstats structure.

Replace all XFSSTAT_END_* macros by a single helper macro to get the
right offset into __xfsstats, and use this helper in xfs_stats_format()
directly.

The quota stats code, still looks a bit cleaner when using XFSSTAT_*
macros, so, this patch also defines XFSSTAT_START_XQMSTAT and
XFSSTAT_END_XQMSTAT locally to that code. This also should prevent
offset mistakes when updates are done into __xfsstats.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_stats.c | 52 +++++++++++++++++++++++++---------------------
 fs/xfs/xfs_stats.h | 28 +++----------------------
 2 files changed, 31 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 740ac9674848..cc509743facd 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -29,30 +29,30 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		char	*desc;
 		int	endpoint;
 	} xstats[] = {
-		{ "extent_alloc",	XFSSTAT_END_EXTENT_ALLOC	},
-		{ "abt",		XFSSTAT_END_ALLOC_BTREE		},
-		{ "blk_map",		XFSSTAT_END_BLOCK_MAPPING	},
-		{ "bmbt",		XFSSTAT_END_BLOCK_MAP_BTREE	},
-		{ "dir",		XFSSTAT_END_DIRECTORY_OPS	},
-		{ "trans",		XFSSTAT_END_TRANSACTIONS	},
-		{ "ig",			XFSSTAT_END_INODE_OPS		},
-		{ "log",		XFSSTAT_END_LOG_OPS		},
-		{ "push_ail",		XFSSTAT_END_TAIL_PUSHING	},
-		{ "xstrat",		XFSSTAT_END_WRITE_CONVERT	},
-		{ "rw",			XFSSTAT_END_READ_WRITE_OPS	},
-		{ "attr",		XFSSTAT_END_ATTRIBUTE_OPS	},
-		{ "icluster",		XFSSTAT_END_INODE_CLUSTER	},
-		{ "vnodes",		XFSSTAT_END_VNODE_OPS		},
-		{ "buf",		XFSSTAT_END_BUF			},
-		{ "abtb2",		XFSSTAT_END_ABTB_V2		},
-		{ "abtc2",		XFSSTAT_END_ABTC_V2		},
-		{ "bmbt2",		XFSSTAT_END_BMBT_V2		},
-		{ "ibt2",		XFSSTAT_END_IBT_V2		},
-		{ "fibt2",		XFSSTAT_END_FIBT_V2		},
-		{ "rmapbt",		XFSSTAT_END_RMAP_V2		},
-		{ "refcntbt",		XFSSTAT_END_REFCOUNT		},
+		{ "extent_alloc",	xfsstats_offset(xs_abt_lookup)	},
+		{ "abt",		xfsstats_offset(xs_blk_mapr)	},
+		{ "blk_map",		xfsstats_offset(xs_bmbt_lookup)	},
+		{ "bmbt",		xfsstats_offset(xs_dir_lookup)	},
+		{ "dir",		xfsstats_offset(xs_trans_sync)	},
+		{ "trans",		xfsstats_offset(xs_ig_attempts)	},
+		{ "ig",			xfsstats_offset(xs_log_writes)	},
+		{ "log",		xfsstats_offset(xs_try_logspace)},
+		{ "push_ail",		xfsstats_offset(xs_xstrat_quick)},
+		{ "xstrat",		xfsstats_offset(xs_write_calls)	},
+		{ "rw",			xfsstats_offset(xs_attr_get)	},
+		{ "attr",		xfsstats_offset(xs_iflush_count)},
+		{ "icluster",		xfsstats_offset(vn_active)	},
+		{ "vnodes",		xfsstats_offset(xb_get)		},
+		{ "buf",		xfsstats_offset(xs_abtb_2)	},
+		{ "abtb2",		xfsstats_offset(xs_abtc_2)	},
+		{ "abtc2",		xfsstats_offset(xs_bmbt_2)	},
+		{ "bmbt2",		xfsstats_offset(xs_ibt_2)	},
+		{ "ibt2",		xfsstats_offset(xs_fibt_2)	},
+		{ "fibt2",		xfsstats_offset(xs_rmap_2)	},
+		{ "rmapbt",		xfsstats_offset(xs_refcbt_2)	},
+		{ "refcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
 		/* we print both series of quota information together */
-		{ "qm",			XFSSTAT_END_QM			},
+		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
 	};
 
 	/* Loop over all stats groups */
@@ -104,6 +104,10 @@ void xfs_stats_clearall(struct xfsstats __percpu *stats)
 #ifdef CONFIG_PROC_FS
 /* legacy quota interfaces */
 #ifdef CONFIG_XFS_QUOTA
+
+#define XFSSTAT_START_XQMSTAT xfsstats_offset(xs_qm_dqreclaims)
+#define XFSSTAT_END_XQMSTAT xfsstats_offset(xs_qm_dquot)
+
 static int xqm_proc_show(struct seq_file *m, void *v)
 {
 	/* maximum; incore; ratio free to inuse; freelist */
@@ -119,7 +123,7 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
 	int j;
 
 	seq_printf(m, "qm");
-	for (j = XFSSTAT_END_REFCOUNT; j < XFSSTAT_END_XQMSTAT; j++)
+	for (j = XFSSTAT_START_XQMSTAT; j < XFSSTAT_END_XQMSTAT; j++)
 		seq_printf(m, " %u", counter_val(xfsstats.xs_stats, j));
 	seq_putc(m, '\n');
 	return 0;
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 130db070e4d8..34d704f703d2 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -41,17 +41,14 @@ enum {
  * XFS global statistics
  */
 struct __xfsstats {
-# define XFSSTAT_END_EXTENT_ALLOC	4
 	uint32_t		xs_allocx;
 	uint32_t		xs_allocb;
 	uint32_t		xs_freex;
 	uint32_t		xs_freeb;
-# define XFSSTAT_END_ALLOC_BTREE	(XFSSTAT_END_EXTENT_ALLOC+4)
 	uint32_t		xs_abt_lookup;
 	uint32_t		xs_abt_compare;
 	uint32_t		xs_abt_insrec;
 	uint32_t		xs_abt_delrec;
-# define XFSSTAT_END_BLOCK_MAPPING	(XFSSTAT_END_ALLOC_BTREE+7)
 	uint32_t		xs_blk_mapr;
 	uint32_t		xs_blk_mapw;
 	uint32_t		xs_blk_unmap;
@@ -59,21 +56,17 @@ struct __xfsstats {
 	uint32_t		xs_del_exlist;
 	uint32_t		xs_look_exlist;
 	uint32_t		xs_cmp_exlist;
-# define XFSSTAT_END_BLOCK_MAP_BTREE	(XFSSTAT_END_BLOCK_MAPPING+4)
 	uint32_t		xs_bmbt_lookup;
 	uint32_t		xs_bmbt_compare;
 	uint32_t		xs_bmbt_insrec;
 	uint32_t		xs_bmbt_delrec;
-# define XFSSTAT_END_DIRECTORY_OPS	(XFSSTAT_END_BLOCK_MAP_BTREE+4)
 	uint32_t		xs_dir_lookup;
 	uint32_t		xs_dir_create;
 	uint32_t		xs_dir_remove;
 	uint32_t		xs_dir_getdents;
-# define XFSSTAT_END_TRANSACTIONS	(XFSSTAT_END_DIRECTORY_OPS+3)
 	uint32_t		xs_trans_sync;
 	uint32_t		xs_trans_async;
 	uint32_t		xs_trans_empty;
-# define XFSSTAT_END_INODE_OPS		(XFSSTAT_END_TRANSACTIONS+7)
 	uint32_t		xs_ig_attempts;
 	uint32_t		xs_ig_found;
 	uint32_t		xs_ig_frecycle;
@@ -81,13 +74,11 @@ struct __xfsstats {
 	uint32_t		xs_ig_dup;
 	uint32_t		xs_ig_reclaims;
 	uint32_t		xs_ig_attrchg;
-# define XFSSTAT_END_LOG_OPS		(XFSSTAT_END_INODE_OPS+5)
 	uint32_t		xs_log_writes;
 	uint32_t		xs_log_blocks;
 	uint32_t		xs_log_noiclogs;
 	uint32_t		xs_log_force;
 	uint32_t		xs_log_force_sleep;
-# define XFSSTAT_END_TAIL_PUSHING	(XFSSTAT_END_LOG_OPS+10)
 	uint32_t		xs_try_logspace;
 	uint32_t		xs_sleep_logspace;
 	uint32_t		xs_push_ail;
@@ -98,22 +89,17 @@ struct __xfsstats {
 	uint32_t		xs_push_ail_flushing;
 	uint32_t		xs_push_ail_restarts;
 	uint32_t		xs_push_ail_flush;
-# define XFSSTAT_END_WRITE_CONVERT	(XFSSTAT_END_TAIL_PUSHING+2)
 	uint32_t		xs_xstrat_quick;
 	uint32_t		xs_xstrat_split;
-# define XFSSTAT_END_READ_WRITE_OPS	(XFSSTAT_END_WRITE_CONVERT+2)
 	uint32_t		xs_write_calls;
 	uint32_t		xs_read_calls;
-# define XFSSTAT_END_ATTRIBUTE_OPS	(XFSSTAT_END_READ_WRITE_OPS+4)
 	uint32_t		xs_attr_get;
 	uint32_t		xs_attr_set;
 	uint32_t		xs_attr_remove;
 	uint32_t		xs_attr_list;
-# define XFSSTAT_END_INODE_CLUSTER	(XFSSTAT_END_ATTRIBUTE_OPS+3)
 	uint32_t		xs_iflush_count;
 	uint32_t		xs_icluster_flushcnt;
 	uint32_t		xs_icluster_flushinode;
-# define XFSSTAT_END_VNODE_OPS		(XFSSTAT_END_INODE_CLUSTER+8)
 	uint32_t		vn_active;	/* # vnodes not on free lists */
 	uint32_t		vn_alloc;	/* # times vn_alloc called */
 	uint32_t		vn_get;		/* # times vn_get called */
@@ -122,7 +108,6 @@ struct __xfsstats {
 	uint32_t		vn_reclaim;	/* # times vn_reclaim called */
 	uint32_t		vn_remove;	/* # times vn_remove called */
 	uint32_t		vn_free;	/* # times vn_free called */
-#define XFSSTAT_END_BUF			(XFSSTAT_END_VNODE_OPS+9)
 	uint32_t		xb_get;
 	uint32_t		xb_create;
 	uint32_t		xb_get_locked;
@@ -133,28 +118,19 @@ struct __xfsstats {
 	uint32_t		xb_page_found;
 	uint32_t		xb_get_read;
 /* Version 2 btree counters */
-#define XFSSTAT_END_ABTB_V2		(XFSSTAT_END_BUF + __XBTS_MAX)
 	uint32_t		xs_abtb_2[__XBTS_MAX];
-#define XFSSTAT_END_ABTC_V2		(XFSSTAT_END_ABTB_V2 + __XBTS_MAX)
 	uint32_t		xs_abtc_2[__XBTS_MAX];
-#define XFSSTAT_END_BMBT_V2		(XFSSTAT_END_ABTC_V2 + __XBTS_MAX)
 	uint32_t		xs_bmbt_2[__XBTS_MAX];
-#define XFSSTAT_END_IBT_V2		(XFSSTAT_END_BMBT_V2 + __XBTS_MAX)
 	uint32_t		xs_ibt_2[__XBTS_MAX];
-#define XFSSTAT_END_FIBT_V2		(XFSSTAT_END_IBT_V2 + __XBTS_MAX)
 	uint32_t		xs_fibt_2[__XBTS_MAX];
-#define XFSSTAT_END_RMAP_V2		(XFSSTAT_END_FIBT_V2 + __XBTS_MAX)
 	uint32_t		xs_rmap_2[__XBTS_MAX];
-#define XFSSTAT_END_REFCOUNT		(XFSSTAT_END_RMAP_V2 + __XBTS_MAX)
 	uint32_t		xs_refcbt_2[__XBTS_MAX];
-#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_REFCOUNT + 6)
 	uint32_t		xs_qm_dqreclaims;
 	uint32_t		xs_qm_dqreclaim_misses;
 	uint32_t		xs_qm_dquot_dups;
 	uint32_t		xs_qm_dqcachemisses;
 	uint32_t		xs_qm_dqcachehits;
 	uint32_t		xs_qm_dqwants;
-#define XFSSTAT_END_QM			(XFSSTAT_END_XQMSTAT+2)
 	uint32_t		xs_qm_dquot;
 	uint32_t		xs_qm_dquot_unused;
 /* Extra precision counters */
@@ -163,10 +139,12 @@ struct __xfsstats {
 	uint64_t		xs_read_bytes;
 };
 
+#define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
+
 struct xfsstats {
 	union {
 		struct __xfsstats	s;
-		uint32_t		a[XFSSTAT_END_XQMSTAT];
+		uint32_t		a[xfsstats_offset(xs_qm_dquot)];
 	};
 };
 
-- 
2.17.1
