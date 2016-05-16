Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D87FE7CAE
	for <xfs@oss.sgi.com>; Mon, 16 May 2016 18:11:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B8A2AC004
	for <xfs@oss.sgi.com>; Mon, 16 May 2016 16:11:03 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6RyvT8SsEZodl8yB for <xfs@oss.sgi.com>;
	Mon, 16 May 2016 16:10:59 -0700 (PDT)
Date: Tue, 17 May 2016 09:10:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160516231056.GE18496@dastard>
References: <94cea603-2782-1c5a-e2df-42db4459a8ce@cn.fujitsu.com>
	<20160512055756.GE6648@birch.djwong.org>
	<20160512080321.GA18496@dastard>
	<20160513160341.GW20141@dhcp22.suse.cz>
	<20160516104130.GK3193@twins.programming.kicks-ass.net>
	<20160516130519.GJ23146@dhcp22.suse.cz>
	<20160516132541.GP3193@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160516132541.GP3193@twins.programming.kicks-ass.net>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org, Qu Wenruo <quwenruo@cn.fujitsu.com>, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>, Michal Hocko <mhocko@kernel.org>

On Mon, May 16, 2016 at 03:25:41PM +0200, Peter Zijlstra wrote:
> On Mon, May 16, 2016 at 03:05:19PM +0200, Michal Hocko wrote:
> > On Mon 16-05-16 12:41:30, Peter Zijlstra wrote:
> > > On Fri, May 13, 2016 at 06:03:41PM +0200, Michal Hocko wrote:
> > IIRC Dave's emails they have tried that by using lockdep classes and
> > that turned out to be an overly complex maze which still doesn't work
> > 100% reliably.
> 
> So that would be the: 
> 
> > >  but we can't tell lockdep that easily in any way
> > > without going back to the bad old ways of creating a new lockdep
> > > class for inode ilocks the moment they enter ->evict. This then
> > > disables "entire lifecycle" lockdep checking on the xfs inode ilock,
> > > which is why we got rid of it in the first place."
> > > 
> > > But fails to explain the problems with the 'old' approach.
> > > 
> > > So clearly this is a 'problem' that has existed for quite a while, so I
> > > don't see any need to rush half baked solutions either.
> > 
> > Well, at least my motivation for _some_ solution here is that xfs has
> > worked around this deficiency by forcing GFP_NOFS also for contexts which
> > are perfectly OK to do __GFP_FS allocation. And that in turn leads to
> > other issues which I would really like to sort out. So the idea was to
> > give xfs another way to express that workaround that would be a noop
> > without lockdep configured.
> 
> Right, that's unfortunate. But I would really like to understand the
> problem with the classes vs lifecycle thing.
> 
> Is there an email explaining that somewhere?

Years ago (i.e. last time I bothered mentioning that lockdep didn't
cover these cases) but buggered if I can find a reference.

We used to have iolock classes. Added in commit 033da48 ("xfs: reset
the i_iolock lock class in the reclaim path") in 2010, removed by
commit 4f59af7 ("xfs: remove iolock lock classes") a couple of years
later.

We needed distinct lock classes above and below reclaim because the
same locks were taken above and below memory allocation, and the
reclaimed inode recycling made lockdep think it had a loop in it's
graph:


inode lookup	memory reclaim		inode lookup
------------	--------------		------------
not found
allocate inode
init inode
take active reference
return to caller
.....
		  inode shrinker
		  find inode with no active reference
		   ->evict
		     start transaction
		       take inode locks
		     .....
		     commit transaction
		     mark for reclaim
		     .....

					find inactive inode in reclaimable state
					remove from reclaim list
					re-initialise inode state
					take active reference
					return to caller

So you can see that an inode can go through the reclaim context
without being freed but having taken locks, but then immediately
reused in a non-reclaim context. Hence we had to split the two
lockdep contexts and re-initialise the lock contexts in the
different allocation paths.

The reason we don't have lock clases for the ilock is that we aren't
supposed to call memory reclaim with that lock held in exclusive
mode. This is because reclaim can run transactions, and that may
need to flush dirty inodes to make progress. Flushing dirty inode
requires taking the ilock in shared mode.

In the code path that was reported, we hold the ilock in /shared/
mode with no transaction context (we are doing a read-only
operation). This means we can run transactions in memory reclaim
because a) we can't deadlock on the inode we hold locks on, and b)
transaction reservations will be able to make progress as we don't
hold any locks it can block on.

Sure, we can have multiple lock classes so that this can be done,
but that then breaks lock order checking between the two contexts.
Both contexts require locking order and transactional behaviour to
be identical and, from this perspective, class separation is
effectively no different from turning lockdep off.

For the ilock, the number of places where the ilock is held over
GFP_KERNEL allocations is pretty small. Hence we've simply added
GFP_NOFS to those allocations to - effectively - annotate those
allocations as "lockdep causes problems here". There are probably
30-35 allocations in XFS that explicitly use KM_NOFS - some of these
are masking lockdep false positive reports.

The reason why we had lock classes for the *iolock* (not the ilock)
was because ->evict processing used to require the iolock for
attribute removal. This caused all sorts of problems with
GFP_KERNEL allocations in the IO path (e.g. allocate a page cache
page under the IO lock, direct reclaim would trigger lockdep
warnings - there's another reason why XFS always used GFP_NOFS
contexts for page cache allocations) which were all false positives
because the inode holding the lock has active references and hence
will never be accessed by the reclaim path. The only workable
solution iwe could come up with at the time this was reported was
to this was to split the lock classes.

In the end, like pretty much all the complex lockdep false positives
we've had to deal in XFS, we've ended up changing the locking or
allocation contexts because that's been far easier than trying to
make annotations cover everything or convince other people that
lockdep annotations are insufficient.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
