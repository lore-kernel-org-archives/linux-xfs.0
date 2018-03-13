Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37940 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932883AbeCMKti (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 06:49:38 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evhUv-0006Ez-Pr
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 10:49:38 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/8] xfs: remove an outdated comment for xfs_inode_item_committing
Date: Tue, 13 Mar 2018 11:49:21 +0100
Message-Id: <20180313104927.12926-3-hch@lst.de>
In-Reply-To: <20180313104927.12926-1-hch@lst.de>
References: <20180313104927.12926-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The function now does something, and that something is central to our
inode logging scheme.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode_item.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index b83fa38f1c74..31f2b32b7e27 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -634,10 +634,6 @@ xfs_inode_item_committed(
 	return lsn;
 }
 
-/*
- * XXX rcc - this one really has to do something.  Probably needs
- * to stamp in a new field in the incore inode.
- */
 STATIC void
 xfs_inode_item_committing(
 	struct xfs_log_item	*lip,
-- 
2.14.2

