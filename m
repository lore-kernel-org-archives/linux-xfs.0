Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55647 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbcI3Iqo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:46:44 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] xfs: update atime before I/O in xfs_file_dio_aio_read
Date: Fri, 30 Sep 2016 10:46:33 +0200
Message-Id: <1475225194-3702-2-git-send-email-hch@lst.de>
In-Reply-To: <1475225194-3702-1-git-send-email-hch@lst.de>
References: <1475225194-3702-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

After the call to __blkdev_direct_IO the final reference to the file
might have been dropped by aio_complete already, and the call to
file_accessed might cause a use after free.

Instead update the access time before the I/O, similar to how we
update the time stamps before writes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Tested-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ef01bd3..301fb3c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -270,6 +270,8 @@ xfs_file_dio_aio_read(
 		return -EINVAL;
 	}
 
+	file_accessed(iocb->ki_filp);
+
 	/*
 	 * Locking is a bit tricky here. If we take an exclusive lock for direct
 	 * IO, we effectively serialise all new concurrent read IO to this file
@@ -324,7 +326,6 @@ xfs_file_dio_aio_read(
 	}
 	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 
-	file_accessed(iocb->ki_filp);
 	return ret;
 }
 
-- 
2.1.4

