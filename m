Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OH1q6J067626 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 12:01:52 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	9I3gD7mZPEGeus5F (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 10:01:48 -0700 (PDT)
Date: Sat, 24 Mar 2012 13:01:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: move shutdown out of xfs_trans_ail_delete_bulk
Message-ID: <20120324170146.GA21708@infradead.org>
References: <1332467263-12985-1-git-send-email-david@fromorbit.com>
	<1332467263-12985-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1332467263-12985-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>  	spin_lock(&ailp->xa_lock);
> -	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)qfs);
> +	error = xfs_trans_ail_delete(ailp, (struct xfs_log_item *)qfs);

please make this a:

	error = xfs_trans_ail_delete(ailp, &qfs->qli_item);

while you're at it.

>  		if (lip->li_flags & XFS_LI_IN_AIL) {
>  			spin_lock(&ailp->xa_lock);
> -			if (lip->li_flags & XFS_LI_IN_AIL)
> -				xfs_trans_ail_delete(ailp, lip);
> -			else
> +			if (lip->li_flags & XFS_LI_IN_AIL) {
> +				int	error = xfs_trans_ail_delete(ailp, lip);
> +				if (error == EFSCORRUPTED)
> +					xfs_force_shutdown(ailp->xa_mount,
> +							SHUTDOWN_CORRUPT_INCORE);
> +			} else

Given that we already have two checks for XFS_LI_IN_AIL around the
call to xfs_trans_ail_delete I don't think we need to handle the error
here.

> @@ -887,8 +892,13 @@ xfs_iflush_abort(
>  		if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
>  			spin_lock(&ailp->xa_lock);
>  			if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
> +				int	error;
>  				/* xfs_trans_ail_delete() drops the AIL lock. */
> -				xfs_trans_ail_delete(ailp, (xfs_log_item_t *)iip);
> +				error = xfs_trans_ail_delete(ailp,
> +							(xfs_log_item_t *)iip);
> +				if (error == EFSCORRUPTED)
> +					xfs_force_shutdown(ailp->xa_mount,
> +							SHUTDOWN_CORRUPT_INCORE);

Same argument here.

Also please pass in &iip->>ili_item instead of the cast here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
