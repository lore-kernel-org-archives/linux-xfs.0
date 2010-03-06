Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26BNTmo081971 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 05:23:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D83E113FF20E
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 03:24:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 41MiFk0KtV8Ck3SW for
	<xfs@oss.sgi.com>; Sat, 06 Mar 2010 03:24:58 -0800 (PST)
Date: Sat, 6 Mar 2010 06:24:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/9] xfs: update and factor xfs_trans_committed()
Message-ID: <20100306112458.GA20821@infradead.org>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
	<1267840284-4652-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267840284-4652-7-git-send-email-david@fromorbit.com>
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

On Sat, Mar 06, 2010 at 12:51:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The function header to xfs-trans_committed has long had this
> comment:
> 
>  * THIS SHOULD BE REWRITTEN TO USE xfs_trans_next_item()
> 
> To prepare for different methods of committing items, convert the
> code to use xfs_trans_next_item() and factor the code into smaller,
> more digestible chunks.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

A few nits left over from the old code that might be worth fixing
while you're at it:

> -STATIC void	xfs_trans_chunk_committed(xfs_log_item_chunk_t *, xfs_lsn_t, int);

Once you start reoerding the functions, can we also move
xfs_trans_committed above it's user?

> +static void
> +xfs_trans_item_committed(
> +	xfs_log_item_t	*lip,
> +	xfs_lsn_t	commit_lsn,
> +	int		aborted)
>  {
> +	xfs_lsn_t	item_lsn;
> +	struct xfs_ail	*ailp;

Might be worth to switch to the struct types consistently and give
the variables another tab of indentation.

> +
> +	if (aborted)
> +		lip->li_flags |= XFS_LI_ABORTED;
>  
>  	/*
> +	 * Send in the ABORTED flag to the COMMITTED routine so that it knows
> +	 * whether the transaction was aborted or not.
>  	 */
> +	item_lsn = IOP_COMMITTED(lip, commit_lsn);

If we want to keep the comment it should be moved above the

	if (aborted)

abive.  But I'd just drop it.

> +xfs_trans_committed(
> +	xfs_trans_t	*tp,
> +	int		abortflag)
>  {
>  	xfs_log_item_desc_t	*lidp;
> +	xfs_log_item_chunk_t	*licp;
> +	xfs_log_item_chunk_t	*next_licp;
>  
> +	/*
> +	 * Call the transaction's completion callback if there
> +	 * is one.
> +	 */
> +	if (tp->t_callback != NULL) {
> +		tp->t_callback(tp, tp->t_callarg);
> +	}

	if (tp->t_callback)
		tp->t_callback(tp, tp->t_callarg);

> +	/* free the item chunks, ignoring the embedded chunk */
> +	licp = tp->t_items.lic_next;
> +	while (licp != NULL) {
> +		next_licp = licp->lic_next;
> +		ASSERT(xfs_lic_are_all_free(licp));
> +		kmem_free(licp);
> +		licp = next_licp;

	for (licp = tp->t_items.lic_next; licp != NULL; licp = next_licp) {
		next_licp = licp->lic_next;
		ASSERT(xfs_lic_are_all_free(licp));
		kmem_free(licp);
	}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
