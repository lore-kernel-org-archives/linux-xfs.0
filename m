Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 17:06:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8E0624p018008
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 17:06:03 -0700
Date: Fri, 14 Sep 2007 10:05:56 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: TAKE 968767 - Ensure file size updates have been completed before writing inode to disk.
Message-ID: <20070914000556.GX734179@sgi.com>
References: <200709130330.l8D3UGu9004196@redback.melbourne.sgi.com> <20070913112046.GA25515@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913112046.GA25515@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Thu, Sep 13, 2007 at 12:20:46PM +0100, Christoph Hellwig wrote:
> This has never been out for review, has it?
> 
> On Thu, Sep 13, 2007 at 01:30:16PM +1000, Lachlan McIlroy wrote:
> > fs/xfs/xfs_vnodeops.c - 1.720 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/> > xfs_vnodeops.c.diff?r1=text&tr1=1.720&r2=text&tr2=1.719&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/> xfs_vnodeops.c.diff?r1=text&tr1=1.720&r2=text&tr2=1.719&f=h
> > http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.720&r2=text&tr2=1.719&f=h
> > 	- Ensure file size updates have been completed before writing inode to disk.
> 
> I think you want to at least add a comment above the filemap_fdatawait
> call why we have it that early compared to where the generic code calls
> it (again).

true - obvious to lachlan and myself, maybe not others. :/

> But hopefully I'll push changes to the core code soon
> to move the filemap_datawrite/wait into fs domain completely.

What timeframe are we looking at there?

> I also don't like idioms like vn_to_inode(XFS_ITOV(ip)) at all.  Just
> doing a direct ip->i_vnode deference sounds perfectly fine.

Sounds like another cleanup patch for Eric ;)

> Why is removing the ipincount check in xfs_inode_flush okay?  Trying
> to flush pinned inodes doesn't seem that much of a good idea.

The code is .... convoluted. In the case where we are doing an async
flush, we check the pin count once we've got the locks so the pin
count check is not really needed here. In the case of a sync flush,
we'd return EAGAIN, which would then call use again with the FLUSH_LOG
flag and so we'd do a log force to unpin the inode.

If we then race with something to else, the inode could end up pinned
again before we go to flush the inode and hence we'd end up not
flushing the inode because the pin count was set again.

Anyway, if we are doing a sync flush, it's a blocking operation
and we want to push the log, which is exactly what will happen
in xfs_iflush() when it calls xfs_iunpin_wait() if the inode is
pinned. hence the check for xfs_ipincount() in the higher level
is pretty much redundant as the correct log force will occur
just by allowing the inode flush to continue.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
