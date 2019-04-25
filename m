Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730861AbfDYLRC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Apr 2019 07:17:02 -0400
Date: Thu, 25 Apr 2019 07:16:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: fix broken bhold behavior in xrep_roll_ag_trans
Message-ID: <20190425111656.GB29744@bfoster>
References: <20190425054747.GG178290@magnolia>
 <20190425055000.GH178290@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425055000.GH178290@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 24, 2019 at 10:50:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xrep_roll_ag_trans, the transaction roll will always set sc->tp to
> the new transaction, even if committing the old one fails.  A bare
> transaction roll leaves the buffer(s) locked but not joined to the new
> transaction, so it's not necessary to release the hold if the roll
> fails.  Remove the incorrect xfs_trans_bhold_release calls.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Makes sense:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/repair.c |   25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 5e7e36cdf3d5..eb358f0f5e0a 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -136,10 +136,16 @@ xrep_roll_ag_trans(
>  	if (sc->sa.agfl_bp)
>  		xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
>  
> -	/* Roll the transaction. */
> +	/*
> +	 * Roll the transaction.  We still own the buffer and the buffer lock
> +	 * regardless of whether or not the roll succeeds.  If the roll fails,
> +	 * the buffers will be released during teardown on our way out of the
> +	 * kernel.  If it succeeds, we join them to the new transaction and
> +	 * move on.
> +	 */
>  	error = xfs_trans_roll(&sc->tp);
>  	if (error)
> -		goto out_release;
> +		return error;
>  
>  	/* Join AG headers to the new transaction. */
>  	if (sc->sa.agi_bp)
> @@ -150,21 +156,6 @@ xrep_roll_ag_trans(
>  		xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
>  
>  	return 0;
> -
> -out_release:
> -	/*
> -	 * Rolling failed, so release the hold on the buffers.  The
> -	 * buffers will be released during teardown on our way out
> -	 * of the kernel.
> -	 */
> -	if (sc->sa.agi_bp)
> -		xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
> -	if (sc->sa.agf_bp)
> -		xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
> -	if (sc->sa.agfl_bp)
> -		xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
> -
> -	return error;
>  }
>  
>  /*
