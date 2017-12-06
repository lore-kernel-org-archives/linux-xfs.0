Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48311 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdLFSii (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 13:38:38 -0500
Date: Wed, 6 Dec 2017 10:38:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: make iomap_begin functions trim iomaps consistently
Message-ID: <20171206183807.GD6896@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Historically, the XFS iomap_begin function only returned mappings for
exactly the range queried, i.e. it doesn't do XFS_BMAPI_ENTIRE lookups.
The current vfs iomap consumers are only set up to deal with trimmed
mappings.  xfs_xattr_iomap_begin does BMAPI_ENTIRE lookups, which is
inconsistent with the current iomap usage.  Remove the flag so that both
iomap_begin functions behave the same way.

FWIW this also fixes a behavioral regression in xattr FIEMAP that was
introduced in 4.8 wherein attr fork extents are no longer trimmed like
they used to be.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 33eb4fb..7ab52a8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1213,7 +1213,7 @@ xfs_xattr_iomap_begin(
 
 	ASSERT(ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
-			       &nimaps, XFS_BMAPI_ENTIRE | XFS_BMAPI_ATTRFORK);
+			       &nimaps, XFS_BMAPI_ATTRFORK);
 out_unlock:
 	xfs_iunlock(ip, lockmode);
 
