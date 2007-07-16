Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 15:18:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6GMIZbm014022
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 15:18:37 -0700
Date: Tue, 17 Jul 2007 08:18:31 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raid50 and 9TB volumes
Message-ID: <20070716221831.GE31489@sgi.com>
References: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com> <20070716130140.GC31489@sgi.com> <5d96567b0707160653m5951fac9v5a56bb4c92174d63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0707160653m5951fac9v5a56bb4c92174d63@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>
Cc: neilb@suse.de, dgc@sgi.com, xfs-oss <xfs@oss.sgi.com>

On Mon, Jul 16, 2007 at 04:53:22PM +0300, Raz wrote:
> On 7/16/07, David Chinner <dgc@sgi.com> wrote:
> >On Mon, Jul 16, 2007 at 03:42:28PM +0300, Raz wrote:
> >> Hello
> >> I found that using xfs over raid50, ( two raid5's 8 disks each and
> >> raid 0 over them ) crashes the file system when the file system is ~
> >> 9TB. crashing is easy: we simply create few hundred of files, then
> >> erase them in bulk. the same test passes in 6.4TB filesystems.
> >> this bug happens in 2.6.22 as well as 2.6.17.7.
> >> thank you .
> >>
> >> 4391322.839000] Filesystem "md3": XFS internal error
> >> xfs_alloc_read_agf at line 2176 of file fs/xfs/xfs_alloc.c.  Caller
> >> 0xc10d31ea
> >> [4391322.863000]  <c10d36e9> xfs_alloc_read_agf+0x199/0x220
> >> <c10d31ea> xfs_alloc_fix_freelist+0x41a/0x4b0
> >
> >Judging by the kernel addresses (<c10d36e9>) you're running
> >an i386 kernel right? Which means there's probably a wrapping
> >issue at 8TB somewhere in the code which has caused an AGF
> 
> what is AGF ?

An AGF is a "Allocation Group Freespace" structure that holds
the free space indexes that the allocator uses. The AGF holds
the root of the btrees used to find space, so if the AGF is
trashed, you're in big trouble. :/

> >header to be trashed somewhere lower down in the filesystem.
> >what does /proc/partitions say? I.e. does the kernel see
> >the whole 9TB of space?
> >
> >What does xfs_repair tell you about the corruption? (assuming
> >it doesn't OOM, which is a good chance if you really are on
> >i386).
> 
> Well you are right.  /proc/partitions  says:
> ....
>   8   241  488384001 sdp1
>   9     1 3404964864 md1
>   9     2 3418684416 md2
>   9     3 6823647232 md3
> 
> while xfs formats md3 as 9 TB.
> If i am using LBD , what is the biggest size I can use on i386 ?

Supposedly 16TB. 32bit x 4k page size = 16TB. Given that the size is
not being reported correctly, I'd say that this is probably not an
XFS issue. The next thing to check is how large an MD device you
can create correctly.

Neil, do you know of any problems with > 8TB md devices on i386?

Cheers,

Dave.
> 
> many thanks
> raz
> 
> 
> 
> 
> -- 
> Raz

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
