Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C73017F83
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 19:00:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6558304032
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 17:00:42 -0800 (PST)
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166]) by
	cuda.sgi.com with ESMTP id FqGyMS85hsz1pY0i (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 17:00:38 -0800 (PST)
From: Wang Sheng-Hui <shhuiw@foxmail.com>
Subject: [PATCH] xfs: remove old and redundant comment in xfs_mount_validate_sb
Date: Mon,  9 Feb 2015 09:00:16 +0800
Message-Id: <1423443616-3004-1-git-send-email-shhuiw@foxmail.com>
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
To: david@fromorbit.com, xfs@oss.sgi.com

Per Dave,
The error messages document the reason for the checks better than the comment
and the comments about volume mounts date back to Irix and so aren't relevant
any more. So just remove the old and redundant comment.

Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 752915f..b231c59 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -174,14 +174,6 @@ xfs_mount_validate_sb(
 	bool		check_inprogress,
 	bool		check_version)
 {
-
-	/*
-	 * If the log device and data device have the
-	 * same device number, the log is internal.
-	 * Consequently, the sb_logstart should be non-zero.  If
-	 * we have a zero sb_logstart in this case, we may be trying to mount
-	 * a volume filesystem in a non-volume manner.
-	 */
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
 		xfs_warn(mp, "bad magic number");
 		return -EWRONGFS;
-- 
2.1.2




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
