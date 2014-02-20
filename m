Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF2DD7F63
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 15:24:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F747AC009
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 13:24:36 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nCU7uKpEQ1hAPr0t for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 13:24:34 -0800 (PST)
Date: Fri, 21 Feb 2014 08:09:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: allocate xfs_da_args to reduce stack footprint
Message-ID: <20140220210922.GO4916@dastard>
References: <1392783402-4726-1-git-send-email-david@fromorbit.com>
	<1392783402-4726-4-git-send-email-david@fromorbit.com>
	<20140220145601.GC8366@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140220145601.GC8366@infradead.org>
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

On Thu, Feb 20, 2014 at 06:56:01AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2014 at 03:16:42PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The struct xfs_da_args used to pass directory/attribute operation
> > information to the lower layers is 128 bytes in size and is
> > allocated on the stack. Dynamically allocate them to reduce the
> > stack footprint of directory operations.
> 
> Are we having stack space problems in the directory code as well,
> without all the VM code above it?  I'm defintively a bit scared about
> adding another memory allocation to every single directory operation.

Oh, yeah. We've been having problems for some time now. When I
introduced the stack switch in the allocation path, i also did it
for metadata allocations because we'd seen a couple of reports
of stack overflows through the directory code. That got reverted
because of the performance issues it caused, so the directory code
is simply just another ticking timebomb.

See the thread here:

http://oss.sgi.com/pipermail/xfs/2014-February/034018.html

and, specifically:

http://oss.sgi.com/pipermail/xfs/2014-February/034156.html

Of further interest:

http://oss.sgi.com/pipermail/xfs/2014-February/034051.html
http://oss.sgi.com/pipermail/xfs/2014-February/034057.html
http://oss.sgi.com/pipermail/xfs/2014-February/034053.html



> 
> > +	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
> > +	if (!args)
> > +		return ENOMEM;
> 
> KM_SLEEP is the default when KM_NOFS is set.  Also KM_SLEEP will never
> return a NULL pointer, either remove the handling or make it an
> KM_MAYFAIL allocation.

It might be, but it's the same pattern we use everywhere else. It's
as much documentation of what the code requires, because we have
KM_MAYFAIL | KM_NOFS in other places. I'll kill the ENOMEM check -
that's just habit....

> 
> > +	/*
> > +	 * If we don't use KM_NOFS here, lockdep will through false positive
> > +	 * deadlock warnings when we come through here of the non-transactional
> > +	 * lookup path because the allocation can recurse into inode reclaim.
> > +	 * Doing this avoids having to add a bunch of lockdep class
> > +	 * annotations into the reclaim patch for the ilock.
> > +	 */
> > +	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
> 
> I don't understand that comment.  We do use KM_NOFS here unlike what the
> comment claims, and the comment seems to explain why we actually need
> KM_NOFS as far as I can tell.

The comment says "if we *don't* use KM_NOFS", so AFAICT, it's
correct. I can rewrite it to be more obvious.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
