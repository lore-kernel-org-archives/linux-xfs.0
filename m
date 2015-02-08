Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 372E87F4E
	for <xfs@oss.sgi.com>; Sat,  7 Feb 2015 22:45:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 267078F8037
	for <xfs@oss.sgi.com>; Sat,  7 Feb 2015 20:45:51 -0800 (PST)
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206]) by
	cuda.sgi.com with ESMTP id W6uBixixhBaDDX2r (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Feb 2015 20:45:48 -0800 (PST)
From: Wang Sheng-Hui <shhuiw@foxmail.com>
Subject: [PATCH] xfs: move the comment on log device near the right log dev
	check in xfs_mount_validate_sb
Date: Sun,  8 Feb 2015 12:45:04 +0800
Message-Id: <1423370704-3464-1-git-send-email-shhuiw@foxmail.com>
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
To: david@fromorbit.com, xfs@oss.sgi.com, sandeen@sandeen.net, hch@lst.de, bfoster@redhat.com, tinguely@sgi.com

The beginning is about magic and version number check.
Move the comment on log device near the log dev check logic.

Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 752915f..b4bb852 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -174,20 +174,13 @@ xfs_mount_validate_sb(
 	bool		check_inprogress,
 	bool		check_version)
 {
+	/* check magic number and version number */
 
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
 	}
 
-
 	if (!xfs_sb_good_version(sbp)) {
 		xfs_warn(mp, "bad version");
 		return -EWRONGFS;
@@ -245,6 +238,14 @@ xfs_mount_validate_sb(
 			return -EFSCORRUPTED;
 	}
 
+	/*
+	 * If the log device and data device have the
+	 * same device number, the log is internal.
+	 * Consequently, the sb_logstart should be non-zero.  If
+	 * we have a zero sb_logstart in this case, we may be trying to mount
+	 * a volume filesystem in a non-volume manner.
+	 */
+
 	if (unlikely(
 	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
 		xfs_warn(mp,
-- 
2.1.2



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
