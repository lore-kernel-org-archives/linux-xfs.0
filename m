Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51845 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdFCNTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:19:55 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 25/25] xfs: Fix off-by-in in loop termination in xfs_find_get_desired_pgoff()
Date: Sat,  3 Jun 2017 15:18:36 +0200
Message-Id: <20170603131836.26661-26-hch@lst.de>
In-Reply-To: <20170603131836.26661-1-hch@lst.de>
References: <20170603131836.26661-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Jan Kara <jack@suse.cz>

commit d7fd24257aa60316bf81093f7f909dc9475ae974 upstream.

There is an off-by-one error in loop termination conditions in
xfs_find_get_desired_pgoff() since 'end' may index a page beyond end of
desired range if 'endoff' is page aligned. It doesn't have any visible
effects but still it is good to fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9292a59efbfa..a90ec3fad69f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1130,7 +1130,7 @@ xfs_find_get_desired_pgoff(
 
 	index = startoff >> PAGE_SHIFT;
 	endoff = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount);
-	end = endoff >> PAGE_SHIFT;
+	end = (endoff - 1) >> PAGE_SHIFT;
 	do {
 		int		want;
 		unsigned	nr_pages;
-- 
2.11.0

