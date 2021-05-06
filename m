Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCB0C4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A7C361077
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhEFHWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 03:22:01 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51090 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233380AbhEFHV7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 03:21:59 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 262DB5EC156
        for <linux-xfs@vger.kernel.org>; Thu,  6 May 2021 17:20:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-005loZ-Mg
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-00197t-EY
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 19/22] xfs: get rid of xfs_dir_ialloc()
Date:   Thu,  6 May 2021 17:20:51 +1000
Message-Id: <20210506072054.271157-20-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210506072054.271157-1-david@fromorbit.com>
References: <20210506072054.271157-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=wL4K8bCONkw7ZEPnSG0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is just a simple wrapper around the per-ag inode allocation
that doesn't need to exist. The internal mechanism to select and
allocate within an AG does not need to be exposed outside
xfs_ialloc.c, and it being exposed simply makes it harder to follow
the code and simplify it.

This is simplified by internalising xf_dialloc_select_ag() and
xfs_dialloc_ag() into a single xfs_dialloc() function and then
xfs_dir_ialloc() can go away.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 15 +++++----
 fs/xfs/libxfs/xfs_ialloc.h | 27 +++-------------
 fs/xfs/xfs_inode.c         | 66 +++++++-------------------------------
 fs/xfs/xfs_inode.h         |  9 +++---
 fs/xfs/xfs_qm.c            |  9 ++++--
 fs/xfs/xfs_symlink.c       |  9 ++++--
 6 files changed, 43 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b22556556bba..2c0ef2dd46d9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1602,24 +1602,23 @@ xfs_ialloc_next_ag(
  * can be allocated, -ENOSPC be returned.
  */
 int
-xfs_dialloc_select_ag(
+xfs_dialloc(
 	struct xfs_trans	**tpp,
 	xfs_ino_t		parent,
 	umode_t			mode,
-	struct xfs_buf		**IO_agbp)
+	xfs_ino_t		*new_ino)
 {
 	struct xfs_mount	*mp = (*tpp)->t_mountp;
 	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
-	int			error;
+	int			error = 0;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	bool			okalloc = true;
 	int			needspace;
 	int			flags;
-
-	*IO_agbp = NULL;
+	xfs_ino_t		ino;
 
 	/*
 	 * Files of these types need at least one block if length > 0
@@ -1763,7 +1762,11 @@ xfs_dialloc_select_ag(
 	return error ? error : -ENOSPC;
 found_ag:
 	xfs_perag_put(pag);
-	*IO_agbp = agbp;
+	/* Allocate an inode in the found AG */
+	error = xfs_dialloc_ag(*tpp, agbp, parent, &ino);
+	if (error)
+		return error;
+	*new_ino = ino;
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 3511086a7ae1..886f6748fb22 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -33,30 +33,11 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 }
 
 /*
- * Allocate an inode on disk.
- * Mode is used to tell whether the new inode will need space, and whether
- * it is a directory.
- *
- * There are two phases to inode allocation: selecting an AG and ensuring
- * that it contains free inodes, followed by allocating one of the free
- * inodes. xfs_dialloc_select_ag() does the former and returns a locked AGI
- * to the caller, ensuring that followup call to xfs_dialloc_ag() will
- * have free inodes to allocate from. xfs_dialloc_ag() will return the inode
- * number of the free inode we allocated.
+ * Allocate an inode on disk.  Mode is used to tell whether the new inode will
+ * need space, and whether it is a directory.
  */
-int					/* error */
-xfs_dialloc_select_ag(
-	struct xfs_trans **tpp,		/* double pointer of transaction */
-	xfs_ino_t	parent,		/* parent inode (directory) */
-	umode_t		mode,		/* mode bits for new inode */
-	struct xfs_buf	**IO_agbp);
-
-int
-xfs_dialloc_ag(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	xfs_ino_t		parent,
-	xfs_ino_t		*inop);
+int xfs_dialloc(struct xfs_trans **tpp, xfs_ino_t parent, umode_t mode,
+		xfs_ino_t *new_ino);
 
 /*
  * Free disk inode.  Carefully avoids touching the incore inode, all
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3918c99fa95b..26668b6846e2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -749,7 +749,7 @@ xfs_inode_inherit_flags2(
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
  */
-static int
+int
 xfs_init_new_inode(
 	struct user_namespace	*mnt_userns,
 	struct xfs_trans	*tp,
@@ -885,54 +885,6 @@ xfs_init_new_inode(
 	return 0;
 }
 
-/*
- * Allocates a new inode from disk and return a pointer to the incore copy. This
- * routine will internally commit the current transaction and allocate a new one
- * if we needed to allocate more on-disk free inodes to perform the requested
- * operation.
- *
- * If we are allocating quota inodes, we do not have a parent inode to attach to
- * or associate with (i.e. dp == NULL) because they are not linked into the
- * directory structure - they are attached directly to the superblock - and so
- * have no parent.
- */
-int
-xfs_dir_ialloc(
-	struct user_namespace	*mnt_userns,
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*dp,
-	umode_t			mode,
-	xfs_nlink_t		nlink,
-	dev_t			rdev,
-	prid_t			prid,
-	bool			init_xattrs,
-	struct xfs_inode	**ipp)
-{
-	struct xfs_buf		*agibp;
-	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
-	xfs_ino_t		ino;
-	int			error;
-
-	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
-
-	/*
-	 * Call the space management code to pick the on-disk inode to be
-	 * allocated.
-	 */
-	error = xfs_dialloc_select_ag(tpp, parent_ino, mode, &agibp);
-	if (error)
-		return error;
-
-	/* Allocate an inode from the selected AG */
-	error = xfs_dialloc_ag(*tpp, agibp, parent_ino, &ino);
-	if (error)
-		return error;
-	ASSERT(ino != NULLFSINO);
-
-	return xfs_init_new_inode(mnt_userns, *tpp, dp, ino, mode, nlink, rdev,
-				  prid, init_xattrs, ipp);
-}
-
 /*
  * Decrement the link count on an inode & log the change.  If this causes the
  * link count to go to zero, move the inode to AGI unlinked list so that it can
@@ -990,6 +942,7 @@ xfs_create(
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
 	uint			resblks;
+	xfs_ino_t		ino;
 
 	trace_xfs_create(dp, name);
 
@@ -1046,14 +999,16 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dir_ialloc(mnt_userns, &tp, dp, mode, is_dir ? 2 : 1, rdev,
-			       prid, init_xattrs, &ip);
+	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
+	if (!error)
+		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
+				is_dir ? 2 : 1, rdev, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
 	/*
 	 * Now we join the directory inode to the transaction.  We do not do it
-	 * earlier because xfs_dir_ialloc might commit the previous transaction
+	 * earlier because xfs_dialloc might commit the previous transaction
 	 * (and release all the locks).  An error from here on will result in
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
@@ -1143,6 +1098,7 @@ xfs_create_tmpfile(
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
 	uint			resblks;
+	xfs_ino_t		ino;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -1167,8 +1123,10 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_release_dquots;
 
-	error = xfs_dir_ialloc(mnt_userns, &tp, dp, mode, 0, 0, prid,
-				false, &ip);
+	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
+	if (!error)
+		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
+				0, 0, prid, false, &ip);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ca826cfba91c..4b6703dbffb8 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -431,11 +431,10 @@ void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
 xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
 
-int		xfs_dir_ialloc(struct user_namespace *mnt_userns,
-			       struct xfs_trans **tpp, struct xfs_inode *dp,
-			       umode_t mode, xfs_nlink_t nlink, dev_t dev,
-			       prid_t prid, bool need_xattr,
-			       struct xfs_inode **ipp);
+int xfs_init_new_inode(struct user_namespace *mnt_userns, struct xfs_trans *tp,
+		struct xfs_inode *pip, xfs_ino_t ino, umode_t mode,
+		xfs_nlink_t nlink, dev_t rdev, prid_t prid, bool init_xattrs,
+		struct xfs_inode **ipp);
 
 static inline int
 xfs_itruncate_extents(
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f7baf4dc2554..fe341f3fd419 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -24,6 +24,7 @@
 #include "xfs_icache.h"
 #include "xfs_error.h"
 #include "xfs_ag.h"
+#include "xfs_ialloc.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -788,8 +789,12 @@ xfs_qm_qino_alloc(
 		return error;
 
 	if (need_alloc) {
-		error = xfs_dir_ialloc(&init_user_ns, &tp, NULL, S_IFREG, 1, 0,
-				       0, false, ipp);
+		xfs_ino_t	ino;
+
+		error = xfs_dialloc(&tp, 0, S_IFREG, &ino);
+		if (!error)
+			error = xfs_init_new_inode(&init_user_ns, tp, NULL, ino,
+					S_IFREG, 1, 0, 0, false, ipp);
 		if (error) {
 			xfs_trans_cancel(tp);
 			return error;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index b4fa70282383..44596c31f4c9 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -21,6 +21,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_ialloc.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -161,6 +162,7 @@ xfs_symlink(
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
+	xfs_ino_t		ino;
 
 	*ipp = NULL;
 
@@ -223,8 +225,11 @@ xfs_symlink(
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-	error = xfs_dir_ialloc(mnt_userns, &tp, dp, S_IFLNK | (mode & ~S_IFMT),
-			       1, 0, prid, false, &ip);
+	error = xfs_dialloc(&tp, dp->i_ino, S_IFLNK, &ino);
+	if (!error)
+		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
+				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
+				false, &ip);
 	if (error)
 		goto out_trans_cancel;
 
-- 
2.31.1

