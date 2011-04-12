Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3CMl9pF170456 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 17:47:10 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A47583C943D
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 15:50:29 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OX7eThpZ1CGrx38O for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2011 15:50:29 -0700 (PDT)
Date: Wed, 13 Apr 2011 08:50:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: reset buffer pointers before freeing them
Message-ID: <20110412225026.GJ31057@dastard>
References: <1302491405-2290-1-git-send-email-david@fromorbit.com>
	<20110412000939.GC29358@infradead.org>
	<20110412110028.GA31057@dastard> <20110412134543.GG31057@dastard>
	<20110412162237.GB22506@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110412162237.GB22506@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Apr 12, 2011 at 12:22:37PM -0400, Christoph Hellwig wrote:
> On Tue, Apr 12, 2011 at 11:45:43PM +1000, Dave Chinner wrote:
> > Something like this?
> 
> Kinda.  A few comments below.
> 
> >  /*
> > + * Read at an offset into the buffer. Returns with the buffer in it's original
> > + * state regardless of the result of the read.
> > + */
> > +STATIC int
> > +xlog_bread_offset(
> > +	xlog_t		*log,
> > +	int		buf_offset,	/* offset into buffer */
> > +	int		buf_blks,	/* original buffer size */
> > +	xfs_daddr_t	blk_no,		/* block to read from */
> > +	int		nbblks,		/* blocks to read */
> > +	xfs_buf_t	*bp,
> > +	xfs_caddr_t	offset)
> > +{
> > +	xfs_caddr_t	orig_offset = XFS_BUF_PTR(bp);
> > +	int		error, error2;
> > +
> > +	error = XFS_BUF_SET_PTR(bp, offset + BBTOB(buf_offset), BBTOB(nbblks));
> 
> Passing in both offset and the buf_offset seems odd as they are only
> used together.  So just passing in one byte offset would make more
> sense to me.  Of course it's not actually an offset anyore, but virtual
> address, but we use that offset naming all around xlog_align/xlog_bread
> and callers.

Fair enough. I was struggling with the best way to pass and name
all the parameters. I just posted this before I went to bed to see
if this is what you had in mind....

> Also I don't think there is a need for the buf_blks argument.  The
> argument always comes directly from the xlog_get_bp number blocks
> argument, so the
> 
> 	BBTOB(buf_blks)
> 
> can be replaced by simply using a copy of b_buffer_length taken at
> the beginning of the function.

Very true. My brain surely was not functioning properly ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
