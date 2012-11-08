Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA89OiwV234239 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 03:24:44 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 35RXJDjkixHOF8iL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 01:26:41 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qA89QeQw005815
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 09:26:41 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qA89QdJa007497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 09:26:40 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qA89Qd9d020650 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 03:26:39 -0600
Message-ID: <509B7AC9.9080906@oracle.com>
Date: Thu, 08 Nov 2012 17:26:33 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: fix comments at xfs_growfs_data_private(),
	s/freelist/freespace/
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

Hello,

Growfs is trying to write a affected AGF header rather than AGFL, fix it IIUC.

Thanks,
-Jeff

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_fsops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index c25b094..a4cd017 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -186,7 +186,7 @@ xfs_growfs_data_private(
 	nfree = 0;
 	for (agno = nagcount - 1; agno >= oagcount; agno--, new -= agsize) {
 		/*
-		 * AG freelist header block
+		 * AG freespace header block
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
