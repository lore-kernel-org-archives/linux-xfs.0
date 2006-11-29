Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Nov 2006 16:54:01 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAT0roaG016794
	for <xfs@oss.sgi.com>; Tue, 28 Nov 2006 16:53:56 -0800
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kAT0r1nU004318
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:53:02 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.195])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kAT0kPX8012205
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:46:25 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kAT0kPN07315 for xfs@oss.sgi.com; Wed, 29 Nov 2006 09:46:25 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kAT0kOu16052 for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:46:24 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061129.095146.06200516 for <xfs@oss.sgi.com>
	; Wed, 29 Nov 2006 09:51:46 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id C9D5EAE4B0
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:45:34 +0900 (JST)
Message-Id: <200611290046.AA04743@TNESG9305.tnes.nec.co.jp>
Date: Wed, 29 Nov 2006 09:46:19 +0900
Subject: [PATCH] infinite loop in xfs_db
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I found two issues in xfs_db.
1)bmap, ablock and dblock command hangs up when the target file has
  either data fork or attr fork which is set XFS_DINODE_FMT_LOCAL. 
  Because bmap() in db/bmap.c performs XFS_DINODE_FMT_BTREE if-block
  and goes into an infinite loop.
2)bmap command does not show attribute area correctly when no option is specified.
  Because an offset for attr fork is changed by following code: 
    co = be.startoff + be.blockcount;

This patch fixes them.

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.15-orgn/db/bmap.c	2006-05-30 23:35:06.000000000 +0900
+++ xfsprogs-2.8.15/db/bmap.c	2006-11-22 14:41:35.004978096 +0900
@@ -77,7 +77,8 @@ bmap(
 	fmt = (xfs_dinode_fmt_t)XFS_DFORK_FORMAT(dip, whichfork);
 	typ = whichfork == XFS_DATA_FORK ? TYP_BMAPBTD : TYP_BMAPBTA;
 	ASSERT(typtab[typ].typnm == typ);
-	ASSERT(fmt == XFS_DINODE_FMT_EXTENTS || fmt == XFS_DINODE_FMT_BTREE);
+	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
+		fmt == XFS_DINODE_FMT_BTREE);
 	if (fmt == XFS_DINODE_FMT_EXTENTS) {
 		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 		xp = (xfs_bmbt_rec_64_t *)XFS_DFORK_PTR(dip, whichfork);
@@ -85,7 +86,7 @@ bmap(
 			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
 				break;
 		}
-	} else {
+	} else if (fmt == XFS_DINODE_FMT_BTREE) {
 		push_cur();
 		bno = NULLFSBLOCK;
 		rblock = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
@@ -147,7 +148,7 @@ bmap_f(
 	int		afork = 0;
 	bmap_ext_t	be;
 	int		c;
-	xfs_dfiloff_t	co;
+	xfs_dfiloff_t	co, cosave;
 	int		dfork = 0;
 	xfs_dinode_t	*dip;
 	xfs_dfiloff_t	eo;
@@ -205,6 +206,7 @@ bmap_f(
 		co = 0;
 		eo = -1;
 	}
+	cosave = co;
 	for (whichfork = XFS_DATA_FORK;
 	     whichfork <= XFS_ATTR_FORK;
 	     whichfork++) {
@@ -226,6 +228,7 @@ bmap_f(
 				be.blockcount, be.flag);
 			co = be.startoff + be.blockcount;
 		}
+		co = cosave;
 	}
 	return 0;
 }
