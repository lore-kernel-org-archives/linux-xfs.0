Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39827 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965155AbdI0Bid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 21:38:33 -0400
Date: Tue, 26 Sep 2017 18:38:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] mkfs: don't overflow the subopts array
Message-ID: <20170927013828.GM5020@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

The new -d cowextsize option overran the subopts array; make it larger.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2acf8bf..7c407b0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -39,7 +39,7 @@ static int  ispow2(unsigned int i);
 unsigned int		blocksize;
 unsigned int		sectorsize;
 
-#define MAX_SUBOPTS	16
+#define MAX_SUBOPTS	17
 #define SUBOPT_NEEDS_VAL	(-1LL)
 #define MAX_CONFLICTS	8
 #define LAST_CONFLICT	(-1)
