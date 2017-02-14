Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:55281 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754030AbdBNRI4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 12:08:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] xfs: fix len comparison in xfs_extent_busy_trim
Date: Tue, 14 Feb 2017 18:08:30 +0100
Message-Id: <20170214170836.2705798-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>, Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org

The length is now passed by reference, so the assertion has to be updated
to match the other changes, as pointed out by this W=1 warning:

fs/xfs/xfs_extent_busy.c: In function 'xfs_extent_busy_trim':
fs/xfs/xfs_extent_busy.c:356:13: error: ordered comparison of pointer with integer zero [-Werror=extra]

Fixes: ebf55872616c ("xfs: improve handling of busy extents in the low-level allocator")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/xfs_extent_busy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index ab062610234e..77760dbf0242 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -353,7 +353,7 @@ xfs_extent_busy_trim(
 	struct rb_node		*rbp;
 	bool			ret = false;
 
-	ASSERT(len > 0);
+	ASSERT(*len > 0);
 
 	spin_lock(&args->pag->pagb_lock);
 restart:
-- 
2.9.0

