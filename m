Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F04A17CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 10:45:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6D8E8AC004
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 08:44:58 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id bkRP5RYCNVDCMuFb (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 08:44:55 -0700 (PDT)
Received: from ip-64-134-228-197.public.wayport.net ([64.134.228.197]
	helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1aoC73-0005EM-Uc
	for xfs@oss.sgi.com; Thu, 07 Apr 2016 15:44:54 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: fix warning in xfs_finish_page_writeback for non-debug
	builds
Date: Thu,  7 Apr 2016 08:44:51 -0700
Message-Id: <1460043891-5075-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

blockmask is unused if ASSERTs are disabled.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 40645a4..1d6eca5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -94,15 +94,14 @@ xfs_finish_page_writeback(
 	struct bio_vec		*bvec,
 	int			error)
 {
-	unsigned int		blockmask = (1 << inode->i_blkbits) - 1;
 	unsigned int		end = bvec->bv_offset + bvec->bv_len - 1;
 	struct buffer_head	*head, *bh;
 	unsigned int		off = 0;
 
 	ASSERT(bvec->bv_offset < PAGE_SIZE);
-	ASSERT((bvec->bv_offset & blockmask) == 0);
+	ASSERT((bvec->bv_offset & ((1 << inode->i_blkbits) - 1)) == 0);
 	ASSERT(end < PAGE_SIZE);
-	ASSERT((bvec->bv_len & blockmask) == 0);
+	ASSERT((bvec->bv_len & ((1 << inode->i_blkbits) - 1)) == 0);
 
 	bh = head = page_buffers(bvec->bv_page);
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
