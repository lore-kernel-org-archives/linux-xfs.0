Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388299AbeGXOAS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jul 2018 10:00:18 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3120BD9E
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 12:53:55 +0000 (UTC)
Date: Tue, 24 Jul 2018 07:53:54 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH v2 06/15] xfs: reset dfops to initial state after finish
Message-ID: <20180724125354.GA8459@redhat.com>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-7-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:05AM -0400, Brian Foster wrote:
> xfs_defer_init() is currently used in two particular situations. The
> first and most obvious case is raw initialization of an
> xfs_defer_ops struct. The other case is partial reinit of
> xfs_defer_ops on reuse due to iteration.
> 
> Most instances of the first case will be replaced by a single init
> of a dfops embedded in the transaction. Init calls are still
> technically required for the second case because the dfops may have
> low space mode enabled or have joined items that need to be reset
> before the dfops should be reused.
> 
> Since the current dfops usage expects either a final transaction
> commit after xfs_defer_finish() or xfs_defer_init() if dfops is to
> be reused, we can shift some of the init logic into
> xfs_defer_finish() such that the latter returns with a reinitialized
> dfops. This eliminates the second dependency noted above such that a
> dfops is immediately ready for reuse after an xfs_defer_finish()
> without the need to change any calling code.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_defer.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 0df09c094e42..23f2a52b088e 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -319,6 +319,19 @@ xfs_defer_bjoin(
>  	return -EFSCORRUPTED;
>  }
>  
> +/*
> + * Reset an already used dfops after finish.
> + */
> +static void
> +xfs_defer_reset(
> +	struct xfs_defer_ops	*dop)
> +{
> +	ASSERT(!xfs_defer_has_unfinished_work(dop));
> +	dop->dop_low = false;
> +	memset(dop->dop_inodes, 0, sizeof(dop->dop_inodes));
> +	memset(dop->dop_bufs, 0, sizeof(dop->dop_bufs));
> +}
> +
>  /*
>   * Finish all the pending work.  This involves logging intent items for
>   * any work items that wandered in since the last transaction roll (if
> @@ -427,10 +440,13 @@ xfs_defer_finish(
>  		dop = (*tp)->t_dfops;
>  	}
>  out:
> -	if (error)
> +	if (error) {
>  		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
> -	else
> +	} else {
>  		trace_xfs_defer_finish_done((*tp)->t_mountp, dop, _RET_IP_);
> +		xfs_defer_reset(dop);
> +	}
> +
>  	return error;
>  }
>  
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
