Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043A1C43334
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 18:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348462AbiFCS5v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348453AbiFCS5u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 14:57:50 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671FC2981D
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 11:57:47 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-f33f0f5b1dso11712955fac.8
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jun 2022 11:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SseSXdCzB+Ifd94vd3Ijc2ci9ymNcqKyCWCDH8QQUjc=;
        b=Ey91W4EZ4eDNPwMrfb5ZN2DjBBpK0kBvlXJVh11FX45cWdTxYxGie2ies+EacCaK/c
         8om/wEROqRDcGbiQ32ch7w2u3H7j9sWs5yVONYfy6vG+O7MEmNuekzcGOoi4JszpNK7z
         nLehrbqPnbZ63NMRpskfH/g8Ehlxi0s9kF5zO0Bmm1QgXQFhQI+qL8Ytx+ZwhHh/MGkQ
         XdQUywXLUdfEZIG+/rlGgp6dKk8kFIk0hlxUq3Jk2eFjSAAl+4sbN6RxaVFrHr1v2c+G
         RBrTltxuTbgB56wkL1IG5WgeRyOlkKLwaVpcACfNrYqzWzW2TeJzLQr4EPMwVzeJxBxu
         jWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SseSXdCzB+Ifd94vd3Ijc2ci9ymNcqKyCWCDH8QQUjc=;
        b=n5oOPzm6SJOfEg2ouLS7/4kPBTJ919IXsGY6ORj/QEtxwH19dhZj3F2SgoCP17lMev
         0qz2R3ixVMXuxh/9RNCHREGW9fNVzSpZxScE/Hqj5rc9alWG+L3/71flNbuPuu3CmbqE
         9Bznjkndzof+qCqFNJG6vFgwXNCcSMtmQOhFULBDHgv8huwNcTEN2wb9RcO0VcFpdBEt
         y5G3BrGcAVxETomAFhzWkEWEJKSngX28sKdb0qqstiu7TyGC4zlzh9XUXsBfei6cpZe7
         0VkBJDx9Ds83YL4X22yjlKvHvaiJMrLg1A491CM/8EdCzRnjWTGi0/ZG6VWbPfOV73dQ
         MOCg==
X-Gm-Message-State: AOAM532sCrqJqKgUkVXNopy9XIuj2MylY9EOEToL1Y2yudHJAs6nychj
        c+NuyhH7odDSydX6p77/HvsL1s5htFE=
X-Google-Smtp-Source: ABdhPJx7EPP/MChllylHcjsWG3WnEPmnff8ckRCSIVZgebx+w+LQk9DOMAsBuHWihwxOW3faae4a9w==
X-Received: by 2002:a17:90b:46c6:b0:1e3:524c:7f94 with SMTP id jx6-20020a17090b46c600b001e3524c7f94mr18947721pjb.177.1654282655267;
        Fri, 03 Jun 2022 11:57:35 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:e74e:a023:a0be:b6a8])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001621ce92196sm4480969plk.86.2022.06.03.11.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:57:34 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org
Cc:     Rustam Kovhaev <rkovhaev@gmail.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 01/15] xfs: use kmem_cache_free() for kmem_cache objects
Date:   Fri,  3 Jun 2022 11:57:07 -0700
Message-Id: <20220603185721.3121645-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

[ Upstream commit c30a0cbd07ecc0eec7b3cd568f7b1c7bb7913f93 ]

For kmalloc() allocations SLOB prepends the blocks with a 4-byte header,
and it puts the size of the allocated blocks in that header.
Blocks allocated with kmem_cache_alloc() allocations do not have that
header.

SLOB explodes when you allocate memory with kmem_cache_alloc() and then
try to free it with kfree() instead of kmem_cache_free().
SLOB will assume that there is a header when there is none, read some
garbage to size variable and corrupt the adjacent objects, which
eventually leads to hang or panic.

Let's make XFS work with SLOB by using proper free function.

Fixes: 9749fee83f38 ("xfs: enable the xfs_defer mechanism to process extents to free")
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_extfree_item.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3f8a0713573a..a4b8caa2c601 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -482,7 +482,7 @@ xfs_extent_free_finish_item(
 			free->xefi_startblock,
 			free->xefi_blockcount,
 			&free->xefi_oinfo, free->xefi_skip_discard);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 	return error;
 }
 
@@ -502,7 +502,7 @@ xfs_extent_free_cancel_item(
 	struct xfs_extent_free_item	*free;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -564,7 +564,7 @@ xfs_agfl_free_finish_item(
 	extp->ext_len = free->xefi_blockcount;
 	efdp->efd_next_extent++;
 
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 	return error;
 }
 
-- 
2.36.1.255.ge46751e96f-goog

