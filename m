Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55088 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfCOWCF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Mar 2019 18:02:05 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 01/36] libxfs: fix repair deadlock due to failed inode
 flushes.
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259742930.31886.16675099707553706623.stgit@magnolia>
Message-ID: <29ea3ff9-bbfc-64eb-8c64-23ef7429b7a3@oracle.com>
Date: Fri, 15 Mar 2019 15:01:53 -0700
MIME-Version: 1.0
In-Reply-To: <155259742930.31886.16675099707553706623.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org, Arkadiusz Miskiewicz <arekm@maven.pl>, Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 3/14/19 2:03 PM, Darrick J. Wong wrote:
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
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   libxfs/trans.c |   17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 46ff8b4a..10a35dd4 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -824,8 +824,10 @@ _("Transaction block reservation exceeded! %u > %u\n"),
>   
>   /*
>    * Transaction commital code follows (i.e. write to disk in libxfs)
> + *
> + * XXX (dgc): should failure to flush the inode (e.g. due to uncorrected
> + * corruption) result in transaction commit failure w/ EFSCORRUPTED?
>    */
> -
>   static void
>   inode_item_done(
>   	xfs_inode_log_item_t	*iip)
> @@ -856,17 +858,24 @@ inode_item_done(
>   		return;
>   	}
>   
> +	/*
> +	 * Flush the inode and disassociate it from the transaction regardless
> +	 * of whether the flush succeed or not. If we fail the flush, make sure
> +	 * we still release the buffer reference we currently hold.
> +	 */
>   	bp->b_log_item = iip;
>   	error = libxfs_iflush_int(ip, bp);
> +	ip->i_transp = NULL;	/* disassociate from transaction */
> +	bp->b_log_item = NULL;	/* remove log item */
> +	bp->b_transp = NULL;	/* remove xact ptr */
> +
>   	if (error) {
>   		fprintf(stderr, _("%s: warning - iflush_int failed (%d)\n"),
>   			progname, error);
> +		libxfs_putbuf(bp);
>   		return;
>   	}
>   
> -	ip->i_transp = NULL;	/* disassociate from transaction */
> -	bp->b_log_item = NULL;	/* remove log item */
> -	bp->b_transp = NULL;	/* remove xact ptr */
>   	libxfs_writebuf(bp, 0);
>   #ifdef XACT_DEBUG
>   	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
> 
