Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0EFC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 02:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E1C6023D
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 02:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhKDCYR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Nov 2021 22:24:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229541AbhKDCYQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Nov 2021 22:24:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635992499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+1t0WDO/fpSESsnWA7L/CZCLfrr2CI8lZwROdpVNulI=;
        b=PKvhyH2PiSxNHRcnNBm8Hlaws8TF56BBqZt5fEEx7JWGqfrQ0l1ZjSRJrpftJke2lAxY+0
        Sp3ZbFdgmxyUWM5MD6a5vMuClIIo1ftV4yds+aVaf2NZEBWIuqzyrmFOUibG2ZCeq1LKon
        tOikTkXRpB6nC7q0JFS8Qy0Uld+VkcA=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-o912zwiwMWOUF7XWznjCZQ-1; Wed, 03 Nov 2021 22:21:37 -0400
X-MC-Unique: o912zwiwMWOUF7XWznjCZQ-1
Received: by mail-io1-f72.google.com with SMTP id m5-20020a0566022e8500b005e192595a3dso2864939iow.20
        for <linux-xfs@vger.kernel.org>; Wed, 03 Nov 2021 19:21:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :content-language:to:subject:cc:content-transfer-encoding;
        bh=+1t0WDO/fpSESsnWA7L/CZCLfrr2CI8lZwROdpVNulI=;
        b=mjFh2oNlYW8PDcf9jM9LsiIX5wo78UxcO27z2TuBgY6E5I1Q/Q0lQzDcH787Vv3yhe
         0kHnBXf9KwNNVReWHgJr5UgPLIKoXTCFJQ4SqPUmD338m3C9Vsi1uTQxpWbbCQ28NoU6
         DLEQ4dF8AiNDLbjFSnUbx1CT3frZq5xqa4fZnhIEUau4E3MJgKQvvcrAz5UynMajXqkF
         5Vi8kwpiu9nFKPELiJksZGNKF5Gv1tQq9pXg0jZeDjcxW2UScEkjSCLskGxue8ERrQpJ
         ANlF5JZZrsGSB+bqSvDv9+ylHptO8aimdmxebKDLBohdl7NG0+8HPeYk+zUV7yhB7jkp
         EmUw==
X-Gm-Message-State: AOAM5330NOCjfzTtJqwkCnrQYUXPGAP1gtsyhn7e+MoP5ADi6RdJ649I
        JrNzl8QSaQGF6NYQQz9JvRtpJeOPpEv4wk4VU2bjXgDDGMw3s5AmRUWX7aMt8+nzZY/ByTwjw3/
        /dRikULhkVlwQS198D0PzkMLmOkfbkMKB1uexYI6Q3Btof1c6sQOt/h05T4YyLBIUTBZJhgHM
X-Received: by 2002:a05:6638:3391:: with SMTP id h17mr1639897jav.33.1635992497165;
        Wed, 03 Nov 2021 19:21:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4lQn00ZJ+suCv2ICJQkOLF4rkYdaPoCZjxF8pbN+FSUlFfbTylooA0Gvltv6hRkQrEwZSRQ==
X-Received: by 2002:a05:6638:3391:: with SMTP id h17mr1639881jav.33.1635992496932;
        Wed, 03 Nov 2021 19:21:36 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id l14sm2180104iow.31.2021.11.03.19.21.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 19:21:36 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
Date:   Wed, 3 Nov 2021 21:21:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfsprogs: move stubbed-out kernel functions out of
 xfs_shared.h
Cc:     "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move kernel stubs out of libxfs/xfs_shared.h, which is kernel
libxfs code and should not have userspace shims in it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

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
index 00000000..41eaa0c4
--- /dev/null
+++ b/include/stubs.h
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Stub out unimplemented and unneeded kernel structures etc
+ */
+#ifndef STUBS_H
+#define STUBS_H
+
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

