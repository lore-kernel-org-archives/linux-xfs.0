Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2770C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 20:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiFWUhH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 16:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiFWUhG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 16:37:06 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2AE60F17
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:06 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id o18so274428plg.2
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EJ0biCIxVVWv8FXDO+74+pFK2hXee6NmP1YA59oxZXM=;
        b=VfmkCaaTpDFP9v08Ve87U3S/KlJACkdFMZ7dY0Ef7gEg2aBmj5kBOij9bNqqQsfFx4
         55HsrhF0f1eq1Rw1rIevWUPxKVu+kXS+CNlpk5Ab3eAxViZQZfnA5GDeybG4G5dA2jBd
         bGqpwdusniu3gCTZ/24fOBwxZi4flGprHGeF7Ld4chlvaCbI2vjkwRm7slsuSK44MQII
         pROdt6XOwSMdXsUBaXq/cJ7D/CfYEN7c4jmvq4tmuDt8oUe7rhqfI5V/KVpp0awzcCbq
         6NpeknTBEYM+7TvpMs6ToKVJYc4oGd9ZiKuVdnQuDNo890wB7dIHcZx77YhPV0e0w0wx
         NsIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EJ0biCIxVVWv8FXDO+74+pFK2hXee6NmP1YA59oxZXM=;
        b=g0IsuAmm6EwaPb66hQBn8JUgHXoZXJ/UNq2w5qwbPGpoztSzY4pR2tEckXWbNEcs2v
         /CjyChoQX+kV8h1uCDT43yOtRWHI+B+4klFFEPiomdcGjhBjEJEWVRWByVamXap8oj6c
         818YzrcR9XS42IXclTM1ck+6IsX8JObAGGdbQRLKf3elPdiy9VMP2vfLM3mAaaELKhEB
         EJXPExNtCCL7xiy7fLTDBN8B8yBaFuK/mYeGBYdxmuRsBJrhe0XKzmjg9ctna54top7g
         KYAvMWDfIL2GlDUKAFyUlg6ofvHtSt0L7K2exkVPaBqwqFQfZ2xMBsLTETBRf9ES9S8y
         PJYw==
X-Gm-Message-State: AJIora+aYHbOlPn6OWTo/07GqvSGJbmLVqsJEsA8V+utBM7UUY8jeyj8
        PtsxBtUMpUFz2JWs2hGSfTLhqD/thGJWVQ==
X-Google-Smtp-Source: AGRyM1tXcQhyXpTbaL7MWwjDwkjF0V1gb2N3O5HQ6enyxzytQKZY47ysC4Q382+ECu4tc1lO1R6FfA==
X-Received: by 2002:a17:902:e5c2:b0:16a:62c7:4190 with SMTP id u2-20020a170902e5c200b0016a62c74190mr2243579plf.110.1656016625302;
        Thu, 23 Jun 2022 13:37:05 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:a654:18fe:feac:cac1])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902768c00b0016a17da4ad4sm228386pll.39.2022.06.23.13.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 13:37:05 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Rustam Kovhaev <rkovhaev@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v3 1/7] xfs: use kmem_cache_free() for kmem_cache objects
Date:   Thu, 23 Jun 2022 13:36:35 -0700
Message-Id: <20220623203641.1710377-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220623203641.1710377-1-leah.rumancik@gmail.com>
References: <20220623203641.1710377-1-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.37.0.rc0.161.g10f37bed90-goog

