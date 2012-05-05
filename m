Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q45NVgX8017010 for <xfs@oss.sgi.com>; Sat, 5 May 2012 18:31:43 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	S8leQnEb9YcLPTQw for <xfs@oss.sgi.com>;
	Sat, 05 May 2012 16:31:41 -0700 (PDT)
Date: Sun, 6 May 2012 09:31:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock below xfs_ialloc, when radix_tree_preload goes into
	reclaim?
Message-ID: <20120505233133.GD25351@dastard>
References: <CAH4wwdHb0=9UtTiwz-fAYovXGO6J8soda31S+dgCGNKBA3j5sw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAH4wwdHb0=9UtTiwz-fAYovXGO6J8soda31S+dgCGNKBA3j5sw@mail.gmail.com>
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
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, May 04, 2012 at 05:55:21PM -0400, Peter Watkins wrote:
> Greetings,
> 
> Anyone seen a deadlock like the one below? It's a 17TB system with 32
> bit inodes and it's doing lots of inode allocations at the same time.
> So you might consider it a stress test for inode alloc activity on a
> single AG.
> 
> xfs_ialloc called xfs_dialloc and got the agi header buf, then it
> called xfs_iget which went into reclaim during radix_tree_preload.
> While trying to shrink the inode cache, xfs_iunlink_remove tries to
> get the same agi header buf.
> 
> With 64 bit inodes you'd be less likely to hit this path, but it's
> still possible, no?
> 
> Should this call to radix_tree_preload use GFP_NOFS?

Yes, because xfs_iget canbe called from transaction context. Can you
send a patch for the current TOT kernel?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
