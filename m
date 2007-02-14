Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Feb 2007 12:48:25 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1EKmFm7004255
	for <xfs@oss.sgi.com>; Wed, 14 Feb 2007 12:48:17 -0800
Date: Thu, 15 Feb 2007 07:48:03 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: a modest proposal for 4kstacks & xfs
Message-ID: <20070214204803.GR44411608@melbourne.sgi.com>
References: <45D1FDFC.20407@sandeen.net> <20070213201306.GA10237@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070213201306.GA10237@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Feb 13, 2007 at 12:13:06PM -0800, Chris Wedgwood wrote:
> On Tue, Feb 13, 2007 at 10:05:48AM -0800, Eric Sandeen wrote:
> 
> > XFS continues to come up against 4k stacks, despite the best efforts
> > of several people to slim down xfs a bit (and in fact it seems ok
> > over simple storage these days), people are always able to stack up
> > enough IO path to push the limits of a 4k stack.
> 
> i'll argue "if XFS is enabled 4K stacks should be disabled"

Only way to be sure, IMO....

> the only people this is really going to bother surely are people
> running stock RH kernels where XFS isn't supported anyhow
> 
> > modprobe xfs 4kstacks_may_break=1
> >
> > or somesuch; and without this modprobe would fail on a 4kstacks
> > kernel with a "helpful" message.
> 
> won't people just add the param and continue anyhow w/o thinking about
> the issue(s)?
> 
> > I hate to further the meme of "xfs won't work with 4kstacks" but the
> > truth is that there are IO path scenarios where it can lead to
> > problems.
> 
> i have a setup here with ENOSPC conditions will wedge up tight wen
> using 4k stacks (the allocator has a path where it calls back into
> itself i think)

Memory reclaim will call the writeback path if you are not within
filesystem code when a kernel allocation fails. So if you fail a
memory allocation and enter reclaim when you are already using half
the stack....

> > What do folks think; useful?  pointless?  too heavy-handed?
> 
> i prefer kconfig magic to simply disallow compilation of XFS w/ 4k
> stacks, it's not in the past you had to try hard to break xfs in these
> conditions --- is it really much harder now?
> 
> also, someone claimed gcc 4.1+ reused stack slots --- if that's the
> case it might make things a lot better than older compilers?
> checkstack.pl should show a difference though

gcc 4.0+ inline single use static functions by default, so it defeats
the code we moved out of the bad functions to reduce the stack usage.
IOWs, it undoes a lot of the previous things we've done to reduce stack
usage in the critical path. That's why we had to add the "noinline"
keywork to all our "STATIC" declarations....

Basically, the only real compiler thing you can do that changes stack
usæge is turn on "optimise for size" which reduces stack usage by
20-25%. It is significant, but you can probably still blow a 4k
stack if you add enough layers....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
