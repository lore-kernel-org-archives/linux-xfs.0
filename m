Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46461 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753011AbdDCRfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 13:35:01 -0400
Date: Mon, 3 Apr 2017 10:34:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: fix kernel memory exposure problems
Message-ID: <20170403173430.GL4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@infradead.org>

Fix a memory exposure problems in inumbers where we allocate an array of
structures with holes, fail to zero the holes, then blindly copy the
kernel memory contents (junk and all) into userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v2: split patches
---
 fs/xfs/xfs_itable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 2a6d9b1..26d67ce 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -583,7 +583,7 @@ xfs_inumbers(
 		return error;
 
 	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
-	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
+	buffer = kmem_zalloc(bcount * sizeof(*buffer), KM_SLEEP);
 	do {
 		struct xfs_inobt_rec_incore	r;
 		int				stat;
