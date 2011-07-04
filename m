Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p64BG9j7141432 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 06:16:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D55C8E714BA
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 04:16:07 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zi4n5F8u5l0XJBny for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2011 04:16:07 -0700 (PDT)
Date: Mon, 4 Jul 2011 07:16:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: use a cursor for bulk AIL insertion
Message-ID: <20110704111605.GA5513@infradead.org>
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

> +	do {
> +		/* no placeholder, so get our insert location */
> +		if (!lip)
> +			lip = __xfs_trans_ail_cursor_last(ailp, cur,
> +								lsn, false);
> +
> +		if (!lip) {
> +			/*
> +			 * The list is empty, so just splice and return.  Our
> +			 * cursor is already guaranteed to be up to date, so we
> +			 * don't need to touch it here.
> +			 */
> +			list_splice(list, &ailp->xa_ail);
> +			return;
> +		}
> +
> +		/* The placeholder was invalidated, need to get a new cursor */
> +		if ((__psint_t)lip & 1)
> +			lip = NULL;
> +
> +	} while (lip == NULL);

Why do we even need a loop here?  Given that we're under xa_lock
no new cursor will get invalidated.  Isn't the simple code below
equivalent?

	/* no valid placeholder, get us a useful one */
	if (!lip || (__psint_t)lip & 1))
		lip = __xfs_trans_ail_cursor_last(ailp, cur, lsn, false);

	if (!lip) {
		/*
		 * The list is empty, so just splice and return.  Our
		 * cursor is already guaranteed to be up to date, so we
		 * don't need to touch it here.
		 */
		list_splice(list, &ailp->xa_ail);
		return;
	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
