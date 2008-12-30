Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUNds54009667 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 17:39:57 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74AAA173DD91
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 15:39:52 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	st7XUNysmbEHQAXE for <xfs@oss.sgi.com>;
	Tue, 30 Dec 2008 15:39:52 -0800 (PST)
Date: Wed, 31 Dec 2008 10:34:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] directory offset overflows in 2.6.28
Message-ID: <20081230233415.GA10725@disturbed>
References: <20081229220745.GA12966@infradead.org>
	<20081230001117.GA5220@disturbed>
	<20081230155726.GA30568@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081230155726.GA30568@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: John Stanley <jpsinthemix@verizon.net>, xfs@oss.sgi.com

On Tue, Dec 30, 2008 at 10:57:26AM -0500, Christoph Hellwig wrote:
> On Tue, Dec 30, 2008 at 11:11:17AM +1100, Dave Chinner wrote:
> > On Mon, Dec 29, 2008 at 05:07:45PM -0500, Christoph Hellwig wrote:
> > > The patch below is a dumb version of just putting back the masking,
> > > to make sure we have the same behavior as in 2.6.27 and earlier.
> > > I think we should at least hide it in a macro that is well-commented,
> > > but I suspect we also need to make sure that we never ever get bigger
> > > offsets in directories in some way.
> > 
> > I think we need that macro sooner rather than later ;)
> 
> > In this case, you can do the masking at the time cook is
> > assigned. I haven't checked, but I suspect the rest will be the
> > same. That will make the patch less invasive and with a macro
> > somewhat cleaner...
> 
> That way we could replace two assignment by one one time each
> in xfs_dir2_leaf.c and xfs_dir2_block.c.
> 
> I started working on the macro, but it seems even more hacky.
> 
> When looking at the big picture we have two problems:
> 
>  - the end of directory marker which always seems to be always too
>    large for 32bit values for 32 bit indices
>  - directories that actually are too large to be represented using
>    32 bit signed offsets.  I guess we just can't support those
>    for apps using the 32bit readdir interface and the EOVERFLOW
>    is valid for those.  The current approach as in < 2.6.28 and
>    with this patch breaks that second case in subtile ways.
> 
> So, I'd just push the first hacky opencoded patch into 2.6.29 and
> -stable now to revert to the old behaviour with all it's faults, and
> in the meantime I'll look into a proper way finding a better end of
> directory indicator.  That should also help Russell's BSD concerns.

Ok, sounds like a plan.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
