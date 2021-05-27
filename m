Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83357C4708F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 04:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68DD161073
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 04:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhE0Exo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 00:53:44 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:52463 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234414AbhE0Exl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 00:53:41 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 3E1A0105F88
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 14:52:06 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-005h1F-P7
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-004qgY-HO
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: add a free space extent change reservation
Date:   Thu, 27 May 2021 14:52:00 +1000
Message-Id: <20210527045202.1155628-5-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527045202.1155628-1-david@fromorbit.com>
References: <20210527045202.1155628-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=rZi3jfzWYBuMxqL7aZQA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Lots of the transaction reservation code reserves space for an
extent allocation. It is inconsistently implemented, and many of
them get it wrong. Introduce a new function to calculate the log
space reservation for adding or removing an extent from the free
space btrees.

This function reserves space for logging the AGF, the AGFL and the
free space btrees, avoiding the need to account for them seperately
in every reservation that manipulates free space.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d1a0848cb52e..6363cacb790f 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -79,6 +79,23 @@ xfs_allocfree_log_count(
 	return blocks;
 }
 
+/*
+ * Log reservation required to add or remove a single extent to the free space
+ * btrees.  This requires modifying:
+ *
+ * the agf header: 1 sector
+ * the agfl header: 1 sector
+ * the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
+uint
+xfs_allocfree_extent_res(
+	struct xfs_mount *mp)
+{
+	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+	       xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+				XFS_FSB_TO_B(mp, 1));
+}
+
 /*
  * Logging inodes is really tricksy. They are logged in memory format,
  * which means that what we write into the log doesn't directly translate into
-- 
2.31.1

