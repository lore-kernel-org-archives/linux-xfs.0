Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C55DCC433E1
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A20F020656
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YptntORd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgGHM4e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:56:34 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45554 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729122AbgGHM4X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 08:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594212981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LMLb2qZoSVu03BXx+vGPzqIar79gY1bq6IR2KeUnBTI=;
        b=YptntORd+56gqotvRxuBdXpVAh2zE6wnysyT5KyFLZJx96hhwNOXYZCXG2ux9lPyy84kGs
        EpGc8OxpVlR3sdLmrk7yKtDOyr/8kaZyKLSF1SgflQFDwPqfe61BQ6TRsbtPjunrj8OgVk
        fLtHh9go3TgUiJan4w0HkU41xJ1KMZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-iVajLQxzMWa31SfBEYx3qA-1; Wed, 08 Jul 2020 08:56:20 -0400
X-MC-Unique: iVajLQxzMWa31SfBEYx3qA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B81F193F56D
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2020 12:56:19 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A211D60E3E
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2020 12:56:18 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: remove xfs_zone_{alloc,zalloc} helpers
Date:   Wed,  8 Jul 2020 14:56:08 +0200
Message-Id: <20200708125608.155645-5-cmaiolino@redhat.com>
In-Reply-To: <20200708125608.155645-1-cmaiolino@redhat.com>
References: <20200708125608.155645-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All their users have been converted to use MM API directly, no need to
keep them around anymore.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.c      | 21 ---------------------
 fs/xfs/kmem.h      |  8 --------
 fs/xfs/xfs_trace.h |  1 -
 3 files changed, 30 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index f1366475c389c..e841ed781a257 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -115,24 +115,3 @@ kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
-
-void *
-kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
-{
-	int	retries = 0;
-	gfp_t	lflags = kmem_flags_convert(flags);
-	void	*ptr;
-
-	trace_kmem_zone_alloc(kmem_cache_size(zone), flags, _RET_IP_);
-	do {
-		ptr = kmem_cache_alloc(zone, lflags);
-		if (ptr || (flags & KM_MAYFAIL))
-			return ptr;
-		if (!(++retries % 100))
-			xfs_err(NULL,
-		"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
-				current->comm, current->pid,
-				__func__, lflags);
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
-	} while (1);
-}
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 34cbcfde92281..8e8555817e6d3 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -85,14 +85,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 #define kmem_zone	kmem_cache
 #define kmem_zone_t	struct kmem_cache
 
-extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
-
-static inline void *
-kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
-{
-	return kmem_zone_alloc(zone, flags | KM_ZERO);
-}
-
 static inline struct page *
 kmem_to_page(void *addr)
 {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 460136628a795..d8f5f3d99bb8f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3582,7 +3582,6 @@ DEFINE_KMEM_EVENT(kmem_alloc);
 DEFINE_KMEM_EVENT(kmem_alloc_io);
 DEFINE_KMEM_EVENT(kmem_alloc_large);
 DEFINE_KMEM_EVENT(kmem_realloc);
-DEFINE_KMEM_EVENT(kmem_zone_alloc);
 
 TRACE_EVENT(xfs_check_new_dalign,
 	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
-- 
2.26.2

