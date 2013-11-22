Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A3D17F37
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 00:04:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF53D304064
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 22:04:11 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Jn6Y36oVWCVcu48v (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Nov 2013 22:04:07 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAM645fI016234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 06:04:06 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAM6445H019247
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 06:04:05 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAM644cL021924 for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 06:04:04 GMT
Message-ID: <528EF3D0.70102@oracle.com>
Date: Fri, 22 Nov 2013 14:04:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: make quota metadata truncation behavior consistent to
	user space
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

In xfs_qm_scall_trunc_qfiles(), we ignore the error if failed to remove
the users quota metadata and proceed to remove groups and projects if
they are being there.  However, in user space, the remove operation will
break and return if failed to remove any kind of quota.
Also for v5 super block, we can enabled both group and project quota at
the same time, in this case the current error handling will cover the
group error with projects but they might failed due to different reasons.

It seems we'd better the error handling consistent to the user space and
don't trying to remove another kind of quota metadata if the previous
operation is failed.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_qm_syscalls.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 437c919..3daf5ea 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -278,7 +278,7 @@ xfs_qm_scall_trunc_qfiles(
 	xfs_mount_t	*mp,
 	uint		flags)
 {
-	int		error = 0, error2 = 0;
+	int		error;
 
 	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0) {
 		xfs_debug(mp, "%s: flags=%x m_qflags=%x",
@@ -286,14 +286,20 @@ xfs_qm_scall_trunc_qfiles(
 		return XFS_ERROR(EINVAL);
 	}
 
-	if (flags & XFS_DQ_USER)
+	if (flags & XFS_DQ_USER) {
 		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
-	if (flags & XFS_DQ_GROUP)
-		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
+		if (error)
+			return error;
+	}
+	if (flags & XFS_DQ_GROUP) {
+		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
+		if (error)
+			return error;
+	}
 	if (flags & XFS_DQ_PROJ)
-		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
+		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
 
-	return error ? error : error2;
+	return error;
 }
 
 /*
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
