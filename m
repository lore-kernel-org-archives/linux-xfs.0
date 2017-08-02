Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50719 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752295AbdHBIhr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 04:37:47 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Fix leak of discard bio
Date: Wed,  2 Aug 2017 10:37:41 +0200
Message-Id: <20170802083741.4600-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, stable@vger.kernel.org

The bio describing discard operation is allocated by
__blkdev_issue_discard() which returns us a reference to it. That
reference is never released and thus we leak this bio. Drop the bio
reference once it completes in xlog_discard_endio().

CC: stable@vger.kernel.org
Fixes: 4560e78f40cb55bd2ea8f1ef4001c5baa88531c7
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_log_cil.c | 1 +
 1 file changed, 1 insertion(+)

Note, this is untested. It's just something I've noticed when looking at the
code.

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index fbe72b134bef..43aa42a3a5d3 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -539,6 +539,7 @@ xlog_discard_endio(
 
 	INIT_WORK(&ctx->discard_endio_work, xlog_discard_endio_work);
 	queue_work(xfs_discard_wq, &ctx->discard_endio_work);
+	bio_put(bio);
 }
 
 static void
-- 
2.12.3

