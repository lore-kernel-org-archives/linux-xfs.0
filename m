Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Nov 2006 23:32:42 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAT7WWaG008564
	for <xfs@oss.sgi.com>; Tue, 28 Nov 2006 23:32:34 -0800
Date: Wed, 29 Nov 2006 18:31:34 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] Make stuff static
Message-ID: <20061129073134.GD33919298@melbourne.sgi.com>
References: <20061016232250.GM11034@melbourne.sgi.com> <1161042943.5723.117.camel@xenon.msp.redhat.com> <20061017005038.GN11034@melbourne.sgi.com> <AED98B89E193744D39BAC541@pmmelb207.melbourne.sgi.com> <20061017215706.GI8394166@melbourne.sgi.com> <1161125131.5723.158.camel@xenon.msp.redhat.com> <20061122004216.GT11034@melbourne.sgi.com> <1164157783.19915.46.camel@xenon.msp.redhat.com> <20061122042445.GR37654165@melbourne.sgi.com> <4563D7DD.1060907@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4563D7DD.1060907@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chatterton <chatz@melbourne.sgi.com>
Cc: David Chinner <dgc@sgi.com>, Russell Cattelan <cattelan@thebarn.com>, Tim Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Nov 22, 2006 at 03:53:49PM +1100, David Chatterton wrote:
> David Chinner wrote:
> > Attached is thecomplete patch. On ia64, the size of the xfs.ko
> > and xfs_quota.ko modules decreases with this patch:
....
> > Performance appears to be slight faster with the noinline
> > patch, but the variation is within the error margins of
> > my measurements so I'd say it's neutral.
> > 
> > Comments?
> > 
> 
> Just reducing xfs_bmapi by 118 bytes makes this worthwhile doesn't it?

Well, this is ia64, so stack usage really isn't the issue there.
A performance degradation was really what I really care about with
this change on ia64.

And the increase in xfs_bmap_btalloc() offsets this saving as well....

> Out of interest, what estimated improvement does this have on one of Jesper's
> stacks?

Depends on the compiler. For gcc 3.3.5, it makes no difference at
all because it doesn't automatically inline static functions. The
problem we're trying to address here is the agressive inlining that
gcc 4.x does of static functions that increases the stack usage
of critical functions.

e.g we've got in the code:

	xfs_bmapi()
	  xfs_bmap_alloc()
	    xfs_bmap_btalloc()

xfs_bmap_{bt}alloc() are static, single use functions, and so gcc 4.x
inlines them and the stack usage of all three functions is brought
into xfs_bmapi().

Now in some cases this is a slight win in terms in stack usage
if the code always passes through that path, but if the inlined
functions are leaf functions, then we increase stack usage for
no gain.

The clearest example of this on i386 is xfs_page_state_convert(),
which goes from 368 bytes of stack usage to 160 bytes of stack usage
once noinline is used on i386. There's over 200 bytes of extra stack
used by inlining functions that are not in the critical path.

Basically, we can factor the code all we like, but while gcc is
undoing that factoring to "go fast" we are fighting a losing battle.
Hence the noinline change is needed first to make the code stack how
we want it to, not how the compiler thinks it should.

> Should we be concerned that there are now more functions with 100 or more bytes?

Not really - the work that Jesper and Keith have done shows us that
we've got a certain set of functions that we really need to
concentrate on and once we've dealt with them we can start looking
at other leaf functions that are stack hogs....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
