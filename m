Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728667AbeGYMXh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 08:23:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D2FF840216E2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 11:12:25 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA9442166BA3
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 11:12:25 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 15/15] xfs: bypass final dfops roll in trans commit path
Date: Wed, 25 Jul 2018 07:12:25 -0400
Message-Id: <20180725111225.3481-1-bfoster@redhat.com>
In-Reply-To: <20180723130414.47980-16-bfoster@redhat.com>
References: <20180723130414.47980-16-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Once xfs_defer_finish() has completed all deferred operations, it
checks the dirty state of the transaction and rolls it once more to
return a clean transaction for the caller. This primarily to cover
the case where repeated xfs_defer_finish() calls are made in a loop
and we need to make sure that the caller starts the next iteration
with a clean transaction. Otherwise we risk transaction reservation
overrun.

This final transaction roll is not required in the transaction
commit path, however, because the transaction is immediately
committed and freed after dfops completion. Refactor the final roll
into a separate helper such that we can avoid it in the transaction
commit path.  Lift the dfops reset as well so dfops remains valid
until after the last call to xfs_defer_trans_roll(). The reset is
also unnecessary in the transaction commit path because the
transaction is about to complete.

This eliminates unnecessary regrants of transactions where the
associated transaction roll can be replaced by a transaction commit.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

v3:
- Refactor xfs_defer_finish() error handling logic.

 fs/xfs/libxfs/xfs_defer.c | 38 +++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_defer.h |  1 +
 fs/xfs/xfs_trans.c        |  2 +-
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index cbee0a86c978..a5f7dc18a62f 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -341,7 +341,7 @@ xfs_defer_reset(
  * If an inode is provided, relog it to the new transaction.
  */
 int
-xfs_defer_finish(
+xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
 	struct xfs_defer_ops		*dop = (*tp)->t_dfops;
@@ -430,25 +430,37 @@ xfs_defer_finish(
 			cleanup_fn(*tp, state, error);
 	}
 
-	/*
-	 * Roll the transaction once more to avoid returning to the caller
-	 * with a dirty transaction.
-	 */
-	if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
-		error = xfs_defer_trans_roll(tp);
-		dop = (*tp)->t_dfops;
-	}
 out:
-	if (error) {
+	if (error)
 		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
-	} else {
+	 else
 		trace_xfs_defer_finish_done((*tp)->t_mountp, dop, _RET_IP_);
-		xfs_defer_reset(dop);
-	}
 
 	return error;
 }
 
+int
+xfs_defer_finish(
+	struct xfs_trans	**tp)
+{
+	int			error;
+
+	/*
+	 * Finish and roll the transaction once more to avoid returning to the
+	 * caller with a dirty transaction.
+	 */
+	error = xfs_defer_finish_noroll(tp);
+	if (error)
+		return error;
+	if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
+		error = xfs_defer_trans_roll(tp);
+		if (error)
+			return error;
+	}
+	xfs_defer_reset((*tp)->t_dfops);
+	return 0;
+}
+
 /*
  * Free up any items left in the list.
  */
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 56f927803940..85c41fe4dbae 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -48,6 +48,7 @@ enum xfs_defer_ops_type {
 
 void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
 		struct list_head *h);
+int xfs_defer_finish_noroll(struct xfs_trans **tp);
 int xfs_defer_finish(struct xfs_trans **tp);
 void __xfs_defer_cancel(struct xfs_defer_ops *dop);
 void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index cd553aa9ecb0..7bf5c1202719 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -933,7 +933,7 @@ __xfs_trans_commit(
 
 	/* finish deferred items on final commit */
 	if (!regrant && tp->t_dfops) {
-		error = xfs_defer_finish(&tp);
+		error = xfs_defer_finish_noroll(&tp);
 		if (error) {
 			xfs_defer_cancel(tp);
 			goto out_unreserve;
-- 
2.17.1

