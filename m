Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4H0HMMS212016 for <xfs@oss.sgi.com>; Sun, 16 May 2010 19:17:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E91D14974BE
	for <xfs@oss.sgi.com>; Sun, 16 May 2010 17:20:31 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	LhDiFpetQfxfb30R for <xfs@oss.sgi.com>;
	Sun, 16 May 2010 17:20:31 -0700 (PDT)
Date: Mon, 17 May 2010 10:19:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] Per-superblock shrinkers
Message-ID: <20100517001926.GI8120@dastard>
References: <1273821863-29524-1-git-send-email-david@fromorbit.com>
	<20100515013005.GA31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100515013005.GA31073@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, May 15, 2010 at 02:30:05AM +0100, Al Viro wrote:
> On Fri, May 14, 2010 at 05:24:18PM +1000, Dave Chinner wrote:
> > 
> > This series reworks the filesystem shrinkers. We currently have a
> > set of issues with the current filesystem shrinkers:
> > 
> > 	1. There is an dependency between dentry and inode cache
> > 	   shrinking that is only implicitly defined by the order of
> > 	   shrinker registration.
> > 	2. The shrinkers need to walk the superblock list and pin
> > 	   the superblock to avoid unmount races with the sb going
> > 	   away.
> > 	3. The dentry cache uses per-superblock LRUs and proportions
> > 	   reclaim between all the superblocks which means we are
> > 	   doing breadth based reclaim. This means we touch every
> > 	   superblock for every shrinker call, and may only reclaim
> > 	   a single dentry at a time from a given superblock.
> > 	4. The inode cache has a global LRU, so it has different
> > 	   reclaim patterns to the dentry cache, despite the fact
> > 	   that the dentry cache is generally the only thing that
> > 	   pins inodes in memory.
> > 	5. Filesystems need to register their own shrinkers for
> > 	   caches and can't co-ordinate them with the dentry and
> > 	   inode cache shrinkers.
> 
> NAK in that form; sb refcounting and iterators had been reworked for .34,
> so at least it needs rediff on top of that.

The tree I based this on was 2.6.34-rc7 - is there new code in a
-next branch somewhere?

> What's more, it's very
> obviously broken wrt locking - you are unregistering a shrinker
> from __put_super().  I.e. grab rwsem exclusively under a spinlock.
> Essentially, you've turned dropping a _passive_ reference to superblock
> (currently an operation safe in any context) into an operation allowed
> only when no fs or vm locks are held by caller.  Not going to work...

Yeah, I picked that up after I posted it. My bad - I'll look into how
I can rework that for the next iteration.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
