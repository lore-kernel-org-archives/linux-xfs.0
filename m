Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBFK4df4254928 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 14:04:39 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH V2] xfs: check for not fully initialized inodes in
	xfs_ireclaim
Date: Tue, 15 Dec 2009 14:05:15 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A686B@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091201181229.GA11982@infradead.org>
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

It's a shame we can't do more than an ASSERT() here
(for non-debug builds).

Looks good though.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/xfs_iget.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iget.c	2009-11-26 19:10:47.206253628 +0100
> +++ xfs/fs/xfs/xfs_iget.c	2009-12-01 19:09:43.310004091 +0100
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
> +	if (!radix_tree_delete(&pag->pag_ici_root, agino))
> +		ASSERT(0);
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
