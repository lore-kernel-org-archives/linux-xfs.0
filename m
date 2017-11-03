Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35621 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752966AbdKCOqI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:46:08 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdEV-0001sX-Qx
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:46:08 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/21] xfs: treat idx as a cursor in xfs_bmap_del_extent_*
Date: Fri,  3 Nov 2017 17:45:25 +0300
Message-Id: <20171103144539.2187-8-hch@lst.de>
In-Reply-To: <20171103144539.2187-1-hch@lst.de>
References: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Stop poking before and after the index and just increment or decrement
it while doing our operations on it to prepare for a new extent list
implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3667fb1f3961..f64b6b74daa9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4750,12 +4750,12 @@ xfs_bmap_del_extent_delay(
 						       del->br_blockcount);
 
 		got->br_startblock = nullstartblock((int)got_indlen);
-		xfs_iext_update_extent(ip, state, *idx, got);
 
 		new.br_startoff = del_endoff;
 		new.br_state = got->br_state;
 		new.br_startblock = nullstartblock((int)new_indlen);
 
+		xfs_iext_update_extent(ip, state, *idx, got);
 		++*idx;
 		xfs_iext_insert(ip, *idx, 1, &new, state);
 
@@ -4832,13 +4832,13 @@ xfs_bmap_del_extent_cow(
 		 * Deleting the middle of the extent.
 		 */
 		got->br_blockcount = del->br_startoff - got->br_startoff;
-		xfs_iext_update_extent(ip, state, *idx, got);
 
 		new.br_startoff = del_endoff;
 		new.br_blockcount = got_endoff - del_endoff;
 		new.br_state = got->br_state;
 		new.br_startblock = del->br_startblock + del->br_blockcount;
 
+		xfs_iext_update_extent(ip, state, *idx, got);
 		++*idx;
 		xfs_iext_insert(ip, *idx, 1, &new, state);
 		break;
@@ -5054,8 +5054,8 @@ xfs_bmap_del_extent_real(
 			flags |= xfs_ilog_fext(whichfork);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
-		xfs_iext_insert(ip, *idx + 1, 1, &new, state);
 		++*idx;
+		xfs_iext_insert(ip, *idx, 1, &new, state);
 		break;
 	}
 
-- 
2.14.2

