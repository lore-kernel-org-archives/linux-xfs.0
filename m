Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36BDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 03:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6A9861056
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 03:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhKDDCi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Nov 2021 23:02:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229561AbhKDDCi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Nov 2021 23:02:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635994800;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=blWntMOfiS0Jpx6eJByyVQ1ebIuCItzJKFz2kz3h/NE=;
        b=ftWELLRMbk5yRpjeOVOmLXL2AY9cwyPYHkEQo1uKICk3MsrP+aCU2q96zzv5v4fSFVvcMW
        31veGqfUlZ+e4NlAIgVpK6lh11D/W4uMxguBIPwCdiiCZgxTjM3aQ40rAnGJsv5JM+QDj5
        qib7Qnz6WjI+z2C6owsFAkLHhWmhh9k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-5ryY1RjyMpuNxdU0jCR7nQ-1; Wed, 03 Nov 2021 22:59:59 -0400
X-MC-Unique: 5ryY1RjyMpuNxdU0jCR7nQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D8801006AA2;
        Thu,  4 Nov 2021 02:59:58 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10B9619EF9;
        Thu,  4 Nov 2021 02:59:57 +0000 (UTC)
Message-ID: <7fe17d89-749d-7114-1f4f-294aba1e3f1d@redhat.com>
Date:   Wed, 3 Nov 2021 21:59:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: [PATCH V2] xfsprogs: move stubbed-out kernel functions out of
 xfs_shared.h
Content-Language: en-US
From:   Eric Sandeen <esandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>
References: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
Reply-To: sandeen@redhat.com
In-Reply-To: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move kernel stubs out of libxfs/xfs_shared.h, which is kernel
libxfs code and should not have userspace shims in it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: fix spdx and copyright

diff --git a/include/libxfs.h b/include/libxfs.h
index 24424d0e..64b44af8 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -11,6 +11,7 @@
  #include "platform_defs.h"
  #include "xfs.h"
  
+#include "stubs.h"
  #include "list.h"
  #include "hlist.h"
  #include "cache.h"
diff --git a/include/stubs.h b/include/stubs.h
new file mode 100644
index 00000000..d80e8de0
--- /dev/null
+++ b/include/stubs.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef STUBS_H
+#define STUBS_H
+
+/* Stub out unimplemented and unneeded kernel functions */
+struct rb_root {
+};
+
+#define RB_ROOT 		(struct rb_root) { }
+
+typedef struct wait_queue_head {
+} wait_queue_head_t;
+
+#define init_waitqueue_head(wqh)	do { } while(0)
+
+struct rhashtable {
+};
+
+struct delayed_work {
+};
+
+#define INIT_DELAYED_WORK(work, func)	do { } while(0)
+#define cancel_delayed_work_sync(work)	do { } while(0)
+
+#endif
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 15bae1ff..32271c66 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -41,6 +41,7 @@
  #include "platform_defs.h"
  #include "xfs.h"
  
+#include "stubs.h"
  #include "list.h"
  #include "hlist.h"
  #include "cache.h"
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

