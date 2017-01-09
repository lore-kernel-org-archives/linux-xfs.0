Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60138 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938664AbdAIPkP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:40:15 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/32] xfs: error out if trying to add attrs and anextents > 0
Date: Mon,  9 Jan 2017 16:38:55 +0100
Message-Id: <1483976343-661-25-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 0f352f8ee8412bd9d34fb2a6411241da61175c0e upstream.

We shouldn't assert if somehow we end up trying to add an attr fork to
an inode that apparently already has attr extents because this is an
indication of on-disk corruption.  Instead, return an error code to
userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a2a24fa..89d727b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1153,6 +1153,10 @@ xfs_bmap_add_attrfork(
 		goto trans_cancel;
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
+	if (ip->i_d.di_anextents != 0) {
+		error = -EFSCORRUPTED;
+		goto trans_cancel;
+	}
 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS) {
 		/*
 		 * For inodes coming from pre-6.2 filesystems.
@@ -1160,7 +1164,6 @@ xfs_bmap_add_attrfork(
 		ASSERT(ip->i_d.di_aformat == 0);
 		ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
-	ASSERT(ip->i_d.di_anextents == 0);
 
 	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-- 
2.1.4

