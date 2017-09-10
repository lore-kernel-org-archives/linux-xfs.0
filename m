Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34762 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdIJAaq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 20:30:46 -0400
Received: by mail-pg0-f68.google.com with SMTP id v82so2988836pgb.1
        for <linux-xfs@vger.kernel.org>; Sat, 09 Sep 2017 17:30:46 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH 1/5] Include fcntl.h for O_EXCL
Date: Sat,  9 Sep 2017 17:30:31 -0700
Message-Id: <20170910003035.14285-1-raj.khem@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>

Fix
error: 'O_CREAT' undeclared (first use in this function)

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 invutil/invidx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/invutil/invidx.c b/invutil/invidx.c
index 67efdf7..325a9a1 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -27,6 +27,7 @@
 #include <sys/stat.h>
 #include <string.h>
 #include <uuid/uuid.h>
+#include <fcntl.h>
 
 #include "types.h"
 #include "mlog.h"
-- 
2.14.1

