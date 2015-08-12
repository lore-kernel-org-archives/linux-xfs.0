Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C1BF7F50
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 02:21:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 59089304039
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 00:21:11 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id tIpvcI75bWhuEDXP (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 00:21:09 -0700 (PDT)
Date: Wed, 12 Aug 2015 00:21:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 13/13] xfs: add missing bmap cancel calls in error paths
Message-ID: <20150812072109.GC14237@infradead.org>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
	<1439233309-19959-14-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439233309-19959-14-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 10, 2015 at 03:01:49PM -0400, Brian Foster wrote:
> If a failure occurs after the bmap free list is populated and before
> xfs_bmap_finish() completes successfully (which returns a partial list
> on failure), the bmap free list must be cancelled. Otherwise, the extent
> items on the list are never freed and a memory leak occurs.
> 
> Several random error paths throughout the code suffer this problem. Fix
> these up such that xfs_bmap_cancel() is always called on error.

Looks sensible.  I wonder if we should attach the freelist to the
transaction and make xfs_trans_commit call into bmap_finish and
xfs_trans_cancel into xfs_bmap_cancel in the longer run?

> +STATIC int
>  xfs_growfs_rt_alloc(
> -	xfs_mount_t	*mp,		/* file system mount point */
> -	xfs_extlen_t	oblocks,	/* old count of blocks */
> -	xfs_extlen_t	nblocks,	/* new count of blocks */
> -	xfs_inode_t	*ip)		/* inode (bitmap/summary) */
> +	struct xfs_mount	*mp,		/* file system mount point */
> +	xfs_extlen_t		oblocks,	/* old count of blocks */
> +	xfs_extlen_t		nblocks,	/* new count of blocks */
> +	struct xfs_inode	*ip)		/* inode (bitmap/summary) */
>  {
> -	xfs_fileoff_t	bno;		/* block number in file */
> -	xfs_buf_t	*bp;		/* temporary buffer for zeroing */
> -	int		committed;	/* transaction committed flag */
> -	xfs_daddr_t	d;		/* disk block address */
> -	int		error;		/* error return value */
> -	xfs_fsblock_t	firstblock;	/* first block allocated in xaction */
> -	xfs_bmap_free_t	flist;		/* list of freed blocks */
> -	xfs_fsblock_t	fsbno;		/* filesystem block for bno */
> -	xfs_bmbt_irec_t	map;		/* block map output */
> -	int		nmap;		/* number of block maps */
> -	int		resblks;	/* space reservation */
> +	xfs_fileoff_t		bno;		/* block number in file */
> +	struct xfs_buf		*bp;	/* temporary buffer for zeroing */
> +	int			committed;	/* transaction committed flag */
> +	xfs_daddr_t		d;		/* disk block address */
> +	int			error;		/* error return value */
> +	xfs_fsblock_t		firstblock;/* first block allocated in xaction */
> +	struct xfs_bmap_free	flist;		/* list of freed blocks */
> +	xfs_fsblock_t		fsbno;		/* filesystem block for bno */
> +	struct xfs_bmbt_irec	map;		/* block map output */
> +	int			nmap;		/* number of block maps */
> +	int			resblks;	/* space reservation */
> +	struct xfs_trans	*tp;

Do we really need all this unrelated reformatting?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
