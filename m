Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6368BC433E3
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 07:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 436D22067B
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 07:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgFDHqM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 03:46:12 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:48572 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726246AbgFDHqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 03:46:11 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id A67CDD598F3
        for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2020 17:46:08 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgkZk-0004AB-1Q
        for linux-xfs@vger.kernel.org; Thu, 04 Jun 2020 17:46:08 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jgkZj-0017Hf-Om
        for linux-xfs@vger.kernel.org; Thu, 04 Jun 2020 17:46:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/30] xfs: move xfs_clear_li_failed out of xfs_ail_delete_one()
Date:   Thu,  4 Jun 2020 17:45:51 +1000
Message-Id: <20200604074606.266213-16-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200604074606.266213-1-david@fromorbit.com>
References: <20200604074606.266213-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=n6ZPMNil_ZAWRd6T3lcA:9 a=pHzHmUro8NiASowvMSCR:22
        a=nt3jZW36AmriUCFCBwmW:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_ail_delete_one() is called directly from dquot and inode IO
completion, as well as from the generic xfs_trans_ail_delete()
function. Inodes are about to have their own failure handling, and
dquots will in future, too. Pull the clearing of the LI_FAILED flag
up into the callers so we can customise the code appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c      | 6 +-----
 fs/xfs/xfs_inode_item.c | 3 +--
 fs/xfs/xfs_trans_ail.c  | 2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index d5984a926d1d0..76353c9a723ee 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1070,16 +1070,12 @@ xfs_qm_dqflush_done(
 	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
 
 		spin_lock(&ailp->ail_lock);
+		xfs_clear_li_failed(lip);
 		if (lip->li_lsn == qip->qli_flush_lsn) {
 			/* xfs_ail_update_finish() drops the AIL lock */
 			tail_lsn = xfs_ail_delete_one(ailp, lip);
 			xfs_ail_update_finish(ailp, tail_lsn);
 		} else {
-			/*
-			 * Clear the failed state since we are about to drop the
-			 * flush lock
-			 */
-			xfs_clear_li_failed(lip);
 			spin_unlock(&ailp->ail_lock);
 		}
 	}
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 86c783dec2bac..0ba75764a8dc5 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -690,12 +690,11 @@ xfs_iflush_done(
 		/* this is an opencoded batch version of xfs_trans_ail_delete */
 		spin_lock(&ailp->ail_lock);
 		list_for_each_entry(lip, &tmp, li_bio_list) {
+			xfs_clear_li_failed(lip);
 			if (lip->li_lsn == INODE_ITEM(lip)->ili_flush_lsn) {
 				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, lip);
 				if (!tail_lsn && lsn)
 					tail_lsn = lsn;
-			} else {
-				xfs_clear_li_failed(lip);
 			}
 		}
 		xfs_ail_update_finish(ailp, tail_lsn);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index ac5019361a139..ac33f6393f99c 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -843,7 +843,6 @@ xfs_ail_delete_one(
 
 	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
 	xfs_ail_delete(ailp, lip);
-	xfs_clear_li_failed(lip);
 	clear_bit(XFS_LI_IN_AIL, &lip->li_flags);
 	lip->li_lsn = 0;
 
@@ -874,6 +873,7 @@ xfs_trans_ail_delete(
 	}
 
 	/* xfs_ail_update_finish() drops the AIL lock */
+	xfs_clear_li_failed(lip);
 	tail_lsn = xfs_ail_delete_one(ailp, lip);
 	xfs_ail_update_finish(ailp, tail_lsn);
 }
-- 
2.26.2.761.g0e0b3e54be

