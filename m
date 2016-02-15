Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 310C529DF6
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 23:32:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CBBEBAC004
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 21:32:33 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LQUJsOXc4WC9FHbY for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 21:32:32 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: introduce per-inode DAX enablement
Date: Mon, 15 Feb 2016 16:32:25 +1100
Message-Id: <1455514346-15481-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1455514346-15481-1-git-send-email-david@fromorbit.com>
References: <1455514346-15481-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: ross.zwisler@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit 58f88ca2df7270881de2034c8286233a89efe71c

Rather than just being able to turn DAX on and off via a mount
option, some applications may only want to enable DAX for certain
performance critical files in a filesystem.

This patch introduces a new inode flag to enable DAX in the v3 inode
di_flags2 field. It adds support for setting and clearing flags in
the di_flags2 field via the XFS_IOC_FSSETXATTR ioctl, and sets the
S_DAX inode flag appropriately when it is seen.

When this flag is set on a directory, it acts as an "inherit flag".
That is, inodes created in the directory will automatically inherit
the on-disk inode DAX flag, enabling administrators to set up
directory heirarchies that automatically use DAX. Setting this flag
on an empty root directory will make the entire filesystem use DAX
by default.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_format.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 967b1ef..7eae0a5 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1024,6 +1024,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM)
 
 /*
+ * Values for di_flags2 These start by being exposed to userspace in the upper
+ * 16 bits of the XFS_XFLAG_s range.
+ */
+#define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
+#define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
+
+#define XFS_DIFLAG2_ANY		(XFS_DIFLAG2_DAX)
+
+/*
  * Inode number format:
  * low inopblog bits - offset in block
  * next agblklog bits - block number in ag
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
