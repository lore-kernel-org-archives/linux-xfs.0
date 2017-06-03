Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50758 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751149AbdFCNSs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:18:48 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/25] xfs: fix kernel memory exposure problems
Date: Sat,  3 Jun 2017 15:18:14 +0200
Message-Id: <20170603131836.26661-4-hch@lst.de>
In-Reply-To: <20170603131836.26661-1-hch@lst.de>
References: <20170603131836.26661-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit bf9216f922612d2db7666aae01e65064da2ffb3a upstream.

Fix a memory exposure problems in inumbers where we allocate an array of
structures with holes, fail to zero the holes, then blindly copy the
kernel memory contents (junk and all) into userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_itable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 66e881790c17..d8a77dbf4e3a 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -585,7 +585,7 @@ xfs_inumbers(
 		return error;
 
 	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
-	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
+	buffer = kmem_zalloc(bcount * sizeof(*buffer), KM_SLEEP);
 	do {
 		struct xfs_inobt_rec_incore	r;
 		int				stat;
-- 
2.11.0

