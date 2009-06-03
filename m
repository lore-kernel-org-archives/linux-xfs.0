Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53M186P197953 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 17:01:08 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 626362BEF97
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 15:01:25 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id SEaN4g5FHZeWE64G for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2009 15:01:25 -0700 (PDT)
Message-ID: <4A26F2A9.8050300@sandeen.net>
Date: Wed, 03 Jun 2009 17:01:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/7] xfs: introduce a per-ag inode iterator
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171558.869514000@bombadil.infradead.org>
In-Reply-To: <20090514171558.869514000@bombadil.infradead.org>
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

> From: Dave Chinner <david@fromorbit.com>
> 
> Given that we walk across the per-ag inode lists so often, it makes sense to
> introduce an iterator for this.
> 
> Convert the sync and reclaim code to use this new iterator, quota code will
> follow in the next patch.
> 
> [hch: merged the lookup and execute callbacks back into one to get the
>  pag_ici_lock locking correct and simplify the code flow]
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Somehow I'm finding this hard to review, but...

> Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-05-14 16:20:37.012658983 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-05-14 16:22:26.321659103 +0200

...

> +STATIC int
> +xfs_inode_ag_walk(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		ag,
> +	int			(*execute)(struct xfs_inode *ip,
> +					   struct xfs_perag *pag, int flags),
> +	int			flags,
> +	int			tag)
> +{
> +	struct xfs_perag	*pag = &mp->m_perag[ag];
> +	uint32_t		first_index;
> +	int			last_error = 0;
> +	int			skipped;
> +
> +restart:
> +	skipped = 0;
> +	first_index = 0;
> +	do {
> +		int		error = 0;
> +		xfs_inode_t	*ip;
> +
> +		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag);
> +		if (!ip)
> +			break;
> +
> +		error = execute(ip, pag, flags);
> +		if (error == EAGAIN) {
> +			skipped++;
> +			continue;
> +		}
> +		if (error)
> +			last_error = error;
> +		/*
> +		 * bail out if the filesystem is corrupted.
> +		 */
> +		if (error == EFSCORRUPTED)
> +			break;

Ok so here we are looking for EFSCORRUPTED from the "execute" function.
 This might be xfs_sync_inode_data, xfs_sync_inode_attr, or
xfs_reclaim_inode_now.  But ...

> +
> +	} while (1);

...

> @@ -85,12 +201,17 @@ xfs_sync_inode_valid(
>  STATIC int
>  xfs_sync_inode_data(
>  	struct xfs_inode	*ip,
> +	struct xfs_perag	*pag,
>  	int			flags)
>  {
>  	struct inode	*inode = VFS_I(ip);
>  	struct address_space *mapping = inode->i_mapping;
>  	int		error = 0;
>  
> +	error = xfs_sync_inode_valid(ip, pag);
> +	if (error)
> +		return 0;xfs_sync_inode_attr(
> +

xfs_sync_inode_valid can return 0, ENOENT, or EFSCORRUPTED.

Aren't we losing the error here...

>  	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
>  		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
>  			if (flags & SYNC_TRYLOCK)
> @@ -106,16 +227,22 @@ xfs_sync_inode_data(
>   out_wait:
>  	if (flags & SYNC_IOWAIT)
>  		xfs_ioend_wait(ip);
> +	IRELE(ip);
>  	return error;
>  }
>  
>  STATIC int
>  xfs_sync_inode_attr(
>  	struct xfs_inode	*ip,
> +	struct xfs_perag	*pag,
>  	int			flags)
>  {
>  	int			error = 0;
>  
> +	error = xfs_sync_inode_valid(ip, pag);
> +	if (error)
> +		return 0;

and here?

so xfs_sync_inode_data / xfs_sync_inode_attr are the "execute" in
xfs_inode_ag_walk():

> +		error = execute(ip, pag, flags);
> +		if (error == EAGAIN) {
> +			skipped++;
> +			continue;
> +		}
> +		if (error)
> +			last_error = error;

above, and I think they're ignoring the return from
xfs_sync_inode_valid(), therefore xfs_inode_ag_walk won't see
EFSCORRUPTED from it either ... right?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
