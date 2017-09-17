Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47170 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbdIQVHY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:24 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/47] xfs: toggle readonly state around xfs_log_mount_finish
Date: Sun, 17 Sep 2017 14:06:47 -0700
Message-Id: <20170917210712.10804-23-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Eric Sandeen <sandeen@sandeen.net>

commit 6f4a1eefdd0ad4561543270a7fceadabcca075dd upstream.

When we do log recovery on a readonly mount, unlinked inode
processing does not happen due to the readonly checks in
xfs_inactive(), which are trying to prevent any I/O on a
readonly mount.

This is misguided - we do I/O on readonly mounts all the time,
for consistency; for example, log recovery.  So do the same
RDONLY flag twiddling around xfs_log_mount_finish() as we
do around xfs_log_mount(), for the same reason.

This all cries out for a big rework but for now this is a
simple fix to an obvious problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4f59cbc0b185..ebe20f1591f1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -743,10 +743,14 @@ xfs_log_mount_finish(
 	struct xfs_mount	*mp)
 {
 	int	error = 0;
+	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
 
 	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 		return 0;
+	} else if (readonly) {
+		/* Allow unlinked processing to proceed */
+		mp->m_flags &= ~XFS_MOUNT_RDONLY;
 	}
 
 	/*
@@ -764,6 +768,9 @@ xfs_log_mount_finish(
 		xfs_log_work_queue(mp);
 	mp->m_super->s_flags &= ~MS_ACTIVE;
 
+	if (readonly)
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+
 	return error;
 }
 
-- 
2.14.1

