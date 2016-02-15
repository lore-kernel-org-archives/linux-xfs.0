Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 748987CA4
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 23:22:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 619FC8F8049
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 21:22:28 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ddk28fLQ4EEMfllF for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 21:22:25 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: XFS_DIFLAG_DAX is only for regular files or
	directories
Date: Mon, 15 Feb 2016 16:22:11 +1100
Message-Id: <1455513734-15192-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1455513734-15192-1-git-send-email-david@fromorbit.com>
References: <1455513734-15192-1-git-send-email-david@fromorbit.com>
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

Only file data can use DAX, so we should onyl be able to set this
flag on regular files. However, the flag also serves as an "inherit"
flag at file create time when set on directories, so limit the
FS_IOC_FSSETXATTR ioctl to only set this flag on regular files and
directories.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 81d6d62..0895967 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1051,6 +1051,14 @@ xfs_ioctl_setattr_xflags(
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
+	/*
+	 * It is only valid to set the DAX flag on regular files and
+	 * directories. On directories it serves as an inherit hint.
+	 */
+	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
+	    !(S_ISREG(VFS_I(ip)->i_mode) || S_ISDIR(VFS_I(ip)->i_mode)))
+		return -EINVAL;
+
 	xfs_set_diflags(ip, fa->fsx_xflags);
 	xfs_diflags_to_linux(ip);
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
