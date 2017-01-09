Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33028 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938696AbdAIPka (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:40:30 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 29/32] xfs: fix double-cleanup when CUI recovery fails
Date: Mon,  9 Jan 2017 16:39:00 +0100
Message-Id: <1483976343-661-30-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 7a21272b088894070391a94fdd1c67014020fa1d upstream.

Dan Carpenter reported a double-free of rcur if _defer_finish fails
while we're recovering CUI items.  Fix the error recovery to prevent
this.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_refcount_item.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index fe86a66..6e4c744 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -526,13 +526,14 @@ xfs_cui_recover(
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	error = xfs_defer_finish(&tp, &dfops, NULL);
 	if (error)
-		goto abort_error;
+		goto abort_defer;
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
 	error = xfs_trans_commit(tp);
 	return error;
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
+abort_defer:
 	xfs_defer_cancel(&dfops);
 	xfs_trans_cancel(tp);
 	return error;
-- 
2.1.4

