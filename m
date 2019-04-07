Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52360 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfDGU1m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Apr 2019 16:27:42 -0400
Subject: [PATCH 4/4] xfs: don't allow most setxattr to immutable files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 07 Apr 2019 13:27:29 -0700
Message-ID: <155466884962.633834.14320700092446721044.stgit@magnolia>
In-Reply-To: <155466882175.633834.15261194784129614735.stgit@magnolia>
References: <155466882175.633834.15261194784129614735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The chattr manpage has this to say about immutable files:

"A file with the 'i' attribute cannot be modified: it cannot be deleted
or renamed, no link can be created to this file, most of the file's
metadata can not be modified, and the file can not be opened in write
mode."

However, we don't actually check the immutable flag in the setattr code,
which means that we can update project ids and extent size hints on
supposedly immutable files.  Therefore, reject a setattr call on an
immutable file except for the case where we're trying to unset
IMMUTABLE.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5a1b96dad901..1215713d7814 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1061,6 +1061,14 @@ xfs_ioctl_setattr_xflags(
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
+	/*
+	 * If immutable is set and we are not clearing it, we're not allowed
+	 * to change anything else in the inode.
+	 */
+	if ((ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE) &&
+	    (fa->fsx_xflags & FS_XFLAG_IMMUTABLE))
+		return -EPERM;
+
 	/* diflags2 only valid for v3 inodes. */
 	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
 	if (di_flags2 && ip->i_d.di_version < 3)
