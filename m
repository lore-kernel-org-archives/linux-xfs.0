Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p648hHSs127615 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 03:43:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 102895246A3
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 01:43:16 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	MNwos1iawA6UlidQ for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2011 01:43:16 -0700 (PDT)
Date: Mon, 4 Jul 2011 04:43:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: convert AIL cursors to use struct list_head
Message-ID: <20110704084316.GA5907@infradead.org>
References: <1309757260-5484-1-git-send-email-david@fromorbit.com>
	<1309757260-5484-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309757260-5484-5-git-send-email-david@fromorbit.com>
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

On Mon, Jul 04, 2011 at 03:27:39PM +1000, Dave Chinner wrote:
>  /*
>   * AIL traversal cursor initialisation.
>   *
> + * The cursor keeps track of where our current traversal is up to by tracking
> + * the next ??tem in the list for us. However, for this to be safe, removing an
               ^^
Non-ASCSI character.

> + * object from the AIL needs to invalidate any cursor that points to it. hence
> + * the traversal cursor needs to be linked to the struct xfs_ail so that
> + * deletion can search all the active cursors for invalidation.
>   */
>  STATIC void
>  xfs_trans_ail_cursor_init(
> @@ -181,17 +177,13 @@ xfs_trans_ail_cursor_init(
>  	struct xfs_ail_cursor	*cur)
>  {
>  	cur->item = NULL;
> -	if (cur == &ailp->xa_cursors)
> -		return;
> -
> -	cur->next = ailp->xa_cursors.next;
> -	ailp->xa_cursors.next = cur;
> +	INIT_LIST_HEAD(&cur->list);
> +	list_add_tail(&cur->list, &ailp->xa_cursors);
>  }

There is no need to initialize a list_head before adding it to a list.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
