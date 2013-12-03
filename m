Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADA467F53
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 15:57:36 -0600 (CST)
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35CE5AC003
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 13:57:36 -0800 (PST)
Date: Tue, 3 Dec 2013 15:57:35 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH] xfs_repair: fix process_bmbt_reclist_int
Message-ID: <20131203215735.GQ1935@sgi.com>
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

Fix this by shadowing error for blkmap_set_ext.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 repair/dinode.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/repair/dinode.c
===================================================================
--- a/repair/dinode.c	2013-12-03 15:43:59.895287548 -0600
+++ b/repair/dinode.c	2013-12-03 15:44:09.315225645 -0600
@@ -663,6 +663,7 @@ _("inode %" PRIu64 " - extent offset too
 		}
 
 		if (blkmapp && *blkmapp) {
+			int error;
 			error = blkmap_set_ext(blkmapp, irec.br_startoff,
 					irec.br_startblock, irec.br_blockcount);
 			if (error) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
