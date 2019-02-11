Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727327AbfBKOJm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Feb 2019 09:09:42 -0500
Date: Mon, 11 Feb 2019 09:09:39 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] libxfs: fix repair deadlock due to failed inode flushes.
Message-ID: <20190211140939.GC2804@bfoster>
References: <20190205032413.16075-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205032413.16075-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, arekm@maven.pl

On Tue, Feb 05, 2019 at 02:24:13PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If inode_item_done() fails to flush an inode after we've grabbed a
> reference to the underlying buffer during a transaction commit, we
> fail to put the buffer and hence leak it. We then deadlock on the
> next lookup ofthe inode buffer as it is still locked and no-one owns
> it.
> 
> To fix it, put the buffer on error so that it gets unlocked and
> can be recovered appropriately in a later phase of repair.
> 
> Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
> Fixes: d15188a1ec14 ("xfs: rework the inline directory verifiers")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libxfs/trans.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 46ff8b4ae798..10a35dd47b01 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -824,8 +824,10 @@ _("Transaction block reservation exceeded! %u > %u\n"),
>  
>  /*
>   * Transaction commital code follows (i.e. write to disk in libxfs)
> + *
> + * XXX (dgc): should failure to flush the inode (e.g. due to uncorrected
> + * corruption) result in transaction commit failure w/ EFSCORRUPTED?
>   */
> -
>  static void
>  inode_item_done(
>  	xfs_inode_log_item_t	*iip)
> @@ -856,17 +858,24 @@ inode_item_done(
>  		return;
>  	}
>  
> +	/*
> +	 * Flush the inode and disassociate it from the transaction regardless
> +	 * of whether the flush succeed or not. If we fail the flush, make sure
> +	 * we still release the buffer reference we currently hold.
> +	 */
>  	bp->b_log_item = iip;
>  	error = libxfs_iflush_int(ip, bp);
> +	ip->i_transp = NULL;	/* disassociate from transaction */
> +	bp->b_log_item = NULL;	/* remove log item */
> +	bp->b_transp = NULL;	/* remove xact ptr */
> +
>  	if (error) {
>  		fprintf(stderr, _("%s: warning - iflush_int failed (%d)\n"),
>  			progname, error);
> +		libxfs_putbuf(bp);
>  		return;
>  	}
>  
> -	ip->i_transp = NULL;	/* disassociate from transaction */
> -	bp->b_log_item = NULL;	/* remove log item */
> -	bp->b_transp = NULL;	/* remove xact ptr */
>  	libxfs_writebuf(bp, 0);
>  #ifdef XACT_DEBUG
>  	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
> -- 
> 2.20.1
> 
