Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33811 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753051AbdJaOWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 10:22:55 -0400
Received: from bzq-164-168-31-210.red.bezeqint.net ([31.168.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9XRO-0007c2-Tl
        for linux-xfs@vger.kernel.org; Tue, 31 Oct 2017 14:22:55 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/18] xfs: treat idx as a cursor in xfs_bmap_del_extent_*
Date: Tue, 31 Oct 2017 16:22:19 +0200
Message-Id: <20171031142230.11755-8-hch@lst.de>
In-Reply-To: <20171031142230.11755-1-hch@lst.de>
References: <20171031142230.11755-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Stop poking before and after the index and just increment or decrement
it while doing our operations on it to prepare for a new extent list
implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 10878c495869..5ba0c0368629 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4749,12 +4749,12 @@ xfs_bmap_del_extent_delay(
 						       del->br_blockcount);
 
 		got->br_startblock = nullstartblock((int)got_indlen);
-		xfs_iext_update_extent(ip, state, *idx, got);
 
 		new.br_startoff = del_endoff;
 		new.br_state = got->br_state;
 		new.br_startblock = nullstartblock((int)new_indlen);
 
+		xfs_iext_update_extent(ip, state, *idx, got);
 		++*idx;
 		xfs_iext_insert(ip, *idx, 1, &new, state);
 
@@ -4831,13 +4831,13 @@ xfs_bmap_del_extent_cow(
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
@@ -5053,8 +5053,8 @@ xfs_bmap_del_extent_real(
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

