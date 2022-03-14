Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAD8C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Mar 2022 22:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbiCNWHr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Mar 2022 18:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiCNWHp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Mar 2022 18:07:45 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30D573D1E6
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 15:06:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7BF0C532E4C
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 09:06:34 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nTspl-005W6U-NM
        for linux-xfs@vger.kernel.org; Tue, 15 Mar 2022 09:06:33 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nTspl-00Cyif-Lw
        for linux-xfs@vger.kernel.org;
        Tue, 15 Mar 2022 09:06:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] xfs: whiteouts release intents that are not in the AIL
Date:   Tue, 15 Mar 2022 09:06:30 +1100
Message-Id: <20220314220631.3093283-8-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314220631.3093283-1-david@fromorbit.com>
References: <20220314220631.3093283-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=622fbc6a
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=FmXBc2Kc0CuRUgi88GUA:9
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
 fs/xfs/xfs_bmap_item.c     | 8 +++++---
 fs/xfs/xfs_extfree_item.c  | 8 +++++---
 fs/xfs/xfs_refcount_item.c | 8 +++++---
 fs/xfs/xfs_rmap_item.c     | 8 +++++---
 4 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 2e7abfe35644..c6f47c13da27 100644
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
index 1d0e5cdc15f9..36eeac9413f5 100644
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
index ada5793ce550..d4632f2ceb89 100644
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
index 6e66e7718902..fa691a6ae737 100644
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
2.35.1

