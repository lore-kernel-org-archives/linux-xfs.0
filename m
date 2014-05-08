Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F25BD7F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 04:49:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9439304048
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 02:49:19 -0700 (PDT)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id XETvvg6MDXlWpnTu (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 02:49:17 -0700 (PDT)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N5900KGT1Y3TF00@mailout3.samsung.com> for
	xfs@oss.sgi.com; Thu, 08 May 2014 18:49:15 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] xfs: remove XFS_TRANS_RESERVE in collapse range
Date: Thu, 08 May 2014 18:49:14 +0900
Message-id: <002601cf6aa2$c59cd670$50d68350$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

There is no need to dip into reserve pool. Reserve pool is used for much
more important things. And xfs_trans_reserve will never return ENOSPC
because punch hole is already done. If we get ENOSPC, collapse range
will be simply failed.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/xfs/xfs_bmap_util.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 296160b..91a43c5 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1519,7 +1519,6 @@ xfs_collapse_file_space(
 
 	while (!error && !done) {
 		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
-		tp->t_flags |= XFS_TRANS_RESERVE;
 		/*
 		 * We would need to reserve permanent block for transaction.
 		 * This will come into picture when after shifting extent into
@@ -1529,7 +1528,7 @@ xfs_collapse_file_space(
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
 				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
 		if (error) {
-			ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+			ASSERT(XFS_FORCED_SHUTDOWN(mp));
 			xfs_trans_cancel(tp, 0);
 			break;
 		}
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
