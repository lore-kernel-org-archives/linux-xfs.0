Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02862C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D212920656
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:56:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FClOaDW6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgGHM4U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:56:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38209 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728997AbgGHM4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 08:56:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594212977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SYidMkVA40UWDQUKr05hdRMx5kGdK8jqZpfuWF6R5pg=;
        b=FClOaDW6RIk5AqeEVHVp+UdUx0mvaWZF15DEte1rLTFPy0frwbLkyJqTKKRS/yFTnPnFOu
        ktygrOpp+hT6NB60zQNoH6dKOgjU7VtNwrUjW6Wv9EEApC4Rrum/srgfe+H+uLpHJHJoQI
        iIXDm86kyhLuXnOOVWBFOGd7i9u/HrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-Ka6oacudPRq9Ssv5HDQUrA-1; Wed, 08 Jul 2020 08:56:15 -0400
X-MC-Unique: Ka6oacudPRq9Ssv5HDQUrA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A0AF107BEFB
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2020 12:56:14 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4D146106A
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2020 12:56:13 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: Remove kmem_zone_alloc() usage
Date:   Wed,  8 Jul 2020 14:56:05 +0200
Message-Id: <20200708125608.155645-2-cmaiolino@redhat.com>
In-Reply-To: <20200708125608.155645-1-cmaiolino@redhat.com>
References: <20200708125608.155645-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use kmem_cache_alloc() directly.

All kmem_zone_alloc() users pass 0 as flags, which are translated into:
GFP_KERNEL | __GFP_NOWARN, and kmem_zone_alloc() loops forever until the
allocation succeeds.

So, call kmem_cache_alloc() with __GFP_NOFAIL directly. which will have
the same result.

Once allocation will never fail, don't bother to add __GFP_NOWARN.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  3 ++-
 fs/xfs/libxfs/xfs_bmap.c  |  3 ++-
 fs/xfs/xfs_icache.c       | 11 +++--------
 3 files changed, 7 insertions(+), 10 deletions(-)

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
index 5daef654956cb..69f887abe4334 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -36,14 +36,9 @@ xfs_inode_alloc(
 {
 	struct xfs_inode	*ip;
 
-	/*
-	 * if this didn't occur in transactions, we could use
-	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
-	 * code up to do this anyway.
-	 */
-	ip = kmem_zone_alloc(xfs_inode_zone, 0);
-	if (!ip)
-		return NULL;
+	ip = kmem_cache_alloc(xfs_inode_zone,
+			      GFP_KERNEL | __GFP_NOFAIL);
+
 	if (inode_init_always(mp->m_super, VFS_I(ip))) {
 		kmem_cache_free(xfs_inode_zone, ip);
 		return NULL;
-- 
2.26.2

