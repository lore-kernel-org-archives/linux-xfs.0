Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A793C7F58
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 18:23:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB160AC001
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 16:23:25 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	alpQ0CVw2quzyhen for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 16:23:19 -0800 (PST)
Date: Thu, 11 Feb 2016 11:21:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/8] xfs: remove xfs_cancel_ioend
Message-ID: <20160211002137.GR14668@dastard>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<1455094043-9694-3-git-send-email-david@fromorbit.com>
	<20160210112800.GA15221@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210112800.GA15221@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Feb 10, 2016 at 03:28:00AM -0800, Christoph Hellwig wrote:
> > +static int
> > +xfs_writepage_submit(
> > +	struct xfs_ioend	*ioend,
> > +	struct xfs_ioend	*iohead,
> > +	struct writeback_control *wbc,
> > +	int			status)
> > +{
> > +	struct blk_plug		plug;
> > +
> > +	/* Reserve log space if we might write beyond the on-disk inode size. */
> > +	if (!status && ioend && ioend->io_type != XFS_IO_UNWRITTEN &&
> > +	    xfs_ioend_is_append(ioend))
> > +		status = xfs_setfilesize_trans_alloc(ioend);
> > +
> > +	if (iohead) {
> > +		blk_start_plug(&plug);
> > +		xfs_submit_ioend(wbc, iohead, status);
> > +		blk_finish_plug(&plug);
> > +	}
> > +	return status;
> > +}
> 
> We return the xfs_setfilesize_trans_alloc failure status here,
> but none of the callers pick it up.  The way this is handled later
> changes a bit, but even at the end of the series only 1 of the
> three callers handles the error.

I'll propagate it through where it makes sense. If we alrady have an
error, then we aren't going to call xfs_setfilesize_trans_alloc()
anyway, so checking the return value only matters in the non-error
cases.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
