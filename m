Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CFA767F5A
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 18:25:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDF73304039
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 16:25:49 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WXxsisaSqtxwDdX6 for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 16:25:46 -0800 (PST)
Date: Thu, 11 Feb 2016 11:25:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/8] xfs: Introduce writeback context for writepages
Message-ID: <20160211002544.GS14668@dastard>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<1455094043-9694-4-git-send-email-david@fromorbit.com>
	<20160210113126.GB15221@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210113126.GB15221@infradead.org>
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

On Wed, Feb 10, 2016 at 03:31:26AM -0800, Christoph Hellwig wrote:
> > +	struct xfs_writepage_ctx wpc = {
> > +		.io_type = XFS_IO_OVERWRITE,
> > +	};
> > +	int			ret;
> > +
> > +	ret = xfs_do_writepage(page, wbc, &wpc);
> > +	return xfs_writepage_submit(&wpc, wbc, ret);
> > +}
> > +
> > +STATIC int
> >  xfs_vm_writepages(
> >  	struct address_space	*mapping,
> >  	struct writeback_control *wbc)
> >  {
> > +	struct xfs_writepage_ctx wpc = {
> > +		.io_type = XFS_IO_OVERWRITE,
> > +	};
> 
> Shouldn't we start out with an invalid (0) state, and just move
> the actual states up to start from 1?

This is just a translation of the existing code - the imap_valid
flag being initialised to zero ensures the io_type is correctly
initialised if it differs from XFS_IO_OVERWRITE. I guess there's no
harm in changing it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
