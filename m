Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 095FA7F52
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:25:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9A6B304092
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:25:20 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 8LtBbeDrMuTsqZWA (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 09:25:17 -0800 (PST)
Message-Id: <20140204172516.819177292@bombadil.infradead.org>
Date: Tue, 04 Feb 2014 09:24:05 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: allow appending aio writes
References: <20140204172402.380571745@bombadil.infradead.org>
Content-Disposition: inline; filename=0003-xfs-allow-appending-aio-writes.patch
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
Cc: Sergey Meirovich <rathamahata@gmail.com>

XFS can easily support appending aio writes by ensuring we always allocate
blocks as unwritten extents when performing direct I/O writes and only
converting them to written extents at I/O completion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a267394..a4278e4 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1441,7 +1441,8 @@ xfs_vm_direct_IO(
 		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
 					    offset, nr_segs,
 					    xfs_get_blocks_direct,
-					    xfs_end_io_direct_write, NULL, 0);
+					    xfs_end_io_direct_write, NULL,
+					    DIO_ASYNC_EXTEND);
 		if (ret != -EIOCBQUEUED && iocb->private)
 			goto out_destroy_ioend;
 	} else {
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
