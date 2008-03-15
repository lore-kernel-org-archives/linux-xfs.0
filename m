Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Mar 2008 22:08:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2F57sXs031778
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 22:07:58 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19EC46A3D3E
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 22:08:25 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id HwkNVP4iXCmDeys8 for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 22:08:25 -0700 (PDT)
Date: Sat, 15 Mar 2008 00:27:03 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
Message-ID: <20080315042703.GA28242@josefsipek.net>
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net> <47DB4F4F.8030407@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DB4F4F.8030407@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Mar 14, 2008 at 11:23:43PM -0500, Eric Sandeen wrote:
> Josef 'Jeff' Sipek wrote:
> > On Fri, Mar 14, 2008 at 10:24:49PM -0500, Eric Sandeen wrote:
> >> This should fix the longstanding issues with xfs and old ABI
> >> arm boxes, which lead to various asserts and xfs shutdowns,
> >> and for which an (incorrect) patch has been floating around
> >> for years.  (Said patch made ARM internally consistent, but
> >> altered the normal xfs on-disk format such that it looked
> >> corrupted on other architectures):
> >> http://lists.arm.linux.org.uk/lurker/message/20040311.002034.5ecf21a2.html
> > ...
> >> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> >>
> >> ---
> >>
> >> Index: linux-2.6.24/fs/xfs/linux-2.6/xfs_linux.h
> >> ===================================================================
> >> --- linux-2.6.24.orig/fs/xfs/linux-2.6/xfs_linux.h
> >> +++ linux-2.6.24/fs/xfs/linux-2.6/xfs_linux.h
> >> @@ -300,4 +300,11 @@ static inline __uint64_t howmany_64(__ui
> >>  	return x;
> >>  }
> >>  
> >> +/* ARM old ABI has some weird alignment/padding */
> >> +#if defined(__arm__) && !defined(__ARM_EABI__)
> >> +#define __arch_pack __attribute__((packed))
> >> +#else
> >> +#define __arch_pack
> >> +#endif
> > 
> > Shouldn't this be unconditional? Just because it ends up being ok on x86
> > doesn't mean that it won't break some time later on...(do we want another
> > bad_features2 incident?)
> 
> I think that packing structures when they don't need to be can actually
> be harmful, efficiency-wise.  I read a nice explanation of this....
> which I can't find now.

Agreed. For in-memory only structures it makes sense to let the compiler do
whatever is the best, but for structures that are on-disk, you really have
no choice, you have to have the same layout in memory - which frequently
means packed. Unless I missed it, the structs you modified are on-disk, and
therefore _must_ be the way the docs say - which happens to be packed.

Josef 'Jeff' Sipek.

-- 
In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like
that.
		- Linus Torvalds
