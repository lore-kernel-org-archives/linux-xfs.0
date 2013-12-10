Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 70FFB7F98
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 14:53:53 -0600 (CST)
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAA46AC014
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:53:52 -0800 (PST)
Date: Tue, 10 Dec 2013 14:53:52 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH v2] xfs_repair: fix process_bmbt_reclist_int
Message-ID: <20131210205352.GC1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

There is a set checks for corruption in block map btrees in
process_bmbt_reclist_int that we identify but currently do not fix.  It
appears that the author's intent in this function was to set error = 1,
and then only clear it when all of the checks were completed
successfully.  Unfortunately error can be cleared when it is used for
the return value of blkmap_set_ext.  Some kinds of corruption are not
being fixed, including duplicate extents, claiming free blocks, claiming
metadata blocks, and multiply used blocks.

Fix this by using error2 for the return code from blkmap_set_ext.

Signed-off-by: Ben Myers <bpm@sgi.com>

---

v2: Use error2 instead of shadowing error, as per Dave's suggestion.

 repair/dinode.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: b/repair/dinode.c
===================================================================
--- a/repair/dinode.c	2013-12-10 14:42:57.905267321 -0600
+++ b/repair/dinode.c	2013-12-10 14:45:43.435246026 -0600
@@ -663,9 +663,10 @@ _("inode %" PRIu64 " - extent offset too
 		}
 
 		if (blkmapp && *blkmapp) {
-			error = blkmap_set_ext(blkmapp, irec.br_startoff,
+			int	error2;
+			error2 = blkmap_set_ext(blkmapp, irec.br_startoff,
 					irec.br_startblock, irec.br_blockcount);
-			if (error) {
+			if (error2) {
 				/*
 				 * we don't want to clear the inode due to an
 				 * internal bmap tracking error, but if we've
@@ -677,7 +678,7 @@ _("inode %" PRIu64 " - extent offset too
 				do_abort(
 _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
   "\t%s fork, off - %" PRIu64 ", start - %" PRIu64 ", cnt %" PRIu64 "\n"),
-					ino, strerror(error), forkname,
+					ino, strerror(error2), forkname,
 					irec.br_startoff, irec.br_startblock,
 					irec.br_blockcount);
 			}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
