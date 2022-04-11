Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635DEC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbiDKAeJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241494AbiDKAeH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:07 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62AE2DED4
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7053310CE85D
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMx-EZ
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pjc-Df
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/17] xfs: convert log item tracepoint flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:42 +1000
Message-Id: <20220411003147.2104423-13-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=ZB7fF_u422Z8S8KfqmwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index de177842b951..569b68fc6912 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -58,10 +58,10 @@ struct xfs_log_item {
 #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
 
 #define XFS_LI_FLAGS \
-	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
-	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
-	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
-	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
+	{ (1u << XFS_LI_IN_AIL),	"IN_AIL" }, \
+	{ (1u << XFS_LI_ABORTED),	"ABORTED" }, \
+	{ (1u << XFS_LI_FAILED),	"FAILED" }, \
+	{ (1u << XFS_LI_DIRTY),		"DIRTY" }
 
 struct xfs_item_ops {
 	unsigned flags;
-- 
2.35.1

