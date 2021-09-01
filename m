Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A0BC432BE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 07:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDFB361075
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 07:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhIAHbl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 03:31:41 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35928 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242502AbhIAHbk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 03:31:40 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2D92C82AB08;
        Wed,  1 Sep 2021 17:30:43 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLKhm-007NLU-LS; Wed, 01 Sep 2021 17:30:42 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLKhm-003Xo5-DN; Wed, 01 Sep 2021 17:30:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 4/5] xfs: fix attribute log iovec sizing
Date:   Wed,  1 Sep 2021 17:30:38 +1000
Message-Id: <20210901073039.844617-5-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901073039.844617-1-david@fromorbit.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210901073039.844617-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=IoOFiFtFkgiQdHSVYkQA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The sizing of the attri name and value log iovecs is incorrect.
This results in memory corruption and crashes on a kernel with
the current CIL scalability patchset applied as it relies on the
callers playing by slightly different alignment rules.

Convert the attri code to the new xlog_calc_iovec_size() API to
fix these issues.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_item.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 4072972a2ed8..bd4089eb8087 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -42,13 +42,6 @@
 static const struct xfs_item_ops xfs_attri_item_ops;
 static const struct xfs_item_ops xfs_attrd_item_ops;
 
-/* iovec length must be 32-bit aligned */
-static inline size_t ATTR_NVEC_SIZE(size_t size)
-{
-	return size == sizeof(int32_t) ? size :
-	       sizeof(int32_t) + round_up(size, sizeof(int32_t));
-}
-
 static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_attri_log_item, attri_item);
@@ -89,19 +82,15 @@ xfs_attri_item_size(
 {
 	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
 
-	*nvecs += 1;
-	*nbytes += sizeof(struct xfs_attri_log_format);
+	*nvecs += 2;
+	*nbytes += sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(attrip->attri_name_len);
 
-	/* Attr set and remove operations require a name */
-	ASSERT(attrip->attri_name_len > 0);
+	if (!attrip->attri_value_len)
+		return;
 
 	*nvecs += 1;
-	*nbytes += ATTR_NVEC_SIZE(attrip->attri_name_len);
-
-	if (attrip->attri_value_len > 0) {
-		*nvecs += 1;
-		*nbytes += ATTR_NVEC_SIZE(attrip->attri_value_len);
-	}
+	*nbytes += xlog_calc_iovec_len(attrip->attri_value_len);
 }
 
 /*
@@ -137,12 +126,10 @@ xfs_attri_item_format(
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
-			attrip->attri_name,
-			ATTR_NVEC_SIZE(attrip->attri_name_len));
+			attrip->attri_name, attrip->attri_name_len);
 	if (attrip->attri_value_len > 0)
 		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
-				attrip->attri_value,
-				ATTR_NVEC_SIZE(attrip->attri_value_len));
+				attrip->attri_value, attrip->attri_value_len);
 }
 
 /*
-- 
2.31.1

