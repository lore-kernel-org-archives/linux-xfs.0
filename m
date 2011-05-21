Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4L0jmJL119916 for <xfs@oss.sgi.com>; Fri, 20 May 2011 19:45:48 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B06C21618A9A
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 17:45:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iXKUoN2rXG9L9ww4 for <xfs@oss.sgi.com>;
	Fri, 20 May 2011 17:45:46 -0700 (PDT)
Date: Sat, 21 May 2011 10:45:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110521004544.GT32466@dastard>
References: <20110520005510.GA15348@schmorp.de>
	<20110520025659.GO32466@dastard> <20110520154920.GD5828@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110520154920.GD5828@schmorp.de>
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

On Fri, May 20, 2011 at 05:49:20PM +0200, Marc Lehmann wrote:
> On Fri, May 20, 2011 at 12:56:59PM +1000, Dave Chinner <david@fromorbit.com> wrote:
> [thanks for the thorough explanation]
> > 
> > So the question there: how is your workload accessing the files? Is
> > it opening and closing them multiple times in quick succession after
> > writing them?
> 
> I don't think so, but of course, when compiling a file, it will be linked
> afterwards, so I guess it would be accessed at least once.

Ok, I'll see if I can reporduce it localy.

> > I think it is triggering the "NFS server access pattern" logic and so
> > keeping speculative preallocation around for longer.
> 
> Longer meaning practically infinitely :)

No, longer meaning the in-memory lifecycle of the inode.

> > I'd suggest removing the allocsize mount option - you shouldn't need
> > it anymore because the new default behaviour resists fragmentation a
> > whole lot better than pre-2.6.38 kernels.
> 
> I did remove it already, and will actively try this on our production
> server which suffer from severe fragmentation (but xfs_fsr fixes that with
> some work (suspending the logfile writing) anyway).

log file writing - append only workloads - is one where the dynamic
speculative preallocation can make a significant difference.

> However, I would suggest that whatever heuristic 2.6.38 uses is deeply
> broken at the momment,

One bug report two months after general availability != deeply
broken.

> as NFS was not involved here at all (so no need for
> it), the usage pattern was a simple compile-then-link-pattern (which is
> very common),

While using a large allocsize mount option, which is relatively
rare. Basically, you've told XFS to optimise allocation for large
files and then are running workloads with lots of small files. It's
not surprise that there are issues, and you don't need the changes
in 2.6.38 to get bitten by this problem....

> and there is really no need to cache this preallocation for
> files that have been closed 8 hours ago and never touched since then.

If the preallocation was the size of the dynamic behaviour, you
wouldn't have even noticed this. So really what you are saying is
that it is excessive for your current configuration and workload.

If I can reproduce it, I'll have a think about how to tweak it
better for allocsize filesystems. However, I'm not going to start to
add lots of workload-dependent tweaks to this code - the default
behaviour is much better and in most cases removes the problems that
led to using allocsize in the first place. So removing allocsize
from your config is, IMO, the correct fix, not tweaking heuristics in
the code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
