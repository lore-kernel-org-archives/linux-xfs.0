Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56206 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727732AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 08/18] xfs_io: include io.h to silence static function warnings
Date: Wed, 10 Oct 2018 15:01:12 -0500
Message-Id: <1539201682-22198-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

io.h exports functions from io/getrusage.c and io/log_writes.c, so include
it from these files to silence warnings about potentially static functions
(getrusage_init, log_writes_init) in sparse.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 io/getrusage.c  | 1 +
 io/log_writes.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/io/getrusage.c b/io/getrusage.c
index ba704b7..6962913 100644
--- a/io/getrusage.c
+++ b/io/getrusage.c
@@ -9,6 +9,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include "init.h"
+#include "io.h"
 
 static cmdinfo_t getrusage_cmd;
 
diff --git a/io/log_writes.c b/io/log_writes.c
index 114f818..9c2285f 100644
--- a/io/log_writes.c
+++ b/io/log_writes.c
@@ -8,6 +8,7 @@
 #include <libdevmapper.h>
 #include "command.h"
 #include "init.h"
+#include "io.h"
 
 static cmdinfo_t log_writes_cmd;
 
-- 
1.8.3.1
