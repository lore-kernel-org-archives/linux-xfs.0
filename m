Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9BE6B7F55
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 16:07:35 -0500 (CDT)
Date: Thu, 8 Aug 2013 16:07:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/14] libxfs: don't verify bmbt reads twice
Message-ID: <20130808210732.GO3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130808210600.GN3111@sgi.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>

xfs_bmbt_read_verify is calling xfs_bmbt_verify twice in a row.  commit
ee1a47ab0e in the kernel removed the first xfs_bmbt_verify but this was
not carried over when it was implemented in userspace.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 libxfs/xfs_bmap_btree.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/libxfs/xfs_bmap_btree.c
===================================================================
--- a/libxfs/xfs_bmap_btree.c	2013-08-08 15:56:12.960817743 -0500
+++ b/libxfs/xfs_bmap_btree.c	2013-08-08 15:56:14.150857067 -0500
@@ -759,7 +759,6 @@ static void
 xfs_bmbt_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_bmbt_verify(bp);
 	if (!(xfs_btree_lblock_verify_crc(bp) &&
 	      xfs_bmbt_verify(bp))) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
@@ -767,7 +766,6 @@ xfs_bmbt_read_verify(
 				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
-
 }
 
 static void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
