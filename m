Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4L1aCNT123686 for <xfs@oss.sgi.com>; Fri, 20 May 2011 20:36:12 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27E1D161C67F
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 18:36:10 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id uApKcZS8sqrVhlym for
	<xfs@oss.sgi.com>; Fri, 20 May 2011 18:36:10 -0700 (PDT)
Date: Sat, 21 May 2011 03:36:04 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110521013604.GC10971@schmorp.de>
References: <20110520005510.GA15348@schmorp.de>
	<20110520025659.GO32466@dastard> <20110520154920.GD5828@schmorp.de>
	<20110521004544.GT32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110521004544.GT32466@dastard>
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

On Sat, May 21, 2011 at 10:45:44AM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > Longer meaning practically infinitely :)
> 
> No, longer meaning the in-memory lifecycle of the inode.

That makes no sense - if I have twice the memory I suddenly have half (or
some other factor) free diskspace.

The lifetime of the preallocated area should be tied to something sensible,
really - all that xfs has now is a broken heuristic that ties the wrong
statistic to the extra space allocated.

Or in other words, tieing the amount of preallocations to the amount of
free ram (for the inode) is not a sensible heuristic.

> log file writing - append only workloads - is one where the dynamic
> speculative preallocation can make a significant difference.

Thats absolutely fantastic, as that will apply to a large range of files
that are problematic (while xfs performs really well in most cases).

> > However, I would suggest that whatever heuristic 2.6.38 uses is deeply
> > broken at the momment,
> 
> One bug report two months after general availability != deeply
> broken.

That makes no sense - I only found out about this broken behaviour because I
specified a large allocsize manually, which is rare.

However, the behaviour happens even without that. but might not be
immediately noticable (how would you find out if you lost a few gigabytes
of disk space unless the disk runs full? most people would have no clue
where to look for).

Just because the breakage is not obviously visible doesn't mean it's not
deeply broken.

Also, I just looked more thoroughly through the list - the problem has
been reported before, but was basically ignored, so you are wrong in that
there is only one report.

> While using a large allocsize mount option, which is relatively
> rare. Basically, you've told XFS to optimise allocation for large
> files and then are running workloads with lots of small files.

The allocsize isn't "optimise for large files", it's to reduce
fragmentation. 64MB is _hardly_ a big size for logfiles.

Note also that the breakage occurs with smaller allocsize values as well.,
it's just less obvious All you do right now is make up fantasy reasons on
why to ignore this report - the problem applies to any allocsize, and,
unless xfs uses a different heuristic for dynamic preallocation, even
without the mount option.

> It's not surprise that there are issues, and you don't need the changes
> in 2.6.38 to get bitten by this problem....

Really? I do know (by measuring it) that older kernels do not have this
problem, and you basically said the same thing, namely that there was a
behaviour change.

If your goal is to argue for yourself that the breakage has to stay, thats
fine, but don't expect users (like me) to follow your illogical train of
thought.

> > and there is really no need to cache this preallocation for
> > files that have been closed 8 hours ago and never touched since then.
> 
> If the preallocation was the size of the dynamic behaviour, you
> wouldn't have even noticed this.

Maybe, it certainly is a lot less noticable. But the new xfs behaviour
basically means you have less space (potentially a lot less) on your disk
when you have more memory, and that disk space is lost indefinitely just
because I have some free ram.

This is simply not a sensible heuristic - more ram must not mean that
potentialy large amounts of diskspace are lost forever (if you have enough
ram).

> So really what you are saying is that it is excessive for your current
> configuration and workload.

No, what I am saying is that the heuristic is simply buggy - it ties one
value (available ram for cache) to a completely unrelated one (amount of free
space used for preallocation).

It also doesn't only happen in my workload only.

> better for allocsize filesystems. However, I'm not going to start to
> add lots of workload-dependent tweaks to this code - the default
> behaviour is much better and in most cases removes the problems that
> led to using allocsize in the first place. So removing allocsize
> from your config is, IMO, the correct fix, not tweaking heuristics in
> the code...

I am fine with not using allocsize if the fragmentation problems in xfs (for
append-only cases) has been improved.

But you aid the heuristic applies regardless of whether allocsize was
specified or not.

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
