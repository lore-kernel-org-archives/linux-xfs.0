Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57614 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbeAaWX3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 17:23:29 -0500
Date: Wed, 31 Jan 2018 14:23:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't allow DAX on reflink filesystems
Message-ID: <20180131222324.GH4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that reflink is no longer experimental, reject attempts to mount
with DAX until that whole mess gets sorted out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f436eec..fd34cf2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1666,9 +1666,12 @@ xfs_fs_fill_super(
 			"DAX unsupported by block device. Turning off DAX.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
 		}
-		if (xfs_sb_version_hasreflink(&mp->m_sb))
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
 			xfs_alert(mp,
 		"DAX and reflink cannot be used together!");
+			error = -EINVAL;
+			goto out_filestream_unmount;
+		}
 	}
 
 	if (mp->m_flags & XFS_MOUNT_DISCARD) {
