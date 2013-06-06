Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 484377F37
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 08:25:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 247B8304077
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 06:24:58 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id B2EzXGRmRPR7wiDd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 06:24:57 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r56DOrao020182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 6 Jun 2013 13:24:54 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r56DOsuM024576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 6 Jun 2013 13:24:55 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r56DOspG024569 for <xfs@oss.sgi.com>; Thu, 6 Jun 2013 13:24:54 GMT
MIME-Version: 1.0
Message-ID: <51B08D71.7090404@oracle.com>
Date: Thu, 6 Jun 2013 06:24:01 -0700 (PDT)
From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH] xfs: return FIEMAP_EXTENT_UNKNOWN for delayed allocation
	extent
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
To: xfs@oss.sgi.com

From: Jie Liu <jeff.liu@oracle.com>

For FIEMAP ioctl(2), if an extent is in delayed allocation
state, we need to return the FIEMAP_EXTENT_UNKNOWN flag except
the FIEMAP_EXTENT_DELALLOC because its data location is unknown.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_iops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d82efaa..53ddbdb 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -970,7 +970,8 @@ xfs_fiemap_format(
 	if (bmv->bmv_oflags & BMV_OF_PREALLOC)
 		fiemap_flags |= FIEMAP_EXTENT_UNWRITTEN;
 	else if (bmv->bmv_oflags & BMV_OF_DELALLOC) {
-		fiemap_flags |= FIEMAP_EXTENT_DELALLOC;
+		fiemap_flags |= (FIEMAP_EXTENT_DELALLOC |
+				 FIEMAP_EXTENT_UNKNOWN);
 		physical = 0;   /* no block yet */
 	}
 	if (bmv->bmv_oflags & BMV_OF_LAST)
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
