Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D4AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235923AbiLaAUV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbiLaAUT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF831E3F0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46C45B81E75
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F6BC433D2;
        Sat, 31 Dec 2022 00:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446016;
        bh=46jpfXRDJm0OanP2NDPmFTai+UZfWqbnc6/C9YTZPbk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DJ6iTwBsxkt+6GmJEunkpZqGmVHSMlx0kDQ+eax0VbVjntAOhXhM/7hDyM7hIt52H
         2u9WGu7EKP06oyd9/mrDDAn9QLWuNXXKxUoI+LwByHbEnAxHyaVEr2czDRCFPWmkcU
         0OQFCWYHtvjpK08F/Q/7Aq2GvZJGnTF+k1A5M70kUxm73gC1+Auy8Q34VndkkSDKNL
         kjCZvEG9/FmOUCA3up2UZBxtqWVmavmPJ0FRaKM5bCc3tckX1J7I3nItydakuLMEOZ
         5A66PYrkJ8JD3HZ1+duuTZkq08Abv7kXe/M3qnqL8VG+gyIMixHvKQ1n0umJe2oxAc
         CY9QFfoHgpKSg==
Subject: [PATCH 06/19] xfs: add error injection to test swapext recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:00 -0800
Message-ID: <167243868018.713817.16393849878133163740.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add an errortag so that we can test recovery of swapext log items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/inject.c           |    1 +
 libxfs/xfs_errortag.h |    4 +++-
 libxfs/xfs_swapext.c  |    4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/io/inject.c b/io/inject.c
index 6ef1fc8d2f4..4b0cd76005c 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -63,6 +63,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_ATTR_LEAF_TO_NODE,		"attr_leaf_to_node" },
 		{ XFS_ERRTAG_WB_DELAY_MS,		"wb_delay_ms" },
 		{ XFS_ERRTAG_WRITE_DELAY_MS,		"write_delay_ms" },
+		{ XFS_ERRTAG_SWAPEXT_FINISH_ONE,	"swapext_finish_one" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 01a9e86b303..263d62a8d70 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -63,7 +63,8 @@
 #define XFS_ERRTAG_ATTR_LEAF_TO_NODE			41
 #define XFS_ERRTAG_WB_DELAY_MS				42
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
-#define XFS_ERRTAG_MAX					44
+#define XFS_ERRTAG_SWAPEXT_FINISH_ONE			44
+#define XFS_ERRTAG_MAX					45
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -111,5 +112,6 @@
 #define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
 #define XFS_RANDOM_WB_DELAY_MS				3000
 #define XFS_RANDOM_WRITE_DELAY_MS			3000
+#define XFS_RANDOM_SWAPEXT_FINISH_ONE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index 4c3dd4f7c7f..3557efedeb6 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -20,6 +20,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_quota_defs.h"
 #include "xfs_health.h"
+#include "xfs_errortag.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -423,6 +424,9 @@ xfs_swapext_finish_one(
 			return error;
 	}
 
+	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_SWAPEXT_FINISH_ONE))
+		return -EIO;
+
 	/* If we still have work to do, ask for a new transaction. */
 	if (sxi_has_more_swap_work(sxi) || sxi_has_postop_work(sxi)) {
 		trace_xfs_swapext_defer(tp->t_mountp, sxi);

