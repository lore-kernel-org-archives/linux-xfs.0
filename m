Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5I3A9o7117903 for <xfs@oss.sgi.com>; Sun, 17 Jun 2012 22:10:10 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	o7VQVWhOYQGvXJy7 for <xfs@oss.sgi.com>;
	Sun, 17 Jun 2012 20:10:07 -0700 (PDT)
Date: Mon, 18 Jun 2012 13:10:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] xfs: merge xfs_ialloc_ag_select into xfs_dialloc
Message-ID: <20120618031002.GN19223@dastard>
References: <20120605144647.051012936@bombadil.infradead.org>
	<20120605144836.693188178@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120605144836.693188178@bombadil.infradead.org>
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

On Tue, Jun 05, 2012 at 10:46:54AM -0400, Christoph Hellwig wrote:
> Both function contain the same basic loop over all AGs.  Merge the two
> by creating three passes in the loop instead of duplicating the code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_ialloc.c |  179 +++++++++++++++-------------------------------------
>  1 file changed, 55 insertions(+), 124 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_ialloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_ialloc.c	2012-06-04 12:58:07.104263361 -0400
> +++ xfs/fs/xfs/xfs_ialloc.c	2012-06-04 13:11:52.512284497 -0400
> @@ -439,114 +439,6 @@ xfs_ialloc_next_ag(
>  }
>  
>  /*
> - * Select an allocation group to look for a free inode in, based on the parent
> - * inode and then mode.  Return the allocation group buffer.
> - */
> -STATIC xfs_agnumber_t
> -xfs_ialloc_ag_select(
> -	xfs_trans_t	*tp,		/* transaction pointer */
> -	xfs_ino_t	parent,		/* parent directory inode number */
> -	umode_t		mode,		/* bits set to indicate file type */
> -	int		okalloc)	/* ok to allocate more space */
> -{
> -	xfs_agnumber_t	agcount;	/* number of ag's in the filesystem */
> -	xfs_agnumber_t	agno;		/* current ag number */
> -	int		flags;		/* alloc buffer locking flags */
> -	xfs_extlen_t	ineed;		/* blocks needed for inode allocation */
> -	xfs_extlen_t	longest = 0;	/* longest extent available */
> -	xfs_mount_t	*mp;		/* mount point structure */
> -	int		needspace;	/* file mode implies space allocated */
> -	xfs_perag_t	*pag;		/* per allocation group data */
> -	xfs_agnumber_t	pagno;		/* parent (starting) ag number */
> -	int		error;
> -
> -	/*
> -	 * Files of these types need at least one block if length > 0
> -	 * (and they won't fit in the inode, but that's hard to figure out).
> -	 */
> -	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
> -	mp = tp->t_mountp;
> -	agcount = mp->m_maxagi;
> -	if (S_ISDIR(mode))
> -		pagno = xfs_ialloc_next_ag(mp);
> -	else {
> -		pagno = XFS_INO_TO_AGNO(mp, parent);
> -		if (pagno >= agcount)
> -			pagno = 0;
> -	}
> -
> -	ASSERT(pagno < agcount);
> -
> -	/*
> -	 * Loop through allocation groups, looking for one with a little
> -	 * free space in it.  Note we don't look for free inodes, exactly.
> -	 * Instead, we include whether there is a need to allocate inodes
> -	 * to mean that blocks must be allocated for them,
> -	 * if none are currently free.
> -	 */
> -	agno = pagno;
> -	flags = XFS_ALLOC_FLAG_TRYLOCK;
> -	for (;;) {
> -		pag = xfs_perag_get(mp, agno);
> -		if (!pag->pagi_inodeok) {
> -			xfs_ialloc_next_ag(mp);
> -			goto nextag;
> -		}
> -
> -		if (!pag->pagi_init) {
> -			error = xfs_ialloc_pagi_init(mp, tp, agno);
> -			if (error)
> -				goto nextag;
> -		}
> -
> -		if (pag->pagi_freecount) {
> -			xfs_perag_put(pag);
> -			return agno;
> -		}
> -
> -		if (!okalloc)
> -			goto nextag;
> -
> -		if (!pag->pagf_init) {
> -			error = xfs_alloc_pagf_init(mp, tp, agno, flags);
> -			if (error)
> -				goto nextag;
> -		}
> -
> -		/*
> -		 * Is there enough free space for the file plus a block of
> -		 * inodes? (if we need to allocate some)?
> -		 */
> -		ineed = XFS_IALLOC_BLOCKS(mp);
> -		longest = pag->pagf_longest;
> -		if (!longest)
> -			longest = pag->pagf_flcount > 0;
> -
> -		if (pag->pagf_freeblks >= needspace + ineed &&
> -		    longest >= ineed) {
> -			xfs_perag_put(pag);
> -			return agno;
> -		}
> -nextag:
> -		xfs_perag_put(pag);
> -		/*
> -		 * No point in iterating over the rest, if we're shutting
> -		 * down.
> -		 */
> -		if (XFS_FORCED_SHUTDOWN(mp))
> -			return NULLAGNUMBER;
> -		agno++;
> -		if (agno >= agcount)
> -			agno = 0;
> -		if (agno == pagno) {
> -			if (flags == 0)
> -				return NULLAGNUMBER;
> -			flags = 0;
> -		}
> -	}
> -}
> -
> -/*
>   * Try to retrieve the next record to the left/right from the current one.
>   */
>  STATIC int
> @@ -901,9 +793,9 @@ xfs_dialloc(
>  	xfs_buf_t	*agbp;		/* allocation group header's buffer */
>  	xfs_agnumber_t	agno;		/* allocation group number */
>  	int		error;		/* error return value */
> -	int		ialloced;	/* inode allocation status */
>  	int		noroom = 0;	/* no space for inode blk allocation */
>  	xfs_agnumber_t	start_agno;	/* starting allocation group number */
> +	int		pass;
>  	struct xfs_perag *pag;
>  
>  	if (*IO_agbp) {
> @@ -917,16 +809,6 @@ xfs_dialloc(
>  	}
>  
>  	/*
> -	 * We do not have an agbp, so select an initial allocation
> -	 * group for inode allocation.
> -	 */
> -	start_agno = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
> -	if (start_agno == NULLAGNUMBER) {
> -		*inop = NULLFSINO;
> -		return 0;
> -	}
> -
> -	/*
>  	 * If we have already hit the ceiling of inode blocks then clear
>  	 * okalloc so we scan all available agi structures for a free
>  	 * inode.
> @@ -938,12 +820,31 @@ xfs_dialloc(
>  	}
>  
>  	/*
> -	 * Loop until we find an allocation group that either has free inodes
> -	 * or in which we can allocate some inodes.  Iterate through the
> -	 * allocation groups upward, wrapping at the end.
> +	 * For directories start with a new allocation groups, for other file
> +	 * types aim to find an inode close to the parent.
>  	 */
> +	if (S_ISDIR(mode)) {
> +		start_agno = xfs_ialloc_next_ag(mp);
> +		ASSERT(start_agno < mp->m_maxagi);
> +	} else {
> +		start_agno = XFS_INO_TO_AGNO(mp, parent);
> +		if (start_agno >= mp->m_maxagi)
> +			start_agno = 0;
> +	}
> +
> +	/*
> +	 * Loop through allocation groups, looking for one with a little
> +	 * free space in it.  Note we don't look for free inodes, exactly.
> +	 * Instead, we include whether there is a need to allocate inodes
> +	 * to mean that blocks must be allocated for them, if none are
> +	 * currently free.
> +	 */
> +	*inop = NULLFSINO;
>  	agno = start_agno;
> +	pass = 0;

Do we even need multiple passes here? The first and second
passes appear to be identical except for the XFS_ALLOC_FLAG_TRYLOCK
flag on the xfs_alloc_pagf_init() call. After the first time we've
allocated in an AG, pag->pagf_init will always be set, so this means
pass = 0 and pass = 1 are identical for anything other than a
freshly mounted filesystem. Hence I think you can just drop the
trylock pass here.

And further, I can't see why we need a second pass at all.

I.e. what we used to do was:

select ag:

	pass 1:
		nonblocking scan over all AGI/AGF buffers
	pass 2 on fail:
		blocking scan over all AGI/AGF buffers

dialloc:
	if okalloc
		allocate inode chunk
	else
		pass 3:
			blocking scan over AGIs to find free inodes

So the 3 passes were used to work around the blocking nature of
AGI/AGF locks and minimising the allocation latency caused by
waiting on busy AGI/AGF buffers. By moving to using the per-ag data,
we avoid that latency problem altogether except for the
initialisation cases, which onyl occur just after mount.

Your logic now is:

dialloc:
	pass 1
		nonblocking scan over pagi/pagf
		if free inodes found, allocate
		else if pagf cannot be read, goto pass 2
		else if no contiguous free space could be found goto pass 2
		else allocate inode chunk and return

	pass 2
		nonblocking scan over pagi/pagf
		if free inodes found, allocate
		else if no contiguous free space could be found goto pass 3
		else allocate inode chunk and return

	pass 3:
		nonblocking scan over pagi/pagf
		if free inodes found, allocate
		else allocate inode chunk and return

AFAICS, pass 3 will always fail if pass 2 failed - if there isn't
enough contiguous free space in the AGF, we won't be able to
allocate a new inode chunk and avoiding that check won't change
anything. And given that pass 2 is completely redundant for a
filesytem that has been active for a few minutes, I really can't see
a need for multiple passes here at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
