Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21371 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdIDPuT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 11:50:19 -0400
Date: Mon, 4 Sep 2017 08:49:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] xfs: don't unconditionally clear the reflink flag on
 zero-block files
Message-ID: <20170904154944.GG4671@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>

If we have speculative cow preallocations hanging around in the cow
fork, don't let a truncate operation clear the reflink flag because if
we do then there's a chance we'll forget to free those extents when we
destroy the incore inode.

Reported-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5599dda..4ec5b7f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1624,10 +1624,12 @@ xfs_itruncate_extents(
 		goto out;
 
 	/*
-	 * Clear the reflink flag if we truncated everything.
+	 * Clear the reflink flag if there are no data fork blocks and
+	 * there are no extents staged in the cow fork.
 	 */
-	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
-		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+	if (xfs_is_reflink_inode(ip) && ip->i_cnextents == 0) {
+		if (ip->i_d.di_nblocks == 0)
+			ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
 		xfs_inode_clear_cowblocks_tag(ip);
 	}
 
