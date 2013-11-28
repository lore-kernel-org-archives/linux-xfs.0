Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B4567F37
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 16:51:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0014DAC002
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 14:51:06 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MsDGgZEBZpxN60DV for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 14:51:05 -0800 (PST)
Date: Fri, 29 Nov 2013 09:51:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131128225102.GS10988@dastard>
References: <20131124140413.GA19271@infradead.org>
	<20131124152758.GL10323@ZenIV.linux.org.uk>
	<20131125160648.GA4933@infradead.org>
	<20131126131134.GM10323@ZenIV.linux.org.uk>
	<20131126141253.GA28062@infradead.org>
	<20131127064351.GN10323@ZenIV.linux.org.uk>
	<20131127100906.GA19740@infradead.org>
	<20131128162618.GO10323@ZenIV.linux.org.uk>
	<20131128212301.GP10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131128212301.GP10323@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com

On Thu, Nov 28, 2013 at 09:23:01PM +0000, Al Viro wrote:
> On Thu, Nov 28, 2013 at 04:26:18PM +0000, Al Viro wrote:
> > On Wed, Nov 27, 2013 at 02:09:06AM -0800, Christoph Hellwig wrote:
> > 
> > > Also if you want to look me into something else feel free - it's very
> > > reproducable here.  Wish I could be more help here, but with all the
> > > RCU and micro optimizations in the path lookup code I can't claim to
> > > really understand it anymore.
> > 
> > OK, I've been able to reproduce it and I see at least a part of what's
> > going on, but...
> > 
> > What happens is that we get path_init() race with something and leave
> > us with nd->path pointing to what used to be pwd but has become a
> > negative dentry in process.
> > 
> > AFAICS, it *was* borderline possible to hit before now:
> > 
> > process A and B are CLONE_FS threads and are chdired to /tmp/foo
> > A asks for e.g. readlink() on bar
> > 	in path_init() we'd got nd->path (at /tmp/foo) and nd->seq; we are
> > 	in LOOKUP_RCU mode, so nd->path isn't pinned.
> > B chdirs them both to /tmp, leaving /tmp/foo not busy
> > C rmdirs /tmp/foo
> > A sets nd->inode to nd->path.dentry->d_inode, but this sucker has gone
> > negative now.  Sure, nd->seq doesn't match anymore, but that doesn't
> > do us any good - the first thing we'll do in link_path_walk() is
> > may_lookup(nd) and it'll blow on attempt to call inode_permission() for
> > nd->inode.
> > 
> > What I still do not understand is how the devil is similar race actually
> > triggered during shutdown.  Digging through that right now...
> > 
> > Anyway, verifying that this is what's going on for particular reproducer
> > is easy - add WARN_ON(!nd->inode) in the very end of path_init() and
> > see if it triggers.
> 
> *grumble*
> 
> Looks like adding if (!nd->inode) { a bunch of printks } in the end of
> path_init() makes the sucker disappear (so far 2 times out of 2, and
> with a test run taking a bit under two hours, well...)  The plain
> WARN_ON(!nd->inode) in that place triggers just fine.

I usually find that when printk() makes race conditions go away,
switching to tracepoints works better. It's still not as good as
reliable as when the debug is not there, but it seems to perturb
race conditions a lot less.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
