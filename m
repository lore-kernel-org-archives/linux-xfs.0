Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA81B7F52
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 05:20:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C38638F8035
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 03:20:04 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id KGl3JJXaNgc3gmYt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Dec 2013 03:20:03 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBSBK2oV030349
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:20:03 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBK10b019957
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:20:02 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBK1ps019945 for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:20:01 GMT
Message-ID: <52BEB3DF.8080901@oracle.com>
Date: Sat, 28 Dec 2013 19:19:59 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 1/10] xfs: remove redundant stat assignment int
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

Trivial fix to get rid of redundant BULKSTAT_RV_NOTHING assignment
in xfs_bulkstat_one_int().

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
