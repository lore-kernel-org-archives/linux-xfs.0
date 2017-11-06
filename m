Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59338 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752756AbdKFOfR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 09:35:17 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eBiUf-00025v-7o
        for linux-xfs@vger.kernel.org; Mon, 06 Nov 2017 14:35:17 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] xfs: mark xfs_btree_check_lblock and xfs_btree_check_ptr static
Date: Mon,  6 Nov 2017 15:34:54 +0100
Message-Id: <20171106143456.13567-7-hch@lst.de>
In-Reply-To: <20171106143456.13567-1-hch@lst.de>
References: <20171106143456.13567-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 994fc1c8c7c6..5f33adf8eecb 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -109,7 +109,7 @@ __xfs_btree_check_lblock(
 }
 
 /* Check a long btree block header. */
-int
+static int
 xfs_btree_check_lblock(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
@@ -239,7 +239,7 @@ xfs_btree_check_sptr(
  * Check that a given (indexed) btree pointer at a certain level of a
  * btree is valid and doesn't point past where it should.
  */
-int
+static int
 xfs_btree_check_ptr(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr,
-- 
2.14.2

