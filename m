Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63760 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbeKGQBW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:22 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/16] xfs: drop ->writepage completely
Date: Wed,  7 Nov 2018 17:31:12 +1100
Message-Id: <20181107063127.3902-2-david@fromorbit.com>
In-Reply-To: <20181107063127.3902-1-david@fromorbit.com>
References: <20181107063127.3902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

->writepage is only used in one place - single page writeback from
memory reclaim. We only allow such writeback from kswapd, not from
direct memory reclaim, and so it is rarely used. When it comes from
kswapd, it is effectively random dirty page shoot-down, which is
horrible for IO patterns. We will already have background writeback
trying to clean all the dirty pages in memory as efficiently as
possible, so having kswapd interrupt our well formed IO stream only
slows things down. So get rid of xfs_vm_writepage() completely.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 338b9d9984e0..0e1342e359ca 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -911,22 +911,6 @@ xfs_do_writepage(
 	return 0;
 }
 
-STATIC int
-xfs_vm_writepage(
-	struct page		*page,
-	struct writeback_control *wbc)
-{
-	struct xfs_writepage_ctx wpc = {
-		.io_type = XFS_IO_HOLE,
-	};
-	int			ret;
-
-	ret = xfs_do_writepage(page, wbc, &wpc);
-	if (wpc.ioend)
-		ret = xfs_submit_ioend(wbc, wpc.ioend, ret);
-	return ret;
-}
-
 STATIC int
 xfs_vm_writepages(
 	struct address_space	*mapping,
@@ -1019,7 +1003,6 @@ xfs_iomap_swapfile_activate(
 const struct address_space_operations xfs_address_space_operations = {
 	.readpage		= xfs_vm_readpage,
 	.readpages		= xfs_vm_readpages,
-	.writepage		= xfs_vm_writepage,
 	.writepages		= xfs_vm_writepages,
 	.set_page_dirty		= iomap_set_page_dirty,
 	.releasepage		= xfs_vm_releasepage,
-- 
2.19.1
