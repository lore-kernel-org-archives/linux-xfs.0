Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932094AbeCMOgP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 10:36:15 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evl2E-0004aU-8V
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 14:36:14 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] xfs: assert that xfs_reflink_allocate_cow is called with XFS_ILOCK_EXCL
Date: Tue, 13 Mar 2018 15:35:56 +0100
Message-Id: <20180313143601.30028-4-hch@lst.de>
In-Reply-To: <20180313143601.30028-1-hch@lst.de>
References: <20180313143601.30028-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that we convert COW preallocations from unwritten to real on every
call this function needs to be called with the ilock held exclusively.

Fortunately we already do that, but update the assert to match.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d81c4f868d69..90aac8889dd9 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -394,7 +394,7 @@ xfs_reflink_allocate_cow(
 
 retry:
 	ASSERT(xfs_is_reflink_inode(ip));
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	/*
 	 * Even if the extent is not shared we might have a preallocation for
-- 
2.14.2

