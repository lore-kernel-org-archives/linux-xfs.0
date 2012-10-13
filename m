Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9DG0djB205106 for <xfs@oss.sgi.com>; Sat, 13 Oct 2012 11:00:39 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZlQqH3pe8mPyIJwT (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 13 Oct 2012 09:02:13 -0700 (PDT)
Date: Sat, 13 Oct 2012 12:02:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/23] xfs: add pre-write metadata buffer verifier
	callbacks
Message-ID: <20121013160212.GA24337@infradead.org>
References: <1350020669-19504-1-git-send-email-david@fromorbit.com>
	<1350020669-19504-23-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1350020669-19504-23-git-send-email-david@fromorbit.com>
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

> +xfs_agfl_write_verify(
> +	struct xfs_buf	*bp)
> +{
> +	xfs_agfl_verify(bp);
> +}
> +
> +void
> +xfs_agfl_read_verify(
> +	struct xfs_buf	*bp)
> +{
> +	xfs_agfl_verify(bp);
> +	bp->b_pre_io = xfs_agfl_write_verify;
>  	bp->b_iodone = NULL;
>  	xfs_buf_ioend(bp, 0);

I have to say I hate the way the API works for the buffer callbacks
even more now that I see the write side.  I know you're a bit annoyed
about churn from review requests, but I'd really prefer if this
was redone.

Two ways to do this nicer come to mind:

 - Have one commone b_verify callback, which gets a bool for_write
   argument to key of differences.  The xfs_buf_ioend call for reads
   remains in the caller, b_iodone is not touched at all.  This will
   remove the boilerplate code a lot in the current version.
 - Expecting to have some more difference between the read and the
   write side when we actually do the crcs from my work on the previous
   iteration of it it might make sense to have two callbacks, but I'd
   again prefer to not overload b_iodone.  Maybe just pass a:

struct xfs_buf_ops {
	int (*verify_read)(struct xfs_buf *);
	int (*verify_write)(struct xfs_buf *);
};

to all the buffer read/write API calls, and let that deal with it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
