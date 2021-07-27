Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0D9C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 07:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A34D161163
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 07:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhG0HKV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 03:10:21 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:56885 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235745AbhG0HKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 03:10:20 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id ED7F063A1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 17:10:17 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00BI3e-Mk
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00E5aj-Eu
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/11] xfs: flush data dev on external log write
Date:   Tue, 27 Jul 2021 17:10:02 +1000
Message-Id: <20210727071012.3358033-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727071012.3358033-1-david@fromorbit.com>
References: <20210727071012.3358033-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=r_EzLFMmjEd-lPC6gHAA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We incorrectly flush the log device instead of the data device when
trying to ensure metadata is correctly on disk before writing the
unmount record.

Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 36fa2650b081..96434cc4df6e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -833,7 +833,7 @@ xlog_write_unmount_record(
 	 * stamp the tail LSN into the unmount record.
 	 */
 	if (log->l_targ != log->l_mp->m_ddev_targp)
-		blkdev_issue_flush(log->l_targ->bt_bdev);
+		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
 	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
 }
 
-- 
2.31.1

