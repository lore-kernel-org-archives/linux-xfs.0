Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 00:03:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6E73OsG029374
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 00:03:27 -0700
From: tes@sgi.com
Date: Mon, 14 Jul 2008 17:04:31 +1000
Subject: [PATCH] fix up delta calculation for
 xfs_bmap_add_extent_unwritten_real
Message-ID: <487afa7f.JM4ZHhEHVRIFNZ+O%tes@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com, xfs@oss.sgi.com

pv#984030
Patch provided by olaf@sgi.com and has been reviewed
but putting out there for others to see the change.

A bug was found in xfs_bmap_add_extent_unwritten_real() which will
not affect xfs in its normal use.
In a particular case, the delta param which is supposed to describe
the region where extents have changed was not updated appropriately.

The case of interest is:
   1707         case 0:
   1708                 /*
   1709                  * Setting the middle part of a previous oldext extent to
   1710                  * newext.  Contiguity is impossible here.
   1711                  * One extent becomes three extents.
   1712                  */

where we are not left-filling (on LHS) or right-filling (on RHS) and so
are also not contiguous with neighbours. But we are in the middle.

PREV:------------------------------------------------------------>|
-----------------------|--------------------|----------------------
|  cur->bc_rec.b  LHS  |    r[0] = new      |    r[1] RHS         |
-----------------------|--------------------|----------------------

So our new extent is in the middle and r[1] is on the RHS.
The LHS, cur, is set to PREV after making PREV's count smaller
to its new size. However, this means that our original PREV's count
is no longer covering the whole range.
So Olaf's change leave's PREV alone and just updates cur->bc_rec.b to have
PREV's contents and decrements its new count.
Mainly, because below we calculate the delta based on the PREV values
(in particular expecting the original block count).
We are not using PREV anywhere else after that AFAICS so I think the
change is safe from causing a regression elsewhere.

--Tim

 xfs_bmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
Index: 2.6.x-xfs-quilt/fs/xfs/xfs_bmap.c
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_bmap.c	2008-07-04 15:34:38.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_bmap.c	2008-07-09 16:24:17.250532483 +1000
@@ -1740,9 +1740,9 @@ xfs_bmap_add_extent_unwritten_real(
 				r[1].br_state)))
 				goto done;
 			/* new left extent - oldext */
-			PREV.br_blockcount =
-				new->br_startoff - PREV.br_startoff;
 			cur->bc_rec.b = PREV;
+			cur->bc_rec.b.br_blockcount =
+				new->br_startoff - PREV.br_startoff;
 			if ((error = xfs_bmbt_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
