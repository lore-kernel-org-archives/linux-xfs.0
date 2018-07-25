Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58792 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbeGYG0S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 02:26:18 -0400
Date: Tue, 24 Jul 2018 22:16:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 15/15] xfs: bypass final dfops roll in trans commit
 path
Message-ID: <20180725051622.GH5802@infradead.org>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-16-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-16-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> +xfs_defer_finish(
> +	struct xfs_trans	**tp)
> +{
> +	int			error;
> +
> +	/*
> +	 * Finish and roll the transaction once more to avoid returning to the
> +	 * caller with a dirty transaction.
> +	 */
> +	error = xfs_defer_finish_noroll(tp);
> +	if (!error && ((*tp)->t_flags & XFS_TRANS_DIRTY))
> +		error = xfs_defer_trans_roll(tp);
> +	if (!error)
> +		xfs_defer_reset((*tp)->t_dfops);
>  
>  	return error;

Nitpick: I'd write this as:

	error = xfs_defer_finish_noroll(tp);
	if (error)
		return error;

	if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
		error = xfs_defer_trans_roll(tp);
		if (error)
			return error;
	}

	xfs_defer_reset((*tp)->t_dfops);
	return 0;

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
