Return-Path: <dgc@snort.melbourne.sgi.com>
Date: Tue, 30 Jan 2007 18:06:36 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [xfs-masters] Re: question about potentially dead kernel config settings for XFS
Message-ID: <20070130070636.GG33919298@melbourne.sgi.com>
References: <Pine.LNX.4.64.0701261607240.30502@CPE00045a9c397f-CM001225dbafb6> <20070128203911.GC33919298@melbourne.sgi.com> <Pine.LNX.4.64.0701290618050.12945@CPE00045a9c397f-CM001225dbafb6> <20070129142819.GY33919298@melbourne.sgi.com> <Pine.LNX.4.64.0701290943430.20972@CPE00045a9c397f-CM001225dbafb6> <45BED165.1070501@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BED165.1070501@sandeen.net>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com, David Chinner <dgc@sgi.com>
List-ID: <xfs>

On Mon, Jan 29, 2007 at 11:02:29PM -0600, Eric Sandeen wrote:
> Robert P. J. Day wrote:
> >On Tue, 30 Jan 2007, David Chinner wrote:
> >
> >>On Mon, Jan 29, 2007 at 06:24:29AM -0500, Robert P. J. Day wrote:
> >
> >>>user-configurable kernel setting, it should not have a
> >>>configuration macro name starting with "CONFIG_" -- that should be
> >>>reserved for configurable settings defined in Kconfig files.
> >>Yup, and that's exactly what we use them for.
> >>
> >>However, we don't anyone to use them in mainline because they are
> >>for debugging or features that aren't in mainline, but they are not
> >>easily of ussefully separable from the core XFS code. Hence we use
> >>CONFIG_XFS_???  options that you can't turn on in mainline to
> >>enforce this - making them CONFIG_XFS_??? options means we don't
> >>have to maintain different code in the dev tree and mainline and IMO
> >>that is a Good Thing.
> 
> One thing that may not be crystal clear from the thread (?) is that if 
> you download xfs cvs, you will in fact find these in the Kconfig files:
> 
> config XFS_DEBUG
>         bool "XFS Debugging support (EXPERIMENTAL)"
>         depends on XFS_FS && EXPERIMENTAL
> ...etc
> 
> but they aren't pushed out to kernel.org...

I thought i'd said that up front. Thanks for clarifying, Eric.

> David, is CONFIG_XFS_DEBUG really so bad to expose? 

Probably not - I just don't like exposing something that almost
everyone who runs XFS should not turn on....

> CONFIG_XFS_TRACE 
> -is- pretty useless w/o KDB, though, IIRC...

Agreed (until we put a relayfs type interface on it for live
tracing), but then again CONFIG_XFS_DEBUG is also pretty useless you
have a debugger.....

> I suppose it would be a real headache to remove the unused CONFIG_FOO 
> stuff from kernel.org and leave them in cvs...

Yes, that's kind of my point.

> In the end it's not the most pressing problem,

Waaaaay down my list.

> although it adds to the 
> perception of swaths of dead code in xfs.

Must be what is using all the stack space, eh? ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
