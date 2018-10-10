Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56208 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 09/18] libxfs: silence sparse static function warnings in util.c
Date: Wed, 10 Oct 2018 15:01:13 -0500
Message-Id: <1539201682-22198-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

libxfs.h exports functions defined in util.c, so include that file to
silence sparse warnings about potential static functions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxfs/util.c b/libxfs/util.c
index ffd2650..bd41404 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -5,6 +5,7 @@
  */
 
 #include "libxfs_priv.h"
+#include "libxfs.h"
 #include "libxfs_io.h"
 #include "init.h"
 #include "xfs_fs.h"
-- 
1.8.3.1
