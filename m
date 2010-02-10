Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1AErvEu055471 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 08:54:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E356E1CBCAF7
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 06:55:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id V54jJesv3HnEPiR3 for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2010 06:55:11 -0800 (PST)
Date: Wed, 10 Feb 2010 09:55:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Inode reclaim fixes (was Re: 2.6.31
	xfs_fs_destroy_inode: cannot reclaim)
Message-ID: <20100210145508.GA29047@infradead.org>
References: <4B3F9F88.9030307@news-service.com>
	<20100107110446.GA13802@discord.disaster>
	<4B45CFAC.4000607@news-service.com>
	<20100108113114.GA8654@discord.disaster>
	<4B504B03.7050604@news-service.com>
	<4B6706CE.1020207@news-service.com>
	<20100208194226.GD9527@infradead.org>
	<4B712166.9010701@news-service.com>
	<20100209103157.GA5197@infradead.org>
	<4B72A9D1.8030101@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B72A9D1.8030101@news-service.com>
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
To: Patrick Schreurs <patrick@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, xfs@oss.sgi.com

On Wed, Feb 10, 2010 at 01:42:57PM +0100, Patrick Schreurs wrote:
> Thanks for the patch. After having this patch applied we saw *a lot*  
> warnings. They all look like this:

Ok, looks like that is not an issue, so you can discard that patch.

I went down to the radix tree code to look for races in it's tag
handling, but then noticed that we might have an issue with our
usage of the radix-tree API.  Can you try the patch below ontop
of Dave's rollup, and instead of my previous one?

---

From: Christoph Hellwig <hch@lst.de>
Subject: xfs: fix locking for inode cache radix tree tag updates

The radix-tree code requires it's users to serialize tag updates against
other updates to the tree.  While XFS protects tag updates against each
other it does not serialize them against updates of the tree contents,
which can lead to tag corruption.  Fix the inode cache to always take
pag_ici_lock in exclusive mode when updating radix tree tags.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-02-10 14:28:46.648004203 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2010-02-10 14:29:56.657023619 +0100
@@ -734,12 +734,12 @@ xfs_inode_set_reclaim_tag(
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
 
-	read_lock(&pag->pag_ici_lock);
+	write_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 	__xfs_inode_set_reclaim_tag(pag, ip);
 	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 	spin_unlock(&ip->i_flags_lock);
-	read_unlock(&pag->pag_ici_lock);
+	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 }
 
Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2010-02-10 14:30:01.092254586 +0100
+++ linux-2.6/fs/xfs/xfs_iget.c	2010-02-10 14:34:00.199005529 +0100
@@ -228,13 +228,12 @@ xfs_iget_cache_hit(
 		xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
 		/*
-		 * We need to set XFS_INEW atomically with clearing the
-		 * reclaimable tag so that we do have an indicator of the
-		 * inode still being initialized.
+		 * We need to set XFS_IRECLAIM to prevent xfs_reclaim_inode
+		 * from stomping over us while we recycle the inode.  We can't
+		 * clear the radix tree reclaimable tag yet as it requires
+		 * pag_ici_lock to be helt exclusive.
 		 */
-		ip->i_flags |= XFS_INEW;
-		ip->i_flags &= ~XFS_IRECLAIMABLE;
-		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
+		ip->i_flags |= XFS_IRECLAIM;
 
 		spin_unlock(&ip->i_flags_lock);
 		read_unlock(&pag->pag_ici_lock);
@@ -253,7 +252,15 @@ xfs_iget_cache_hit(
 			__xfs_inode_set_reclaim_tag(pag, ip);
 			goto out_error;
 		}
-		inode->i_state = I_LOCK|I_NEW;
+
+		write_lock(&pag->pag_ici_lock);
+		spin_lock(&ip->i_flags_lock);
+		ip->i_flags &= ~(XFS_IRECLAIMABLE | XFS_IRECLAIM);
+		ip->i_flags |= XFS_INEW;
+		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
+		inode->i_state = I_LOCK | I_NEW;
+		spin_unlock(&ip->i_flags_lock);
+		write_unlock(&pag->pag_ici_lock);
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode)) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
