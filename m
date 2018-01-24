Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965091AbeAXSoU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jan 2018 13:44:20 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EE19C5C9CC
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:19 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1C2C60A9D
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFCv2 2/9] xfs: allow attach of dfops to transaction
Date: Wed, 24 Jan 2018 13:44:11 -0500
Message-Id: <20180124184418.40403-3-bfoster@redhat.com>
In-Reply-To: <20180124184418.40403-1-bfoster@redhat.com>
References: <20180124184418.40403-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_defer_ops is a separate data structure from the xfs_trans data
structure. The former is typically allocated on the stack and
completed/processed before the associated thread returns outside of
the scope that defines the structure.

While this currently works fine, there are many places where
xfs_dfops has to be plumbed through deep callchains and/or subsystem
data structures (e.g., struct xfs_da_args) to other contexts. Since
deferred operations cannot be processed without a transaction, the
scope of xfs_defer_ops is essentially a subset of that of a
transaction. Further, an upcoming enhancement to defer AGFL block
frees requires to plumb xfs_defer_ops through yet another context
(struct xfs_alloc_arg) that already carries a transaction.

Rather than continue to pass dfops around independently, support the
ability to optionally carry an xfs_defer_ops structure in the
transaction itself. This facilitates the addition of deferred AGFL
block free behavior from selective contexts and incremental
clean up of other callchains to set/use the transaction reference
rather than plumb the dfops through explicitly.

Note that this patch does not change behavior nor dictate any
changes to how dfops structs are allocated (on the stack) and so all
existing rules apply. Changes to how dfops are allocated can be
considered once all paths are converted and thus would use a
consistent allocation pattern.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans.c | 7 ++++---
 fs/xfs/xfs_trans.h | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 86f92df32c42..50ee39faf64e 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -94,11 +94,11 @@ xfs_trans_free(
  * blocks.  Locks and log items, however, are no inherited.  They must
  * be added to the new transaction explicitly.
  */
-STATIC xfs_trans_t *
+STATIC struct xfs_trans *
 xfs_trans_dup(
-	xfs_trans_t	*tp)
+	struct xfs_trans	*tp)
 {
-	xfs_trans_t	*ntp;
+	struct xfs_trans	*ntp;
 
 	ntp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
 
@@ -124,6 +124,7 @@ xfs_trans_dup(
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
 	ntp->t_pflags = tp->t_pflags;
+	ntp->t_dfops = tp->t_dfops;
 
 	xfs_trans_dup_dqinfo(tp, ntp);
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 815b53d20e26..d3e0599a4ce9 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -111,6 +111,7 @@ typedef struct xfs_trans {
 	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
 	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
+	struct xfs_defer_ops	*t_dfops;	/* deferred ops reference */
 	unsigned int		t_flags;	/* misc flags */
 	int64_t			t_icount_delta;	/* superblock icount change */
 	int64_t			t_ifree_delta;	/* superblock ifree change */
-- 
2.13.6

