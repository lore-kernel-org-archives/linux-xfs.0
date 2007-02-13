Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Feb 2007 12:13:15 -0800 (PST)
Received: from smtp112.sbc.mail.mud.yahoo.com (smtp112.sbc.mail.mud.yahoo.com [68.142.198.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1DKD8m7022206
	for <xfs@oss.sgi.com>; Tue, 13 Feb 2007 12:13:10 -0800
Date: Tue, 13 Feb 2007 12:13:06 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: a modest proposal for 4kstacks & xfs
Message-ID: <20070213201306.GA10237@tuatara.stupidest.org>
References: <45D1FDFC.20407@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D1FDFC.20407@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Feb 13, 2007 at 10:05:48AM -0800, Eric Sandeen wrote:

> XFS continues to come up against 4k stacks, despite the best efforts
> of several people to slim down xfs a bit (and in fact it seems ok
> over simple storage these days), people are always able to stack up
> enough IO path to push the limits of a 4k stack.

i'll argue "if XFS is enabled 4K stacks should be disabled"

the only people this is really going to bother surely are people
running stock RH kernels where XFS isn't supported anyhow

> modprobe xfs 4kstacks_may_break=1
>
> or somesuch; and without this modprobe would fail on a 4kstacks
> kernel with a "helpful" message.

won't people just add the param and continue anyhow w/o thinking about
the issue(s)?

> I hate to further the meme of "xfs won't work with 4kstacks" but the
> truth is that there are IO path scenarios where it can lead to
> problems.

i have a setup here with ENOSPC conditions will wedge up tight wen
using 4k stacks (the allocator has a path where it calls back into
itself i think)

> What do folks think; useful?  pointless?  too heavy-handed?

i prefer kconfig magic to simply disallow compilation of XFS w/ 4k
stacks, it's not in the past you had to try hard to break xfs in these
conditions --- is it really much harder now?

also, someone claimed gcc 4.1+ reused stack slots --- if that's the
case it might make things a lot better than older compilers?
checkstack.pl should show a difference though
