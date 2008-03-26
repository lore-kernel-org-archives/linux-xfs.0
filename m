Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 20:37:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2Q3bQHn009113
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 20:37:30 -0700
Date: Wed, 26 Mar 2008 14:37:38 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [opensuse] nfs_update_inode: inode X mode changed, Y to Z
Message-ID: <20080326033738.GX103491721@sgi.com>
References: <20080312221511.GC31632@fieldses.org> <9a8748490803121516u36395872i70cc88b0439adc74@mail.gmail.com> <18394.1501.991087.80264@notabene.brown> <47DAEFD0.9020407@m2000.com> <47E92F8E.7030504@m2000.com> <20080325190943.GF2237@fieldses.org> <32953.192.168.1.70.1206477121.squirrel@neil.brown.name> <20080325212425.GA20257@josefsipek.net> <34178.192.168.1.70.1206481102.squirrel@neil.brown.name> <20080325221321.GC20257@josefsipek.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325221321.GC20257@josefsipek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>, xfs@oss.sgi.com, Adam Schrotenboer <adam@m2000.com>, Jesper Juhl <jesper.juhl@gmail.com>, Trond Myklebust <trond.myklebust@netapp.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, Thomas Daniel <tdaniel@m2000.com>, Frederic Revenu <frevenu@m2000.com>, Jeff Doan <jdoan@m2000.com>

On Tue, Mar 25, 2008 at 06:13:21PM -0400, Josef 'Jeff' Sipek wrote:
> On Wed, Mar 26, 2008 at 08:38:22AM +1100, NeilBrown wrote:
> ...
> > However you still need to do something about the generation number.  It
> > must be set to something.
.....
> > Even better would be store store that 'next generation number' in the
> > superblock so there would be even less risk of the 'random' generation
> > producing repeats.
> > This is what ext3 does.  It doesn't dynamically allocate inodes,
> > but it doesn't want to pay the cost of reading an old inode from
> > storage just to see what the generation number is.  So it has
> > a number in the superblock which is incremented on each inode allocation
> > and is used as the generation number.
>  
> Something tells me that the SGI folks might not be all too happy with the
> in-sb number...
.....
> Perhaps a per-ag variable would be better,

/me goes back to the bug from last year about stable inode/gen numbers
for a HSM.

dgc> Right, except the last thing we want is yet more global state needing to
dgc> be updated in inode allocation. The best way to do this is a max generation
dgc> number per AG (held in the AGI) so that it can be updated at the same time
dgc> inodes are freed and not cause additional serialisation.

Which was soundly rejected by the HSM folk because it wraps at 4 billion
inode create/unlink cycles in an AG rather than per inode. The only thing
they were happy with was the old behaviour and so they now mount their
filesystems with ikeep. At that point the issue was dropped on the floor;
the NFS side of things apparently weren't causing any problems so we didn't
consider it urgent to fix....

Given this state of affairs (i.e. HSM using ikeep), I guess we can do
anything we want for the noikeep case. I'll cook up a patch that does
something similar to ext3 generation numbers for the initial seeding....

> but I remember reading that parallelizing updates
> to some inode count variable (I forget which) in the superblock
> \cite{dchinner-ols2006} led to a rather big improvement.

That was for in memory counters not on disk, and the problem really was
free block counts rather than free inode counts. Yes, I converted the
inode counters at the same time, but that wasn't the limiting factor.
Updates to the on disk superblock, OTOH, are a limiting factor and
that was the lazy superblock counter modifications solve....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
