Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B6CD07F57
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 04:28:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9140C304043
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 02:27:59 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 13QYQoNy64HfqMbD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 02:27:57 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s6F9RtCj000334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 09:27:56 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s6F9Rt3b014961
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 09:27:55 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s6F9RsOd022738 for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 09:27:54 GMT
Message-ID: <53C4F513.4020502@oracle.com>
Date: Tue, 15 Jul 2014 17:32:03 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: remove XFS_IS_OQUOTA_ON macros
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

Remove the XFS_IS_OQUOTA_ON macros as it is obsoleted.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 137e209..1b0a083 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -98,8 +98,6 @@ typedef __uint16_t	xfs_qwarncnt_t;
 #define XFS_IS_QUOTA_ON(mp)	((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
 						   XFS_GQUOTA_ACTIVE | \
 						   XFS_PQUOTA_ACTIVE))
-#define XFS_IS_OQUOTA_ON(mp)	((mp)->m_qflags & (XFS_GQUOTA_ACTIVE | \
-						   XFS_PQUOTA_ACTIVE))
 #define XFS_IS_UQUOTA_ON(mp)	((mp)->m_qflags & XFS_UQUOTA_ACTIVE)
 #define XFS_IS_GQUOTA_ON(mp)	((mp)->m_qflags & XFS_GQUOTA_ACTIVE)
 #define XFS_IS_PQUOTA_ON(mp)	((mp)->m_qflags & XFS_PQUOTA_ACTIVE)
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
