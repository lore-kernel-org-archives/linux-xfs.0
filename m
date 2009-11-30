Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAUK7EpI055235 for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 14:07:14 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: check for not fully initialized inodes in
	xfs_ireclaim
Date: Mon, 30 Nov 2009 14:07:40 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AF45@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091112190657.GA32110@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Add an assert for inodes not added to the inode cache in xfs_ireclaim, to make
> sure we're not going to introduce something like the famous nfsd inode cache
> bug again.

I confess I have not looked at the radix tree
code in detail yet, but radix_tree_delete()
returns a value that is ignored here.  It reportedly
will return a null pointer if the index has no
corresponding item in the tree, so this could be
used in the assertion rather than doing a separate
lookup.

I think the change is fine, but would rather see
it done without the extra lookup (though there may
be a good reason for doing it anyway).

					-Alex

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_iget.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iget.c	2009-11-12 17:10:20.216276486 +0100
> +++ xfs/fs/xfs/xfs_iget.c	2009-11-12 17:13:27.565003964 +0100
> @@ -514,17 +514,21 @@ xfs_ireclaim(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_perag	*pag;
> +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> 
>  	XFS_STATS_INC(xs_ig_reclaims);
> 
>  	/*
> -	 * Remove the inode from the per-AG radix tree.  It doesn't matter
> -	 * if it was never added to it because radix_tree_delete can deal
> -	 * with that case just fine.
> +	 * Remove the inode from the per-AG radix tree.
> +	 *
> +	 * Because radix_tree_delete won't complain even if the item was never
> +	 * added to the tree assert that it's been there before to catch
> +	 * problems with the inode life time early on.
>  	 */
>  	pag = xfs_get_perag(mp, ip->i_ino);
>  	write_lock(&pag->pag_ici_lock);
> -	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
> +	ASSERT(radix_tree_lookup(&pag->pag_ici_root, agino));
> +	radix_tree_delete(&pag->pag_ici_root, agino);
>  	write_unlock(&pag->pag_ici_lock);
>  	xfs_put_perag(mp, pag);
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
