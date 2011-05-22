Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4M20Ulm180213 for <xfs@oss.sgi.com>; Sat, 21 May 2011 21:00:30 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF215471724
	for <xfs@oss.sgi.com>; Sat, 21 May 2011 19:00:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8II4ai9bT5JGu4VF for <xfs@oss.sgi.com>;
	Sat, 21 May 2011 19:00:27 -0700 (PDT)
Date: Sun, 22 May 2011 12:00:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110522020024.GZ32466@dastard>
References: <20110520005510.GA15348@schmorp.de>
	<20110520025659.GO32466@dastard> <20110520154920.GD5828@schmorp.de>
	<20110521004544.GT32466@dastard>
	<20110521013604.GC10971@schmorp.de>
	<20110521031537.GV32466@dastard>
	<20110521041652.GA18375@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110521041652.GA18375@schmorp.de>
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

On Sat, May 21, 2011 at 06:16:52AM +0200, Marc Lehmann wrote:
> On Sat, May 21, 2011 at 01:15:37PM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > > The lifetime of the preallocated area should be tied to something sensible,
> > > really - all that xfs has now is a broken heuristic that ties the wrong
> > > statistic to the extra space allocated.
> > 
> > So, instead of tying it to the lifecycle of the file descriptor, it
> > gets tied to the lifecycle of the inode.
> 
> That's quite the difference, though - the former is in some relation to
> the actual in-use files, while the latter is in no relation to it.
> 
> > those that can be easily used.  When your workload spans hundreds of
> > thousands of inodes and they are cached in memory, switching to the
> > inode life-cycle heuristic works better than anything else that has
> > been tried.
> 
> The problem is that this is not anything like the normal case.

For you, maybe.

> It simply doesn't make any sense to preallocate disk space for files that
> are not in use and are unlikely to be in use again.

That's why the normal close case truncates it away. But there are
other cases where we don't want this to happen.

> > One of those cases is large NFS servers, and the changes made in 2.6.38
> > are intended to improve performance on NFS servers by switching it to
> > use inode life-cycle to control speculative preallocation.
> 
> It's easy to get some gains in special situations at the expense of normal
> ones - keep in mind that this optimisation makes little sense for non-NFS
> cases, which is the majority of use cases.

XFS is used extensively in NAS products, from small $100 ARM/MIPS
embedded NAS systems all the way up to high end commercial NAS
products. It is one of the main use cases we optimise XFS for.

> The problem here is that XFS doesn't get enough feedback in the case of
> an NFS server which might open and close files much more often than local
> processes.
> 
> However, the solution to this is a better nfs server, not some dirty hacks
> in some filesystem code in the hope that it works in the special case of
> an NFS server, to the detriment of all other workloads which give better
> feedback.

Sure, that would be my preferred approach. However, if you followed
the discussion when this first came up, you'd realise that we've
been trying to get NFS server changes to fix this operation for the
past 5 years, and I've just about  given up trying.  Hell, the NFS
OFC (open file cache) proposal that would have mostly solved this
(and other problems like readahead state thrashing) from 2-3 years
ago went nowhere...

> This heuristic is just that: a bad hack to improve benchmarks in a special
> case.

It wasn't aimed at improving benchmark performance - these changes
have been measured to reduce large file fragmentation in real-world
workloads on the default configuration by at least an order of
magnitude.

> The preallocation makes sense in relation to the working set, which can be
> characterised by the open files, or recently opened files.
> Tieing it to the (in-memory) inode lifetime is an abysmal approximation to
> this.

So you keep saying, but you keep ignoring the fact that the inode
cache represents the _entire_ working set of inodes. It's not an
approximation - it is the _exact_ current working set of files we
currently have.

Hence falling back to "preallocation lasts for as long as the inode
is part of the working set" is an extremely good heuristic to use -
we move from preallocation for only the L1 cache lifecycle (open
fd's) to using the L2 cache lifecycle (recently opened inodes)
instead.

> If I unpack a large tar file, this means that I get a lot of (internal)
> fragmentation because all files are spread over a large area than
> necesssary, and diskspace is used for a potentially indefinite time.

So you can reproduce this using an tar? Any details on size, # of
files, the untar command, etc? How do you know you get internal
fragmentation and tha tit is affecting fragmentation? Please provide
concrete examples (e.g. copy+paste the command lines and any
relevant output) that so I might be able to reproduce your problem
myself?

I don't really care what you think the problem is based on what
you've read in this email thread, or for that matter how you think
we should fix it. What I really want is your test cases that
reproduce the problem so I can analyse it for myself. Once I
understand what is going on, then we can talk about what the real
problem is and how to fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
