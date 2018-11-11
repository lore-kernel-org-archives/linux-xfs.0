Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:49434 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726478AbeKKLIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Nov 2018 06:08:49 -0500
Message-ID: <7302f4a13c1cbf62b07f636878ce25fcca84b6c4.camel@perches.com>
Subject: [PATCH] xfs: Remove noinline from #define STATIC
From: Joe Perches <joe@perches.com>
Date: Sat, 10 Nov 2018 17:21:49 -0800
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Reduce total object size quite a bit (~32KB) and presumably
improve performance at the same time.

Total object size old vs new (x86-64 defconfig with xfs)

    text	   data	    bss	    dec	    hex	filename
- 959351	 165573	    632	1125556	 112cb4	(TOTALS) (old)
+ 924683	 165669	    632	1090984	 10a5a8	(TOTALS) (new)

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/xfs_linux.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index edbd5a210df2..f33c8b626bca 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -242,7 +242,7 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 #endif /* XFS_WARN */
 #endif /* DEBUG */
 
-#define STATIC static noinline
+#define STATIC static
 
 #ifdef CONFIG_XFS_RT
 
