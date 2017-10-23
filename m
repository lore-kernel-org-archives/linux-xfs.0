Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41644 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdJWGa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 02:30:26 -0400
Received: from [46.125.250.114] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e6WFl-0002mR-5H
        for linux-xfs@vger.kernel.org; Mon, 23 Oct 2017 06:30:25 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] xfs: add asserts for the mmap lock in xfs_{insert,collapse}_file_space
Date: Mon, 23 Oct 2017 08:30:14 +0200
Message-Id: <20171023063017.11520-2-hch@lst.de>
In-Reply-To: <20171023063017.11520-1-hch@lst.de>
References: <20171023063017.11520-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 034f3429ca8c..170b74c7f2d5 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1334,6 +1334,8 @@ xfs_collapse_file_space(
 	bool			done = false;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
+
 	trace_xfs_collapse_file_space(ip);
 
 	error = xfs_free_file_space(ip, offset, len);
@@ -1408,6 +1410,8 @@ xfs_insert_file_space(
 	bool			done = false;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
+
 	trace_xfs_insert_file_space(ip);
 
 	error = xfs_prepare_shift(ip, offset);
-- 
2.14.2

