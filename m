Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49803 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757027AbdKNVq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2017 16:46:26 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAELkPh8027239
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2017 21:46:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAELkPuQ004301
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2017 21:46:25 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAELkOlp026364
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2017 21:46:24 GMT
Date: Tue, 14 Nov 2017 13:46:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] iomap: report collisions between directio and buffered
 writes to userspace
Message-ID: <20171114214625.GB5119@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

If two programs simultaneously try to write to the same part of a file
via direct IO and buffered IO, there's a chance that the post-diowrite
pagecache invalidation will fail on the dirty page.  When this happens,
the dio write succeeded, which means that the page cache is no longer
coherent with the disk!  Programs are not supposed to mix IO types and
this is a clear case of data corruption, so store an EIO which will be
reflected to userspace during the next fsync.  Get rid of the WARN_ON
to assuage the fuzz-tester complaints.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index d4801f8..61b2eca 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -710,6 +710,13 @@ struct iomap_dio {
 	};
 };
 
+static void iomap_warn_stale_pagecache(struct inode *inode)
+{
+	errseq_set(&inode->i_mapping->wb_err, -EIO);
+	pr_crit_ratelimited("Stale pagecache contents after collision "
+			    "between direct and buffered write!\n");
+}
+
 static ssize_t iomap_dio_complete(struct iomap_dio *dio)
 {
 	struct kiocb *iocb = dio->iocb;
@@ -752,7 +759,8 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
 		err = invalidate_inode_pages2_range(inode->i_mapping,
 				offset >> PAGE_SHIFT,
 				(offset + dio->size - 1) >> PAGE_SHIFT);
-		WARN_ON_ONCE(err);
+		if (err)
+			iomap_warn_stale_pagecache(inode);
 	}
 
 	inode_dio_end(file_inode(iocb->ki_filp));
@@ -1011,9 +1019,16 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (ret)
 		goto out_free_dio;
 
+	/*
+	 * Try to invalidate cache pages for the range we're direct
+	 * writing.  If this invalidation fails, tough, the write will
+	 * still work, but racing two incompatible write paths is a
+	 * pretty crazy thing to do, so we don't support it 100%.
+	 */
 	ret = invalidate_inode_pages2_range(mapping,
 			start >> PAGE_SHIFT, end >> PAGE_SHIFT);
-	WARN_ON_ONCE(ret);
+	if (ret)
+		iomap_warn_stale_pagecache(inode);
 	ret = 0;
 
 	if (iov_iter_rw(iter) == WRITE && !is_sync_kiocb(iocb) &&
