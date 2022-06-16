Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770BDC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 18:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377969AbiFPS2h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbiFPS2R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 14:28:17 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85D13914E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:15 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g186so1993285pgc.1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pi6ZfE3z4hZEsthmh+HAVBUNN5yitJQkb1TuPH9Q86E=;
        b=VON7MdR85AIJwG1fHFLpZL5N+jlg/0QomInyIK9yJTyT9ASCqY5ISZyl9Zl6H8d8vD
         e4y0JYcRxfL/TZpjSvSZIcR5chAmEiIf3L+80Pb37wgXnCM2jbnZP1NaMbo8vNc/CgW9
         NMEr7g+YnUtwSksyP0OzWhTYnqr74qNjlC1A9Ng1FHo+uXbGt+hs605Cq6jJoCivOJjZ
         nAJrUTjf1jfCVh2LhEfgtHiEX0CCihPqGdoxpBVKsN/dXPHX10o3rOlmU4gB6zm/plew
         pOEs4dBCyLCGfxgEHPFUh+d1Mrep9N9FS8JIpPZmKCL61H7b+n8f/0ZM7eZ0BTRuY2bi
         gYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pi6ZfE3z4hZEsthmh+HAVBUNN5yitJQkb1TuPH9Q86E=;
        b=Mc+jP7QYXcPZOjldsOYN+uFamM3N8V+Gm9ZGI5iR/hd5coxCql60Jc9oTF6Ux585XT
         gc5bGqqVON1JPGnOsG/S2KRV7D4loWM65exMf6tZ7pQ73Ijz4/eTkMJpDLDSzeheHn1b
         wnS1vFfVA+MeCsvFMh2KOElwf1O+KfPw+J+Cf1iozq17dennVavvFwY0pXttHG4dTwWq
         CuGS5hSRYniO4lzy78i9oWa2Yt9HX2ewQ8oIwkBkKLP2U89SrhnSUTTEtA/epzIgNAsk
         CilPtg8VOTrjj4ynsQ4vjNIir90o0iT/0pIONo42xWlndGscoJlZiXKdtxREzr2c0jA7
         ucnw==
X-Gm-Message-State: AJIora+++Iwz4MfDzybHPdJcU8RLBKzuRMQfZo0rc61YZgEP3knDs20f
        c8hOzRxWK+yl9f7DMkJoMkh6ytftLm8N8Q==
X-Google-Smtp-Source: AGRyM1t0ILb3JqA+flFutWq0EegEDg8Y8sjQJZ9yj4L8H/+nqJxkcQc/8F4AnyL7eYOQhc0O5AjJgA==
X-Received: by 2002:a05:6a00:23c6:b0:51b:f8e3:2e5c with SMTP id g6-20020a056a0023c600b0051bf8e32e5cmr6100182pfc.43.1655404095209;
        Thu, 16 Jun 2022 11:28:15 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:fd57:7edc:385a:c1be])
        by smtp.gmail.com with ESMTPSA id fs20-20020a17090af29400b001ea75a02805sm4131511pjb.52.2022.06.16.11.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:28:14 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     mcgrof@kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v2 1/8] xfs: use kmem_cache_free() for kmem_cache objects
Date:   Thu, 16 Jun 2022 11:27:42 -0700
Message-Id: <20220616182749.1200971-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220616182749.1200971-1-leah.rumancik@gmail.com>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
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
2.36.1.476.g0c4daa206d-goog

