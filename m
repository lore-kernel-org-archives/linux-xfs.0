Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 16:43:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2HNhaCH024412
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 16:43:38 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B06DDFBDE83
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 16:44:08 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id muB82EkvK299QQeW for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 16:44:08 -0700 (PDT)
Date: Mon, 17 Mar 2008 16:28:53 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
Message-ID: <20080317202853.GC16500@josefsipek.net>
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net> <47DB4F4F.8030407@sandeen.net> <20080315042703.GA28242@josefsipek.net> <47DB51A3.70200@sandeen.net> <20080315045147.GB28242@josefsipek.net> <47DEB930.7020108@sandeen.net> <20080317195313.GB16500@josefsipek.net> <47DECEBD.10604@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DECEBD.10604@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 17, 2008 at 03:04:13PM -0500, Eric Sandeen wrote:
> Josef 'Jeff' Sipek wrote:
...
> Oh, I wasn't trying to blame you or our patch specifically, just wanted
> to highlight what I consider to be the bad idea of giving gcc a bunch of
> directives that IMHO we don't need.
 
Right. And yes, just plopping __attribute__((packed)) to the end of each
on-disk structure is a really bad idea - it actually make xfsqa fail :)

But living on the edge, without telling gcc what exactly we want from it is
an even worse idea! Take sb_bad_features2...that fiasco that's going to stay
with the XFS on-disk format for a long time to come, would have never
happened if the structures were properly packed/padded to begin with.

> > Second, I need to find out whether all the affected structures are always
> > aligned on some boundary (probably 4 or 8 byte). If there indeed is some
> > alignment, there might be a way to reduce those 15k extra lines to something
> > a whole lot less - I hope.
> 
> To what end?  What are you trying to fix?  If it's not reduced to 0 then

Not packing the structures is all fine if you have one compiler, one OS, and
one architecture to care about. That worked fine when XFS ran on IRIX on
MIPS, but Linux runs on so many different ABIs that you are asking for
trouble by not packing. I can't imagine the number of supported ABIs not
growing. Packing on as-needed basis (which you suggested with your patch) is
rather messy...

1) new ABIs have to checked

2) you'll end up with a rat's nest of #ifdefs to make __arch_pack do the
   right thing

Really, we need a way to tell gcc: "hey, gcc, we know what we're doing -
just trust us; don't pad, and don't worry about the alignment".  packed gets
you the no-padding, and as I mentioned in my previous reply, align(X) will
hopefully take care of the alignment. Then, gcc should generate nice code to
access members that are on proper boundaries (AFAIK virtually all, if not
all, the struct members in XFS fall into this category), and slightly worse
code for few places that might exist.

The problem you saw in ia64, is because gcc generated the "worst" case code
for all the struct accesses. I _think_ that can be fixed to near-0, if not 0
on all but the few ABIs (e.g., old arm).

Josef 'Jeff' Sipek.

-- 
The box said "Windows XP or better required". So I installed Linux.
