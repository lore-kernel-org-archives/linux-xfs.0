Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 15:13:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2PMCqMg004005
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 15:12:55 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57CC86E9A73
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 15:13:26 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id PYa7A7x0ZSwEcuTu for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 15:13:26 -0700 (PDT)
Date: Tue, 25 Mar 2008 18:13:21 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [opensuse] nfs_update_inode: inode X mode changed, Y to Z
Message-ID: <20080325221321.GC20257@josefsipek.net>
References: <9a8748490803121513w285cd45rb6b26a3d842cac1b@mail.gmail.com> <20080312221511.GC31632@fieldses.org> <9a8748490803121516u36395872i70cc88b0439adc74@mail.gmail.com> <18394.1501.991087.80264@notabene.brown> <47DAEFD0.9020407@m2000.com> <47E92F8E.7030504@m2000.com> <20080325190943.GF2237@fieldses.org> <32953.192.168.1.70.1206477121.squirrel@neil.brown.name> <20080325212425.GA20257@josefsipek.net> <34178.192.168.1.70.1206481102.squirrel@neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34178.192.168.1.70.1206481102.squirrel@neil.brown.name>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: NeilBrown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, xfs@oss.sgi.com, Adam Schrotenboer <adam@m2000.com>, Jesper Juhl <jesper.juhl@gmail.com>, Trond Myklebust <trond.myklebust@netapp.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, Thomas Daniel <tdaniel@m2000.com>, Frederic Revenu <frevenu@m2000.com>, Jeff Doan <jdoan@m2000.com>

On Wed, Mar 26, 2008 at 08:38:22AM +1100, NeilBrown wrote:
...
> However you still need to do something about the generation number.  It
> must be set to something.
 
Right.

> When you allocate an inode that doesn't currently exist on the device,
> you obviously cannot increment the old value and use that.

Makes sense.

> However you can do a lot better than always using 0.

I looked at the code (xfs_ialloc.c:xfs_ialloc_ag_alloc)

 290                 /*
 291                  * Set initial values for the inodes in this buffer.
 292                  */
 293                 xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
 294                 for (i = 0; i < ninodes; i++) {
 295                         free = XFS_MAKE_IPTR(args.mp, fbuf, i);
 296                         free->di_core.di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 297                         free->di_core.di_version = version;
 298                         free->di_next_unlinked = cpu_to_be32(NULLAGINO);
 299                         xfs_ialloc_log_di(tp, fbuf, i,
 300                                 XFS_DI_CORE_BITS | XFS_DI_NEXT_UNLINKED);
 301                 }

xfs_biozero(...) turns into a memset(buf, 0, len), and since the loop that
follows doesn't change the generation number, it'll stay 0.

> The simplest would be to generate a 'random' number (get_random_bytes).
> Slightly better would be to generate a random number at boot time
> and use that, incrementing it each time it is used to set the
> generation number for an inode.

I'm not familiar enough with NFS, do you want something that's monotonically
increasing or do you just test for inequality?  If it is inequality, why not
just use something like the jiffies - that should be unique enough.

> Even better would be store store that 'next generation number' in the
> superblock so there would be even less risk of the 'random' generation
> producing repeats.
> This is what ext3 does.  It doesn't dynamically allocate inodes,
> but it doesn't want to pay the cost of reading an old inode from
> storage just to see what the generation number is.  So it has
> a number in the superblock which is incremented on each inode allocation
> and is used as the generation number.
 
Something tells me that the SGI folks might not be all too happy with the
in-sb number...XFS tries to be as parallel as possible, and this would cause
the counter variable to bounce around their NUMA systems.  Perhaps a per-ag
variable would be better, but I remember reading that parallelizing updates
to some inode count variable (I forget which) in the superblock
\cite{dchinner-ols2006} led to a rather big improvement.  It's almost
morning down under, so I guess we'll get their comments on this soon.

Josef 'Jeff' Sipek.

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are, by
definition, not smart enough to debug it.
		- Brian W. Kernighan 
