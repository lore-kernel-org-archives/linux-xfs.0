Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:59371 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755224AbdKBLLr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 07:11:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] xfs: scrub: avoid uninitialized return code
Date: Thu,  2 Nov 2017 12:11:12 +0100
Message-Id: <20171102111137.3062126-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org

The newly added xfs_scrub_da_btree_block() function has one code path
that returns the 'error' variable without initializing it first, as
shown by this compiler warning:

fs/xfs/scrub/dabtree.c: In function 'xfs_scrub_da_btree_block':
fs/xfs/scrub/dabtree.c:462:9: error: 'error' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Returning -EINVAL might be an appropriate return code in this case.

Fixes: 7c4a07a424c1 ("xfs: scrub directory/attribute btrees")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/scrub/dabtree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 4a93cf1753d3..971566388c9a 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -349,8 +349,10 @@ xfs_scrub_da_btree_block(
 
 	/* Check the pointer. */
 	blk->blkno = blkno;
-	if (!xfs_scrub_da_btree_ptr_ok(ds, level, blkno))
+	if (!xfs_scrub_da_btree_ptr_ok(ds, level, blkno)) {
+		error = -EINVAL;
 		goto out_nobuf;
+	}
 
 	/* Read the buffer. */
 	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno, -2,
-- 
2.9.0

