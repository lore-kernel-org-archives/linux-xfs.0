Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3E5C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 11:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 600BD2166E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 11:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfH2LfL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 07:35:11 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53682 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727072AbfH2LfK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 07:35:10 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9FBC5361719
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 21:35:09 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3Ihn-0003VD-Tp
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 21:35:07 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3Ihn-0007AO-SH
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 21:35:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: remove unnecessary indenting from xfs_attr3_leaf_getvalue
Date:   Thu, 29 Aug 2019 21:35:02 +1000
Message-Id: <20190829113505.27223-3-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190829113505.27223-1-david@fromorbit.com>
References: <20190829113505.27223-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=FmdZ9Uzk2mMA:10 a=20KFwNOVAAAA:8
        a=KmcVe20qwJy7HWUPDk8A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 7a9440b7ab00..c7378bc62d2b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2391,24 +2391,25 @@ xfs_attr3_leaf_getvalue(
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
+		args->valuelen = args->rmtvaluelen;
+		return 0;
+	}
+	if (args->valuelen < args->rmtvaluelen) {
 		args->valuelen = args->rmtvaluelen;
+		return -ERANGE;
 	}
+	args->valuelen = args->rmtvaluelen;
 	return 0;
 }
 
-- 
2.23.0.rc1

