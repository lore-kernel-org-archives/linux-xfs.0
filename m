Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E550E7F37
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 03:50:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC344304059
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 01:50:04 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id qs39fMN4sdNv29Mm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 01:50:03 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAE9o2R3007675
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 09:50:03 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAE9o26w028326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 09:50:02 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAE9o1SH028302 for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 09:50:01 GMT
Message-ID: <52849CC5.10109@oracle.com>
Date: Thu, 14 Nov 2013 17:49:57 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs/quota: fix NULL pointer dereference in report_f
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Run xfs_quota report against an invalid XFS path without desired quota
limitation is enabled will hit SEGSEGV as fs_path is uninitialized, e.g.

# xfs_quota -xc 'report -up' /invalid_path
xfs_quota: cannot setup path for mount /invalid_path: No such file or directory
Segmentation fault (core dumped)

(gdb) r -xc 'report -up' /invalid_path
xfs_quota: cannot setup path for mount /invalid_path: No such file or directory

Program received signal SIGSEGV, Segmentation fault.
0x0000000000408b4d in report_f (argc=2, argv=0x105ea70) at report.c:627
627			else if (fs_path->fs_flags & FS_MOUNT_POINT)

This patch fix report_f() to only do report if the fs_path is initialized.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 quota/report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/quota/report.c b/quota/report.c
index 70894a2..8e3316e 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -624,7 +624,7 @@ report_f(
 		if (flags & ALL_MOUNTS_FLAG)
 			report_any_type(fp, form, type, NULL,
 					lower, upper, flags);
-		else if (fs_path->fs_flags & FS_MOUNT_POINT)
+		else if (fs_path && (fs_path->fs_flags & FS_MOUNT_POINT))
 			report_any_type(fp, form, type, fs_path->fs_dir,
 					lower, upper, flags);
 	} else while (argc > optind) {
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
