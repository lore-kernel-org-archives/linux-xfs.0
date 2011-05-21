Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4L3Fqob126983 for <xfs@oss.sgi.com>; Fri, 20 May 2011 22:15:52 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F5ED4449A0
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 20:15:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	l73OET3j5WKjkTSv for <xfs@oss.sgi.com>;
	Fri, 20 May 2011 20:15:50 -0700 (PDT)
Date: Sat, 21 May 2011 13:15:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110521031537.GV32466@dastard>
References: <20110520005510.GA15348@schmorp.de>
	<20110520025659.GO32466@dastard> <20110520154920.GD5828@schmorp.de>
	<20110521004544.GT32466@dastard>
	<20110521013604.GC10971@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110521013604.GC10971@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On Sat, May 21, 2011 at 03:36:04AM +0200, Marc Lehmann wrote:
> On Sat, May 21, 2011 at 10:45:44AM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > > Longer meaning practically infinitely :)
> > 
> > No, longer meaning the in-memory lifecycle of the inode.
> 
> That makes no sense - if I have twice the memory I suddenly have half (or
> some other factor) free diskspace.
> 
> The lifetime of the preallocated area should be tied to something sensible,
> really - all that xfs has now is a broken heuristic that ties the wrong
> statistic to the extra space allocated.

So, instead of tying it to the lifecycle of the file descriptor, it
gets tied to the lifecycle of the inode. There isn't much in between
those that can be easily used.  When your workload spans hundreds of
thousands of inodes and they are cached in memory, switching to the
inode life-cycle heuristic works better than anything else that has
been tried.  One of those cases is large NFS servers, and the
changes made in 2.6.38 are intended to improve performance on NFS
servers by switching it to use inode life-cycle to control
speculative preallocation.

As it is, regardless of this change, we already have pre-existing
circumstances where specualtive preallocation is controlled by the
inode life-cycle - inodes with manual preallocation (e.g fallocate)
and append only files - so this problem with allocsize causing
premature ENOSPC raises it's head every couple of years regardless
of whether there's been any recent changes or not.

FWIW, I remember reading bug reports for Irix from 1998 about such
problems w.r.t. manual preallocation. In all cases that I can
remember, the problems went away with small configuration tweaks....

> > > However, I would suggest that whatever heuristic 2.6.38 uses
> > > is deeply broken at the momment,
> > 
> > One bug report two months after general availability != deeply
> > broken.
> 
> That makes no sense - I only found out about this broken behaviour
> because I specified a large allocsize manually, which is rare.
> 
> However, the behaviour happens even without that.  but might not be
> immediately noticable (how would you find out if you lost a few
> gigabytes of disk space unless the disk runs full? most people
> would have no clue where to look for).

If most people never notice it and it reduces fragmentation
and improves performance, then I don't see a problem. Right now
evidence points to the "most people have not noticed it".

Just to point out what people do notice: when the dynamic
functionality was introduced into 2.6.38-rc1, it had a bug in a
calculation that was resulting in 32bit machines always preallocing
8GB extents. That was noticed _immediately_ and reported by several
people independently. Once that bug was fixed there have been no
further reports until yours. That tells me that the new default
behaviour is not actually causing ENOSPC problems for most people.

I've already said I'll look into the allocsize interaction with the
new heuristic you've reported, and told you how to work around the
problem in the mean time. I can't do any more than that.

> Just because the breakage is not obviously visible doesn't mean it's not
> deeply broken.
> 
> Also, I just looked more thoroughly through the list - the problem has
> been reported before, but was basically ignored, so you are wrong in that
> there is only one report.

I stand corrected. I get at least 1000-1500 emails a day and I
occasionally forget/miss/delete one I shouldn't. Or maybe it was one
I put down to the above bug.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
