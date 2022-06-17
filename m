Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 314FCC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 10:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381620AbiFQKH2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 06:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381696AbiFQKHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 06:07:17 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D403F69CE2;
        Fri, 17 Jun 2022 03:06:49 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id n1so4855416wrg.12;
        Fri, 17 Jun 2022 03:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aeFrWkB9bAtH1ohe/wgGvpaJlZDS3CmcylgXaGBlt54=;
        b=KOaQZ5POGis26lUZ50+UBc0xDSnzow02/3JLsQNYGscEugNsvMmOqifQXdhujixGOE
         +n3meouiYo96fH06XhO3p2ghSH0ySNk4wWJoqhOinPr/mSPgPQpQIdAqiqhdRnGbaEzX
         hIux1pDg+ouCaiBMzr2u4/9WbuC30NZpQGm1RYVQDOcaEFLHTgUknG+Q8lYggLFEl7sI
         /5fpIFiB6D7hktqiAZedeHdke+n2wlHITYjWfzJE1dDQ3dpL2ANi5ht6DTRVgraBzsiC
         WokvF73cQtbqLOofVlRWjRfoxYbRP2Xb6yQELe5G0ZTQhhskdZprhbsZ2Vy03G1Cn4nu
         UQOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aeFrWkB9bAtH1ohe/wgGvpaJlZDS3CmcylgXaGBlt54=;
        b=d2ZXXjgx5LwFBB0bfV3F+m3fNl8/aywHc0gTwpyR/JOBFxVDRj93rrNS4hx1qPoWrV
         avgJ2RD2CqcDG094XjkWgqCQtlpC6TAgL/ZkuU5hARvNX1kYvSLnsRUzDApz5vwZ6W1L
         QksDHfnzQ+eHJKSm552Mz0GPwjqYURydMVXn7be0iyZKiq72Otyx83JIqYVBaXp0kZUg
         ZYlXjo89gBKXkp/S8Fmfe2ITgrC5zbr/yPr33y3LzD66sYmrLBgZL24wJOLM2prdwPuW
         TDBadBy8CgHks6f/Q5zFSaK/caUafWLgW49usaZVGwBGdQI9xvPI5TMM8e4G//gF3jSU
         dqMQ==
X-Gm-Message-State: AJIora+EjptPzyXqQeB5aF5WRBVlAuY9AQxhjgPu0Sn+q8Md0fOdNf3W
        Qu9kdxT4J7tdsDHfJ/Ih/YExs+g5dy27fQ==
X-Google-Smtp-Source: AGRyM1tdf8q4Aj4fFkfDT/W2StMXWq4R3JP4G4LFK8mSKLXV6wzW6NlyXEvElGENaLZ62EOrSNpGEA==
X-Received: by 2002:a5d:6786:0:b0:215:3cb5:b16c with SMTP id v6-20020a5d6786000000b002153cb5b16cmr8625426wru.6.1655460408012;
        Fri, 17 Jun 2022 03:06:48 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id m42-20020a05600c3b2a00b003973435c517sm5265534wms.0.2022.06.17.03.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:47 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [PATCH 5.10 CANDIDATE 01/11] xfs: use kmem_cache_free() for kmem_cache objects
Date:   Fri, 17 Jun 2022 13:06:31 +0300
Message-Id: <20220617100641.1653164-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617100641.1653164-1-amir73il@gmail.com>
References: <20220617100641.1653164-1-amir73il@gmail.com>
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

