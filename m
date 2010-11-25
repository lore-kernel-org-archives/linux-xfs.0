Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAPBZhPJ002303 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 05:35:44 -0600
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E427F1C71E8F
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 03:37:22 -0800 (PST)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id a1MgQhG7qgeWCagK for
	<xfs@oss.sgi.com>; Thu, 25 Nov 2010 03:37:22 -0800 (PST)
Subject: Re: XFS reclaim lock order bug
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20101125112530.GB4195@infradead.org>
References: <20101123121802.GA4785@amd> <20101123211258.GY22876@dastard>
	<20101124200341.GA2493@infradead.org> <20101125034824.GA3359@amd>
	<1290666325.2072.535.camel@laptop> <20101125102940.GE12187@dastard>
	<20101125112530.GB4195@infradead.org>
Date: Thu, 25 Nov 2010 12:37:37 +0100
Message-ID: <1290685057.2145.33.camel@laptop>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Nick Piggin <npiggin@kernel.dk>, xfs@oss.sgi.com

On Thu, 2010-11-25 at 06:25 -0500, Christoph Hellwig wrote:
> On Thu, Nov 25, 2010 at 09:29:40PM +1100, Dave Chinner wrote:
> > Yes, actually it is - see the XFS_IRECLAIMABLE case in
> > xfs_iget_cache_hit(). I guess we haven't seen the original lock
> > inversion false positives that this was supposed to fix because the
> > reclaim warnings trip first...
> > 
> > I think that means we also need to reinitialise the lock when we recycle
> > the inode out of the XFS_IRECLAIMABLE state.
> 
> I came up with the patch below when we had a previous report of the
> warning, but I couldn't convince myself that it really helps:
> 
> Index: linux-2.6/fs/xfs/xfs_iget.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_iget.c	2010-09-20 12:10:28.227444173 -0300
> +++ linux-2.6/fs/xfs/xfs_iget.c	2010-09-20 12:11:25.631444190 -0300
> @@ -207,6 +207,10 @@ xfs_iget_cache_hit(
>  
>  			ip->i_flags &= ~XFS_INEW;
>  			ip->i_flags |= XFS_IRECLAIMABLE;
> +
> +			ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
> +			mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
> +
>  			__xfs_inode_set_reclaim_tag(pag, ip);
>  			trace_xfs_iget_reclaim_fail(ip);
>  			goto out_error;


That adds a 3rd class which should work, but doesn't validate that the
first -- xfs_inode_alloc() and this one are in fact similar.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
