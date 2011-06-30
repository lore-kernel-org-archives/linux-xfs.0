Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U2iXFC166289 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 21:44:33 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC7984C2739
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 19:44:31 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DzID4BUJoQLpaL2e for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 19:44:31 -0700 (PDT)
Date: Thu, 30 Jun 2011 12:44:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/27] xfs: split xfs_itruncate_finish
Message-ID: <20110630024428.GB561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140338.286808024@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629140338.286808024@bombadil.infradead.org>
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

On Wed, Jun 29, 2011 at 10:01:18AM -0400, Christoph Hellwig wrote:
> Split the guts of xfs_itruncate_finish that loop over the existing extents
> and calls xfs_bunmapi on them into a new helper, xfs_itruncate_externs.
> Make xfs_attr_inactive call it directly instead of xfs_itruncate_finish,
> which allows to simplify the latter a lot, by only letting it deal with
> the data fork.  As a result xfs_itruncate_finish is renamed to
> xfs_itruncate_data to make its use case more obvious.
> 
> Also remove the sync parameter from xfs_itruncate_data, which has been
> unessecary since the introduction of the busy extent list in 2002, and
> completely dead code since 2003 when the XFS_BMAPI_ASYNC parameter was
> made a no-op.
> 
> I can't actually see why the xfs_attr_inactive needs to set the transaction
> sync, but let's keep this patch simple and without changes in behaviour.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Overall, looks good. A few minor comments in line, but consider it

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*ntp = *tpp;
> +	xfs_bmap_free_t		free_list;
> +	xfs_fsblock_t		first_block;
> +	xfs_fileoff_t		first_unmap_block;
> +	xfs_fileoff_t		last_block;
> +	xfs_filblks_t		unmap_len;
> +	int			committed;
> +	int			error = 0;
> +	int			done = 0;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
> -	ASSERT((new_size == 0) || (new_size <= ip->i_size));
> -	ASSERT(*tp != NULL);
> -	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> -	ASSERT(ip->i_transp == *tp);
> +	ASSERT(new_size == 0 || new_size <= ip->i_size);

If new_size == 0, then it will always be <= ip->i_size, so that's
kind of a redundant check. I think this really should be two
different asserts, one that validates the data fork new_size range,
and one that validates the attr fork truncate to zero length only
condition:

	ASSERT(new_size <= ip->i_size);
	ASSERT(whichfork != XFS_ATTR_FORK || new_size == 0);


> @@ -1464,15 +1311,16 @@ xfs_itruncate_finish(
>  		}
>  
>  		ntp = xfs_trans_dup(ntp);
> -		error = xfs_trans_commit(*tp, 0);
> -		*tp = ntp;
> +		error = xfs_trans_commit(*tpp, 0);
> +		*tpp = ntp;

I've always found this a mess to follow which transaction is which
because of the rewriting of ntp. This is easier to follow:

		ntp = xfs_trans_dup(*tpp);
		error = xfs_trans_commit(*tpp, 0);
		*tpp = ntp;

Now it's clear that we are duplicating *tpp, then committing it, and
then setting it to the duplicated transaction. Now I don't have to
go look at all the surrounding code to remind myself what ntp
contains to validate that the fragment of code is doing the right
thing.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
