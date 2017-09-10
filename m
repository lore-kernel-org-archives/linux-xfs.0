Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34174 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdIJAat (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 20:30:49 -0400
Received: by mail-pf0-f194.google.com with SMTP id g65so3046164pfe.1
        for <linux-xfs@vger.kernel.org>; Sat, 09 Sep 2017 17:30:49 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH 4/5] include limit.h for PATH_MAX
Date: Sat,  9 Sep 2017 17:30:34 -0700
Message-Id: <20170910003035.14285-4-raj.khem@gmail.com>
In-Reply-To: <20170910003035.14285-1-raj.khem@gmail.com>
References: <20170910003035.14285-1-raj.khem@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>

fixed
var.c:42:12: error: 'PATH_MAX' undeclared (first use in this function); did you mean 'RAND_MAX'?
  char path[PATH_MAX];`

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 dump/var.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/dump/var.c b/dump/var.c
index 645caab..8156d37 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <limits.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
-- 
2.14.1

