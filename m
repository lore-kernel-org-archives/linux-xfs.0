Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56247 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdGMLda (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 07:33:30 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dVcMs-0001oR-QH
        for linux-xfs@vger.kernel.org; Thu, 13 Jul 2017 11:33:15 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] =?UTF-8?q?xfs:=20assert=20locking=20precond=D1=96tion?= =?UTF-8?q?=20in=20xfs=5Fattr=5Flist=5Fint=5Filocked?=
Date: Thu, 13 Jul 2017 13:33:02 +0200
Message-Id: <20170713113304.8079-3-hch@lst.de>
In-Reply-To: <20170713113304.8079-1-hch@lst.de>
References: <20170713113304.8079-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_list.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 545eca508d42..7740c8a5e736 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -463,6 +463,8 @@ xfs_attr_list_int_ilocked(
 {
 	struct xfs_inode		*dp = context->dp;
 
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+
 	/*
 	 * Decide on what work routines to call based on the inode size.
 	 */
-- 
2.11.0

