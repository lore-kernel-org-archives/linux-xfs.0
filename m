Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55562 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbfFTV3j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:39 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 07/11] xfs_logprint: remove unneeded includes
Date: Thu, 20 Jun 2019 16:29:30 -0500
Message-Id: <1561066174-13144-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 logprint/log_print_trans.c | 1 -
 logprint/log_redo.c        | 1 -
 2 files changed, 2 deletions(-)

diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index 08e44a3..28c83a9 100644
--- a/logprint/log_print_trans.c
+++ b/logprint/log_print_trans.c
@@ -6,7 +6,6 @@
 #include "libxfs.h"
 #include "libxlog.h"
 
-#include "logprint.h"
 
 void
 xlog_recover_print_trans_head(
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index f1f690e..acc7067 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -7,7 +7,6 @@
 #include "libxfs.h"
 #include "libxlog.h"
 
-#include "logprint.h"
 
 /* Extent Free Items */
 
-- 
1.8.3.1
