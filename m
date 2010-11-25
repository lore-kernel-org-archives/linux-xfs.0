Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAPAYp3Q257040 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 04:34:51 -0600
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35D221A6E48
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 02:36:29 -0800 (PST)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id Ly2L6FPV7LAOjIYl for
	<xfs@oss.sgi.com>; Thu, 25 Nov 2010 02:36:29 -0800 (PST)
Subject: Re: XFS reclaim lock order bug
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20101125102940.GE12187@dastard>
References: <20101123121802.GA4785@amd> <20101123211258.GY22876@dastard>
	<20101124200341.GA2493@infradead.org> <20101125034824.GA3359@amd>
	<1290666325.2072.535.camel@laptop>  <20101125102940.GE12187@dastard>
Date: Thu, 25 Nov 2010 11:36:44 +0100
Message-ID: <1290681404.2145.20.camel@laptop>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>, Nick Piggin <npiggin@kernel.dk>, xfs@oss.sgi.com

On Thu, 2010-11-25 at 21:29 +1100, Dave Chinner wrote:

> > In that case though, it would suggest the inode got re-used instead of
> > destroyed and re-created using xfs_alloc_inode(), is that at all
> > possible?
> 
> Yes, actually it is - see the XFS_IRECLAIMABLE case in
> xfs_iget_cache_hit(). I guess we haven't seen the original lock
> inversion false positives that this was supposed to fix because the
> reclaim warnings trip first...
> 
> I think that means we also need to reinitialise the lock when we recycle
> the inode out of the XFS_IRECLAIMABLE state.

Right, in which case you probably want an explicit lock class and use
that one class in both xfs_alloc_inode() and the reclaim case.

See my earlier suggestion wrt lockdep_set_class*() on how to do that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
