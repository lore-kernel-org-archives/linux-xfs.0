Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47585 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754929AbdERKtH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 May 2017 06:49:07 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] xfs: Fix off-by-in in loop termination in xfs_find_get_desired_pgoff()
Date: Thu, 18 May 2017 12:48:49 +0200
Message-Id: <20170518104850.14508-3-jack@suse.cz>
In-Reply-To: <20170518104850.14508-1-jack@suse.cz>
References: <20170518104850.14508-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Eryu Guan <eguan@redhat.com>, Jan Kara <jack@suse.cz>

There is an off-by-one error in loop termination conditions in
xfs_find_get_desired_pgoff() since 'end' may index a page beyond end of
desired range if 'endoff' is page aligned. It doesn't have any visible
effects but still it is good to fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f371812e20c6..3714b5736fd3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1043,7 +1043,7 @@ xfs_find_get_desired_pgoff(
 
 	index = startoff >> PAGE_SHIFT;
 	endoff = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount);
-	end = endoff >> PAGE_SHIFT;
+	end = (endoff - 1) >> PAGE_SHIFT;
 	do {
 		int		want;
 		unsigned	nr_pages;
-- 
2.12.0

