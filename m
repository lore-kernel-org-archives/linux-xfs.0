Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34075 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfEFVD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 May 2019 17:03:29 -0400
Received: by mail-pg1-f196.google.com with SMTP id c13so7080125pgt.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 May 2019 14:03:29 -0700 (PDT)
Received: from mangix-pc.lan (76-14-106-140.rk.wavecable.com. [76.14.106.140])
        by smtp.gmail.com with ESMTPSA id v6sm4221685pgk.77.2019.05.06.14.03.27
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 14:03:27 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
Subject: [PATCH] db/malloc: Use posix_memalign instead of deprecated valloc
Date: Mon,  6 May 2019 14:03:26 -0700
Message-Id: <20190506210326.29581-1-rosenp@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

valloc is not available with uClibc-ng as well as being deprecated, which
causes compilation errors. aligned_alloc is not available before C11 so
used posix_memalign.'

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 db/malloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/db/malloc.c b/db/malloc.c
index 77b3e022..38fe0b05 100644
--- a/db/malloc.c
+++ b/db/malloc.c
@@ -44,8 +44,7 @@ xmalloc(
 {
 	void	*ptr;
 
-	ptr = valloc(size);
-	if (ptr)
+	if(!posix_memalign(&ptr, sysconf(_SC_PAGESIZE), size))
 		return ptr;
 	badmalloc();
 	/* NOTREACHED */
-- 
2.17.1
