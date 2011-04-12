Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3CGJGFk157983 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 11:19:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6B4214B4BE3
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 09:22:37 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dzjeSXBHxVDy4ld6 for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2011 09:22:37 -0700 (PDT)
Date: Tue, 12 Apr 2011 12:22:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reset buffer pointers before freeing them
Message-ID: <20110412162237.GB22506@infradead.org>
References: <1302491405-2290-1-git-send-email-david@fromorbit.com>
	<20110412000939.GC29358@infradead.org>
	<20110412110028.GA31057@dastard> <20110412134543.GG31057@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110412134543.GG31057@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Apr 12, 2011 at 11:45:43PM +1000, Dave Chinner wrote:
> Something like this?

Kinda.  A few comments below.

>  /*
> + * Read at an offset into the buffer. Returns with the buffer in it's original
> + * state regardless of the result of the read.
> + */
> +STATIC int
> +xlog_bread_offset(
> +	xlog_t		*log,
> +	int		buf_offset,	/* offset into buffer */
> +	int		buf_blks,	/* original buffer size */
> +	xfs_daddr_t	blk_no,		/* block to read from */
> +	int		nbblks,		/* blocks to read */
> +	xfs_buf_t	*bp,
> +	xfs_caddr_t	offset)
> +{
> +	xfs_caddr_t	orig_offset = XFS_BUF_PTR(bp);
> +	int		error, error2;
> +
> +	error = XFS_BUF_SET_PTR(bp, offset + BBTOB(buf_offset), BBTOB(nbblks));

Passing in both offset and the buf_offset seems odd as they are only
used together.  So just passing in one byte offset would make more
sense to me.  Of course it's not actually an offset anyore, but virtual
address, but we use that offset naming all around xlog_align/xlog_bread
and callers.

Also I don't think there is a need for the buf_blks argument.  The
argument always comes directly from the xlog_get_bp number blocks
argument, so the

	BBTOB(buf_blks)

can be replaced by simply using a copy of b_buffer_length taken at
the beginning of the function.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
