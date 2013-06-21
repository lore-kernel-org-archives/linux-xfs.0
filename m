Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C9ADF7F37
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 07:33:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60221AC003
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 05:33:28 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CG50NKYIACeFG61X (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Jun 2013 05:33:27 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r5LCR8vR030893
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 12:27:09 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5LCXP54017744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 12:33:25 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5LCXP7c013693 for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 12:33:25 GMT
Message-ID: <51C44819.6070003@oracle.com>
Date: Fri, 21 Jun 2013 20:33:29 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Remove the left function variable from
	xfs_ialloc_get_rec()
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

This patch clean out the left function variable as it is
useless to xfs_ialloc_get_rec().

Signed-off-by: jeff <jeff@kdev.(none)>
---
 fs/xfs/xfs_ialloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index c8f5ae1..4345c53 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -615,8 +615,7 @@ xfs_ialloc_get_rec(
 	struct xfs_btree_cur	*cur,
 	xfs_agino_t		agino,
 	xfs_inobt_rec_incore_t	*rec,
-	int			*done,
-	int			left)
+	int			*done)
 {
 	int                     error;
 	int			i;
@@ -724,12 +723,12 @@ xfs_dialloc_ag(
 		    pag->pagl_leftrec != NULLAGINO &&
 		    pag->pagl_rightrec != NULLAGINO) {
 			error = xfs_ialloc_get_rec(tcur, pag->pagl_leftrec,
-						   &trec, &doneleft, 1);
+						   &trec, &doneleft);
 			if (error)
 				goto error1;
 
 			error = xfs_ialloc_get_rec(cur, pag->pagl_rightrec,
-						   &rec, &doneright, 0);
+						   &rec, &doneright);
 			if (error)
 				goto error1;
 		} else {
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
