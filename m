Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45578 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbcJGXIH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 19:08:07 -0400
Subject: [PATCH 7/7] xfs: clear reflink flag if setting realtime flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Oct 2016 16:08:03 -0700
Message-ID: <147588168294.12127.1609759616316145097.stgit@birch.djwong.org>
In-Reply-To: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

Since we can only turn on the rt flag if there are no data extents,
we can safely turn off the reflink flag if the rt flag is being
turned on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8b9f31c5..598b97b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1034,9 +1034,9 @@ xfs_ioctl_setattr_xflags(
 			return -EINVAL;
 	}
 
-	/* Don't allow us to set realtime mode for a reflinked file. */
+	/* Clear reflink if we are actually able to set the rt flag. */
 	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
-		return -EINVAL;
+		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
 
 	/* Don't allow us to set DAX mode for a reflinked file for now. */
 	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))

