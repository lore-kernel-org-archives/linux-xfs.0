Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35653 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbdJSG75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 02:59:57 -0400
Received: from 212095007233.public.telering.at ([212.95.7.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e54o8-0004Bj-NO
        for linux-xfs@vger.kernel.org; Thu, 19 Oct 2017 06:59:57 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/15] xfs: make better use of the 'state' variable in xfs_bmap_del_extent_real
Date: Thu, 19 Oct 2017 08:59:29 +0200
Message-Id: <20171019065942.18813-3-hch@lst.de>
In-Reply-To: <20171019065942.18813-1-hch@lst.de>
References: <20171019065942.18813-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We already have all the information about the fork aѕ well as additional
tracing information, so pass that to xfs_iext_remove().

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 676fc8aed67f..06a9ac7dcdab 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5022,8 +5022,7 @@ xfs_bmap_del_extent_real(
 		 * Matches the whole extent.  Delete the entry.
 		 */
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_iext_remove(ip, *idx, 1,
-				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
+		xfs_iext_remove(ip, *idx, 1, state);
 		--*idx;
 
 		XFS_IFORK_NEXT_SET(ip, whichfork,
-- 
2.14.1

