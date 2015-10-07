Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF57C7FA4
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:58:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF327304032
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 21:58:56 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5OOuzJDkHwNlexEI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 21:58:55 -0700 (PDT)
Subject: [PATCH 34/58] xfs: add refcount btree stats infrastructure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 21:58:51 -0700
Message-ID: <20151007045851.30457.86030.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

The refcount btree presents the same stats as the other btrees, so
add all the code for that now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.h |    4 ++--
 fs/xfs/xfs_stats.c        |    1 +
 fs/xfs/xfs_stats.h        |   18 +++++++++++++++++-
 3 files changed, 20 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 4b49e35..8c59521 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -99,7 +99,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(rmap, stat); break;	\
-	case XFS_BTNUM_REFC: break;	\
+	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_INC(refcbt, stat); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -115,7 +115,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_ADD(rmap, stat, val); break; \
-	case XFS_BTNUM_REFC: break;	\
+	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_ADD(refcbt, stat, val); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 67bbfa2..64a60ef 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -61,6 +61,7 @@ static int xfs_stat_proc_show(struct seq_file *m, void *v)
 		{ "ibt2",		XFSSTAT_END_IBT_V2		},
 		{ "fibt2",		XFSSTAT_END_FIBT_V2		},
 		{ "rmapbt",		XFSSTAT_END_RMAP_V2		},
+		{ "refcntbt",		XFSSTAT_END_REFCOUNT		},
 		/* we print both series of quota information together */
 		{ "qm",			XFSSTAT_END_QM			},
 	};
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 8414db2..f6e4de6 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -215,7 +215,23 @@ struct xfsstats {
 	__uint32_t		xs_rmap_2_alloc;
 	__uint32_t		xs_rmap_2_free;
 	__uint32_t		xs_rmap_2_moves;
-#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_RMAP_V2+6)
+#define XFSSTAT_END_REFCOUNT		(XFSSTAT_END_RMAP_V2 + 15)
+	__uint32_t		xs_refcbt_2_lookup;
+	__uint32_t		xs_refcbt_2_compare;
+	__uint32_t		xs_refcbt_2_insrec;
+	__uint32_t		xs_refcbt_2_delrec;
+	__uint32_t		xs_refcbt_2_newroot;
+	__uint32_t		xs_refcbt_2_killroot;
+	__uint32_t		xs_refcbt_2_increment;
+	__uint32_t		xs_refcbt_2_decrement;
+	__uint32_t		xs_refcbt_2_lshift;
+	__uint32_t		xs_refcbt_2_rshift;
+	__uint32_t		xs_refcbt_2_split;
+	__uint32_t		xs_refcbt_2_join;
+	__uint32_t		xs_refcbt_2_alloc;
+	__uint32_t		xs_refcbt_2_free;
+	__uint32_t		xs_refcbt_2_moves;
+#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_REFCOUNT + 6)
 	__uint32_t		xs_qm_dqreclaims;
 	__uint32_t		xs_qm_dqreclaim_misses;
 	__uint32_t		xs_qm_dquot_dups;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
