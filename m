Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1640D7F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:25:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02704304071
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 07:25:27 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id fsnuikyoQfbVWMPB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 07:25:26 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s14FPPaq023999
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 15:25:26 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s14FPOiY007471
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 15:25:25 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id
	s14FPOHo006116 for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 15:25:24 GMT
Message-ID: <52F1065F.8040904@oracle.com>
Date: Tue, 04 Feb 2014 23:25:19 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: remove XFS_TRANS_DEBUG dead code
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

Remove the leftover XFS_TRANS_DEBUG dead code following the previous
cleaning up of it in commits ec47eb6b0b450.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3314911..8752821 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -796,20 +796,6 @@ xfs_buf_item_init(
 		bip->bli_formats[i].blf_map_size = map_size;
 	}
 
-#ifdef XFS_TRANS_DEBUG
-	/*
-	 * Allocate the arrays for tracking what needs to be logged
-	 * and what our callers request to be logged.  bli_orig
-	 * holds a copy of the original, clean buffer for comparison
-	 * against, and bli_logged keeps a 1 bit flag per byte in
-	 * the buffer to indicate which bytes the callers have asked
-	 * to have logged.
-	 */
-	bip->bli_orig = kmem_alloc(BBTOB(bp->b_length), KM_SLEEP);
-	memcpy(bip->bli_orig, bp->b_addr, BBTOB(bp->b_length));
-	bip->bli_logged = kmem_zalloc(BBTOB(bp->b_length) / NBBY, KM_SLEEP);
-#endif
-
 	/*
 	 * Put the buf item into the list of items attached to the
 	 * buffer at the front.
@@ -957,11 +943,6 @@ STATIC void
 xfs_buf_item_free(
 	xfs_buf_log_item_t	*bip)
 {
-#ifdef XFS_TRANS_DEBUG
-	kmem_free(bip->bli_orig);
-	kmem_free(bip->bli_logged);
-#endif /* XFS_TRANS_DEBUG */
-
 	xfs_buf_item_free_format(bip);
 	kmem_zone_free(xfs_buf_item_zone, bip);
 }
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
