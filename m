Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C586229DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 15:51:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A789304048
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 13:51:39 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6TgFFFEBg0CPGfJr for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 13:51:36 -0800 (PST)
Date: Wed, 10 Feb 2016 08:51:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: Introduce writeback context for writepages
Message-ID: <20160209215134.GF14668@dastard>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
	<1454910258-7578-3-git-send-email-david@fromorbit.com>
	<20160209142224.GA25829@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209142224.GA25829@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 09:22:26AM -0500, Brian Foster wrote:
> On Mon, Feb 08, 2016 at 04:44:15PM +1100, Dave Chinner wrote:
> > +	/*
> > +	 * We have to fail the iohead here because we buffers locked in the
> > +	 * ioend chain. If we don't do this, we'll deadlock invalidating the
> > +	 * page as that tries to lock the buffers on the page. Also, because we
> > +	 * have set pages under writeback, we have to run IO completion to mark
> > +	 * the error state of the IO appropriately, so we can't cancel the ioend
> > +	 * directly here. That means we have to mark this page as under
> > +	 * writeback if we included any buffers from it in the ioend chain.
> > +	 */
> > +	if (count)
> > +		xfs_start_page_writeback(page, 0, count);
> > +	xfs_writepage_submit(wpc, wbc, err);
> 
> We make the xfs_writepage_submit() error case call here because...
...
> >  STATIC int
> > +xfs_vm_writepage(
> > +	struct page		*page,
> > +	struct writeback_control *wbc)
> > +{
> > +	struct xfs_writepage_ctx wpc = {
> > +		.io_type = XFS_IO_OVERWRITE,
> > +	};
> > +	int			ret;
> > +
> > +	ret = xfs_do_writepage(page, wbc, &wpc);
> > +	if (ret)
> > +		return ret;
> > +	return xfs_writepage_submit(&wpc, wbc, ret);
> 
> 
> ... the callers only call it when ret == 0. Can we eliminate the error
> call down in xfs_do_writepage() and just invoke this consistently from
> the writepage(s) callers?

Probably - I think this is left over from an early concoction that
exploded badly when it was stirred too vigorously...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
