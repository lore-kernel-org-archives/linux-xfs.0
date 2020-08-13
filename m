Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5A6C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 14:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A52D20716
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 14:26:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JTrjRLbm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgHMO0w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 10:26:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38767 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726142AbgHMO0v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 10:26:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597328810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=htUszEghnbJwG50sWIHXh1ICZQ/UfGrU7BCJMGcfEF0=;
        b=JTrjRLbmLBiMto2aCihMbs5JCSohAGgPdsS1Irx+GWswahej6ALd25+NYZ+6jnV3ZeLFd2
        qYbtfBsANK9LLjUMoRevEY/2DxvlFnqYbS+jiJFn/jMbVV1irVD9/9qSS3tMo4LB8EfUOn
        kUabj8ky4kN4uJ+6LEQyoPczkZJTbXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-7RtzbYEZPmO616GiORsJIQ-1; Thu, 13 Aug 2020 10:26:48 -0400
X-MC-Unique: 7RtzbYEZPmO616GiORsJIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95D02801AC3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2020 14:26:47 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.195.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDC8C5B696
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2020 14:26:46 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: remove kmem_realloc()
Date:   Thu, 13 Aug 2020 16:26:40 +0200
Message-Id: <20200813142640.47923-3-cmaiolino@redhat.com>
In-Reply-To: <20200813142640.47923-1-cmaiolino@redhat.com>
References: <20200813142640.47923-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All its users are now using MM API directly, so, there is no more need
for this function and its tracepoint to be around

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.c      | 22 ----------------------
 fs/xfs/kmem.h      |  1 -
 fs/xfs/xfs_trace.h |  1 -
 3 files changed, 24 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index e841ed781a25..e986b95d94c9 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -93,25 +93,3 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
 		return ptr;
 	return __kmem_vmalloc(size, flags);
 }
-
-void *
-kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
-{
-	int	retries = 0;
-	gfp_t	lflags = kmem_flags_convert(flags);
-	void	*ptr;
-
-	trace_kmem_realloc(newsize, flags, _RET_IP_);
-
-	do {
-		ptr = krealloc(old, newsize, lflags);
-		if (ptr || (flags & KM_MAYFAIL))
-			return ptr;
-		if (!(++retries % 100))
-			xfs_err(NULL,
-	"%s(%u) possible memory allocation deadlock size %zu in %s (mode:0x%x)",
-				current->comm, current->pid,
-				newsize, __func__, lflags);
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
-	} while (1);
-}
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 8e8555817e6d..fb1d06677072 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -59,7 +59,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
 extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
 extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
-extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
 static inline void  kmem_free(const void *ptr)
 {
 	kvfree(ptr);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index abb1d859f226..d898d7ac4dc3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3676,7 +3676,6 @@ DEFINE_EVENT(xfs_kmem_class, name, \
 DEFINE_KMEM_EVENT(kmem_alloc);
 DEFINE_KMEM_EVENT(kmem_alloc_io);
 DEFINE_KMEM_EVENT(kmem_alloc_large);
-DEFINE_KMEM_EVENT(kmem_realloc);
 
 TRACE_EVENT(xfs_check_new_dalign,
 	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
-- 
2.26.2

