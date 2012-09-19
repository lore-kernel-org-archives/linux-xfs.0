Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JGXtrj220171 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 11:33:55 -0500
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 660D88F80CB
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 09:35:04 -0700 (PDT)
Message-Id: <20120919163145.587098223@sgi.com>
Date: Wed, 19 Sep 2012 11:31:36 -0500
From: tinguely@sgi.com
Subject: [PATCH 3/3] xfs: zero allocation_args on the kernel stack
References: <20120919163133.097340199@sgi.com>
Content-Disposition: inline; filename=3-3-xfs-zero_allocation_args.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The allocation argument structures is created on the kernel stack space. This
patch makes sure the userdata variable is always initialized.

The better solution is always memset to 0 or "= { 0 }" the xfs_alloc_arg
and xfs_bmalloca structures. I believe there will only be 4 places that need
this memset change.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_bmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3096,7 +3096,7 @@ xfs_bmap_extents_to_btree(
 	}
 	args.minlen = args.maxlen = args.prod = 1;
 	args.total = args.minleft = args.alignment = args.mod = args.isfl =
-		args.minalignslop = 0;
+		args.minalignslop = args.userdata = 0;
 	args.wasdel = wasdel;
 	*logflagsp = 0;
 	if ((error = xfs_alloc_vextent(&args))) {
@@ -3254,7 +3254,7 @@ xfs_bmap_local_to_extents(
 		}
 		args.total = total;
 		args.mod = args.minleft = args.alignment = args.wasdel =
-			args.isfl = args.minalignslop = 0;
+			args.isfl = args.minalignslop = args.userdata = 0;
 		args.minlen = args.maxlen = args.prod = 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			goto done;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
