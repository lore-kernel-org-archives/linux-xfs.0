Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41546 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729103AbeK2D70 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Nov 2018 22:59:26 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 643441F8C6
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 16:57:08 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 4/4] common/drive.c: include stdlib.h
Date: Wed, 28 Nov 2018 17:56:49 +0100
Message-Id: <20181128165649.56853-5-jtulak@redhat.com>
In-Reply-To: <20181128165649.56853-1-jtulak@redhat.com>
References: <20181128165649.56853-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, Jan Tulak <jtulak@redhat.com>

We are using calloc() inside of this file, but it is not included in any
way (resultin in "implicit declaration" warnings from the compiler). So,
add the include.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/drive.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/drive.c b/common/drive.c
index 4b0825f..edb63c0 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -17,6 +17,7 @@
  */
 
 #include <stdio.h>
+#include <stdlib.h>
 #include <unistd.h>
 #include <sys/stat.h>
 #include <time.h>
-- 
2.19.1
