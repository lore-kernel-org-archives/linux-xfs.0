Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Mar 2008 21:51:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2F4pGZi027849
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:51:18 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02CD86A3B3D
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:51:47 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id MTBmNDM0EUqKUIFf for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:51:47 -0700 (PDT)
Date: Sat, 15 Mar 2008 00:51:47 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
Message-ID: <20080315045147.GB28242@josefsipek.net>
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net> <47DB4F4F.8030407@sandeen.net> <20080315042703.GA28242@josefsipek.net> <47DB51A3.70200@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DB51A3.70200@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Mar 14, 2008 at 11:33:39PM -0500, Eric Sandeen wrote:
> Josef 'Jeff' Sipek wrote:
> > On Fri, Mar 14, 2008 at 11:23:43PM -0500, Eric Sandeen wrote:
> >> Josef 'Jeff' Sipek wrote:
> 
> >>> Shouldn't this be unconditional? Just because it ends up being ok on x86
> >>> doesn't mean that it won't break some time later on...(do we want another
> >>> bad_features2 incident?)
> >> I think that packing structures when they don't need to be can actually
> >> be harmful, efficiency-wise.  I read a nice explanation of this....
> >> which I can't find now.
> > 
> > Agreed. For in-memory only structures it makes sense to let the compiler do
> > whatever is the best, but for structures that are on-disk, you really have
> > no choice, you have to have the same layout in memory - which frequently
> > means packed. Unless I missed it, the structs you modified are on-disk, and
> > therefore _must_ be the way the docs say - which happens to be packed.
> 
> Well, the docs probably don't actually say "packed" :) ... they just
> assume standard/predictable layout of the structures.
 
Ok, nitpicking, eh? Well, you started ;)

Yes, it is true that they don't say packed, but at the same time they don't
define any holes, and the best way to force the compiler to not make holes
is to pack the structure.

> So on almost all architectures they _don't_ need to be explicitly
> packed, and it's my understanding that doing so when it's not neccessary
> is harmful.  But these 3 cases, on the odd arm abi, do need it.
 
My understanding of the "harmful" case is that of unaligned word access, but
the compiler takes care of that.

All in all, all the ABIs that get the right alignment without packing will
not suffer performance-wise, and the old arm ABI needs to be packed anyway.
Now, next time Linux gets ported to an architecture - if that arch has a
"bad" alignment ABI rules, XFS will break, and someone (I nominate you :-P )
will have to augment the #if...or just use packed and forget about the whole
issue. :)

Josef 'Jeff' Sipek, wondering exactly how passionate one can get about
structure member alignment :)

-- 
Research, n.:
  Consider Columbus:
    He didn't know where he was going.
    When he got there he didn't know where he was.
    When he got back he didn't know where he had been.
    And he did it all on someone else's money.
