Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5D88E7F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 19:04:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3AD4030417B
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 17:03:58 -0700 (PDT)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25]) by
	cuda.sgi.com with ESMTP id 9PEL8vAQK7FQ1rVN (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 17:03:57 -0700 (PDT)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout2.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N5H00E32K6J8VA0@mailout2.samsung.com> for
	xfs@oss.sgi.com; Tue, 13 May 2014 09:03:55 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2] xfs: remove XFS_TRANS_RESERVE in collapse range
Date: Tue, 13 May 2014 09:03:55 +0900
Message-id: <000f01cf6e3e$d4a0a800$7de1f800$@samsung.com>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

There is no need to dip into reserve pool. Reserve pool is used for much
more important things. And xfs_trans_reserve will never return ENOSPC
because punch hole is already done. If we get ENOSPC, collapse range
will be simply failed.

Cc: Brian Foster <bfoster@redhat.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/xfs/xfs_bmap_util.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 296160b..057f671 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1519,7 +1519,6 @@ xfs_collapse_file_space(
 
 	while (!error && !done) {
 		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
-		tp->t_flags |= XFS_TRANS_RESERVE;
 		/*
 		 * We would need to reserve permanent block for transaction.
 		 * This will come into picture when after shifting extent into
@@ -1529,7 +1528,6 @@ xfs_collapse_file_space(
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
 				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
 		if (error) {
-			ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
 			xfs_trans_cancel(tp, 0);
 			break;
 		}
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
