Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39898 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbeJICqX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Oct 2018 22:46:23 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 1/3] xfs: hard fail dax mount on unsupported devices
Date: Mon,  8 Oct 2018 14:32:47 -0500
Message-Id: <1539027169-23332-2-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

As dax inches closer to production use, an administrator should not
be surprised by silently disabling the feature they asked for.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 fs/xfs/xfs_super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 207ee30..a0a32cd 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1674,9 +1674,9 @@ struct proc_xfs_info {
 			rtdev_is_dax = bdev_dax_supported(
 				mp->m_rtdev_targp->bt_bdev, sb->s_blocksize);
 		if (!rtdev_is_dax && !datadev_is_dax) {
-			xfs_alert(mp,
-			"DAX unsupported by block device. Turning off DAX.");
-			mp->m_flags &= ~XFS_MOUNT_DAX;
+			xfs_alert(mp, "DAX unsupported by block device.");
+			error = -EINVAL;
+			goto out_filestream_unmount;
 		}
 		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
 			xfs_alert(mp,
-- 
1.8.3.1
