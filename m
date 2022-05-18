Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA61C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241696AbiERSzY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241698AbiERSzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:55:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0274622EA7D
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 931056189A
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BB9C385A9;
        Wed, 18 May 2022 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900120;
        bh=LOCMaFd78cYiPJoAFLbvy/2Tf+VsdWrPCKWNGwyMcxM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=srKAmYEiif1jVgnWu03+EaXzv2QnOA3qgoEOEr6JwxRKaiFioyDvFGA9ObF2Y4v9b
         DfEarKxXVsOnZirmTWNtIoT4oU+zIbYW2eoCx/CrJ67NEjrTS0s6yLf0+8FQ5Osxqs
         nAdJ+P8o7/UWaxyezCsBqIYJWipRHtmBe6F/5giaM65KFU3wxq2nh58XxyfaUyayTr
         xOGa/6k4uQzlEm3X4u61GQAkCuGhgV/cmwp7lvqGUFBSdommxlhb0kNGoDjKBVy+I/
         qE4yu15yK1tIRB6kbJBdtAa2LaojBox1VNCusQ/zn6qphee0EnHRJe2YZi8U5tIV8K
         +dhL/ykA86YZw==
Subject: [PATCH 3/3] xfs: free xfs_attrd_log_items correctly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:55:19 -0700
Message-ID: <165290011952.1646163.16695840263373472236.stgit@magnolia>
In-Reply-To: <165290010248.1646163.12346986876716116665.stgit@magnolia>
References: <165290010248.1646163.12346986876716116665.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Technically speaking, objects allocated out of a specific slab cache are
supposed to be freed to that slab cache.  The popular slab backends will
take care of this for us, but SLOB famously doesn't.  Fix this, even if
slob + xfs are not that common of a combination.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 7d4469e8a4fc..9ef2c2455921 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -290,7 +290,7 @@ STATIC void
 xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
 {
 	kmem_free(attrdp->attrd_item.li_lv_shadow);
-	kmem_free(attrdp);
+	kmem_cache_free(xfs_attrd_cache, attrdp);
 }
 
 STATIC void

