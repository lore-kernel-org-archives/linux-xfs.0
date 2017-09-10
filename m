Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36733 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdIJAau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 20:30:50 -0400
Received: by mail-pf0-f194.google.com with SMTP id f84so3274470pfj.3
        for <linux-xfs@vger.kernel.org>; Sat, 09 Sep 2017 17:30:50 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH 5/5] include sys/types.h for u_int32_t in attr/attributes.h
Date: Sat,  9 Sep 2017 17:30:35 -0700
Message-Id: <20170910003035.14285-5-raj.khem@gmail.com>
In-Reply-To: <20170910003035.14285-1-raj.khem@gmail.com>
References: <20170910003035.14285-1-raj.khem@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>

error: unknown type name 'u_int32_t'

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 restore/content.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/restore/content.c b/restore/content.c
index 7c4a81f..1d5de1b 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -24,6 +24,7 @@
 #include <sys/param.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
+#include <sys/types.h>
 #include <attr/attributes.h>
 #include <xfs/handle.h>
 #include <time.h>
-- 
2.14.1

