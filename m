Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D071BC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 02:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A053560E93
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 02:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhKJCFF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Nov 2021 21:05:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35824 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhKJCFE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Nov 2021 21:05:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636509737;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RXr0OXnPZhtdbF7z4tfwDPOM4CnfS4NXitz7YpZh0i0=;
        b=RcJRdxH90UGOq5jZ2bGXzt3Yna6FrdghAIG02u6qvFTaouibnHETQzDcKVRqK5xUxm2/dg
        ZNHEKTnJdgQQB30WbNXEXE/8UxzS3s5+CcN9riUu1SJtgE5mYV+gIqbHvKUrsSmhi6wX15
        hyOMsk/27kcZf34+lAkP+h1+CqY31GY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-6KoYcwMVNxCIAXnLY0SXRg-1; Tue, 09 Nov 2021 21:02:15 -0500
X-MC-Unique: 6KoYcwMVNxCIAXnLY0SXRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3C67180830B
        for <linux-xfs@vger.kernel.org>; Wed, 10 Nov 2021 02:02:14 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E765100E125
        for <linux-xfs@vger.kernel.org>; Wed, 10 Nov 2021 02:02:14 +0000 (UTC)
Message-ID: <bf4256a4-a4eb-29e7-b974-0a7c01913d9a@redhat.com>
Date:   Tue, 9 Nov 2021 20:02:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
From:   Eric Sandeen <esandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
References: <a98ed48b-7297-34af-2a2a-795b15b35f12@redhat.com>
Reply-To: sandeen@redhat.com
Subject: [PATCH 3/3] xfsprogs: remove kernel stubs from xfs_shared.h
In-Reply-To: <a98ed48b-7297-34af-2a2a-795b15b35f12@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The kernel stubs added to xfs_shared.h don't belong there, and
are mostly unnecessary with the #ifdef __KERNEL__ bits added to
the xfs_ag.[ch] files. Move the one remaining needed stub in
libxfs_priv.h.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 15bae1ff..3957a2e0 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -75,6 +75,8 @@ extern kmem_zone_t *xfs_trans_zone;
  /* fake up kernel's iomap, (not) used in xfs_bmap.[ch] */
  struct iomap;
  
+#define cancel_delayed_work_sync(work) do { } while(0)
+
  #include "xfs_cksum.h"
  
  /*
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index bafee48c..25c4cab5 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -180,24 +180,4 @@ struct xfs_ino_geometry {
  
  };
  
-/* Faked up kernel bits */
-struct rb_root {
-};
-
-#define RB_ROOT 		(struct rb_root) { }
-
-typedef struct wait_queue_head {
-} wait_queue_head_t;
-
-#define init_waitqueue_head(wqh)	do { } while(0)
-
-struct rhashtable {
-};
-
-struct delayed_work {
-};
-
-#define INIT_DELAYED_WORK(work, func)	do { } while(0)
-#define cancel_delayed_work_sync(work)	do { } while(0)
-
  #endif /* __XFS_SHARED_H__ */

