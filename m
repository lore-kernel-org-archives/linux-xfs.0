Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAP76nwG236549 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 01:06:50 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DA5713EB902
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 23:08:27 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5EcfgSvNo8BUjdym for <xfs@oss.sgi.com>;
	Wed, 24 Nov 2010 23:08:27 -0800 (PST)
Date: Thu, 25 Nov 2010 18:08:17 +1100
From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: XFS reclaim lock order bug
Message-ID: <20101125070817.GA4120@amd>
References: <20101123121802.GA4785@amd> <20101123211258.GY22876@dastard>
	<20101124200341.GA2493@infradead.org> <20101125034824.GA3359@amd>
	<1290666325.2072.535.camel@laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290666325.2072.535.camel@laptop>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>, Nick Piggin <npiggin@kernel.dk>, xfs@oss.sgi.com

On Thu, Nov 25, 2010 at 07:25:25AM +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-25 at 14:48 +1100, Nick Piggin wrote:
> > On Wed, Nov 24, 2010 at 03:03:41PM -0500, Christoph Hellwig wrote:
> > > On Wed, Nov 24, 2010 at 08:12:58AM +1100, Dave Chinner wrote:
> > > > It is supposed to be handled by the re-initialisation of the
> > > > ip->i_iolock in ->evict_inode (xfs_fs_evict_inode). An inode found
> > > > in the reclaim state must have passed through this reinitialisation,
> > > > so from a lockdep perspective the iolock in the vfs path is a
> > > > different context to the iolock in the reclaim path. That fixed all
> > > > the non-reclaim state related lockdep false positives, so Perhaps
> > > > there is an issue with the lockdep reclaim state checking that does
> > > > not interact well with re-initialised lock contexts?
> > > 
> > > I've been looking through this again, and I think it's indeed not
> > > enough.  We don't just need to re-initialize it, but also set a
> > > different lockclass for it.
> > 
> > Doesn't init_rwsem give it a new class?
> 
> Per call-site, yes it should.
> 
> > Guys, can you take a quick look at the code Dave is referring to
> > (xfs_fs_evict_inode), and check that it actually does what he
> > intends?
> 
> Right, so this is trying to set a different class from the regular init
> site, which (/me applies grep) lives in xfs_inode_alloc(), right?
> 
> Ought to work.. assuming the inode will be fully destroyed and new
> inodes are always obtained through xfs_inode_alloc() and not reused.
> 
> > We're getting what seems to be false positives in reclaim inversion
> > of lockings. Backtraces here
> > http://oss.sgi.com/pipermail/xfs/2010-November/048092.html
> 
> Right, so there its holding the inode in the read path while taking a
> page-fault which does an allocation.
> 
> vs
> 
> acquiring the inode in the xfs_reclaim_node_shrink() path.
> 
> 
> Presumably the whole xfs_fs_evict_inode() stuff will happen _after_ its
> possible to end up in that read path?

I think that's the idea.

 
> Something like the below would give the lock-class an explicit name,
> because both sites now use the exact same init thing they're called:
> 
>   (&(&ip->i_iolock)->mr_lock)
>   (&(&ip->i_iolock)->mr_lock#2)
> 
> Which is hard to tell apart, but I suspect #2 is the dead one, since
> they get numbered in order of appearance and its hard to have a dead
> inode before having a life one ;-)
> 
> In that case though, it would suggest the inode got re-used instead of
> destroyed and re-created using xfs_alloc_inode(), is that at all
> possible?

Ah, I see what you mean. An inode that has been through the evict_inode
path is now found to be locked for read(2). The rwsem is in the
init_always path of the allocator, so it seems like it's getting reused
after evict_inode. Dave?

> 
> ---
>  fs/xfs/linux-2.6/xfs_super.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> index 064f964..721c1c5 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -1091,6 +1091,8 @@ xfs_fs_write_inode(
>  	return -error;
>  }
>  
> +static struct lock_class_key xfs_dead_inode;
> +
>  STATIC void
>  xfs_fs_evict_inode(
>  	struct inode		*inode)
> @@ -1118,6 +1120,8 @@ xfs_fs_evict_inode(
>  	 */
>  	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
>  	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
> +	lockdep_set_class_and_name(&ip->i_iolock->mr_lock, &xfs_dead_inode, 
> +			"xfd_dead_inode");
>  
>  	xfs_inactive(ip);
>  }

With this change, I assume the mrlock_init can go? (it would be nice
to have a wrapper to allocate the class by itself)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
