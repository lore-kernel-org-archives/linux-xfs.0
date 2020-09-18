Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96783C43464
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 571B121D43
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c2R1YCTU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIRJsp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 05:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRJso (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 05:48:44 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED1FC06174A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k15so3090266pfc.12
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Qi7/wmzxM6qqkn9YV3YieHUEp2D+o+n5U3RwxtM9Ws=;
        b=c2R1YCTU6gfPopcfwnlXsH9gExRMxNayiWCX/x3Lp5aCBQ+DUlhCyEECedCtQ0Zk1n
         eAIqibnw+/JAPe0RrWzHx21ctP2Jyo8nktBeK0c5p4zKWgq1l2SIV8wSK22FdUgYERgf
         wAQqg/JfmlxMPksRshJP1eYDjNnDXd/LrIA0mVlxFCyF4oWrFOsZU4U1rMvdCorZeG3Y
         MQ3DZsihAI+YEPDrrkhNwuLEAfrYct2pLRtaDcSdMaYYVzw3z76YZWB7WlvKRW+J3Lcp
         opnGfaUcx1MQTVK3xv7bF7DnN3HLJhMSIfoAU8Xl6VMVRqAtqIhQRPSi5MoWlwrxJt1U
         w4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Qi7/wmzxM6qqkn9YV3YieHUEp2D+o+n5U3RwxtM9Ws=;
        b=I7GoQv5sCx9RHue3US+QnKck0EyIxvmlGmBqyd1VyXaMHkAqiqy2KTdwIkVQgRvd7C
         CeUtUJEnAR0985AyZY+3zMRbMc7ne3XHYfENfocGAIH/gBAF5F+2RDR/LR6tM6Gt1k1Z
         a5YO2/MdhAp8IxYiu+z/IsBDXguXmDuAt/nrq7zYgLT4Yy7uNUba2GGUPxX6xIRznBrQ
         brf+7hzpUJaguNlLA4BB0uSB49GNjTAba4UYucbD+x+9AEe1h36TkyCWxvKhk84zVZGb
         jn1VnIANH5YdABbu52Cr8in1ORFz+R2/6i60AMGOUV3s1WtBcokSoljg5eLH8VZZxzcz
         iU4g==
X-Gm-Message-State: AOAM530pHE+3BpLcB0hC1J4ja8eQRZInLiL3Dau4AhFdbUCFarV6AH7Y
        O164yiNK4KbgM/tv6jToEn2t9KGt4NY=
X-Google-Smtp-Source: ABdhPJzZr2SvJtcFbJXcZbmSlXn68ElkC3SpPq4JMy7+wuSOGxyBghmfIwpqhrmUR9pek0WlXFEk8g==
X-Received: by 2002:a05:6a00:888:b029:13f:f7eb:578c with SMTP id q8-20020a056a000888b029013ff7eb578cmr20143936pfj.10.1600422523534;
        Fri, 18 Sep 2020 02:48:43 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id s24sm2227194pjp.53.2020.09.18.02.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 02:48:42 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V4 09/10] xfs: Check for extent overflow when swapping extents
Date:   Fri, 18 Sep 2020 15:17:58 +0530
Message-Id: <20200918094759.2727564-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918094759.2727564-1-chandanrlinux@gmail.com>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Removing an initial range of source/donor file's extent and adding a new
extent (from donor/source file) in its place will cause extent count to
increase by 1.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 18 +++++++++---------
 fs/xfs/libxfs/xfs_bmap.h       |  1 +
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_util.c         | 17 +++++++++++++++++
 4 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 51c2d2690f05..9c665e379dfc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6104,15 +6104,6 @@ xfs_bmap_split_extent(
 	return error;
 }
 
-/* Deferred mapping is only for real extents in the data fork. */
-static bool
-xfs_bmap_is_update_needed(
-	struct xfs_bmbt_irec	*bmap)
-{
-	return  bmap->br_startblock != HOLESTARTBLOCK &&
-		bmap->br_startblock != DELAYSTARTBLOCK;
-}
-
 /* Record a bmap intent. */
 static int
 __xfs_bmap_add(
@@ -6144,6 +6135,15 @@ __xfs_bmap_add(
 	return 0;
 }
 
+/* Deferred mapping is only for real extents in the data fork. */
+bool
+xfs_bmap_is_update_needed(
+	struct xfs_bmbt_irec	*bmap)
+{
+	return  bmap->br_startblock != HOLESTARTBLOCK &&
+		bmap->br_startblock != DELAYSTARTBLOCK;
+}
+
 /* Map an extent into a file. */
 void
 xfs_bmap_map_extent(
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e1bd484e5548..60fbe184d5f4 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -263,6 +263,7 @@ struct xfs_bmap_intent {
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
+bool	xfs_bmap_is_update_needed(struct xfs_bmbt_irec *bmap);
 int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_inode *ip,
 		enum xfs_bmap_intent_type type, int whichfork,
 		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index ded3c1b56c94..837c01595439 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -102,6 +102,13 @@ struct xfs_ifork {
 #define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
 	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
 
+/*
+ * Removing an initial range of source/donor file's extent and adding a new
+ * extent (from donor/source file) in its place will cause extent count to
+ * increase by 1.
+ */
+#define XFS_IEXT_SWAP_RMAP_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0776abd0103c..542f990247c4 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -28,6 +28,7 @@
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_bmap.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -1407,6 +1408,22 @@ xfs_swap_extent_rmap(
 					irec.br_blockcount);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
+			if (xfs_bmap_is_update_needed(&uirec)) {
+				error = xfs_iext_count_may_overflow(ip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
+			if (xfs_bmap_is_update_needed(&irec)) {
+				error = xfs_iext_count_may_overflow(tip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
 			/* Remove the mapping from the donor file. */
 			xfs_bmap_unmap_extent(tp, tip, &uirec);
 
-- 
2.28.0

