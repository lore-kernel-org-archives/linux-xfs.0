Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:32940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731729AbeGSOcg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 10:32:36 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 350F940122CD
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:20 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 207CD1C5B0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 06/14] xfs: reset dfops to initial state after finish
Date: Thu, 19 Jul 2018 09:49:11 -0400
Message-Id: <20180719134919.29939-7-bfoster@redhat.com>
In-Reply-To: <20180719134919.29939-1-bfoster@redhat.com>
References: <20180719134919.29939-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_defer_init() is currently used in two particular situations. The
first and most obvious case is raw initialization of an
xfs_defer_ops struct. The other case is partial reinit of
xfs_defer_ops on reuse due to iteration.

Most instances of the first case will be replaced by a single init
of a dfops embedded in the transaction. Init calls are still
technically required for the second case because the dfops may have
low space mode enabled or have joined items that need to be reset
before the dfops should be reused.

Since the current dfops usage expects either a final transaction
commit after xfs_defer_finish() or xfs_defer_init() if dfops is to
be reused, we can shift some of the init logic into
xfs_defer_finish() such that the latter returns with a reinitialized
dfops. This eliminates the second dependency noted above such that a
dfops is immediately ready for reuse after an xfs_defer_finish()
without the need to change any calling code.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index d3466087db16..e6baa27a690b 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -319,6 +319,29 @@ xfs_defer_bjoin(
 	return -EFSCORRUPTED;
 }
 
+/*
+ * Reset an already used dfops after finish.
+ */
+static void
+xfs_defer_reset(
+	struct xfs_defer_ops	*dop)
+{
+	int 			i;
+
+	ASSERT(!xfs_defer_has_unfinished_work(dop));
+	dop->dop_low = false;
+	for (i = 0; i < XFS_DEFER_OPS_NR_INODES; i++) {
+		if (!dop->dop_inodes[i])
+			break;
+		dop->dop_inodes[i] = NULL;
+	}
+	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS; i++) {
+		if (!dop->dop_bufs[i])
+			break;
+		dop->dop_bufs[i] = NULL;
+	}
+}
+
 /*
  * Finish all the pending work.  This involves logging intent items for
  * any work items that wandered in since the last transaction roll (if
@@ -419,10 +442,13 @@ xfs_defer_finish(
 	}
 
 out:
-	if (error)
+	if (error) {
 		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
-	else
+	} else {
 		trace_xfs_defer_finish_done((*tp)->t_mountp, dop, _RET_IP_);
+		xfs_defer_reset(dop);
+	}
+
 	return error;
 }
 
-- 
2.17.1

