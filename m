Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08289C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 02:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbiEXCWJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 22:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbiEXCWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 22:22:08 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F33AA6470B
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 19:22:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1DC33534638
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 12:22:02 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntKBM-00Fexm-B0
        for linux-xfs@vger.kernel.org; Tue, 24 May 2022 12:22:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ntKBM-007lAr-AD
        for linux-xfs@vger.kernel.org;
        Tue, 24 May 2022 12:22:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: don't assert fail on perag references on teardown
Date:   Tue, 24 May 2022 12:21:57 +1000
Message-Id: <20220524022158.1849458-3-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524022158.1849458-1-david@fromorbit.com>
References: <20220524022158.1849458-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=628c414a
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=iAqWTa0Cm29I_VJh4nsA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Not fatal, the assert is there to catch developer attention. I'm
seeing this occasionally during recoveryloop testing after a
shutdown, and I don't want this to stop an overnight recoveryloop
run as it is currently doing.

Convert the ASSERT to a XFS_IS_CORRUPT() check so it will dump a
corruption report into the log and cause a test failure that way,
but it won't stop the machine dead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 1e4ee042d52f..3e920cf1b454 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -173,7 +173,6 @@ __xfs_free_perag(
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
 	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
-	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
 
@@ -192,7 +191,7 @@ xfs_free_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
-		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_iunlink_destroy(pag);
-- 
2.35.1

