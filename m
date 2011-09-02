Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86FJf75087638 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 10:19:41 -0500
Subject: Re: [PATCH 08/25] xfs: introduce xfs_bmapi_delay()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060641.979845427@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060641.979845427@bombadil.infradead.org>
Date: Fri, 2 Sep 2011 17:23:58 -0500
Message-ID: <1315002238.2069.88.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-bmapi-add-xfs_bmapi_delay)
> Delalloc reservations are much simpler than allocations, so give them a
> separate bmapi-level interface.  Using the previously added
> xfs_bmapi_reserve_delalloc we get a function that is only minimally
> more complicated than xfs_bmapi_read, which is far from the complexity
> in xfs_bmapi.  Also remove the XFS_BMAPI_DELAY code after switching
> over the only user to xfs_bmapi_delay.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I have a minor suggestion but it's not worth
rejecting this over.  Also a question.  But
regardless, this looks good:

Reviewed-by: Alex Elder <aelder@sgi.com>

I'm out of time today.  I will have to continue
later.

> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:12:56.272619118 +0200
> +++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:12:59.355935746 +0200
> @@ -4238,7 +4238,7 @@ xfs_bmap_validate_ret(
>  		ASSERT(i == 0 ||
>  		       mval[i - 1].br_startoff + mval[i - 1].br_blockcount ==
>  		       mval[i].br_startoff);
> -		if ((flags & XFS_BMAPI_WRITE) && !(flags & XFS_BMAPI_DELAY))
> +		if (flags & XFS_BMAPI_WRITE)
>  			ASSERT(mval[i].br_startblock != DELAYSTARTBLOCK &&
>  			       mval[i].br_startblock != HOLESTARTBLOCK);
>  		ASSERT(mval[i].br_state == XFS_EXT_NORM ||
> @@ -4553,6 +4553,90 @@ out_unreserve_quota:
>  }
>  
>  /*
> + * Map file blocks to filesystem blocks, adding delayed allocations as needed.
> + */
> +int
> +xfs_bmapi_delay(
> +	struct xfs_inode	*ip,	/* incore inode */
> +	xfs_fileoff_t		bno,	/* starting file offs. mapped */
> +	xfs_filblks_t		len,	/* length to map in file */
> +	struct xfs_bmbt_irec	*mval,	/* output: map values */
> +	int			*nmap,	/* i/o: mval size/count */
> +	int			flags)	/* XFS_BMAPI_... */
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	struct xfs_bmbt_irec	got;	/* current file extent record */
> +	struct xfs_bmbt_irec	prev;	/* previous file extent record */
> +	xfs_fileoff_t		obno;	/* old block number (offset) */
> +	xfs_fileoff_t		end;	/* end of mapped file region */
> +	xfs_extnum_t		lastx;	/* last useful extent number */
> +	int			eof;	/* we've hit the end of extents */
> +	int			n = 0;	/* current extent index */
> +	int			error = 0;
> +
> +	ASSERT(*nmap >= 1);
> +	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
> +	ASSERT(!(flags & ~XFS_BMAPI_ENTIRE));
> +

Rearrange the following test to use the pattern (assigning error)
used in xfs_bmapi_read().

> +	if (unlikely(XFS_TEST_ERROR(
> +	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
> +	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),

Are you certain that XFS_DINODE_FMT_LOCAL is not possible here?
I tried to trace it back but I'm still not sure.  The transaction
pointer passed is null, so it would have tripped an assertion
in the previous code.  (A simple explanation would reassure me.)

> +	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
> +		XFS_ERROR_REPORT("xfs_bmapi_delay", XFS_ERRLEVEL_LOW, mp);
> +		return XFS_ERROR(EFSCORRUPTED);
> +	}
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return XFS_ERROR(EIO);
> +
> +	XFS_STATS_INC(xs_blk_mapw);
> +
> +
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
