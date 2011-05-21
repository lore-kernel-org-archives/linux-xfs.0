Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4L4GxMl129162 for <xfs@oss.sgi.com>; Fri, 20 May 2011 23:17:00 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4ADFB14D6E0C
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 21:16:56 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id 5kcJDZX2xr4SpTXY for
	<xfs@oss.sgi.com>; Fri, 20 May 2011 21:16:56 -0700 (PDT)
Date: Sat, 21 May 2011 06:16:52 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110521041652.GA18375@schmorp.de>
References: <20110520005510.GA15348@schmorp.de>
	<20110520025659.GO32466@dastard> <20110520154920.GD5828@schmorp.de>
	<20110521004544.GT32466@dastard>
	<20110521013604.GC10971@schmorp.de>
	<20110521031537.GV32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110521031537.GV32466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, May 21, 2011 at 01:15:37PM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > The lifetime of the preallocated area should be tied to something sensible,
> > really - all that xfs has now is a broken heuristic that ties the wrong
> > statistic to the extra space allocated.
> 
> So, instead of tying it to the lifecycle of the file descriptor, it
> gets tied to the lifecycle of the inode.

That's quite the difference, though - the former is in some relation to
the actual in-use files, while the latter is in no relation to it.

> those that can be easily used.  When your workload spans hundreds of
> thousands of inodes and they are cached in memory, switching to the
> inode life-cycle heuristic works better than anything else that has
> been tried.

The problem is that this is not anything like the normal case.

It simply doesn't make any sense to preallocate disk space for files that
are not in use and are unlikely to be in use again.

> One of those cases is large NFS servers, and the changes made in 2.6.38
> are intended to improve performance on NFS servers by switching it to
> use inode life-cycle to control speculative preallocation.

It's easy to get some gains in special situations at the expense of normal
ones - keep in mind that this optimisation makes little sense for non-NFS
cases, which is the majority of use cases.

The problem here is that XFS doesn't get enough feedback in the case of
an NFS server which might open and close files much more often than local
processes.

However, the solution to this is a better nfs server, not some dirty hacks
in some filesystem code in the hope that it works in the special case of
an NFS server, to the detriment of all other workloads which give better
feedback.

This heuristic is just that: a bad hack to improve benchmarks in a special
case.

The preallocation makes sense in relation to the working set, which can be
characterised by the open files, or recently opened files.

Tieing it to the (in-memory) inode lifetime is an abysmal approximation to
this.

I understand that XFS does this to please a very suboptimal case - the NFS
server code which doesn't give you enough feedback on which files are open.

But keep in mind that in my case, XFS cached a large number of inodes that
have been closed many hours ago - and haven't been accessed for many hours
as well.

I have 8GB of ram, which is plenty, but not really an abnormal amount of
memory.

If I unpack a large tar file, this means that I get a lot of (internal)
fragmentation because all files are spread over a large area than
necesssary, and diskspace is used for a potentially indefinite time.

> > However, the behaviour happens even without that.  but might not be
> > immediately noticable (how would you find out if you lost a few
> > gigabytes of disk space unless the disk runs full? most people
> > would have no clue where to look for).
> 
> If most people never notice it and it reduces fragmentation
> and improves performance, then I don't see a problem. Right now

Preallocation sure also increases fragmentation when its never going to be
used.

> evidence points to the "most people have not noticed it".

The problem with these statements is that they have no meaning. Most
people don't even notice filesystem fragmentation - or corruption, or bugs
in xfs_repair.

If I apply your style of arguing that means it's not big deal - msot people
don't even notice when a few files get corrupted, they will just reinstall
their box. And ehy, who uses xfs_repasir and notices some bugs in it.

Sorry, but this kind of arguing makes no sense to me.

> 8GB extents. That was noticed _immediately_ and reported by several
> people independently. Once that bug was fixed there have been no
> further reports until yours. That tells me that the new default
> behaviour is not actually causing ENOSPC problems for most people.

You of curse know well enough that ENOSPC was just one symptom, and that
the real problem is allocating free disk space semi-permanently. Why do
you bring up this strawmen of ENOSPC?

> I've already said I'll look into the allocsize interaction with the
> new heuristic you've reported, and told you how to work around the
> problem in the mean time. I can't do any more than that.

The problem is that you are selectively ignoring facts to downplay this
problem. That doesn't instill confidence, you really sound like "don't
insult my toy allocation heuristic, I'll just ignore the facts and claim
there is no problem lalala".

You simply ignore most of what I wrote - the problem is also clearly not
allocsize interaction, but the broken logic behind the heuristic - "NFS
servers have bad access patterns, so we assume every workload is like an
NFS server". It's simply wrong.

The heuristic clearly doesn't make sense with any normal workload, where
files that were closed long ago will not be used. Heck, in most workloads,
files that are closed will almost never be written to soon afterwards,
simply because it is a common sense optimisations to not do unnecessary
operations.

If XFS contains dirty hacks that are meant for specific workloads only (to
workaround bad access patterns by NFS servers), then it would make sense
to disable these to not hurt the common cases.

And this heuristic clearly is just a hack to suit a specific need. I know
that, and I am sure you know that too, otherwise you wouldn't be hammering
home the NFS server case :)

Hacking some NFS server access pattern heuristic into XFS is, however,
just a workaround for that case, not a fix, or a sensible thing to do in
the general case.

I would certainly appreciate that XFS has such hacks and heuristics, and
would certainly try them out (having lots of NFS servers :), but it's
clear that enforcing workarounds for uncommon cases at the expense of
normal workloads is a bad idea, in general.

So please give this a bit considerations: is it really worth to keep
preallocstion for files that are not used by anything on a computer just
to improve benchmark numbers for a client with bad access patterns (the
NFS server code)?

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
