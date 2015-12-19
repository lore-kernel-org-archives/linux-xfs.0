Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3D2FB7FFF
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:59:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1045B8F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:32 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id M7cunqMjyYHWUXF1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:29 -0800 (PST)
Subject: [PATCH 28/76] xfs: piggyback rmapbt update intents in the bmap free
	structure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:59:25 -0800
Message-ID: <20151219085925.12713.15426.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Extend the xfs_bmap_free structure to track a list of rmapbt update
intents.  In a subsequent patch, we'll defer all data fork rmapbt
edits until we're done making changes to the bmbt, at which point we
can replay the rmap edits in order of increasing AG number.  This
enables us to avoid deadlocks by complying with AG lock ordering
rules.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        |   18 +++++++++---------
 fs/xfs/libxfs/xfs_attr_remote.c |    4 ++--
 fs/xfs/libxfs/xfs_bmap.c        |    4 ++--
 fs/xfs/libxfs/xfs_bmap.h        |   13 ++++++++++++-
 fs/xfs/xfs_bmap_util.c          |   10 ++++++----
 fs/xfs/xfs_dquot.c              |    4 ++--
 fs/xfs/xfs_inode.c              |   12 ++++++------
 fs/xfs/xfs_iomap.c              |    7 ++++---
 fs/xfs/xfs_rtalloc.c            |    2 +-
 fs/xfs/xfs_symlink.c            |    4 ++--
 10 files changed, 46 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f949818..ea49e6f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -336,7 +336,7 @@ xfs_attr_set(
 		error = xfs_attr_shortform_to_leaf(&args);
 		if (!error) {
 			error = xfs_bmap_finish(&args.trans, args.flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -630,7 +630,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		error = xfs_attr3_leaf_to_node(args);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -732,7 +732,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							&committed);
+							&committed, dp);
 			}
 			if (error) {
 				ASSERT(committed);
@@ -805,7 +805,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -941,7 +941,7 @@ restart:
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							&committed);
+							&committed, dp);
 			}
 			if (error) {
 				ASSERT(committed);
@@ -979,7 +979,7 @@ restart:
 		error = xfs_da3_split(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -1089,7 +1089,7 @@ restart:
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							&committed);
+							&committed, dp);
 			}
 			if (error) {
 				ASSERT(committed);
@@ -1222,7 +1222,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 		error = xfs_da3_join(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -1268,7 +1268,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							&committed);
+							&committed, dp);
 			}
 			if (error) {
 				ASSERT(committed);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 5ab95ff..d0d1fd2 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -468,7 +468,7 @@ xfs_attr_rmtval_set(
 				  args->total, &map, &nmap, args->flist);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -622,7 +622,7 @@ xfs_attr_rmtval_remove(
 				    args->flist, &done);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, args->dp);
 		}
 		if (error) {
 			ASSERT(committed);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9fd02de..dfc634a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1208,7 +1208,7 @@ xfs_bmap_add_attrfork(
 			xfs_log_sb(tp);
 	}
 
-	error = xfs_bmap_finish(&tp, &flist, &committed);
+	error = xfs_bmap_finish(&tp, &flist, &committed, NULL);
 	if (error)
 		goto bmap_cancel;
 	error = xfs_trans_commit(tp);
@@ -5967,7 +5967,7 @@ xfs_bmap_split_extent(
 	if (error)
 		goto out;
 
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e7cd789..fcea496 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -56,6 +56,7 @@ struct xfs_bmalloca {
 	bool			conv;	/* overwriting unwritten extents */
 	char			userdata;/* userdata mask */
 	int			flags;
+	struct xfs_rmap_list	*rlist;
 };
 
 /*
@@ -70,6 +71,13 @@ typedef struct xfs_bmap_free_item
 	struct xfs_bmap_free_item *xbfi_next;	/* link to next entry */
 } xfs_bmap_free_item_t;
 
+struct xfs_rmap_intent;
+
+struct xfs_rmap_list {
+	struct xfs_rmap_intent			*rl_first;
+	unsigned int				rl_count;
+};
+
 /*
  * Header for free extent list.
  *
@@ -89,6 +97,7 @@ typedef	struct xfs_bmap_free
 	xfs_bmap_free_item_t	*xbf_first;	/* list of to-be-free extents */
 	int			xbf_count;	/* count of items on list */
 	int			xbf_low;	/* alloc in low mode */
+	struct xfs_rmap_list	xbf_rlist;	/* rmap intent list */
 } xfs_bmap_free_t;
 
 #define	XFS_BMAP_MAX_NMAP	4
@@ -144,6 +153,8 @@ static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 {
 	((flp)->xbf_first = NULL, (flp)->xbf_count = 0, \
 		(flp)->xbf_low = 0, *(fbp) = NULLFSBLOCK);
+	flp->xbf_rlist.rl_first = NULL;
+	flp->xbf_rlist.rl_count = 0;
 }
 
 /*
@@ -197,7 +208,7 @@ void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
 			  struct xfs_owner_info *oinfo);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
-			int *committed);
+			int *committed, struct xfs_inode *ip);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0543779..b8dfa93 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -40,6 +40,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_log.h"
+#include "xfs_rmap_btree.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -98,7 +99,8 @@ int						/* error */
 xfs_bmap_finish(
 	struct xfs_trans		**tp,	/* transaction pointer addr */
 	struct xfs_bmap_free		*flist,	/* i/o: list extents to free */
-	int				*committed)/* xact committed or not */
+	int				*committed,/* xact committed or not */
+	struct xfs_inode		*ip)	/* inode to join with rmap transaction */
 {
 	struct xfs_efd_log_item		*efd;	/* extent free data */
 	struct xfs_efi_log_item		*efi;	/* extent free intention */
@@ -1072,7 +1074,7 @@ xfs_alloc_file_space(
 		/*
 		 * Complete the transaction
 		 */
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
 		if (error) {
 			goto error0;
 		}
@@ -1354,7 +1356,7 @@ xfs_free_file_space(
 		/*
 		 * complete the transaction
 		 */
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
 		if (error) {
 			goto error0;
 		}
@@ -1527,7 +1529,7 @@ xfs_shift_file_space(
 		if (error)
 			goto out_bmap_cancel;
 
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
 		if (error)
 			goto out_bmap_cancel;
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7ac6c5c..8c7c9fb 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -379,9 +379,9 @@ xfs_qm_dqalloc(
 
 	xfs_trans_bhold(tp, bp);
 
-	if ((error = xfs_bmap_finish(tpp, &flist, &committed))) {
+	error = xfs_bmap_finish(tpp, &flist, &committed, NULL);
+	if (error)
 		goto error1;
-	}
 
 	if (committed) {
 		tp = *tpp;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8ee3939..55a7e00 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1275,7 +1275,7 @@ xfs_create(
 	 */
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -1506,7 +1506,7 @@ xfs_link(
 		xfs_trans_set_sync(tp);
 	}
 
-	error = xfs_bmap_finish (&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
 	if (error) {
 		xfs_bmap_cancel(&free_list);
 		goto error_return;
@@ -1601,7 +1601,7 @@ xfs_itruncate_extents(
 		 * Duplicate the transaction that has the permanent
 		 * reservation and commit the old transaction.
 		 */
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, &committed, ip);
 		if (committed)
 			xfs_trans_ijoin(tp, ip, 0);
 		if (error)
@@ -1841,7 +1841,7 @@ xfs_inactive_ifree(
 	 * Just ignore errors at this point.  There is nothing we can do except
 	 * to try to keep going. Make sure it's not a silent error.
 	 */
-	error = xfs_bmap_finish(&tp,  &free_list, &committed);
+	error = xfs_bmap_finish(&tp,  &free_list, &committed, NULL);
 	if (error) {
 		xfs_notice(mp, "%s: xfs_bmap_finish returned error %d",
 			__func__, error);
@@ -2624,7 +2624,7 @@ xfs_remove(
 	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
 		xfs_trans_set_sync(tp);
 
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -2711,7 +2711,7 @@ xfs_finish_rename(
 	if (tp->t_mountp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
 		xfs_trans_set_sync(tp);
 
-	error = xfs_bmap_finish(&tp, free_list, &committed);
+	error = xfs_bmap_finish(&tp, free_list, &committed, NULL);
 	if (error) {
 		xfs_bmap_cancel(free_list);
 		xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f4f5b43..96dcaeb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -247,7 +247,7 @@ xfs_iomap_write_direct(
 	/*
 	 * Complete the transaction
 	 */
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -794,7 +794,8 @@ xfs_iomap_write_allocate(
 			if (error)
 				goto trans_cancel;
 
-			error = xfs_bmap_finish(&tp, &free_list, &committed);
+			error = xfs_bmap_finish(&tp, &free_list, &committed,
+					NULL);
 			if (error)
 				goto trans_cancel;
 
@@ -924,7 +925,7 @@ xfs_iomap_write_unwritten(
 			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		}
 
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ab1bac6..96db032 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -811,7 +811,7 @@ xfs_growfs_rt_alloc(
 		/*
 		 * Free any blocks freed up in the transaction, then commit.
 		 */
-		error = xfs_bmap_finish(&tp, &flist, &committed);
+		error = xfs_bmap_finish(&tp, &flist, &committed, NULL);
 		if (error)
 			goto out_bmap_cancel;
 		error = xfs_trans_commit(tp);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 996481e..6303362 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -387,7 +387,7 @@ xfs_symlink(
 		xfs_trans_set_sync(tp);
 	}
 
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -510,7 +510,7 @@ xfs_inactive_symlink_rmt(
 	/*
 	 * Commit the first transaction.  This logs the EFI and the inode.
 	 */
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed, ip);
 	if (error)
 		goto error_bmap_cancel;
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
