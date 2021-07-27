Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BEDC43214
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 07:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0CC261165
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 07:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbhG0HKX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 03:10:23 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:39089 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235760AbhG0HKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 03:10:21 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id EC54210B819
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 17:10:17 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00BI3f-Nl
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00E5am-G7
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/11] xfs: external logs need to flush data device
Date:   Tue, 27 Jul 2021 17:10:03 +1000
Message-Id: <20210727071012.3358033-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727071012.3358033-1-david@fromorbit.com>
References: <20210727071012.3358033-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=edIB7ZaJnL-MFb9X88MA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The recent journal flush/FUA changes replaced the flushing of the
data device on every iclog write with an up-front async data device
cache flush. Unfortunately, the assumption of which this was based
on has been proven incorrect by the flush vs log tail update
ordering issue. As the fix for that issue uses the
XLOG_ICL_NEED_FLUSH flag to indicate that data device needs a cache
flush, we now need to (once again) ensure that an iclog write to
external logs that need a cache flush to be issued actually issue a
cache flush to the data device as well as the log device.

Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 96434cc4df6e..a3c4d48195d9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -827,13 +827,6 @@ xlog_write_unmount_record(
 	/* account for space used by record data */
 	ticket->t_curr_res -= sizeof(ulf);
 
-	/*
-	 * For external log devices, we need to flush the data device cache
-	 * first to ensure all metadata writeback is on stable storage before we
-	 * stamp the tail LSN into the unmount record.
-	 */
-	if (log->l_targ != log->l_mp->m_ddev_targp)
-		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
 	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
 }
 
@@ -1796,10 +1789,20 @@ xlog_write_iclog(
 	 * metadata writeback and causing priority inversions.
 	 */
 	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_IDLE;
-	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH)
+	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
 		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
+		/*
+		 * For external log devices, we also need to flush the data
+		 * device cache first to ensure all metadata writeback covered
+		 * by the LSN in this iclog is on stable storage. This is slow,
+		 * but it *must* complete before we issue the external log IO.
+		 */
+		if (log->l_targ != log->l_mp->m_ddev_targp)
+			blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
+	}
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
+
 	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
 	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
-- 
2.31.1

