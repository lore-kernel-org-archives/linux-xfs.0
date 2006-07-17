Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 07:48:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6HElRDW023391
	for <xfs@oss.sgi.com>; Mon, 17 Jul 2006 07:47:39 -0700
Date: Tue, 18 Jul 2006 00:46:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Stripe alignment with RAID volumes
Message-ID: <20060717144623.GA2114946@melbourne.sgi.com>
References: <e692861c0607161423o552588a3yd603a423afc71004@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e692861c0607161423o552588a3yd603a423afc71004@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gregory Maxwell <gmaxwell@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Jul 16, 2006 at 05:23:23PM -0400, Gregory Maxwell wrote:
> I have a 12 disk HW raid 5 with 128K stripe size. I built my 4k block
> XFS volume with sunit=256,swidth=2816. Everything is peachy ... or is
> it?
> 
> If I built my volume on a partitioned block device (i.e. /dev/sda2) it
> is quite likely that my partition will not start on a 128K boundary,
> so what XFS thinks is a single disk is actually two..

RAID performance trap for the unwary #21. ;)

> Worse, it's
> possible that the partition won't start on a 4K boundary... so every
> FS block read of a block on the 128K boundary will require hitting two
> disks (and potentially take an extra disk rotation if the disks are
> not spin aligned).

*nod*

IIRC from investigations done years ago on Irix, this misalignment
typically results in the filesystem being 3-4x slower on bandwidth
loads than a correctly aligned filesystem....

> This problem wouldn't be limited to XFS, but as one of the few FSes
> that pays a lot of attention to the underlying disk geometry I thought
> someone here might have given though to this issue.

Plenty ;)

For example, see the Data Layout section of the Irix GRIOv2 man page:

http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi?coll=0650&db=man&fname=/usr/share/catman/p_man/cat5/grio2.z&srch=grio2

We probably should encapsulate some form of this example in a FAQ entry,
because that's exactly what it is...

> I' believe that I have avoided this problem on my own system by just
> putting the FS on the raw device....  which isn't so bad because msdos
> partition tables won't permit a 3TB partition in any case... but
> surely there must be a more general solution.

Device mapper is your friend - you can offset the start of the volume
on each device you use.

We've done this in the past to allow multiple volume managers to coexist
on the same luns. e.g. first volume manager exists in 0-4MiB of each
lun, so we tell dm that each device starts at offset 4MiB rather than
at 0....

> Would it be possible to add a stripe start offset to XFS?

Maybe, but I can't see how it would be a simple thing to do because
it would require on-disk format changes...

Anyway, if you were configuring an XFS filesystem to do this, you
still need to understand the underlying geometry to get it right.
You may as well get your volume manager configuration correct, and
then we don't have to worry about it in XFS.

> I expect
> it would be fairly easy to make a disk benchmark tool which could
> estimate sunit, swidth, and start offset..

Not as easy as you would expect. But if you've got a patch, then we'll
happily consider it. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
