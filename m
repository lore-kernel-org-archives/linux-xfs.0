Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97638C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjBPVAV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjBPVAU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B455A505F0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60918B82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C58DC433EF;
        Thu, 16 Feb 2023 21:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581217;
        bh=NdyeBZB7EKSNad8CInhPk6paiJFzl2XY4ECu4/FKe+A=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Gcadw2pUp1X5CdfQ0muCGy5glTYdRxqVOjYlY7frF2FuOUdX46M4e00rytCPkpx/Z
         Yi0LROftZCCnS+5C90K+oUR+QYK0DdGSnROnAaaUmSmEOzQ8v7T5djnwcf1g2i42Kg
         Dp2xsOIicW5Ku1zthQrFd3NbE1PhwYvMoqJOCzTPgwBozajkU2dFdPUZulm95zImiR
         NCNTIMOUNmZTKR4ZNYc+ZCFq3OPEtk9orZzk+uPal5Tl5PxSLuKkQl6VhDtcRz5M1f
         SF/k2DfpQLmULhxN2ApxSWCukf6dUPdjfE1HE/cMzlIv1oLenepMPQhO6P1sFy4Ujq
         lzT4337de39mg==
Date:   Thu, 16 Feb 2023 13:00:16 -0800
Subject: [PATCH 1/6] libxfs: initialize the slab cache for parent defer items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879547.3476725.192173167629345902.stgit@magnolia>
In-Reply-To: <167657879533.3476725.4672667573997149436.stgit@magnolia>
References: <167657879533.3476725.4672667573997149436.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Initialize the slab cache for parent defer items.  We'll need this in an
upcoming patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h |    1 +
 libxfs/init.c    |    3 +++
 2 files changed, 4 insertions(+)


diff --git a/include/libxfs.h b/include/libxfs.h
index 915bf511..a38d78a1 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -77,6 +77,7 @@ struct iomap;
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
+#include "xfs_parent.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/init.c b/libxfs/init.c
index 93dc1f1c..49cb2326 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -258,6 +258,8 @@ init_caches(void)
 			"xfs_extfree_item");
 	xfs_trans_cache = kmem_cache_init(
 			sizeof(struct xfs_trans), "xfs_trans");
+	xfs_parent_intent_cache = kmem_cache_init(
+			sizeof(struct xfs_parent_defer), "xfs_parent_defer");
 }
 
 static int
@@ -275,6 +277,7 @@ destroy_caches(void)
 	xfs_btree_destroy_cur_caches();
 	leaked += kmem_cache_destroy(xfs_extfree_item_cache);
 	leaked += kmem_cache_destroy(xfs_trans_cache);
+	leaked += kmem_cache_destroy(xfs_parent_intent_cache);
 
 	return leaked;
 }

