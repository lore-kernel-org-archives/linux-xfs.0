Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 03:46:47 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mACBkeYo007320
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 03:46:40 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81746154B44E
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 03:46:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id bPW6FSATWVz1Skco for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 03:46:40 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1L0EAj-00028I-HS
	for xfs@oss.sgi.com; Wed, 12 Nov 2008 11:46:09 +0000
Date: Wed, 12 Nov 2008 06:46:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsidbg: fix uninitialized variable warning
Message-ID: <20081112114609.GB15216@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

We don't initializ s.br_state in xfsidbg_btree_trace_record so gcc
rightly complains about accessing it in xfsidbg_xbirec.  Given that we
don't get the state value from the tracing code just opencode printing
the other which actually reduces code size and makes the XFS_BTNUM_BMAP
case in xfsidbg_btree_trace_record more similar to the others.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-11-12 11:14:39.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-11-12 11:17:14.000000000 +0100
@@ -2759,16 +2759,11 @@ xfsidbg_btree_trace_record(
 {
 	switch (btnum) {
 	case XFS_BTNUM_BMAP:
-	{
-		struct xfs_bmbt_irec s;
-
-		s.br_startoff = ((xfs_dfiloff_t)l0 << 32) | (xfs_dfiloff_t)l1;
-		s.br_startblock = ((xfs_dfsbno_t)l2 << 32) | (xfs_dfsbno_t)l3;
-		s.br_blockcount = ((xfs_dfilblks_t)l4 << 32) | (xfs_dfilblks_t)l5;
-
-		xfsidbg_xbirec(&s);
+		kdb_printf("startoff %Ld startblock %Lx blockcount %Ld\n",
+			   ((xfs_dfiloff_t)l0 << 32) | (xfs_dfiloff_t)l1,
+			   ((xfs_dfsbno_t)l2 << 32) | (xfs_dfsbno_t)l3,
+			   ((xfs_dfilblks_t)l4 << 32) | (xfs_dfilblks_t)l5);
 		break;
-	}
 	case XFS_BTNUM_BNO:
 	case XFS_BTNUM_CNT:
 		qprintf(" startblock = %d, blockcount = %d\n",
