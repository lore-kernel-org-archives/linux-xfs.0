Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932719AbeF1Qgh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:37 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0DB2A2CCC
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:36 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA0CC111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 02/24] xfs: rename xfs_trans ->t_agfl_dfops to ->t_dfops
Date: Thu, 28 Jun 2018 12:36:14 -0400
Message-Id: <20180628163636.52564-3-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The ->t_agfl_dfops field is currently used to defer agfl block frees
from associated transaction contexts. While all known problematic
contexts have already been updated to use ->t_agfl_dfops, the
broader goal is defer agfl frees from all callers that already use a
deferred operations structure. Further, the transaction field
facilitates a good amount of code clean up where the transaction and
dfops have historically been passed down through the stack
separately.

Rename the field to something more generic to prepare to use it as
such throughout XFS. This patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  4 ++--
 fs/xfs/libxfs/xfs_defer.c |  8 ++++----
 fs/xfs/xfs_inode.c        | 10 +++++-----
 fs/xfs/xfs_symlink.c      |  2 +-
 fs/xfs/xfs_trans.c        |  6 +++---
 fs/xfs/xfs_trans.h        |  2 +-
 6 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index eef466260d43..5b1607d76fe9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2323,8 +2323,8 @@ xfs_alloc_fix_freelist(
 			goto out_agbp_relse;
 
 		/* defer agfl frees if dfops is provided */
-		if (tp->t_agfl_dfops) {
-			xfs_defer_agfl_block(mp, tp->t_agfl_dfops, args->agno,
+		if (tp->t_dfops) {
+			xfs_defer_agfl_block(mp, tp->t_dfops, args->agno,
 					     bno, &targs.oinfo);
 		} else {
 			error = xfs_free_agfl_block(tp, args->agno, bno, agbp,
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index c3e5bffda4f5..560a7d178c1e 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -350,9 +350,9 @@ xfs_defer_finish(
 	 * Note that this code can go away once all dfops users attach to the
 	 * associated tp.
 	 */
-	ASSERT(!(*tp)->t_agfl_dfops || ((*tp)->t_agfl_dfops == dop));
-	orig_dop = (*tp)->t_agfl_dfops;
-	(*tp)->t_agfl_dfops = dop;
+	ASSERT(!(*tp)->t_dfops || ((*tp)->t_dfops == dop));
+	orig_dop = (*tp)->t_dfops;
+	(*tp)->t_dfops = dop;
 
 	/* Until we run out of pending work to finish... */
 	while (xfs_defer_has_unfinished_work(dop)) {
@@ -425,7 +425,7 @@ xfs_defer_finish(
 	}
 
 out:
-	(*tp)->t_agfl_dfops = orig_dop;
+	(*tp)->t_dfops = orig_dop;
 	if (error)
 		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
 	else
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5df4de666cc1..9c5fbc94cf14 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1196,7 +1196,7 @@ xfs_create(
 	unlock_dp_on_error = true;
 
 	xfs_defer_init(&dfops, &first_block);
-	tp->t_agfl_dfops = &dfops;
+	tp->t_dfops = &dfops;
 
 	/*
 	 * Reserve disk quota and the inode.
@@ -1452,7 +1452,7 @@ xfs_link(
 	}
 
 	xfs_defer_init(&dfops, &first_block);
-	tp->t_agfl_dfops = &dfops;
+	tp->t_dfops = &dfops;
 
 	/*
 	 * Handle initial link state of O_TMPFILE inode
@@ -1813,7 +1813,7 @@ xfs_inactive_ifree(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	xfs_defer_init(&dfops, &first_block);
-	tp->t_agfl_dfops = &dfops;
+	tp->t_dfops = &dfops;
 	error = xfs_ifree(tp, ip, &dfops);
 	if (error) {
 		/*
@@ -2659,7 +2659,7 @@ xfs_remove(
 		goto out_trans_cancel;
 
 	xfs_defer_init(&dfops, &first_block);
-	tp->t_agfl_dfops = &dfops;
+	tp->t_dfops = &dfops;
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
 					&first_block, &dfops, resblks);
 	if (error) {
@@ -3027,7 +3027,7 @@ xfs_rename(
 	}
 
 	xfs_defer_init(&dfops, &first_block);
-	tp->t_agfl_dfops = &dfops;
+	tp->t_dfops = &dfops;
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 3783afcb68d2..44335bdebea2 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -247,7 +247,7 @@ xfs_symlink(
 	 * bmapi or the directory create code.
 	 */
 	xfs_defer_init(&dfops, &first_block);
-	tp->t_agfl_dfops = &dfops;
+	tp->t_dfops = &dfops;
 
 	/*
 	 * Allocate an inode for the symlink.
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 524f543c5b82..630993387517 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -118,7 +118,7 @@ xfs_trans_dup(
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
 	ntp->t_pflags = tp->t_pflags;
-	ntp->t_agfl_dfops = tp->t_agfl_dfops;
+	ntp->t_dfops = tp->t_dfops;
 
 	xfs_trans_dup_dqinfo(tp, ntp);
 
@@ -914,8 +914,8 @@ __xfs_trans_commit(
 	int			error = 0;
 	int			sync = tp->t_flags & XFS_TRANS_SYNC;
 
-	ASSERT(!tp->t_agfl_dfops ||
-	       !xfs_defer_has_unfinished_work(tp->t_agfl_dfops) || regrant);
+	ASSERT(!tp->t_dfops ||
+	       !xfs_defer_has_unfinished_work(tp->t_dfops) || regrant);
 
 	trace_xfs_trans_commit(tp, _RET_IP_);
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6526314f0b8f..d8a695c57103 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -105,7 +105,7 @@ typedef struct xfs_trans {
 	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
 	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
-	struct xfs_defer_ops	*t_agfl_dfops;	/* optional agfl fixup dfops */
+	struct xfs_defer_ops	*t_dfops;	/* dfops reference */
 	unsigned int		t_flags;	/* misc flags */
 	int64_t			t_icount_delta;	/* superblock icount change */
 	int64_t			t_ifree_delta;	/* superblock ifree change */
-- 
2.17.1

