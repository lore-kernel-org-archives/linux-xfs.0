Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36474 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdH3XKw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 19:10:52 -0400
Date: Wed, 30 Aug 2017 16:10:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 9/8] xfs: simplify the rmap code in xfs_bmse_merge
Message-ID: <20170830231047.GC3775@magnolia>
References: <20170829174835.2218-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829174835.2218-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In Christoph's patch to refactor xfs_bmse_merge, the updated rmap code
does more work than it needs to (because map-extent auto-merges
records).  Remove the unnecessary unmap and save ourselves a deferred
op.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9b87702..9558f5e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5942,13 +5942,12 @@ xfs_bmse_merge(
 	xfs_iext_update_extent(ifp, current_ext - 1, &new);
 	xfs_iext_remove(ip, current_ext, 1, 0);
 
-	/* update reverse mapping */
+	/* update reverse mapping. rmap functions merge the rmaps for us */
 	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
 	if (error)
 		return error;
-	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, left);
-	if (error)
-		return error;
+	memcpy(&new, got, sizeof(new));
+	new.br_startoff = left->br_startoff + left->br_blockcount;
 	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &new);
 }
