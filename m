Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7Q88liB054718 for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 03:08:48 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C324D11AB18
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 01:08:45 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id nZKbRFvvrIy7TAmJ for
	<xfs@oss.sgi.com>; Fri, 26 Aug 2011 01:08:45 -0700 (PDT)
Date: Fri, 26 Aug 2011 10:08:41 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110826080841.GA24948@schmorp.de>
References: <20110806122556.GB20341@schmorp.de> <201108091210.50204@zmi.at>
	<20110809111526.GA7631@schmorp.de> <201108100859.27576@zmi.at>
	<20110811220418.GB12808@schmorp.de>
	<20110812040530.GB26978@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110812040530.GB26978@dastard>
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

On Fri, Aug 12, 2011 at 02:05:30PM +1000, Dave Chinner <david@fromorbit.com> wrote:
> It only does that if the pattern of writes are such that keeping the
> preallocation around for longer periods of time will reduce
> potential fragmentation.

That can only be false. Here is a an example that I saw *just now*:

I have a process that takes a directory with jpg files (in this case,
all around 64kb in size) and loslessly recompresses them. This works
by reading a file, writing it under another name (single write() call)
and using rename to replace the original file *iff* it got smaller. The
typical reduction is 5%. no allocsize option is used. Kernel used was
2.6.39.

This workload would obviously benefit most by having no preallocaiton
anywhere, i.e. have all files tightly packed.

Here is a "du" on a big directory where this process is running, every few
minutes:

   6439892 .
   6439888 .
   6620168 .
   6633156 .
   6697588 .
   6729092 .
   6755808 .
   6852192 .
   6816632 .
   6250824 .

Instead of decreasing, the size increased, until just before the last
du. Thats where I did echo 3 >drop_caches, which presumably cleared all
those inodes that have not been used for an hour and would never have been
used again for writing.

Since XFS obviously keeps quite a bit of preallocation here (or some other
magic, but what?), and this workload definitely does not benefit from any
preallocaiton (because xfs has perfect knowledge about the file size at
every point in time), what you say is simply not true: The files will not
be touched anymore, neither read, nor written, so preallocation is just
bad.

Also, bickering about extra fragmentation caused by xfs_fsr when running
it daily instead of weekly is weird - the amount of external fragmentation
caused by preallocation must be overwhelming with large amounts of ram.

> Indeed, it's not a NFS specific optimisation, but it is one that
> directly benefits NFS server IO patterns.

I'd say it's a grotesque deoptimisation, and definitely doesn't work the
way you describe it.

In fact, it can't work the way you describe it, because XFS would have
to be clairvoyant to make it work. How else would it know that keeping
preallocation indefinitely will be useful?

In any case, XFS detects a typical "open write, file file, close
file, never tochu it again" pattern as something that somehow needs
preallocation.

I can see how that helps NFS, but in all other cases, this is simply a
bug.

> about). Given that inodes for log files will almost always remain in
> memory as they are regularly referenced, it seems like the right
> solution to that problem, too...

Given that, with enough ram, everything stays in ram, most of which is
not log files, this behaviour is simply broken.

> FWIW, you make it sound like "benchmark-improved" is a bad thing.

If it costs regular performance or eats diskspace like mad, it's clearly a
bad thing yes.

Benchmark performance is irrelevant, what counts is actual performance.

If the two coincide, thats great. This is clearly not the case here, of
course.

> However, I don't hear you complaining about the delayed logging
> optimisations at all.

I wouldn't be surprised if the new xfs_fsr crashes are caused by these
changes, actually. But yes, otherwise they are great - I do keep external
journals for most of my filesystems, and the write load for these has
decreased by a factor of 10-100 in some metadata-heavy cases (such as lots
of renames).

Of course, XFS is still way behind other filesystems in managing journal
devices.

> I'll let you in on a dirty little secret: I tested delayed logging on
> nothing but benchmarks - it is -entirely- a "benchmark-improved" class
> optimisation.

As a good engineer one would expect you to actually think about whether
this optimiation is useful outside of some benchmark setup, too. I am sure
you did that, how else would you have come up with the idea in the first
place?

> But despite how delayed logging was developed and optimised, it

The difference to the new preallocation is that it's not obviously a bad
algorithm.

However, the preallocation strategy of wasting some diskspace for every
file that has been opened in the last 24 hours or so (depending on ram) is
*obviously* wrong, regardless of what your microbenchmarks say.

What it does is basically introduce big clusters allocation, just like
with god old FAT, except that people with more RAM get punished more.

> different workloads. That's because the  benchmarks I use accurately
> model the workloads that cause the problem that needs to be solved.

That means you will optimise a single problem at the expense of any other
workload. This indeed seems to be the case here.

Good engineering would make sure that typical use cases that were not the
"problem" before wouldn't get unduly affected.

Apart from potentially helping with NFS in your benchmarks, I cannot
see any positive aspect of this change. However, I keep hitting the bad
aspects of it. It seems that with this change, XFS will degrade much
faster due to the insane amounts of useless preallocation tied to files
that have been closed and will never be written again, which is by far
*most* files.

In the example above, roughly 32kb (+-50%) overallocation are associated
with each file. FAT, here we come :(

Don't get me wrong, it is great that XFS is now optimised for slow log
writing over NFS, and this surely is important for some people, but this
comes at an enourmous cost to every other workload.

A benchmark that measures additional fragmentation introduced by all those
32kb blocks over some months would be nice.

> Similarly, the "NFS optimisation" in a significant and measurable
> reduction in fragmentation on NFS-exported XFS filesystems across a

It's the dirtiest hack I have seen in a filesystem. Making an optimisaiton
that only helps with the extremely bad access patterns of NFS (and only
sometimes) and forcing this on even for non-NFS filesystems where it only
causes negative effects.

It's a typical case of "a is broken, so apply some hack to b", while good
engineering dictates "a is broken, let's fix a".

Again: Your rationale is that NFS doesn't give you enough information about
whether a file is in use, because it doesn't keep it open.

This leads you to consider all files whose inode is cached in memory as
being "in use" for unlimited amounts of time.

Sure, those idiot applications such as cp or mv cannot be trusted. Surely,
when mv'ing a file, this means the file will be appended later. Because if
not, XFS wouldn't keep the preallocation.

> Yes, there have been regressions caused by both changes (though

The whole thing is a regression - slow appender processes that close a
file after each write basically don't exist - close is an extremely good
hint that a file has been finalised, and because NFS doesn't give the
notion of close (nfsv4 has it, to some extent), suddenly it's ignored for
all applications.

This is simply a completely, utterly, totally broken algorithm.

> regressions does not take anything away from the significant
> real-world improvements that are the result of the changes.

I gave plenty of real-world examples where these changes are nothing but
bad. I have yet to see a *single* real-world example where this isn't the
case.

All you achieved is that now every workload works as bad as NFS, lots
and lots of disk space is wasted, and an enourmous amount of external
fragmentation is introduced. And thats just with an 8GB box. I can only
imagine how many months files will be considered "in use" just because the
box has enough ram to cache their inodes.

> http://code.google.com/p/ioapps/wiki/ioreplay

Since "cp" and "mv" already cause problems in current versions of
XFS, I guess we are far from needing those. It seems XFS has been so
fundamentally deoptimised w.r.t. preallocation now that there are much
bigger fish to catch than freenet. Basically anything thct creates files,
even when it's just a single open/write/close, is now affected.

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
