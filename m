Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 19:11:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5O2BWHY009095
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 19:11:35 -0700
Message-ID: <486058F3.3030305@sgi.com>
Date: Tue, 24 Jun 2008 12:16:19 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH 2/2] Restore the lowspace extent allocator algorithm
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

When free space is running low the extent allocator may choose to
allocate an extent from an AG without leaving sufficient space for
a btree split when inserting the new extent (see where
xfs_bmap_btalloc() sets minleft to 0).  In this case the allocator
will enable the lowspace algorithm which is supposed to allow further
allocations (such as btree splits and newroots) to allocate from
sequential AGs.  This algorithm has been broken for a long time
and this patch restores its behaviour.

Lachlan

--- 2.6.x-agno2.orig/fs/xfs/xfs_bmap_btree.c
+++ 2.6.x-agno2/fs/xfs/xfs_bmap_btree.c
@@ -1504,7 +1504,9 @@ xfs_bmbt_split(
 		 * we may need space for two tree splits.
 		 */
 		args.minleft = xfs_trans_get_block_res(args.tp);
-	} else
+	} else if (cur->bc_private.b.flist->xbf_low)
+		args.type = XFS_ALLOCTYPE_START_BNO;
+	else
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	args.mod = args.alignment = args.total = args.isfl =
 		args.userdata = args.minalignslop = 0;
@@ -2232,7 +2234,9 @@ xfs_bmbt_newroot(
 #endif
 		args.fsbno = be64_to_cpu(*pp);
 		args.type = XFS_ALLOCTYPE_START_BNO;
-	} else
+	} else if (cur->bc_private.b.flist->xbf_low)
+		args.type = XFS_ALLOCTYPE_START_BNO;
+	else
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	if ((error = xfs_alloc_vextent(&args))) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
