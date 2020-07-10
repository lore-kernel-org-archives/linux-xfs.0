Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB441C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA764207BC
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:15:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BVB4Y9aA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgGJJPv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 05:15:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20165 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726644AbgGJJPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 05:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594372549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=liZUOmg7EpGsPGOLZiPjLut7eHt/DYv0memxnIAi5UM=;
        b=BVB4Y9aAid4mSovKglDy3Mpb7lKEC8jMHF6JneM+Kat3/AM5CbLvWcg1AOKaOx0cHVs+lJ
        Fe8M0dHI7HGGryDE7eJN6THoz2oiy8MjF7qs/DvL35tC2/UAOZN/xF94bLivIwec/RvMCm
        1pPhcB+DatRdOHx9bX6m/Moaqyp4rNE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-yzE7RsSoON6f14ayQqidwg-1; Fri, 10 Jul 2020 05:15:48 -0400
X-MC-Unique: yzE7RsSoON6f14ayQqidwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 305E0801E6A
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:15:47 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.193.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89E9E78A44
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:15:46 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2 1/5] xfs: Remove kmem_zone_alloc() usage
Date:   Fri, 10 Jul 2020 11:15:32 +0200
Message-Id: <20200710091536.95828-2-cmaiolino@redhat.com>
In-Reply-To: <20200710091536.95828-1-cmaiolino@redhat.com>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use kmem_cache_alloc() directly.

All kmem_zone_alloc() users pass 0 as flags, which are translated into:
GFP_KERNEL | __GFP_NOWARN, and kmem_zone_alloc() loops forever until the
allocation succeeds.

We can use __GFP_NOFAIL to tell the allocator to loop forever rather
than doing it ourself, and because the allocation will never fail, we do
not need to use __GFP_NOWARN anymore. Hence, all callers can be
converted to use GFP_KERNEL | __GFP_NOFAIL

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Changelog:
	V2:	- Wire up xfs_inode_alloc to use __GFP_NOFAIL
		  if it's called inside a transaction
		- Rewrite changelog in a more decent way.

 fs/xfs/libxfs/xfs_alloc.c |  3 ++-
 fs/xfs/libxfs/xfs_bmap.c  |  3 ++-
 fs/xfs/xfs_icache.c       | 13 +++++++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 203e74fa64aa6..583242253c027 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2467,7 +2467,8 @@ xfs_defer_agfl_block(
 	ASSERT(xfs_bmap_free_item_zone != NULL);
 	ASSERT(oinfo != NULL);
 
-	new = kmem_zone_alloc(xfs_bmap_free_item_zone, 0);
+	new = kmem_cache_alloc(xfs_bmap_free_item_zone,
+			       GFP_KERNEL | __GFP_NOFAIL);
 	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
 	new->xefi_blockcount = 1;
 	new->xefi_oinfo = *oinfo;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 667cdd0dfdf4a..fd5c0d669d0d7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -553,7 +553,8 @@ __xfs_bmap_add_free(
 #endif
 	ASSERT(xfs_bmap_free_item_zone != NULL);
 
-	new = kmem_zone_alloc(xfs_bmap_free_item_zone, 0);
+	new = kmem_cache_alloc(xfs_bmap_free_item_zone,
+			       GFP_KERNEL | __GFP_NOFAIL);
 	new->xefi_startblock = bno;
 	new->xefi_blockcount = (xfs_extlen_t)len;
 	if (oinfo)
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5daef654956cb..8c3fe7ef56e27 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -35,15 +35,20 @@ xfs_inode_alloc(
 	xfs_ino_t		ino)
 {
 	struct xfs_inode	*ip;
+	gfp_t			gfp_mask = GFP_KERNEL;
 
 	/*
-	 * if this didn't occur in transactions, we could use
-	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
-	 * code up to do this anyway.
+	 * If this is inside a transaction, we can not fail here,
+	 * otherwise we can return NULL on ENOMEM.
 	 */
-	ip = kmem_zone_alloc(xfs_inode_zone, 0);
+
+	if (current->flags & PF_MEMALLOC_NOFS)
+		gfp_mask |= __GFP_NOFAIL;
+
+	ip = kmem_cache_alloc(xfs_inode_zone, gfp_mask);
 	if (!ip)
 		return NULL;
+
 	if (inode_init_always(mp->m_super, VFS_I(ip))) {
 		kmem_cache_free(xfs_inode_zone, ip);
 		return NULL;
-- 
2.26.2

