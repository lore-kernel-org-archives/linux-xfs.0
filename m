Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9M75aOY067627 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 02:05:37 -0500
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C17C52AB67
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 00:07:10 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by
	cuda.sgi.com with ESMTP id RKVitIlw2HoZjX9U for
	<xfs@oss.sgi.com>; Thu, 22 Oct 2009 00:07:10 -0700 (PDT)
Received: from mailgate3.nec.co.jp ([10.7.69.160])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id n9M778iB028238
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 16:07:08 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp
	(8.11.7/3.7W-MAILGATE-NEC) id n9M778X20414 for xfs@oss.sgi.com;
	Thu, 22 Oct 2009 16:07:08 +0900 (JST)
Received: from mail03.kamome.nec.co.jp (mail03.kamome.nec.co.jp [10.25.43.7])
	by mailsv.nec.co.jp (8.13.8/8.13.4) with ESMTP id n9M7782f012445
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 16:07:08 +0900 (JST)
Subject: [PATCH] xfs: fix xfs_quota remove error
Message-Id: <20091022160627r-yamauchi@mail.jp.nec.com>
Mime-Version: 1.0
From: r-yamauchi@vf.jp.nec.com
Date: Thu, 22 Oct 2009 16:06:27 +0900
Reply-To: r-yamauchi@vf.jp.nec.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

The xfs_quota returns ENOSYS when remove command is executed.
My kernel version is 2.6.31 and xfsprogs version is 3.0.3.
You can reproduce this issue with following steps.

    # mount -t xfs -o uquota /dev/sda7 /mnt/mp1
    # xfs_quota -x -c off -c remove
    XFS_QUOTARM: Function not implemented.

The remove command is allowed during quotaoff,
but xfs_xstate() checks whether quota is running, 
so it leads to ENOSYS.

To solve this problem, add conditional statement 
that op is not X_QUOTARM with running check.

Signed-off-by: Ryota Yamauchi <r-yamauchi@vf.jp.nec.com>
Signed-off-by: Utako Kusaka <u-kusaka@wm.jp.nec.com>

----
xfs_quotaops.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff -Nrup a/fs/xfs/linux-2.6/xfs_quotaops.c b/fs/xfs/linux-2.6/xfs_quotaops.c
--- a/fs/xfs/linux-2.6/xfs_quotaops.c	2009-10-21 14:15:12.000000000 +0900
+++ b/fs/xfs/linux-2.6/xfs_quotaops.c	2009-10-21 14:16:04.000000000 +0900
@@ -80,7 +80,7 @@ xfs_fs_set_xstate(
 
 	if (sb->s_flags & MS_RDONLY)
 		return -EROFS;
-	if (!XFS_IS_QUOTA_RUNNING(mp))
+	if (!XFS_IS_QUOTA_RUNNING(mp) && op != Q_XQUOTARM)
 		return -ENOSYS;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;

Best regards,
Ryota Yamauchi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
