Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52752 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfCWAh1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Mar 2019 20:37:27 -0400
Date: Fri, 22 Mar 2019 17:37:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: prohibit fstrim in norecovery mode
Message-ID: <20190323003720.GQ1183@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190323003532.GB1180@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, linux-ext4 <linux-ext4@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

The xfs fstrim implementation uses the free space btrees to find free
space that can be discarded.  If we haven't recovered the log, the bnobt
will be stale and we absolutely *cannot* use stale metadata to zap the
underlying storage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_discard.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 93f07edafd81..9ee2a7d02e70 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -161,6 +161,14 @@ xfs_ioc_trim(
 		return -EPERM;
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
+
+	/*
+	 * We haven't recovered the log, so we cannot use our bnobt-guided
+	 * storage zapping commands.
+	 */
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		return -EROFS;
+
 	if (copy_from_user(&range, urange, sizeof(range)))
 		return -EFAULT;
 
