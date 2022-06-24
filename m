Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C78CCA47F
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 06:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiFXGhM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 02:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiFXGhL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 02:37:11 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE466270D;
        Thu, 23 Jun 2022 23:37:09 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id p6-20020a05600c1d8600b0039c630b8d96so2873822wms.1;
        Thu, 23 Jun 2022 23:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X6hunTx6t84e1RH7TuIwMAVJt14IU7tMQ/ZDFHTvWjE=;
        b=ZyCRg4GWAXGUtf3Z2N1++vgG8NWM5m70FpRceKMSPYG3E2gS52XfB8jWTKfh/KUucW
         3k9szx9jp44HPPrwRzya/EBsjdnZJE9rhZ2SSdNfNR3Ltdzl+YcC9wCLAYOUe+fRRbPt
         RVTNPt/Xg7h0U9zFReAp7BZQEO8IlPDGQ+WESwN+MhKoK5FgRSZctZ3wlb+CEeIdmzzE
         RTXVkK4mtustOIpCPn773p80bpcWHuAiz3b0gC3l42Zrn0+pccq38MA4d9JjxGgx2JMJ
         dd+ViQI8tD5JTlGjeuVtx4jurdcLWA2WFro7lUbm3jRMLaGC8EwJA9tbCTfJYKE7HF4B
         oxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X6hunTx6t84e1RH7TuIwMAVJt14IU7tMQ/ZDFHTvWjE=;
        b=FlUSJk00zv2nQsKyN5usRYFZsNGnitbcJOPY+mRaFms8vHY3M9IkU6rT8ZmvJiKm1s
         k2h+c3p8QnTX0Nen+i2Q58NYK1LFM4c7XuIdjLg9g9pPwWC6OyVc7BAlmfYpYKQ+RwQ4
         AHGy42x6McPrXHTzTRG34ijP2CrTVTHXTtz52d36ApBrkMAykoXDj18tYZnCMjKpO0+2
         yo1EO5UyHnH1D8eyww389x8QpNkLYK+MgI8qug9IkHfG060O6Ja5zove70DAftAFTDDs
         81KGLrVrsbi9yOMJmh7oZxVzXLaEOhJhK0nVSsX3PUs+77Fa022rVHDWQc0VUW+j5RxE
         7EWw==
X-Gm-Message-State: AJIora8OrQraEtkev+Yj/O0ECCYxFu1VmKIhXhGqavIdOzQ4odTKNZoX
        WrBjF0YLf+e0MWSvIG+28ysimSZScN8lxQ==
X-Google-Smtp-Source: AGRyM1u3AG1crJ5vqgFUF2vqOHUW0mKmfMFkGZNv/OqTLUdsA1zAWRmxHwuuE5moZDnlJ7w1FT+Myg==
X-Received: by 2002:a7b:cb03:0:b0:39e:e826:ce6d with SMTP id u3-20020a7bcb03000000b0039ee826ce6dmr1890278wmj.102.1656052628580;
        Thu, 23 Jun 2022 23:37:08 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d67ce000000b0021b89c07b6asm1540653wrw.108.2022.06.23.23.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:37:08 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [5.10 CANDIDATE v2 1/5] xfs: use kmem_cache_free() for kmem_cache objects
Date:   Fri, 24 Jun 2022 09:36:58 +0300
Message-Id: <20220624063702.2380990-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624063702.2380990-1-amir73il@gmail.com>
References: <20220624063702.2380990-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

commit c30a0cbd07ecc0eec7b3cd568f7b1c7bb7913f93 upstream.

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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 5c0395256bd1..11474770d630 100644
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
2.25.1

