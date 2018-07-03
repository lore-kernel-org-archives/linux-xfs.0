Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933565AbeGCRXU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A6F9940753AC
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:19 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9257F1117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 02/25] xfs: add firstblock field to xfs_trans
Date: Tue,  3 Jul 2018 13:22:56 -0400
Message-Id: <20180703172319.24509-3-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

A firstblock var is typically allocated and initialized along with
xfs_defer_ops structures and passed around independent from the
associated transaction. To facilitate combining the two, add an
optional ->t_firstblock field to xfs_trans that can be used in place
of an on-stack variable.

The firstblock value follows the lifetime of the transaction, so
initialize it on allocation and when a transaction rolls.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans.c | 2 ++
 fs/xfs/xfs_trans.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 630993387517..de00f79ff698 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -100,6 +100,7 @@ xfs_trans_dup(
 	ntp->t_mountp = tp->t_mountp;
 	INIT_LIST_HEAD(&ntp->t_items);
 	INIT_LIST_HEAD(&ntp->t_busy);
+	ntp->t_firstblock = NULLFSBLOCK;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(tp->t_ticket != NULL);
@@ -273,6 +274,7 @@ xfs_trans_alloc(
 	tp->t_mountp = mp;
 	INIT_LIST_HEAD(&tp->t_items);
 	INIT_LIST_HEAD(&tp->t_busy);
+	tp->t_firstblock = NULLFSBLOCK;
 
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error) {
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index d8a695c57103..37fdacc690c7 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -102,6 +102,7 @@ typedef struct xfs_trans {
 	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
 	unsigned int		t_rtx_res;	/* # of rt extents resvd */
 	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
+	xfs_fsblock_t		t_firstblock;	/* first block allocated */
 	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
 	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
-- 
2.17.1

