Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53MIQJC198814 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 17:18:26 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E04AB1BC9054
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 15:18:43 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id gsbRePDjUOqin3kt for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2009 15:18:43 -0700 (PDT)
Message-ID: <4A26F6B1.20509@sandeen.net>
Date: Wed, 03 Jun 2009 17:18:25 -0500
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

And a similar error handling question...

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

Ok, it's looking for EAGAIN here, I'm assuming this is for when we are
calling xfs_reclaim_inode_now, because...

...

> -STATIC void
> -xfs_reclaim_inodes_ag(
> -	xfs_mount_t	*mp,
> -	int		ag,
> -	int		mode)
> +STATIC int
> +xfs_reclaim_inode_now(
> +	struct xfs_inode	*ip,
> +	struct xfs_perag	*pag,
> +	int			flags)
>  {
> -	xfs_inode_t	*ip = NULL;
> -	xfs_perag_t	*pag = &mp->m_perag[ag];
> -	int		nr_found;
> -	uint32_t	first_index;
> -	int		skipped;
> -
> -restart:
> -	first_index = 0;
> -	skipped = 0;
> -	do {

...

> -
> -		/*
> -		 * hmmm - this is an inode already in reclaim. Do
> -		 * we even bother catching it here?
> -		 */
> -		if (xfs_reclaim_inode(ip, 0, mode))
> -			skipped++;
> -	} while (nr_found);

... because before, that's what we did above, after testing for a non-0
return from xfs_reclaim_inode.

But xfs_reclaim_inode_now() returns 0 or the result of
xfs_reclaim_inode, which is 0/1, so above:

> +		error = execute(ip, pag, flags);
> +		if (error == EAGAIN) {
> +			skipped++;
> +			continue;
> +		}

isn't going to see EAGAIN from xfs_reclaim_inode_now... am I following
this right?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
