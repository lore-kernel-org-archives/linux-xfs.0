Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5DBA37FF0
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 04:03:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4CA348F8035
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:03:59 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id mtDXv8iGzpK0TH9U (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 02:03:58 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s4693uUF028712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 6 May 2014 09:03:57 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id
	s4693tME024682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 6 May 2014 09:03:56 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s4693tq8024781 for <xfs@oss.sgi.com>; Tue, 6 May 2014 09:03:55 GMT
Message-ID: <5368A578.7070201@oracle.com>
Date: Tue, 06 May 2014 17:03:52 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Fwd: New Defects reported by Coverity Scan for xfsprogs
References: <5362fbfc78ad5_2dbacf387045986@209.249.196.67.mail>
In-Reply-To: <5362fbfc78ad5_2dbacf387045986@209.249.196.67.mail>
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

Hi Folks,

I'm not sure if someone else has also noticed the following reports from Coverity.


-------- Original Message --------
Subject: New Defects reported by Coverity Scan for xfsprogs
Date: Thu, 01 May 2014 18:59:24 -0700
From: scan-admin@coverity.com


Hi,


Please find the latest report on new defect(s) introduced to xfsprogs found with Coverity Scan.

Defect(s) Reported-by: Coverity Scan
Showing 1 of 1 defect(s)


** CID 996972:  Out-of-bounds access  (OVERRUN)
/libxfs/xfs_btree.c: 2641 in xfs_btree_new_root()


________________________________________________________________________________________________________
*** CID 996972:  Out-of-bounds access  (OVERRUN)
/libxfs/xfs_btree.c: 2641 in xfs_btree_new_root()
2635     	/* Allocate the new block. If we can't do it, we're toast. Give up. */
2636     	error = cur->bc_ops->alloc_block(cur, &rptr, &lptr, 1, stat);
2637     	if (error)
2638     		goto error0;
2639     	if (*stat == 0)
2640     		goto out0;
>>>     CID 996972:  Out-of-bounds access  (OVERRUN)
>>>     Jumping to case "XFS_BTNUM_MAX".
2641     	XFS_BTREE_STATS_INC(cur, alloc);
2642     
2643     	/* Set up the new block. */
2644     	error = xfs_btree_get_buf_block(cur, &lptr, 0, &new, &nbp);
2645     	if (error)
2646     		goto error0;


It seems like a false alarm, but maybe we can just remove the out0 label as below?

From: Jie Liu <jeff.liu@oracle.com>
Subject: xfs: get rid of out0 goto label from xfs_btree_new_root

Get rid of the useless out0 goto label and return 0 directly in case
of falling to alloate the new block.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_btree.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 182bac2..f162dc9 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -2653,8 +2653,11 @@ xfs_btree_new_root(
 	error = cur->bc_ops->alloc_block(cur, &rptr, &lptr, stat);
 	if (error)
 		goto error0;
-	if (*stat == 0)
-		goto out0;
+	if (*stat == 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		return 0;
+	}
+
 	XFS_BTREE_STATS_INC(cur, alloc);
 
 	/* Set up the new block. */
@@ -2743,10 +2746,6 @@ xfs_btree_new_root(
 error0:
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 	return error;
-out0:
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-	*stat = 0;
-	return 0;
 }
 
 STATIC int
-- 
1.8.3.2


Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
