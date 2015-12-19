Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E00DF7FA9
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:57:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B3FF0304059
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:16 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id A017nqdF1t6fyrA3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:15 -0800 (PST)
Subject: [PATCH 07/76] xfs: add rmap btree stats infrastructure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:57:08 -0800
Message-ID: <20151219085708.12713.3834.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

>From : Dave Chinner <dchinner@redhat.com>

The rmap btree will require the same stats as all the other generic
btrees, so add al the code for that now.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.h |    7 ++++---
 fs/xfs/xfs_stats.c        |    1 +
 fs/xfs/xfs_stats.h        |   18 +++++++++++++++++-
 3 files changed, 22 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 4942c4a..0d0e546 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -96,8 +96,8 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(__mp, bmbt, stat); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
-	case XFS_BTNUM_RMAP: break;	\
-	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(__mp, rmap, stat); break; \
+	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break; \
 	}       \
 } while (0)
 
@@ -117,7 +117,8 @@ do {    \
 		__XFS_BTREE_STATS_ADD(__mp, ibt, stat, val); break; \
 	case XFS_BTNUM_FINO:	\
 		__XFS_BTREE_STATS_ADD(__mp, fibt, stat, val); break; \
-	case XFS_BTNUM_RMAP: break; \
+	case XFS_BTNUM_RMAP:	\
+		__XFS_BTREE_STATS_ADD(__mp, rmap, stat, val); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break; \
 	}       \
 } while (0)
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 8686df6..f04f547 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -61,6 +61,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "bmbt2",		XFSSTAT_END_BMBT_V2		},
 		{ "ibt2",		XFSSTAT_END_IBT_V2		},
 		{ "fibt2",		XFSSTAT_END_FIBT_V2		},
+		{ "rmapbt",		XFSSTAT_END_RMAP_V2		},
 		/* we print both series of quota information together */
 		{ "qm",			XFSSTAT_END_QM			},
 	};
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 483b0ef..657865f 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -197,7 +197,23 @@ struct xfsstats {
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
