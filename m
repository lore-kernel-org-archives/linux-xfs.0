Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5C1C4708B
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4105613DA
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbhEZWtE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 18:49:04 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58712 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234661AbhEZWtC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 18:49:02 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 811BE863E12;
        Thu, 27 May 2021 08:47:26 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-005b8s-Qh; Thu, 27 May 2021 08:47:25 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-004fAW-J3; Thu, 27 May 2021 08:47:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH 09/10] xfs: cleanup error handling in xfs_buf_get_map
Date:   Thu, 27 May 2021 08:47:21 +1000
Message-Id: <20210526224722.1111377-10-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526224722.1111377-1-david@fromorbit.com>
References: <20210526224722.1111377-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=N3pm71BiTs0DYQFgoCYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Use a single goto label for freeing the buffer and returning an
error.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 701a798db7b7..f56a76f8a653 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -689,16 +689,12 @@ xfs_buf_get_map(
 		return error;
 
 	error = xfs_buf_allocate_memory(new_bp, flags);
-	if (error) {
-		xfs_buf_free(new_bp);
-		return error;
-	}
+	if (error)
+		goto out_free_buf;
 
 	error = xfs_buf_find(target, map, nmaps, flags, new_bp, &bp);
-	if (error) {
-		xfs_buf_free(new_bp);
-		return error;
-	}
+	if (error)
+		goto out_free_buf;
 
 	if (bp != new_bp)
 		xfs_buf_free(new_bp);
@@ -726,6 +722,9 @@ xfs_buf_get_map(
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
 	*bpp = bp;
 	return 0;
+out_free_buf:
+	xfs_buf_free(new_bp);
+	return error;
 }
 
 int
-- 
2.31.1

