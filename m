Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 19:04:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5O24JZ7008152
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 19:04:21 -0700
Message-ID: <48605744.8070400@sgi.com>
Date: Tue, 24 Jun 2008 12:09:08 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH 1/2] set minleft in xfs_bmbt_split()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

The bmap btree split code relies on a previous data extent allocation
(from xfs_bmap_btalloc()) to find an AG that has sufficient space
to perform a full btree split, when inserting the extent.  When
converting unwritten extents we don't allocate a data extent so a
btree split will be the first allocation.  In this case we need to
set minleft so the allocator will pick an AG that has space to
complete the split(s).

Lachlan

--- 2.6.x-agno2.orig/fs/xfs/xfs_bmap_btree.c
+++ 2.6.x-agno2/fs/xfs/xfs_bmap_btree.c
@@ -1493,12 +1493,20 @@ xfs_bmbt_split(
 	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
 	args.fsbno = cur->bc_private.b.firstblock;
 	args.firstblock = args.fsbno;
+	args.minleft = 0;
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = lbno;
 		args.type = XFS_ALLOCTYPE_START_BNO;
+		/*
+		 * Make sure there is sufficient room left in the AG to
+		 * complete a full tree split for an extent insert.  If
+		 * we are converting the middle part of an extent then
+		 * we may need space for two tree splits.
+		 */
+		args.minleft = xfs_trans_get_block_res(args.tp);
 	} else
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.mod = args.minleft = args.alignment = args.total = args.isfl =
+	args.mod = args.alignment = args.total = args.isfl =
 		args.userdata = args.minalignslop = 0;
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
