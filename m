Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAD587FAD
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 01:05:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 99198304032
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 23:05:12 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	iUM5GrjfCfSGE5gE for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 23:05:07 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Z01nQ-0001DC-K9
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Z01nQ-0002v6-JE
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/20] xfs: add rmap btree stats infrastructure
Date: Wed,  3 Jun 2015 16:04:43 +1000
Message-Id: <1433311497-10245-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1433311497-10245-1-git-send-email-david@fromorbit.com>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
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

The rmap btree will require the same stats as all the other generic
btrees, so add al the code for that now.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.h |  4 ++--
 fs/xfs/xfs_stats.c        |  1 +
 fs/xfs/xfs_stats.h        | 18 +++++++++++++++++-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index ace1995..494ee0b 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -95,7 +95,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
-	case XFS_BTNUM_RMAP: break;	\
+	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(rmap, stat); break;	\
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -110,7 +110,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
-	case XFS_BTNUM_RMAP: break; \
+	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_ADD(rmap, stat, val); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index f224038..67bbfa2 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -60,6 +60,7 @@ static int xfs_stat_proc_show(struct seq_file *m, void *v)
 		{ "bmbt2",		XFSSTAT_END_BMBT_V2		},
 		{ "ibt2",		XFSSTAT_END_IBT_V2		},
 		{ "fibt2",		XFSSTAT_END_FIBT_V2		},
+		{ "rmapbt",		XFSSTAT_END_RMAP_V2		},
 		/* we print both series of quota information together */
 		{ "qm",			XFSSTAT_END_QM			},
 	};
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index c8f238b..8414db2 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -199,7 +199,23 @@ struct xfsstats {
 	__uint32_t		xs_fibt_2_alloc;
 	__uint32_t		xs_fibt_2_free;
 	__uint32_t		xs_fibt_2_moves;
-#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_FIBT_V2+6)
+#define XFSSTAT_END_RMAP_V2		(XFSSTAT_END_FIBT_V2+15)
+	__uint32_t		xs_rmap_2_lookup;
+	__uint32_t		xs_rmap_2_compare;
+	__uint32_t		xs_rmap_2_insrec;
+	__uint32_t		xs_rmap_2_delrec;
+	__uint32_t		xs_rmap_2_newroot;
+	__uint32_t		xs_rmap_2_killroot;
+	__uint32_t		xs_rmap_2_increment;
+	__uint32_t		xs_rmap_2_decrement;
+	__uint32_t		xs_rmap_2_lshift;
+	__uint32_t		xs_rmap_2_rshift;
+	__uint32_t		xs_rmap_2_split;
+	__uint32_t		xs_rmap_2_join;
+	__uint32_t		xs_rmap_2_alloc;
+	__uint32_t		xs_rmap_2_free;
+	__uint32_t		xs_rmap_2_moves;
+#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_RMAP_V2+6)
 	__uint32_t		xs_qm_dqreclaims;
 	__uint32_t		xs_qm_dqreclaim_misses;
 	__uint32_t		xs_qm_dquot_dups;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
