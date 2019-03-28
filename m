Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40522 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfC1Ru7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Mar 2019 13:50:59 -0400
Subject: [PATCH 3/3] xfs: don't allow most setxattr to immutable files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 28 Mar 2019 10:50:54 -0700
Message-ID: <155379545404.24796.5019142212767521955.stgit@magnolia>
In-Reply-To: <155379543409.24796.5783716624820175068.stgit@magnolia>
References: <155379543409.24796.5783716624820175068.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

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
index 2bd1c5ab5008..9cf0bc0ae2bd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1067,6 +1067,14 @@ xfs_ioctl_setattr_xflags(
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
