Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE45729E08
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:06:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DFB58F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:06:32 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 0hCdmcWVPEljUDS0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:06:29 -0800 (PST)
Subject: [PATCH 15/53] libxfs: piggyback rmapbt update intents in the bmap
	free structure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:06:26 -0800
Message-ID: <20151219090626.14255.78989.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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
 include/libxfs.h         |    3 ++-
 libxfs/util.c            |    9 +++++----
 libxfs/xfs_attr.c        |   18 +++++++++---------
 libxfs/xfs_attr_remote.c |    4 ++--
 libxfs/xfs_bmap.c        |    4 ++--
 libxfs/xfs_bmap.h        |   13 ++++++++++++-
 mkfs/proto.c             |   12 ++++++------
 repair/phase6.c          |   24 ++++++++++++------------
 8 files changed, 50 insertions(+), 37 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 7d1ad46..2357aec 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -165,7 +165,8 @@ extern unsigned int	libxfs_log2_roundup(unsigned int i);
 
 extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
 				xfs_off_t, int, int);
-extern int	libxfs_bmap_finish(xfs_trans_t **, xfs_bmap_free_t *, int *);
+extern int	libxfs_bmap_finish(xfs_trans_t **, xfs_bmap_free_t *, int *,
+				struct xfs_inode *ip);
 
 extern void 	libxfs_fs_repair_cmn_err(int, struct xfs_mount *, char *, ...);
 extern void	libxfs_fs_cmn_err(int, struct xfs_mount *, char *, ...);
diff --git a/libxfs/util.c b/libxfs/util.c
index 0609ba4..19d5e0e 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -491,9 +491,10 @@ libxfs_mod_incore_sb(
 
 int
 libxfs_bmap_finish(
-	xfs_trans_t	**tp,
-	xfs_bmap_free_t *flist,
-	int		*committed)
+	xfs_trans_t		**tp,
+	xfs_bmap_free_t		*flist,
+	int			*committed,
+	struct xfs_inode	*ip)
 {
 	xfs_bmap_free_item_t	*free;	/* free extent list item */
 	xfs_bmap_free_item_t	*next;	/* next item on free list */
@@ -586,7 +587,7 @@ libxfs_alloc_file_space(
 			goto error0;
 
 		/* complete the transaction */
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, &committed, ip);
 		if (error)
 			goto error0;
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index bdde0f6..083a14c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -329,7 +329,7 @@ xfs_attr_set(
 		error = xfs_attr_shortform_to_leaf(&args);
 		if (!error) {
 			error = xfs_bmap_finish(&args.trans, args.flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -623,7 +623,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		error = xfs_attr3_leaf_to_node(args);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -725,7 +725,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							&committed);
+							&committed, dp);
 			}
 			if (error) {
 				ASSERT(committed);
@@ -798,7 +798,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -934,7 +934,7 @@ restart:
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							&committed);
+							&committed, dp);
 			}
 			if (error) {
 				ASSERT(committed);
@@ -972,7 +972,7 @@ restart:
 		error = xfs_da3_split(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -1082,7 +1082,7 @@ restart:
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							&committed);
+							&committed, dp);
 			}
 			if (error) {
 				ASSERT(committed);
@@ -1215,7 +1215,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 		error = xfs_da3_join(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -1261,7 +1261,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
-							&committed);
+							&committed, dp);
 			}
 			if (error) {
 				ASSERT(committed);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 95383e3..ac64009 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -464,7 +464,7 @@ xfs_attr_rmtval_set(
 				  args->total, &map, &nmap, args->flist);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, dp);
 		}
 		if (error) {
 			ASSERT(committed);
@@ -618,7 +618,7 @@ xfs_attr_rmtval_remove(
 				    args->flist, &done);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						&committed, args->dp);
 		}
 		if (error) {
 			ASSERT(committed);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 785d10a..9595971 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1190,7 +1190,7 @@ xfs_bmap_add_attrfork(
 			xfs_log_sb(tp);
 	}
 
-	error = xfs_bmap_finish(&tp, &flist, &committed);
+	error = xfs_bmap_finish(&tp, &flist, &committed, NULL);
 	if (error)
 		goto bmap_cancel;
 	error = xfs_trans_commit(tp);
@@ -5918,7 +5918,7 @@ xfs_bmap_split_extent(
 	if (error)
 		goto out;
 
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
 	if (error)
 		goto out;
 
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index d3daf6d..722f36c 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -56,6 +56,7 @@ struct xfs_bmalloca {
 	bool			aeof;	/* allocated space at eof */
 	bool			conv;	/* overwriting unwritten extents */
 	int			flags;
+	struct xfs_rmap_list	*rlist;
 };
 
 /*
@@ -69,6 +70,13 @@ typedef struct xfs_bmap_free_item
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
@@ -88,6 +96,7 @@ typedef	struct xfs_bmap_free
 	xfs_bmap_free_item_t	*xbf_first;	/* list of to-be-free extents */
 	int			xbf_count;	/* count of items on list */
 	int			xbf_low;	/* alloc in low mode */
+	struct xfs_rmap_list	xbf_rlist;	/* rmap intent list */
 } xfs_bmap_free_t;
 
 #define	XFS_BMAP_MAX_NMAP	4
@@ -134,6 +143,8 @@ static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 {
 	((flp)->xbf_first = NULL, (flp)->xbf_count = 0, \
 		(flp)->xbf_low = 0, *(fbp) = NULLFSBLOCK);
+	flp->xbf_rlist.rl_first = NULL;
+	flp->xbf_rlist.rl_count = 0;
 }
 
 /*
@@ -186,7 +197,7 @@ void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
 			  xfs_fsblock_t bno, xfs_filblks_t len);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
-			int *committed);
+			int *committed, struct xfs_inode *ip);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
diff --git a/mkfs/proto.c b/mkfs/proto.c
index cb34b28..c7e94e3 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -481,7 +481,7 @@ parseproto(
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_log_inode(tp, ip, flags);
 
-		error = -libxfs_bmap_finish(&tp, &flist, &committed);
+		error = -libxfs_bmap_finish(&tp, &flist, &committed, ip);
 		if (error)
 			fail(_("Pre-allocated file creation failed"), error);
 		libxfs_trans_commit(tp);
@@ -563,7 +563,7 @@ parseproto(
 		}
 		newdirectory(mp, tp, ip, pip);
 		libxfs_trans_log_inode(tp, ip, flags);
-		error = -libxfs_bmap_finish(&tp, &flist, &committed);
+		error = -libxfs_bmap_finish(&tp, &flist, &committed, ip);
 		if (error)
 			fail(_("Directory creation failed"), error);
 		libxfs_trans_commit(tp);
@@ -589,7 +589,7 @@ parseproto(
 		fail(_("Unknown format"), EINVAL);
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, &committed, ip);
 	if (error) {
 		fail(_("Error encountered creating file from prototype file"),
 			error);
@@ -700,7 +700,7 @@ rtinit(
 		}
 	}
 
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, &committed, rbmip);
 	if (error) {
 		fail(_("Completion of the realtime bitmap failed"), error);
 	}
@@ -735,7 +735,7 @@ rtinit(
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, &committed, rsumip);
 	if (error) {
 		fail(_("Completion of the realtime summary failed"), error);
 	}
@@ -759,7 +759,7 @@ rtinit(
 			fail(_("Error initializing the realtime space"),
 				error);
 		}
-		error = -libxfs_bmap_finish(&tp, &flist, &committed);
+		error = -libxfs_bmap_finish(&tp, &flist, &committed, rbmip);
 		if (error) {
 			fail(_("Error completing the realtime space"), error);
 		}
diff --git a/repair/phase6.c b/repair/phase6.c
index e41bf20..e7b2387 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -578,7 +578,7 @@ mk_rbmino(xfs_mount_t *mp)
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, &committed, ip);
 	if (error) {
 		do_error(
 		_("allocation of the realtime bitmap failed, error = %d\n"),
@@ -843,7 +843,7 @@ mk_rsumino(xfs_mount_t *mp)
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, &committed, ip);
 	if (error) {
 		do_error(
 	_("allocation of the realtime summary ino failed, error = %d\n"),
@@ -1059,7 +1059,7 @@ mk_orphanage(xfs_mount_t *mp)
 	libxfs_dir_init(tp, ip, pip);
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, &committed, pip);
 	if (error) {
 		do_error(_("%s directory creation failed -- bmapf error %d\n"),
 			ORPHANAGE, error);
@@ -1168,7 +1168,7 @@ mv_orphanage(
 			ino_p->i_d.di_nlink++;
 			libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 
-			err = -libxfs_bmap_finish(&tp, &flist, &committed);
+			err = -libxfs_bmap_finish(&tp, &flist, &committed, ino_p);
 			if (err)
 				do_error(
 	_("bmap finish failed (err - %d), filesystem may be out of space\n"),
@@ -1215,7 +1215,7 @@ mv_orphanage(
 						err);
 			}
 
-			err = -libxfs_bmap_finish(&tp, &flist, &committed);
+			err = -libxfs_bmap_finish(&tp, &flist, &committed, ino_p);
 			if (err)
 				do_error(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1254,7 +1254,7 @@ mv_orphanage(
 		ino_p->i_d.di_nlink = 1;
 		libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 
-		err = -libxfs_bmap_finish(&tp, &flist, &committed);
+		err = -libxfs_bmap_finish(&tp, &flist, &committed, orphanage_ip);
 		if (err)
 			do_error(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1356,7 +1356,7 @@ longform_dir2_rebuild(
 		goto out_bmap_cancel;
 	}
 
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, &committed, ip);
 
 	libxfs_trans_commit(tp);
 
@@ -1391,7 +1391,7 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
 			goto out_bmap_cancel;
 		}
 
-		error = -libxfs_bmap_finish(&tp, &flist, &committed);
+		error = -libxfs_bmap_finish(&tp, &flist, &committed, ip);
 		if (error) {
 			do_warn(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1453,7 +1453,7 @@ dir2_kill_block(
 	if (error)
 		do_error(_("shrink_inode failed inode %" PRIu64 " block %u\n"),
 			ip->i_ino, da_bno);
-	libxfs_bmap_finish(&tp, &flist, &committed);
+	libxfs_bmap_finish(&tp, &flist, &committed, ip);
 	libxfs_trans_commit(tp);
 }
 
@@ -1930,7 +1930,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 		libxfs_dir2_data_freescan(mp->m_dir_geo, M_DIROPS(mp), d, &i);
 	if (needlog)
 		libxfs_dir2_data_log_header(&da, bp);
-	libxfs_bmap_finish(&tp, &flist, &committed);
+	libxfs_bmap_finish(&tp, &flist, &committed, ip);
 	libxfs_trans_commit(tp);
 
 	/* record the largest free space in the freetab for later checking */
@@ -2996,7 +2996,7 @@ process_dir_inode(
 
 		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-		error = -libxfs_bmap_finish(&tp, &flist, &committed);
+		error = -libxfs_bmap_finish(&tp, &flist, &committed, ip);
 		ASSERT(error == 0);
 		libxfs_trans_commit(tp);
 
@@ -3057,7 +3057,7 @@ process_dir_inode(
 
 			libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-			error = -libxfs_bmap_finish(&tp, &flist, &committed);
+			error = -libxfs_bmap_finish(&tp, &flist, &committed, ip);
 			ASSERT(error == 0);
 			libxfs_trans_commit(tp);
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
