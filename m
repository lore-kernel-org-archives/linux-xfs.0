Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D139CC4320E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2F4C61041
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhIBKAj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 06:00:39 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:41245 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233710AbhIBKAi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 06:00:38 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 71521108AB2
        for <linux-xfs@vger.kernel.org>; Thu,  2 Sep 2021 19:59:37 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-007nIs-OK
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-003pCx-Gm
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] xfs: whiteouts release intents that are not in the AIL
Date:   Thu,  2 Sep 2021 19:59:25 +1000
Message-Id: <20210902095927.911100-6-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902095927.911100-1-david@fromorbit.com>
References: <20210902095927.911100-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=FmXBc2Kc0CuRUgi88GUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we release an intent that a whiteout applies to, it will not
have been committed to the journal and so won't be in the AIL. Hence
when we drop the last reference to the intent, we do not want to try
to remove it from the AIL as that will trigger a filesystem
shutdown. Hence make the removal of intents from the AIL conditional
on them actually being in the AIL so we do the correct thing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_item.c     | 11 ++++++-----
 fs/xfs/xfs_bmap_item.c     |  8 +++++---
 fs/xfs/xfs_extfree_item.c  |  8 +++++---
 fs/xfs/xfs_refcount_item.c |  8 +++++---
 fs/xfs/xfs_rmap_item.c     |  8 +++++---
 5 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 86c8d5d08176..11546967a5d7 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -67,11 +67,12 @@ xfs_attri_release(
 	struct xfs_attri_log_item	*attrip)
 {
 	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
-	if (atomic_dec_and_test(&attrip->attri_refcount)) {
-		xfs_trans_ail_delete(&attrip->attri_item,
-				     SHUTDOWN_LOG_IO_ERROR);
-		xfs_attri_item_free(attrip);
-	}
+	if (!atomic_dec_and_test(&attrip->attri_refcount))
+		return;
+
+	if (test_bit(XFS_LI_IN_AIL, &attrip->attri_item.li_flags))
+		xfs_trans_ail_delete(&attrip->attri_item, SHUTDOWN_LOG_IO_ERROR);
+	xfs_attri_item_free(attrip);
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 0b06159cfd1b..7cabb59138b1 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -54,10 +54,12 @@ xfs_bui_release(
 	struct xfs_bui_log_item	*buip)
 {
 	ASSERT(atomic_read(&buip->bui_refcount) > 0);
-	if (atomic_dec_and_test(&buip->bui_refcount)) {
+	if (!atomic_dec_and_test(&buip->bui_refcount))
+		return;
+
+	if (test_bit(XFS_LI_IN_AIL, &buip->bui_item.li_flags))
 		xfs_trans_ail_delete(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
-		xfs_bui_item_free(buip);
-	}
+	xfs_bui_item_free(buip);
 }
 
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 87cba4a71883..7032125fe987 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -58,10 +58,12 @@ xfs_efi_release(
 	struct xfs_efi_log_item	*efip)
 {
 	ASSERT(atomic_read(&efip->efi_refcount) > 0);
-	if (atomic_dec_and_test(&efip->efi_refcount)) {
+	if (!atomic_dec_and_test(&efip->efi_refcount))
+		return;
+
+	if (test_bit(XFS_LI_IN_AIL, &efip->efi_item.li_flags))
 		xfs_trans_ail_delete(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
-		xfs_efi_item_free(efip);
-	}
+	xfs_efi_item_free(efip);
 }
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index de739884e857..f62dc5b7af88 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -53,10 +53,12 @@ xfs_cui_release(
 	struct xfs_cui_log_item	*cuip)
 {
 	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
-	if (atomic_dec_and_test(&cuip->cui_refcount)) {
+	if (!atomic_dec_and_test(&cuip->cui_refcount))
+		return;
+
+	if (test_bit(XFS_LI_IN_AIL, &cuip->cui_item.li_flags))
 		xfs_trans_ail_delete(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
-		xfs_cui_item_free(cuip);
-	}
+	xfs_cui_item_free(cuip);
 }
 
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 8d57529d9ddd..0c67abcd189b 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -53,10 +53,12 @@ xfs_rui_release(
 	struct xfs_rui_log_item	*ruip)
 {
 	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
-	if (atomic_dec_and_test(&ruip->rui_refcount)) {
+	if (!atomic_dec_and_test(&ruip->rui_refcount))
+		return;
+
+	if (test_bit(XFS_LI_IN_AIL, &ruip->rui_item.li_flags))
 		xfs_trans_ail_delete(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
-		xfs_rui_item_free(ruip);
-	}
+	xfs_rui_item_free(ruip);
 }
 
 STATIC void
-- 
2.31.1

