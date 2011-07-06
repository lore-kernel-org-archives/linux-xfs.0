Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p664ZxeI069791 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 23:35:59 -0500
Subject: Re: [PATCH 07/27] xfs: split xfs_itruncate_finish
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094603.580931463@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094603.580931463@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 23:35:58 -0500
Message-ID: <1309926958.3381.61.camel@doink>
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

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-split-xfs_itruncate_finish)
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
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

OK, finally got through this.  Not with my usual
rigor, but it looks like a pretty reasonable
split-up of the function.

I have one remark but that's it.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> @@ -1390,128 +1274,143 @@ xfs_itruncate_finish(
>  	 * beyond the maximum file size (ie it is the same as last_block),
>  	 * then there is nothing to do.
>  	 */
> +	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
>  	last_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
> -	ASSERT(first_unmap_block <= last_block);

. . .

> +		if (error)
> +			goto out_bmap_cancel;
>  
>  		/*
>  		 * Duplicate the transaction that has the permanent
>  		 * reservation and commit the old transaction.
>  		 */
> -		error = xfs_bmap_finish(tp, &free_list, &committed);
> -		ntp = *tp;
> +		error = xfs_bmap_finish(&tp, &free_list, &committed);
>  		if (committed)
> -			xfs_trans_ijoin(ntp, ip);
> -
> -		if (error) {
> -			/*
> -			 * If the bmap finish call encounters an error, return
> -			 * to the caller where the transaction can be properly
> -			 * aborted.  We just need to make sure we're not
> -			 * holding any resources that we were not when we came
> -			 * in.
> -			 *
> -			 * Aborting from this point might lose some blocks in
> -			 * the file system, but oh well.

The above comment (if true--I haven't really checked) seems
like something significant to preserve.

> -			 */
> -			xfs_bmap_cancel(&free_list);
> -			return error;
> -		}
> +			xfs_trans_ijoin(tp, ip);
> +		if (error)
> +			goto out_bmap_cancel;

. . .

> +
> +out:
> +	*tpp = tp;
> +	return error;
> +out_bmap_cancel:
> +	/*
> +	 * If the bunmapi call encounters an error, return to the caller where
> +	 * the transaction can be properly aborted.  We just need to make sure
> +	 * we're not holding any resources that we were not when we came in.
> +	 */
> +	xfs_bmap_cancel(&free_list);
> +	goto out;
> +}
> +

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
