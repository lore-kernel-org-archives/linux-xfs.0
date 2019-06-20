Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55550 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbfFTV3i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:38 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 01/11] xfs_estimate: remove unneeded includes
Date: Thu, 20 Jun 2019 16:29:24 -0500
Message-Id: <1561066174-13144-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 estimate/xfs_estimate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
index 9e01cce..189bb6c 100644
--- a/estimate/xfs_estimate.c
+++ b/estimate/xfs_estimate.c
@@ -10,7 +10,6 @@
  * XXX: assumes dirv1 format.
  */
 #include "libxfs.h"
-#include <sys/stat.h>
 #include <ftw.h>
 
 static unsigned long long
-- 
1.8.3.1
