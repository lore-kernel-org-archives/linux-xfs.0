Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p648W7aC125883 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 03:32:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35DB71678D19
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 01:32:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DAjcWAuoAH6UxbV9 for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2011 01:32:06 -0700 (PDT)
Date: Mon, 4 Jul 2011 04:32:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: use a cursor for bulk AIL insertion
Message-ID: <20110704083206.GA28858@infradead.org>
References: <1309757260-5484-1-git-send-email-david@fromorbit.com>
	<1309757260-5484-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309757260-5484-3-git-send-email-david@fromorbit.com>
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

>  /*
> + * Initialise the cursor to the last item in the AIL with the given @lsn.
> + * This searches the list from highest LSN to lowest.
>   */
> +static struct xfs_log_item *
> +__xfs_trans_ail_cursor_last(
> +	struct xfs_ail		*ailp,
> +	struct xfs_ail_cursor	*cur,
> +	xfs_lsn_t		lsn,
> +	bool			do_init)
>  {
> +	xfs_log_item_t		*lip = NULL;
>  
> +	if (do_init)
> +		xfs_trans_ail_cursor_init(ailp, cur);
> +
> +	if (list_empty(&ailp->xa_ail)) 
> +		goto out;
>  
> +	list_for_each_entry_reverse(lip, &ailp->xa_ail, li_ail) {
> +		if (XFS_LSN_CMP(lip->li_lsn, lsn) <= 0)
>  			break;
>  	}
> +out:
> +	if (cur)
> +		cur->item = lip;
> +	return lip;
> +}

Please just move the xfs_trans_ail_cursor_init call to
xfs_trans_ail_cursor_init instead of adding the do_init parameter.
Also the list_empty check is not needed due to the list_for_each*
macros handling that case just fine.

I haven't looked at the details of the new xfs_ail_splice code yet, so
more updates later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
