Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GApasp086116 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 05:51:56 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 251AD19C8BF
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:51:14 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	eArla3lweTXVnGJM for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2009 03:51:14 -0700 (PDT)
Date: Mon, 16 Mar 2009 21:45:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] [XFS] Use xfs_sync_inodes() for device flushing
Message-ID: <20090316104537.GH26138@disturbed>
References: <1237116707-25793-1-git-send-email-david@fromorbit.com>
	<1237116707-25793-2-git-send-email-david@fromorbit.com>
	<20090316090847.GA2636@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316090847.GA2636@infradead.org>
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
Cc: mpatocka@redhat.com, xfs@oss.sgi.com

On Mon, Mar 16, 2009 at 05:08:47AM -0400, Christoph Hellwig wrote:
> On Sun, Mar 15, 2009 at 10:31:43PM +1100, Dave Chinner wrote:
> > index 5aeb777..08be36d 100644
> > --- a/fs/xfs/linux-2.6/xfs_fs_subr.c
> > +++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
> > @@ -74,14 +74,14 @@ xfs_flush_pages(
> >  
> >  	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> >  		xfs_iflags_clear(ip, XFS_ITRUNCATED);
> > -		ret = filemap_fdatawrite(mapping);
> > -		if (flags & XFS_B_ASYNC)
> > -			return -ret;
> > -		ret2 = filemap_fdatawait(mapping);
> > -		if (!ret)
> > -			ret = ret2;
> > +		ret = -filemap_fdatawrite(mapping);
> >  	}
> > -	return -ret;
> > +	if (flags & XFS_B_ASYNC)
> > +		return ret;
> > +	ret2 = xfs_wait_on_pages(ip, first, last);
> > +	if (!ret)
> > +		ret = ret2;
> > +	return ret;
> >  }
> 
> How does this belong into this patch series?

So xfs_flush_pages waits on writeback pages which aren't caught by
mapping_tagged(mapping, PAGECACHE_TAG_DIRTY). If we are waiting for
a flush to complete, we should be waiting for all pages under IO to
complete regardless of whether there are dirty pages or not. That
matters if we are doing 2 passes to flush everything and then wait;
the wait won't see dirty mappings, but there might still be pages
under IO....

> Also I think the sync code should just use filemap_fdatawait and
> filemap_fdatawait directly.  It's at a high enough level that we don't
> need all these obsfucations.

OK. I'll rework it so that:

> > +		if (flags & SYNC_DELWRI) {
> > +			if (VN_DIRTY(inode)) {
> > +				if (flags & SYNC_TRYLOCK) {
> > +					if (xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
> > +						lock_flags |= XFS_IOLOCK_SHARED;
> > +				} else {
> > +					xfs_ilock(ip, XFS_IOLOCK_SHARED);
> > +					lock_flags |= XFS_IOLOCK_SHARED;
> > +				}
> 
> > +				if (lock_flags & XFS_IOLOCK_SHARED) {
> 
> Too long line and pretty ugly use of the lock_flags variable, but given
> that it gets sorted out in the sync series I think we can leave it that way.

This gets done early and the later patches become simpler.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
