Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DA3C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 22:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D90E5218AC
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 22:18:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AZMugjqo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfLRWSW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 17:18:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32025 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726387AbfLRWSW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 17:18:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576707501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UWWGHr84qxq6s0WDk3/HIloMZAO9Vi++1gD2HGi8hHY=;
        b=AZMugjqo/oLDqwdO9/3ieR4+cFswicmHxaYMAQ/Maw/6Z9bFiog8O2nLNodts7snu54auk
        5UBh/66vcuGG+pndFijpQ50xZOXntbqu4sPTebEAA0ShbHaBBFpt+QTCW/Gj/cXlwh2ZxL
        85NhAklCHVkn5Dl/LiCfvMMj6xyFt38=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-1lxPIICRPCuAxozXLQt_pA-1; Wed, 18 Dec 2019 17:18:18 -0500
X-MC-Unique: 1lxPIICRPCuAxozXLQt_pA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF7D2800EBF
        for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2019 22:18:17 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98BCA26DE4
        for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2019 22:18:17 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: fix sparse checker warnings on kmem tracepoints
Message-ID: <7c2af866-5a8e-3f48-ac07-041c3085c545@redhat.com>
Date:   Wed, 18 Dec 2019 16:18:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Sparse checker doesn't like kmem.c tracepoints:

kmem.c:18:32: warning: incorrect type in argument 2 (different base types)
kmem.c:18:32:    expected int [signed] flags
kmem.c:18:32:    got restricted xfs_km_flags_t [usertype] flags

So take an xfs_km_flags_t, and cast it to an int when we print it.

Fixes: 0ad95687c3ad ("xfs: add kmem allocation trace points")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c13bb3655e48..dd165b6d2289 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3545,11 +3545,11 @@ TRACE_EVENT(xfs_pwork_init,
 )
 
 DECLARE_EVENT_CLASS(xfs_kmem_class,
-	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip),
+	TP_PROTO(ssize_t size, xfs_km_flags_t flags, unsigned long caller_ip),
 	TP_ARGS(size, flags, caller_ip),
 	TP_STRUCT__entry(
 		__field(ssize_t, size)
-		__field(int, flags)
+		__field(xfs_km_flags_t, flags)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
@@ -3559,13 +3559,13 @@ DECLARE_EVENT_CLASS(xfs_kmem_class,
 	),
 	TP_printk("size %zd flags 0x%x caller %pS",
 		  __entry->size,
-		  __entry->flags,
+		  (int)__entry->flags,
 		  (char *)__entry->caller_ip)
 )
 
 #define DEFINE_KMEM_EVENT(name) \
 DEFINE_EVENT(xfs_kmem_class, name, \
-	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
+	TP_PROTO(ssize_t size, xfs_km_flags_t flags, unsigned long caller_ip), \
 	TP_ARGS(size, flags, caller_ip))
 DEFINE_KMEM_EVENT(kmem_alloc);
 DEFINE_KMEM_EVENT(kmem_alloc_io);

