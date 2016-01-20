Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5C097F37
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 14:32:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8BDD304053
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 12:32:15 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	C8nmxD3E7sHKHlRG for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2016 12:32:13 -0800 (PST)
Date: Thu, 21 Jan 2016 07:32:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Pass mp to kmem_alloc and friends?
Message-ID: <20160120203211.GC20456@dastard>
References: <569FCAED.4050306@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <569FCAED.4050306@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Jan 20, 2016 at 11:59:09AM -0600, Eric Sandeen wrote:
> I had a request for the kmem_alloc deadlock warning to print the
> filesystem involved.
> 
> Any objections to passing mp into kmem_alloc() and friends whenever
> it's reasonably available from the caller?
> 
> It'd be a big mechanical change, don't want to embark on that unless
> it seems acceptable & useful.

I think I hinted at this in the configurable error handling patchset
I have so that we could have configurable ENOMEM error handling. My
comment in the current commit message for that patch includes this:

| I'm not yet sure how to hook it into the memory allocation calls -
| that will be done in a later patch; this just demonstrates how
| multiple classes are configured and initialised. It may be that we
| don't configure specific errors here - instead configure how we
| handle specific types of allocation failure e.g. GFP_KERNEL vs
| GFP_NOFS vs allocations inside transactions. Either way, we are
| going to need to plumb the error config handler into the
| memory allocation code in some manner.

So I think we are going to have to plumb the xfs_mount into these
calls at some point in the near future.

> I think we generally know the root causes of the most common deadlock
> warnings, but it's a warm fuzzy to give as much info as possible.
> 
> Heck, I almost wonder if passing a descriptive string in, for at
> least the problematic cases we know about, i.e. "extent map realloc"
> so we'd get something like:
> 
> XFS (sdb1): myprocess(123) possible memory allocation deadlock size 12345 during extent map realloc in kmem_alloc (mode:0x250)

If we want more context, then make it an error message that can dump
the stack when the error level is turned up. i.e. if we pass in an
xfs_mount, we can use XFS_ERROR_REPORT here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
