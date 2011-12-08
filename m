Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB8G7CqW151203 for <xfs@oss.sgi.com>; Thu, 8 Dec 2011 10:07:12 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A14FB2A8A43
	for <xfs@oss.sgi.com>; Thu,  8 Dec 2011 08:07:11 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QVfHxZhiyGzaUX2x for <xfs@oss.sgi.com>;
	Thu, 08 Dec 2011 08:07:11 -0800 (PST)
Date: Thu, 8 Dec 2011 11:07:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12] xfs: clean up buffer get/read call API
Message-ID: <20111208160710.GB26805@infradead.org>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
	<1323238703-13198-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323238703-13198-3-git-send-email-david@fromorbit.com>
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

On Wed, Dec 07, 2011 at 05:18:13PM +1100, Dave Chinner wrote:
> -	bp->b_file_offset = range_base;
> +	bp->b_file_offset = blkno << BBSHIFT;
>  	/*
>  	 * Set buffer_length and count_desired to the same value initially.
>  	 * I/O routines should use count_desired, which will be the same in
>  	 * most cases but may be reset (e.g. XFS recovery).
>  	 */
> -	bp->b_buffer_length = bp->b_count_desired = range_length;
> +	bp->b_buffer_length = bp->b_count_desired = numblks << BBSHIFT;
>  	bp->b_flags = flags;
> +
> +	/* XXX: we have the block number. Why don't we just set it here? */
>  	bp->b_bn = XFS_BUF_DADDR_NULL;

If you touch all this anyway I think we should kill one of b_file_offset
and b_bn.  Given that b_file_offset is never used outside of xfs_buf.c
and with your patch we're using the block number much more often than
the byte offset b_file_offset seems like the likely candidate to kill
to me.

Otherwise this looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
