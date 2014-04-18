Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A6D557F53
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:58:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B3578F8040
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 17:58:25 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5pEwy2dKl0RYCkvv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Apr 2014 17:58:24 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s3I0wMKO010888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:23 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s3I0wLD8015652
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:22 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id
	s3I0wLYQ024743 for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:21 GMT
Message-ID: <535078A9.409@oracle.com>
Date: Fri, 18 Apr 2014 08:58:17 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 01/10] xfs: remove redundant stat assignment in
	xfs_bulkstat_one_int
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

Remove the redundant BULKSTAT_RV_NOTHING assignment in case of call
xfs_iget() failed at xfs_bulkstat_one_int().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f463382..b5bb7b6 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -76,10 +76,8 @@ xfs_bulkstat_one_int(
 	error = xfs_iget(mp, NULL, ino,
 			 (XFS_IGET_DONTCACHE | XFS_IGET_UNTRUSTED),
 			 XFS_ILOCK_SHARED, &ip);
-	if (error) {
-		*stat = BULKSTAT_RV_NOTHING;
+	if (error)
 		goto out_free;
-	}
 
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_imap.im_blkno != 0);
@@ -136,7 +134,6 @@ xfs_bulkstat_one_int(
 	IRELE(ip);
 
 	error = formatter(buffer, ubsize, ubused, buf);
-
 	if (!error)
 		*stat = BULKSTAT_RV_DIDONE;
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
