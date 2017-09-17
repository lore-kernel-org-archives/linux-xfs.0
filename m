Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55489 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751452AbdIQVGd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:06:33 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/25] xfs: write unmount record for ro mounts
Date: Sun, 17 Sep 2017 14:06:07 -0700
Message-Id: <20170917210631.10725-2-hch@lst.de>
In-Reply-To: <20170917210631.10725-1-hch@lst.de>
References: <20170917210631.10725-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Eric Sandeen <sandeen@sandeen.net>

commit 757a69ef6cf2bf839bd4088e5609ddddd663b0c4 upstream.

There are dueling comments in the xfs code about intent
for log writes when unmounting a readonly filesystem.

In xfs_mountfs, we see the intent:

/*
 * Now the log is fully replayed, we can transition to full read-only
 * mode for read-only mounts. This will sync all the metadata and clean
 * the log so that the recovery we just performed does not have to be
 * replayed again on the next mount.
 */

and it calls xfs_quiesce_attr(), but by the time we get to
xfs_log_unmount_write(), it returns early for a RDONLY mount:

 * Don't write out unmount record on read-only mounts.

Because of this, sequential ro mounts of a filesystem with
a dirty log will replay the log each time, which seems odd.

Fix this by writing an unmount record even for RO mounts, as long
as norecovery wasn't specified (don't write a clean log record
if a dirty log may still be there!) and the log device is
writable.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4ebd0bafc914..972eda87db2b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -812,11 +812,14 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	int		 error;
 
 	/*
-	 * Don't write out unmount record on read-only mounts.
+	 * Don't write out unmount record on norecovery mounts or ro devices.
 	 * Or, if we are doing a forced umount (typically because of IO errors).
 	 */
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
+	    xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
+		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 		return 0;
+	}
 
 	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
 	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));
-- 
2.14.1

