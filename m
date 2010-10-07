Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o973BurT143977 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 22:11:56 -0500
Subject: Re: [patch] xfs: properly account for reclaimed inodes
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <201010051126.47537.hpj@urpla.net>
References: <20101001074354.GF2618@cmpxchg.org>
	<20101004071904.GH4681@dastard> <20101004102213.GJ2618@cmpxchg.org>
	<201010051126.47537.hpj@urpla.net>
Date: Wed, 06 Oct 2010 22:12:54 -0500
Message-ID: <1286421174.6040.1.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: John Hawley <warthog9@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Johannes Weiner <hannes@cmpxchg.org>, stable@kernel.org

On Tue, 2010-10-05 at 11:26 +0200, Hans-Peter Jansen wrote:
> On Monday 04 October 2010, 12:22:13 Johannes Weiner wrote:
> > Hi,
> >
> > On Mon, Oct 04, 2010 at 06:19:04PM +1100, Dave Chinner wrote:
> > > On Fri, Oct 01, 2010 at 12:17:23PM -0500, Alex Elder wrote:
> > > > On Fri, 2010-10-01 at 09:43 +0200, Johannes Weiner wrote:
> > > > > When marking an inode reclaimable, a per-AG counter is increased,
> > > > > the inode is tagged reclaimable in its per-AG tree, and, when this
> > > > > is the first reclaimable inode in the AG, the AG entry in the
> > > > > per-mount tree is also tagged.
> > > > >
> > > > > When an inode is finally reclaimed, however, it is only deleted
> > > > > from the per-AG tree.  Neither the counter is decreased, nor is the
> > > > > parent tree's AG entry untagged properly.
> > > > >
> > > > > Since the tags in the per-mount tree are not cleared, the inode
> > > > > shrinker iterates over all AGs that have had reclaimable inodes at
> > > > > one point in time.
> > > > >
> > > > > The counters on the other hand signal an increasing amount of slab
> > > > > objects to reclaim.  Since "70e60ce xfs: convert inode shrinker to
> > > > > per-filesystem context" this is not a real issue anymore because
> > > > > the shrinker bails out after one iteration.
> > > > >
> > > > > But the problem was observable on a machine running v2.6.34, where
> > > > > the reclaimable work increased and each process going into direct
> > > > > reclaim eventually got stuck on the xfs inode shrinking path,
> > > > > trying to scan several million objects.
> > > > >
> > > > > Fix this by properly unwinding the reclaimable-state tracking of an
> > > > > inode when it is reclaimed.
> > > > >
> > > > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > > > Cc: stable@kernel.org
> > > >
> > > > Yes, this looks right to me.  The state was correctly
> > > > adjusted in xfs_iget_cache_hit() when a RECLAIMABLE
> > > > inode is found in the cache, but it was not done when
> > > > reclaim completes.
> > > >
> > > > Reviewed-by: Alex Elder <aelder@sgi.com>
> > >
> > > Alex, can you push this to Linus ASAP? This needs to go back to
> > > stable kernels as well..
> >
> > Here is my suggestion of a backport to .34.  Dave, Alex, do you
> > approve?
> >
> > 	Hannes
> >
> > diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> > index 6845db9..3314f2a 100644
> > --- a/fs/xfs/xfs_iget.c
> > +++ b/fs/xfs/xfs_iget.c
> > @@ -499,6 +499,7 @@ xfs_ireclaim(
> >  	write_lock(&pag->pag_ici_lock);
> >  	if (!radix_tree_delete(&pag->pag_ici_root, agino))
> >  		ASSERT(0);
> > +	pag->pag_ici_reclaimable--;
> >  	write_unlock(&pag->pag_ici_lock);
> >  	xfs_perag_put(pag);
> >
> >
> 
> Ping?
> 
> Masters of xfs, please raise your voices!
> 
> Pete

I know I'm a little late to the game in saying so, but I do
agree this looks like the right fix for the .34 stable branch.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
