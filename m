Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59222 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfCTTe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 15:34:26 -0400
Date: Wed, 20 Mar 2019 12:34:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 37/36] xfs_scrub: include unicrash.h in unicrash.c
Message-ID: <20190320193417.GA1183@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix broken function prototype checking in unicrash.c by actually
including its header.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/unicrash.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 121eedbc..824b10f0 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -16,6 +16,7 @@
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
+#include "unicrash.h"
 
 /*
  * Detect Unicode confusable names in directories and attributes.
