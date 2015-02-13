Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4CD477F6C
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2015 16:35:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B954304032
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2015 14:35:16 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	40YBWewMF172Se8a for <xfs@oss.sgi.com>;
	Fri, 13 Feb 2015 14:35:10 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YMOpH-0006rP-L5
	for xfs@oss.sgi.com; Sat, 14 Feb 2015 09:35:07 +1100
Date: Sat, 14 Feb 2015 09:35:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] xfs shrink feature
Message-ID: <20150213223507.GV4251@dastard>
References: <20150213131446.GC1800@hades.maiolino.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150213131446.GC1800@hades.maiolino.org>
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
To: xfs@oss.sgi.com

On Fri, Feb 13, 2015 at 11:14:46AM -0200, Carlos Maiolino wrote:
> Hi folks,
> 
> I've been seeing a lot of users requesting a shrink feature for XFS, and I
> believe it's time to have it implemented in XFS.

I'm not so sure about that.

> Is there anybody working on a shrink feature? If not, I'm going to
> start to work on it, if nobody have any objections.


I currently in design discussions with various other developers
about a line of development that will make growing and shrinking XFS
redundant operations. i.e. if we get this right, we'll never need to
deal with capacity changes of XFS filesystems at the XFS level
again. both grow and shrink will be instanteneous, and not require
any modification to the layout of the filesystem at all.

Mind you, that's not the reason for that line of development - it's
all about integrated snapshots in XFS. We essentially get
grow/shrink for free with that infrastructure....

I'm not quite ready to publish the docco yet - need to get all my
ducks in a line first - but if it does work out as a feasible line
of development, then the old "shrink" method is essentially a dead
end.

However, don't let that stop you working towards shrink, because
there is infrastructure that it requires that we need for other
things as well. Take you pick:

	- parent pointers
	- AG state control
	- ranged bulkstat call (e.g. AG range)
	- allocation location control from userspace
	  (which may tie in to AG state control)
	- Atomic inode location swaps

Parent pointers are needed to locate the owners of the inodes
in AGs that need to be moved efficiently. i.e. bulkstat the inodes,
use parent lookup to return parent or entire path to inode. It's
also needed for more efficient and robust metadata checking and
online repair of broken directory structures.

AG state control is needed to tell the filesystem not to allocate
in specific AGs, and then to take them completely off line prior
to a shrink operation starting. It is also needed for online repair
of AGs and other applications that need to manipulate the contents
of an AG without interference from the rest of the filesystem.

Efficient shrink also relies on reverse block mapping being
available. I'm working on that right now for multiple reasons, none
of which are for shrinking the filesystem. ;)

I'd recommend that you work on the infrastructure problems one at a
time, rather than "shrink" because the infrastructure has multiple
uses and we need that infrastructure for various reasons much more
urgently than we do shrink. However, once the infrastructure is in
place, shrink should just be a case of tying it all together with a
userspace utility. That is, of course, if we still need it.

If you want something simple to start with then the ranged bulkstat
calls and AG state control are the place to start.

However, I'd recommend you start with finishing off the parent
pointer infrastructure because that's more important in the longer
term. We had converged to the point where we had a design that
solved all known problems, but it wasn't ever implemented.  That's
where we need to pick it up from. Design for EAs in here:

http://oss.sgi.com/archives/xfs/2014-01/msg00263.html

But it's worth reading the entire discussion starting here because
it start with a summary of the different approaches taken and why
they were rejected:

http://oss.sgi.com/archives/xfs/2014-01/msg00224.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
