Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A69F67F90
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 21:14:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 85DF48F8050
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 19:14:59 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ALXkYHLHYFyoEba3 for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 19:14:57 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/9] xfs: FSX_NONBLOCK is not used
Date: Tue, 27 Jan 2015 14:14:38 +1100
Message-Id: <1422328486-24661-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1422328486-24661-1-git-send-email-david@fromorbit.com>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
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
Cc: iustin@k1024.org

From: Dave Chinner <dchinner@redhat.com>

It is set if the filp is set ot non-blocking, but the flag is not
used anywhere. Hence we can kill it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8810959..09325ff 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1016,7 +1016,6 @@ xfs_diflags_to_linux(
 #define FSX_PROJID	1
 #define FSX_EXTSIZE	2
 #define FSX_XFLAGS	4
-#define FSX_NONBLOCK	8
 
 STATIC int
 xfs_ioctl_setattr(
@@ -1299,8 +1298,6 @@ xfs_ioc_fssetxattr(
 		return -EFAULT;
 
 	mask = FSX_XFLAGS | FSX_EXTSIZE | FSX_PROJID;
-	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-		mask |= FSX_NONBLOCK;
 
 	error = mnt_want_write_file(filp);
 	if (error)
@@ -1343,8 +1340,6 @@ xfs_ioc_setxflags(
 		return -EOPNOTSUPP;
 
 	mask = FSX_XFLAGS;
-	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-		mask |= FSX_NONBLOCK;
 	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
 
 	error = mnt_want_write_file(filp);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
