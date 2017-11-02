Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43243 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932497AbdKBTxN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 15:53:13 -0400
Date: Thu, 2 Nov 2017 12:53:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: scrub: avoid uninitialized return code
Message-ID: <20171102195306.GA4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

The newly added xfs_scrub_da_btree_block() function has one code path
that returns the 'error' variable without initializing it first, as
shown by this compiler warning:

fs/xfs/scrub/dabtree.c: In function 'xfs_scrub_da_btree_block':
fs/xfs/scrub/dabtree.c:462:9: error: 'error' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Return zero since the caller will exit the scrub code if we don't produce a
buffer pointer.

Fixes: 7c4a07a424c1 ("xfs: scrub directory/attribute btrees")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dabtree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index c21c528..4c9839c 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -336,7 +336,7 @@ xfs_scrub_da_btree_block(
 	xfs_ino_t			owner;
 	int				*pmaxrecs;
 	struct xfs_da3_icnode_hdr	nodehdr;
-	int				error;
+	int				error = 0;
 
 	blk = &ds->state->path.blk[level];
 	ds->state->path.active = level + 1;
