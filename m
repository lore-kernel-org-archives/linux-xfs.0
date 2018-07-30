Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730607AbeG3SVL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 14:21:11 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1490C4219DC8
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 16:45:21 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F40CB112D193
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 16:45:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 01/15] xfs: refactor internal dfops initialization
Date: Mon, 30 Jul 2018 12:45:06 -0400
Message-Id: <20180730164520.36882-2-bfoster@redhat.com>
In-Reply-To: <20180730164520.36882-1-bfoster@redhat.com>
References: <20180730164520.36882-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The current transaction allocation code conditionally initializes
the ->t_dfops indirection pointer. Transaction commit/cancel check
the validity of the pointer to determine whether to finish/cancel
the internal dfops.

This disallows the ability to use the internal dfops list as a
temporary container (via xfs_trans_alloc_empty()). Refactor
transaction allocation to always initialize ->t_dfops and check
permanent reservation state on transaction commit/cancel.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bf5c1202719..8d3b7f28b193 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -281,13 +281,7 @@ xfs_trans_alloc(
 	INIT_LIST_HEAD(&tp->t_items);
 	INIT_LIST_HEAD(&tp->t_busy);
 	tp->t_firstblock = NULLFSBLOCK;
-	/*
-	 * We only roll transactions with permanent log reservation. Don't init
-	 * ->t_dfops to skip attempts to finish or cancel an empty dfops with a
-	 * non-permanent res.
-	 */
-	if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES)
-		xfs_defer_init(tp, &tp->t_dfops_internal);
+	xfs_defer_init(tp, &tp->t_dfops_internal);
 
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error) {
@@ -932,7 +926,7 @@ __xfs_trans_commit(
 	trace_xfs_trans_commit(tp, _RET_IP_);
 
 	/* finish deferred items on final commit */
-	if (!regrant && tp->t_dfops) {
+	if (!regrant && (tp->t_flags & XFS_TRANS_PERM_LOG_RES)) {
 		error = xfs_defer_finish_noroll(&tp);
 		if (error) {
 			xfs_defer_cancel(tp);
@@ -1029,7 +1023,7 @@ xfs_trans_cancel(
 
 	trace_xfs_trans_cancel(tp, _RET_IP_);
 
-	if (tp->t_dfops)
+	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
 		xfs_defer_cancel(tp);
 
 	/*
-- 
2.17.1

