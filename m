Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n95LgPH9241804 for <xfs@oss.sgi.com>; Mon, 5 Oct 2009 16:42:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D997BD19C9
	for <xfs@oss.sgi.com>; Mon,  5 Oct 2009 14:43:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JNPaUIKznhzjGJbw for
	<xfs@oss.sgi.com>; Mon, 05 Oct 2009 14:43:49 -0700 (PDT)
Date: Mon, 5 Oct 2009 17:43:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20091005214348.GA15448@infradead.org>
References: <20090930124104.GA7463@infradead.org>
	<4AC60D27.9060703@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AC60D27.9060703@news-service.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bas Couwenberg <bas@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Patrick Schreurs <patrick@news-service.com>, Tommy van Leeuwen <tommy@news-service.com>, XFS List <xfs@oss.sgi.com>

On Fri, Oct 02, 2009 at 04:24:39PM +0200, Bas Couwenberg wrote:
> Dear Christoph,
>
> Yesterday two of our servers (2.6.31.1 + your patch) crashed again, this  
> time we have a bigger console, but not the full backtrace unfortunately.
>
> I did manage to get some more calltrace info from the logs, which I have  
> attached together with the screenshots of the crashscreens.
>
> I hope this info helps you.

It helps a bit, but not so much.  I suspect it could be a double free
of an inode, and I have identified a possible race window that could
explain it.  But all the traces are really weird and I think only show
later symptoms of something that happened earlier.  I'll come up with
a patch for the race window ASAP, but could you in the meantime turn on
CONFIG_XFS_DEBUG for the test kernel to see if it triggers somehwere
and additionally apply the tiny patch below for additional debugging?


Subject: xfs: check for not fully initialized inodes in xfs_ireclaim
From: Christoph Hellwig <hch@lst.de>

Add an assert for inodes not added to the inode cache in xfs_ireclaim, to make
sure we're not going to introduce something like the famous nfsd inode cache
bug again.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-08-10 11:30:55.729724742 -0300
+++ linux-2.6/fs/xfs/xfs_iget.c	2009-08-10 11:40:15.271748324 -0300
@@ -535,17 +535,21 @@ xfs_ireclaim(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 
 	XFS_STATS_INC(xs_ig_reclaims);
 
 	/*
-	 * Remove the inode from the per-AG radix tree.  It doesn't matter
-	 * if it was never added to it because radix_tree_delete can deal
-	 * with that case just fine.
+	 * Remove the inode from the per-AG radix tree.
+	 *
+	 * Because radix_tree_delete won't complain even if the item was never
+	 * added to the tree assert that it's been there before to catch
+	 * problems with the inode life time early on.
 	 */
 	pag = xfs_get_perag(mp, ip->i_ino);
 	write_lock(&pag->pag_ici_lock);
-	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
+	ASSERT(radix_tree_lookup(&pag->pag_ici_root, agino));
+	radix_tree_delete(&pag->pag_ici_root, agino);
 	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
