Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB6EZjdK254396 for <xfs@oss.sgi.com>; Mon, 6 Dec 2010 08:35:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B9CD1C9E60
	for <xfs@oss.sgi.com>; Mon,  6 Dec 2010 06:37:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id N78lAO2PE4GdFk5P for
	<xfs@oss.sgi.com>; Mon, 06 Dec 2010 06:37:32 -0800 (PST)
Date: Mon, 6 Dec 2010 09:37:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] xfs: use AIL bulk delete function to implement
	single delete
Message-ID: <20101206143732.GC31100@infradead.org>
References: <1290993152-20999-1-git-send-email-david@fromorbit.com>
	<1290993152-20999-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290993152-20999-9-git-send-email-david@fromorbit.com>
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

> -/*
>   * Bulk update version of xfs_trans_ail_delete
>   *
>   * This version takes an array of log items that all need to removed from the
>   * AIL. The caller is already holding the AIL lock, and done all the checks

Not overly useful now that the non-bulk version is gone.

>   * necessary to ensure the items passed in via @lgia are ready for deletion.
> + * If an item we delete in the AIL is the minimum one, update the tail lsn in
> + * the log manager.
>   *
>   * This function will not drop the AIL lock until all items are removed from
>   * the AIL to minimise the amount of lock traffic on the AIL. This does not
>   * greatly increase the AIL hold time, but does significantly reduce the amount
>   * of traffic on the lock, especially during IO completion.
> + *
> + * This function must be called with the AIL lock held.  The lock is dropped
> + * before returning.

These should be in the patch introducing xfs_trans_ail_delete_bulk.

Otherwise looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
