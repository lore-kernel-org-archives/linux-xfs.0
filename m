Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19710 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdDFQEc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 12:04:32 -0400
Date: Thu, 6 Apr 2017 09:03:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: actually report xattr extents via iomap
Message-ID: <20170406160356.GY4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eryu Guan <eguan@redhat.com>

Apparently FIEMAP for xattrs has been broken since we switched to
the iomap backend because of an incorrect check for xattr presence.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 288ee5b..4f118a1 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1173,7 +1173,7 @@ xfs_xattr_iomap_begin(
 	lockmode = xfs_ilock_data_map_shared(ip);
 
 	/* if there are no attribute fork or extents, return ENOENT */
-	if (XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
+	if (!XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
 		error = -ENOENT;
 		goto out_unlock;
 	}
