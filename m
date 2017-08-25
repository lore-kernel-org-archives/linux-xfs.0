Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36166 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbdHYF1I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 01:27:08 -0400
Received: by mail-pg0-f66.google.com with SMTP id 83so2357870pgb.3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2017 22:27:07 -0700 (PDT)
Date: Fri, 25 Aug 2017 10:56:59 +0530
From: Achilles Gaikwad <achillesgaikwad@gmail.com>
Subject: [PATCH] fs/xfs/kmem.c: fix coding style, using 'unsigned int'
 instead of 'unsigned'
Message-ID: <20170825052659.GA11087@fubar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Fixes a warning given by checkpatch.pl to use 'unsigned int'
instead of just 'unsigned'.

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
+	unsigned nofs_flag = 0;

Signed-off-by: Achilles Gaikwad <achillesgaikwad@gmail.com>
---
 fs/xfs/kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 393b6849aeb3..a20909087e5e 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -48,7 +48,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 void *
 kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 {
-	unsigned nofs_flag = 0;
+	unsigned int nofs_flag = 0;
 	void	*ptr;
 	gfp_t	lflags;
 
-- 
2.13.5

