Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 00:50:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3L7nl3D019583
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 00:49:53 -0700
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C37B6A6B3C9
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 00:50:27 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by cuda.sgi.com with ESMTP id Q0cxSZtYLilNAsNP for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 00:50:27 -0700 (PDT)
Date: Mon, 21 Apr 2008 09:55:58 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: likely and unlikely was: Re: [PATCH] split xfs_ioc_xattr
Message-ID: <20080421075558.GC14446@one.firstfloor.org>
References: <20080319204014.GA23644@lst.de> <ncciqylf7q0.fsf@sgi.com> <20080414032940.GA10579@lst.de> <ncclk3ejwam.fsf@sgi.com> <20080416063712.GN108924158@sgi.com> <4805A589.7080906@sgi.com> <87ve2i5kbs.fsf@basil.nowhere.org> <4808488A.7010204@sgi.com> <4808AAA5.1060201@sandeen.net> <20080421003343.GL108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421003343.GL108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Timothy Shimmin <tes@sgi.com>, Andi Kleen <andi@firstfloor.org>, Niv Sardi <xaiki@cxhome.ath.cx>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Apr 21, 2008 at 10:33:43AM +1000, David Chinner wrote:
> On Fri, Apr 18, 2008 at 09:05:25AM -0500, Eric Sandeen wrote:
> > ISTR that the dir2 code on Irix had tons of compiler pragmas for likely
> > and unlikely paths, and that it actually was well-profiled and tested.
> > Did that ever get translated into Linux hints?
> 
> The Irix code (#pragma mips_frequency_hint [FREQUENT|NEVER|INIT])
> only controllered physical placement of code, it never issued
> branch hints. 

likely/unlikely control placement too and I think it is actually
more important for kernel code than branch hints (which x86 doesn't
have explictely unlike ia64, they only way to do a branch hint is to reorder
the code) due to icache effects.

i.e. a "never" block gets moved out of line,
> while a "frequent" block is left inline. Realistically, the way
> this is used in the Irix dir2 code is completely useless - code like
> this:

Indeed because gcc has a heuristic that early returns are considered
unlikely:

/* Branch causing function to terminate is probably not taken.  */
DEF_PREDICTOR (PRED_TREE_EARLY_RETURN, "early return (on trees)", HITRATE (61), 
0)

It's only 61%, but that should be enough.

I'm somewhat surprised that MipsPro didn't have such a default heuristic 
though ...

-Andi
