Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456C1C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbiECWjB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243719AbiECWix (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:38:53 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D31C814092
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:35:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 15EA110E626C
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 08:35:18 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm0pm-007gGZ-9V
        for linux-xfs@vger.kernel.org; Wed, 04 May 2022 08:17:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nm0pm-000mGo-8W
        for linux-xfs@vger.kernel.org;
        Wed, 04 May 2022 08:17:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/10] xfs: whiteouts release intents that are not in the AIL
Date:   Wed,  4 May 2022 08:17:27 +1000
Message-Id: <20220503221728.185449-10-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503221728.185449-1-david@fromorbit.com>
References: <20220503221728.185449-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6271ae26
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
        a=FmXBc2Kc0CuRUgi88GUA:9 a=AjGcO6oz07-iQ99wixmX:22
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c     | 9 +++++----
 fs/xfs/xfs_extfree_item.c  | 9 +++++----
 fs/xfs/xfs_refcount_item.c | 9 +++++----
 fs/xfs/xfs_rmap_item.c     | 9 +++++----
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f05663fdb6ff..51f66e982484 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -55,10 +55,11 @@ xfs_bui_release(
 	struct xfs_bui_log_item	*buip)
 {
 	ASSERT(atomic_read(&buip->bui_refcount) > 0);
-	if (atomic_dec_and_test(&buip->bui_refcount)) {
-		xfs_trans_ail_delete(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
-		xfs_bui_item_free(buip);
-	}
+	if (!atomic_dec_and_test(&buip->bui_refcount))
+		return;
+
+	xfs_trans_ail_delete(&buip->bui_item, 0);
+	xfs_bui_item_free(buip);
 }
 
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 032db5269e97..765be054dffe 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -58,10 +58,11 @@ xfs_efi_release(
 	struct xfs_efi_log_item	*efip)
 {
 	ASSERT(atomic_read(&efip->efi_refcount) > 0);
-	if (atomic_dec_and_test(&efip->efi_refcount)) {
-		xfs_trans_ail_delete(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
-		xfs_efi_item_free(efip);
-	}
+	if (!atomic_dec_and_test(&efip->efi_refcount))
+		return;
+
+	xfs_trans_ail_delete(&efip->efi_item, 0);
+	xfs_efi_item_free(efip);
 }
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 57a025f5fd4b..7e97bf19793d 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -54,10 +54,11 @@ xfs_cui_release(
 	struct xfs_cui_log_item	*cuip)
 {
 	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
-	if (atomic_dec_and_test(&cuip->cui_refcount)) {
-		xfs_trans_ail_delete(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
-		xfs_cui_item_free(cuip);
-	}
+	if (!atomic_dec_and_test(&cuip->cui_refcount))
+		return;
+
+	xfs_trans_ail_delete(&cuip->cui_item, 0);
+	xfs_cui_item_free(cuip);
 }
 
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 1c7d8518cb48..fef92e02f3bb 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -54,10 +54,11 @@ xfs_rui_release(
 	struct xfs_rui_log_item	*ruip)
 {
 	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
-	if (atomic_dec_and_test(&ruip->rui_refcount)) {
-		xfs_trans_ail_delete(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
-		xfs_rui_item_free(ruip);
-	}
+	if (!atomic_dec_and_test(&ruip->rui_refcount))
+		return;
+
+	xfs_trans_ail_delete(&ruip->rui_item, 0);
+	xfs_rui_item_free(ruip);
 }
 
 STATIC void
-- 
2.35.1

