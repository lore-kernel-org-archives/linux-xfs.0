Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0203329DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 07:39:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA8C58F8049
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 05:39:44 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Ob67UF7bhRSU1kv7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 05:39:42 -0800 (PST)
Date: Tue, 9 Feb 2016 05:39:41 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: Introduce writeback context for writepages
Message-ID: <20160209133941.GA13357@infradead.org>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
	<1454910258-7578-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454910258-7578-3-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This looks good in general and now passes testing for me.  A couple
comments below:

>  
>  /*
> - * Cancel submission of all buffer_heads so far in this endio.
> - * Toss the endio too.  Only ever called for the initial page
> - * in a writepage request, so only ever one page.
> - */
> -STATIC void
> -xfs_cancel_ioend(
> -	xfs_ioend_t		*ioend)
> -{
> -	xfs_ioend_t		*next;
> -	struct buffer_head	*bh, *next_bh;
> -
> -	do {
> -		next = ioend->io_list;
> -		bh = ioend->io_buffer_head;
> -		do {
> -			next_bh = bh->b_private;
> -			clear_buffer_async_write(bh);
> -			/*
> -			 * The unwritten flag is cleared when added to the
> -			 * ioend. We're not submitting for I/O so mark the
> -			 * buffer unwritten again for next time around.
> -			 */
> -			if (ioend->io_type == XFS_IO_UNWRITTEN)
> -				set_buffer_unwritten(bh);
> -			unlock_buffer(bh);
> -		} while ((bh = next_bh) != NULL);
> -
> -		mempool_free(ioend, xfs_ioend_pool);
> -	} while ((ioend = next) != NULL);
> -}

Removing xfs_cancel_ioend and replacing it with the start and cancel
writeback scheme that we currently only use for
xfs_setfilesize_trans_alloc failures actually seems to be the biggest
change in this patch and is entirely undocumented.  Any chance you
could split this into a prep patch and properly document it?

> -
> -	if (!ioend || need_ioend || type != ioend->io_type) {
> -		xfs_ioend_t	*previous = *result;
> -
> -		ioend = xfs_alloc_ioend(inode, type);
> -		ioend->io_offset = offset;
> -		ioend->io_buffer_head = bh;
> -		ioend->io_buffer_tail = bh;
> -		if (previous)
> -			previous->io_list = ioend;
> -		*result = ioend;
> +	if (!wpc->ioend || wpc->io_type != wpc->ioend->io_type ||
> +	    bh->b_blocknr != wpc->last_block + 1) {

We now start a new ioend if the blocks aren't contiguous, which seems
reasonable.  But this also means the similar check in xfs_submit_ioend
should be removed at the same time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
