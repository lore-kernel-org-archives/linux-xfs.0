Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52084 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbfCNVGO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:06:14 -0400
Subject: [PATCH 23/36] xfs_repair: reinitialize the root directory nlink
 correctly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:06:11 -0700
Message-ID: <155259757149.31886.6730311002359408147.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In mk_root_dir, we reinitialize the root directory inode with a link
count of 1.  This differs from mkfs parseproto, which initializes the
root to have a link count of 2.  The nlink discrepancy in repair is
caught and corrected during phase 7, but this is unnecessary since we
should set it properly in the first place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 9477bc25..8a50b350 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -891,7 +891,7 @@ mk_root_dir(xfs_mount_t *mp)
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
-	set_nlink(VFS_I(ip), 1);	/* account for . */
+	set_nlink(VFS_I(ip), 2);	/* account for . and .. */
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
 	if (ip->i_d.di_version == 3) {
