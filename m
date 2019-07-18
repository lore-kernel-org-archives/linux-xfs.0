Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41750 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXGW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 19:06:22 -0400
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 1/9] xfs: fix pagecache truncation prior to reflink
Date: Thu, 18 Jul 2019 23:06:09 +0000
Message-Id: <20190718230617.7439-2-mcgrof@kernel.org>
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, zlang@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Luis Chamberlain <mcgrof@kernel.org>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4918ef4ea008cd2ff47eb852894e3f9b9047f4f3 upstream.

Prior to remapping blocks, it is necessary to remove pages from the
destination file's page cache.  Unfortunately, the truncation is not
aggressive enough -- if page size > block size, we'll end up zeroing
subpage blocks instead of removing them.  So, round the start offset
down and the end offset up to page boundaries.  We already wrote all
the dirty data so the larger range shouldn't be a problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_reflink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7088f44c0c59..38ea08a3dd1d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1369,8 +1369,9 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	/* Zap any page cache for the destination file's range. */
-	truncate_inode_pages_range(&inode_out->i_data, pos_out,
-				   PAGE_ALIGN(pos_out + *len) - 1);
+	truncate_inode_pages_range(&inode_out->i_data,
+			round_down(pos_out, PAGE_SIZE),
+			round_up(pos_out + *len, PAGE_SIZE) - 1);
 
 	/* If we're altering the file contents... */
 	if (!is_dedupe) {
-- 
2.20.1
