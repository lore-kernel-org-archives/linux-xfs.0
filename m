Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46288 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752773AbeA0SJR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jan 2018 13:09:17 -0500
Date: Sat, 27 Jan 2018 10:08:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 5/7] iomap: warn on zero-length mappings
Message-ID: <20180127180855.GI9068@magnolia>
References: <151701540938.3070.15043243007590700677.stgit@magnolia>
 <151701544071.3070.9611886870612110372.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151701544071.3070.9611886870612110372.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, bfoster@redhat.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't let the iomap callback get away with feeding us a garbage zero
length mapping -- there was a bug in xfs that resulted in those leaking
out to hilarious effect.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index e5de772..afd1635 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -65,6 +65,8 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 		return ret;
 	if (WARN_ON(iomap.offset > pos))
 		return -EIO;
+	if (WARN_ON(iomap.length == 0))
+		return -EIO;
 
 	/*
 	 * Cut down the length to the one actually provided by the filesystem,
