Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43102 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934507AbdDGR0P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 13:26:15 -0400
Date: Fri, 7 Apr 2017 10:25:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: actually report xattr extents via iomap
Message-ID: <20170407172540.GK4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Eryu Guan <eguan@redhat.com>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>

Apparently FIEMAP for xattrs has been broken since we switched to
the iomap backend because of an incorrect check for xattr presence.
Also fix the broken locking.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 009f824..b2f0901 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1170,10 +1170,10 @@ xfs_xattr_iomap_begin(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	lockmode = xfs_ilock_data_map_shared(ip);
+	lockmode = xfs_ilock_attr_map_shared(ip);
 
 	/* if there are no attribute fork or extents, return ENOENT */
-	if (XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
+	if (!XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
 		error = -ENOENT;
 		goto out_unlock;
 	}
