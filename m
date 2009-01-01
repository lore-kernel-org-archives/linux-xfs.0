Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01H3Vbv006469 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 11:03:32 -0600
Date: Thu, 1 Jan 2009 12:03:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] XFS update for 2.6.29
Message-ID: <20090101170329.GA17892@infradead.org>
References: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com>
	<Pine.LNX.4.64.0901011048090.14380@anakin>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901011048090.14380@anakin>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Thu, Jan 01, 2009 at 10:50:52AM +0100, Geert Uytterhoeven wrote:
> | fs/xfs/xfs_btree.c: In function 'xfs_btree_readahead_lblock':
> | fs/xfs/xfs_btree.c:736: warning: comparison is always true due to limited range of data type
> | fs/xfs/xfs_btree.c:741: warning: comparison is always true due to limited range of data type
> 
> left/right = xfs_fsblock_t (32 or 64 bit), NULLDFSBNO = xfs_dfsbno_t (64 bit)

Hmm, can't reproduce it here with CONFIG_LBD=n on x86, but the following
patch should fix it:

Index: linux-2.6/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_btree.c	2009-01-01 15:57:04.606547140 +0100
+++ linux-2.6/fs/xfs/xfs_btree.c	2009-01-01 15:57:24.780673454 +0100
@@ -730,8 +730,8 @@ xfs_btree_readahead_lblock(
 	struct xfs_btree_block	*block)
 {
 	int			rval = 0;
-	xfs_fsblock_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
-	xfs_fsblock_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
+	xfs_dfsbno_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
+	xfs_dfsbno_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLDFSBNO) {
 		xfs_btree_reada_bufl(cur->bc_mp, left, 1);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
