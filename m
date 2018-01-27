Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52992 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751916AbeA0BLH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 20:11:07 -0500
Subject: [PATCH 5/7] iomap: warn on zero-length mappings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 26 Jan 2018 17:10:40 -0800
Message-ID: <151701544071.3070.9611886870612110372.stgit@magnolia>
In-Reply-To: <151701540938.3070.15043243007590700677.stgit@magnolia>
References: <151701540938.3070.15043243007590700677.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, bfoster@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't let the iomap callback get away with feeding us a garbage zero
length mapping -- there was a bug in xfs that resulted in those leaking
out to hilarious effect.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/iomap.c b/fs/iomap.c
index e5de772..aec35a0 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -63,7 +63,7 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 	ret = ops->iomap_begin(inode, pos, length, flags, &iomap);
 	if (ret)
 		return ret;
-	if (WARN_ON(iomap.offset > pos))
+	if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0))
 		return -EIO;
 
 	/*

