Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 15:15:19 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0HNF7wZ027393
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 15:15:11 -0800
Date: Fri, 18 Jan 2008 10:15:17 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
Message-ID: <20080117231517.GF155407@sgi.com>
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253594C@pvn-3001.purevideo.local> <20080117030111.GH155259@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F02535951@pvn-3001.purevideo.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F02535951@pvn-3001.purevideo.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 17, 2008 at 09:29:22AM -0800, Mark Magpayo wrote:
> > On Wed, Jan 16, 2008 at 03:19:19PM -0800, Mark Magpayo wrote:
> > > Hi,
> > >
> > > So I have run across a strange situation which I hope there
> > > are some gurus out there to help.
> > >
> > > The original setup was a logical volume of 8.9TB.  I extended
> > > the volume to 17.7TB and attempted to run xfs_growfs.  I am
> > > not sure whether the command actually finished, as after I ran
> > > the command, the metadata was displayed, but there was no
> > > nothing that stated the the number of data blocks had changed.
> > > I was just returned to the prompt, so I'm not sure whether the
> > > command completed or not..
> > 
> > Hmmm - what kernel and what version of xfsprogs are you using?
> > (xfs_growfs -V).
> 
> xfs_growfs version 2.9.4

Ok, that's recent - what kernel? (uname -a)

> > Also, can you post the output of the growfs command if you still
> > have it?
> > 
> > If not, the output of:
> > 
> > # xfs_db -r -c 'sb 0' -c p <device>
> 
> #xfs_db -r -c 'sb 0' -c p /dev/vg0/lv0
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 11904332800

	= 44TB?
....
> agblocks = 74402080
	= ~283GB

> agcount = 160

	160*283GB = 44TB.

Hold on - 160 AGs? I saw this exact same growfs failure signature
just before Christmas at a customer site on an old kernel and
xfsprogs.  I really need to know what kernel you are running to
determine if we may have fixed this bug or not....

But, I did manage to recover that filesystem successfully,
so I can give you a simple recipe to fix it up and it won't
take me 4 hours on IRC to understand the scope of the damage
completely.

BTW, if you wanted 18TB, that should be ~64AGs at that size AG
so my initial suspicion was confirmed....

> rbmblocks = 0
> logblocks = 32768
> versionnum = 0x3094
....
> icount = 1335040
> ifree = 55
> fdblocks = 9525955616
	= 35TB

So the free block count got updated as well.

Ok, that means once we've fixed up the number of AGs and block
count, we'll need to run xfs_repair to ensure all the accounting
is correct....


So the superblock in AG1 shoul dhave the original (pre-grow)
geometry in it:

> #xfs_db -r -c 'sb 1' -c p /dev/vg0/lv0
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 2380866560

	= 8.9TB
....
> agblocks = 74402080
> agcount = 32

Yup, 32 AGs originally.

> rbmblocks = 0
> logblocks = 32768
> versionnum = 0x3094
....
> icount = 1334912
> ifree = 59
> fdblocks = 2809815

Yeah, you didn't have much free space, did you? ;)

FWIW: sb.0.fdblocks - (sb.0.dblocks - sb.1.dblocks)
	= 9525955616 - (11904332800 - 2380866560)
	= 2489376

Which means we can use simple subtraction to fix up the free
block count. You'll need to run xfs_reapir to fix this after
we've fixed the geometry.

The way to fix this is to manually fix up the agcount
and dblocks in all the AGs. Seeing as you simply doubled the
volume size, that is relatively easy to do. dblocks should
be 2*2380866560 = 4761733120 blocks = 19,046,932,480 bytes.

Your device is 19,504,058,859,520 bytes in size, so this should
fit just fine.

# for i in `seq 0 1 63`; do
> xfs_db -x -c "sb $i" -c 'write agcount 64' -c 'write dblock 4761733120' /dev/vg0/lv0
> done

Then run 'xfs_repair -n /dev/vg0/lv0' to check that phase 1 will
pass (i.e. it can read the last block of the filesystem). If phase
1 completes, then you can kill it and run xfs_repair again without
the '-n' flag.

Once that completes, you should have a mountable filesystem that is
~18TB in size.

If you want, once you've mounted it run xfs_growfs again to extend
the filesystem completely to the end of new device....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
