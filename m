Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RC2pAm183991 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 07:02:52 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 216B51330DF6
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 05:13:15 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	tlQceJbav5odVW7g for <xfs@oss.sgi.com>;
	Tue, 27 Jul 2010 05:13:15 -0700 (PDT)
Date: Tue, 27 Jul 2010 22:05:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: use range primitives for xfs page cache
	operations
Message-ID: <20100727120552.GN7362@dastard>
References: <1280210129-10925-1-git-send-email-david@fromorbit.com>
	<1280210129-10925-2-git-send-email-david@fromorbit.com>
	<20100727065326.GA32510@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100727065326.GA32510@infradead.org>
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

On Tue, Jul 27, 2010 at 02:53:26AM -0400, Christoph Hellwig wrote:
> On Tue, Jul 27, 2010 at 03:55:28PM +1000, Dave Chinner wrote:
> > While XFS passes ranges to operate on from the core code, the
> > functions being called ignore the either the entire range or the end
> > of the range. This is historical because when the function were
> > written linux didn't have the necessary range operations. Update the
> > functions to use the correct operations.
> 
> Assuming you have actually tested this - given that we've ignore
> these parameters so long that I'm really fearing some callers have
> started to rely on that behaviour.

Several xfstests run on different configs haven't shown any
regressions.

All current callers of xfs_tosspages() trim from and offset to EOF,
so no change in behaviour there.

All of the xfs_flush_pages() icallers except one flush the entire
file (0 to -1), except for a single call in xfs_setattr which
between on disk size and the new filesystem when extending the file
size by truncate.  It will now flush just the necessary range
instead of the whole file.

All of xfs_flushinval_pages() callers flush to the end of file,
so once again there should be no change in behaviour there.

So I don't think there really is much risk here - the only one that
I'd be concerned about is the setattr() call and we have tests
covering that specific case (138, 139 and 140)....

> >  	if (mapping->nrpages) {
> 
> I'd drop this check ere as well - no other caller does it.
> 
> >  		xfs_iflags_clear(ip, XFS_ITRUNCATED);
> > -		ret = filemap_write_and_wait(mapping);
> > +		ret = filemap_write_and_wait_range(mapping, first,
> > +					last == -1 ? LLONG_MAX : last);
> >  		if (!ret)
> > -			truncate_inode_pages(mapping, first);
> > +			truncate_inode_pages_range(mapping, first, last);
> >  	}
> >  	return -ret;
> >  }
> > @@ -73,7 +71,8 @@ xfs_flush_pages(
> >  
> >  	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> 
> Same for this check.

Ok, killed those checks.

> >  		xfs_iflags_clear(ip, XFS_ITRUNCATED);
> > -		ret = -filemap_fdatawrite(mapping);
> > +		ret = -filemap_fdatawrite_range(mapping, first,
> > +					last == -1 ? LLONG_MAX : last);
> 
> Also for the non-async case we should just use
> filemap_write_and_wait_range, and kill off xfs_wait_on_pages.

That can be done separately, I think. If we don't see any
problems from this patch, then I think we can kill all
the wrappers, not just one of them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
