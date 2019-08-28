Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FA5C41514
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 04:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFED722CF4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 04:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbfH1EX6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 00:23:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49325 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725865AbfH1EX6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 00:23:58 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C763843DEB8
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2019 14:23:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2pUu-0004w5-GK
        for linux-xfs@vger.kernel.org; Wed, 28 Aug 2019 14:23:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2pUu-0001hE-EU
        for linux-xfs@vger.kernel.org; Wed, 28 Aug 2019 14:23:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: move remote attr retrieval into xfs_attr3_leaf_getvalue
Date:   Wed, 28 Aug 2019 14:23:49 +1000
Message-Id: <20190828042350.6062-3-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190828042350.6062-1-david@fromorbit.com>
References: <20190828042350.6062-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=FmdZ9Uzk2mMA:10 a=20KFwNOVAAAA:8
        a=h6DLRALk1JxXsCKv6hQA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because we repeat exactly the same code to get the remote attribute
value after both calls to xfs_attr3_leaf_getvalue() if it's a remote
attr. Just do it in xfs_attr3_leaf_getvalue() so the callers don't
have to care about it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 16 +---------------
 fs/xfs/libxfs/xfs_attr_leaf.c | 35 ++++++++++++++++++-----------------
 2 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 776343c4f22b..5e6b6846e607 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -794,15 +794,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	}
 	error = xfs_attr3_leaf_getvalue(bp, args);
 	xfs_trans_brelse(args->trans, bp);
-	if (error)
-		return error;
-
-	/* check if we have to retrieve a remote attribute to get the value */
-	if (args->flags & ATTR_KERNOVAL)
-		return 0;
-	if (!args->rmtblkno)
-		return 0;
-	return xfs_attr_rmtval_get(args);
+	return error;
 }
 
 /*========================================================================
@@ -1316,12 +1308,6 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	 */
 	blk = &state->path.blk[state->path.active - 1];
 	retval = xfs_attr3_leaf_getvalue(blk->bp, args);
-	if (retval)
-		goto out_release;
-	if (args->flags & ATTR_KERNOVAL)
-		goto out_release;
-	if (args->rmtblkno > 0)
-		retval = xfs_attr_rmtval_get(args);
 
 	/*
 	 * If not in a transaction, we have to release all the buffers.
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d056767b5c53..e325cdbc9818 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2391,25 +2391,26 @@ xfs_attr3_leaf_getvalue(
 		}
 		args->valuelen = valuelen;
 		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
-	} else {
-		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
-		ASSERT(name_rmt->namelen == args->namelen);
-		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
-		args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
-		args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
-		args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
-						       args->rmtvaluelen);
-		if (args->flags & ATTR_KERNOVAL) {
-			args->valuelen = args->rmtvaluelen;
-			return 0;
-		}
-		if (args->valuelen < args->rmtvaluelen) {
-			args->valuelen = args->rmtvaluelen;
-			return -ERANGE;
-		}
+		return 0;
+	}
+
+	name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
+	ASSERT(name_rmt->namelen == args->namelen);
+	ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
+	args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
+	args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
+	args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
+					       args->rmtvaluelen);
+	if (args->flags & ATTR_KERNOVAL) {
 		args->valuelen = args->rmtvaluelen;
+		return 0;
 	}
-	return 0;
+	if (args->valuelen < args->rmtvaluelen) {
+		args->valuelen = args->rmtvaluelen;
+		return -ERANGE;
+	}
+	args->valuelen = args->rmtvaluelen;
+	return xfs_attr_rmtval_get(args);
 }
 
 /*========================================================================
-- 
2.23.0.rc1

