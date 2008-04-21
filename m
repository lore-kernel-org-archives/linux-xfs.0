Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 14:41:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3LLfMCk028589
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 14:41:24 -0700
Date: Tue, 22 Apr 2008 07:41:47 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: likely and unlikely was: Re: [PATCH] split xfs_ioc_xattr
Message-ID: <20080421214147.GP108924158@sgi.com>
References: <ncciqylf7q0.fsf@sgi.com> <20080414032940.GA10579@lst.de> <ncclk3ejwam.fsf@sgi.com> <20080416063712.GN108924158@sgi.com> <4805A589.7080906@sgi.com> <87ve2i5kbs.fsf@basil.nowhere.org> <4808488A.7010204@sgi.com> <4808AAA5.1060201@sandeen.net> <20080421003343.GL108924158@sgi.com> <20080421075558.GC14446@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421075558.GC14446@one.firstfloor.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, Timothy Shimmin <tes@sgi.com>, Niv Sardi <xaiki@cxhome.ath.cx>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Apr 21, 2008 at 09:55:58AM +0200, Andi Kleen wrote:
> On Mon, Apr 21, 2008 at 10:33:43AM +1000, David Chinner wrote:
> > On Fri, Apr 18, 2008 at 09:05:25AM -0500, Eric Sandeen wrote:
> > > ISTR that the dir2 code on Irix had tons of compiler pragmas for likely
> > > and unlikely paths, and that it actually was well-profiled and tested.
> > > Did that ever get translated into Linux hints?
> > 
> > The Irix code (#pragma mips_frequency_hint [FREQUENT|NEVER|INIT])
> > only controllered physical placement of code, it never issued
> > branch hints. 
> 
> likely/unlikely control placement too and I think it is actually
> more important for kernel code than branch hints (which x86 doesn't
> have explictely unlike ia64, they only way to do a branch hint is to reorder
> the code) due to icache effects.
> 
> i.e. a "never" block gets moved out of line,
> > while a "frequent" block is left inline. Realistically, the way
> > this is used in the Irix dir2 code is completely useless - code like
> > this:
> 
> Indeed because gcc has a heuristic that early returns are considered
> unlikely:
> 
> /* Branch causing function to terminate is probably not taken.  */
> DEF_PREDICTOR (PRED_TREE_EARLY_RETURN, "early return (on trees)", HITRATE (61), 
> 0)
> 
> It's only 61%, but that should be enough.
> 
> I'm somewhat surprised that MipsPro didn't have such a default heuristic 
> though ...

Different heuristics. IIRC the "true" branch of the if was typically
put inline so you could implicitly code your logic to get the
compiler to do the right thing....

And with the branch delay slot, things like:

	if (error)
		return error;

translate into three instructions:

	cmp	error, r0
	jne	return_prelude
	mov	v0, error	<<< BDS

Seeing as the BDS is only executed when the jump occurs and v0 holds
the function return value, there's no out of line code to bother
hinting about....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
