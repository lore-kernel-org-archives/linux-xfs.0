Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60208 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbdGMLdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 07:33:23 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dVcMq-0001oL-6b
        for linux-xfs@vger.kernel.org; Thu, 13 Jul 2017 11:33:12 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] xfs: fixup xfs_attr_get_ilocked
Date: Thu, 13 Jul 2017 13:33:01 +0200
Message-Id: <20170713113304.8079-2-hch@lst.de>
In-Reply-To: <20170713113304.8079-1-hch@lst.de>
References: <20170713113304.8079-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The comment mentioned the wrong lock.  Also add an ASSERT to assert
this locking precondition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ef8a1c75a467..de7b9bd30bec 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -114,12 +114,14 @@ xfs_inode_hasattr(
  * Overall external interface routines.
  *========================================================================*/
 
-/* Retrieve an extended attribute and its value.  Must have iolock. */
+/* Retrieve an extended attribute and its value.  Must have ilock. */
 int
 xfs_attr_get_ilocked(
 	struct xfs_inode	*ip,
 	struct xfs_da_args	*args)
 {
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+
 	if (!xfs_inode_hasattr(ip))
 		return -ENOATTR;
 	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
-- 
2.11.0

