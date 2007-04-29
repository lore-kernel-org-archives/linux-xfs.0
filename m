Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Apr 2007 16:07:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3TN7afB010345
	for <xfs@oss.sgi.com>; Sun, 29 Apr 2007 16:07:37 -0700
Date: Mon, 30 Apr 2007 09:07:27 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: mkfs.xfs cannot make sector size 64 KiB?
Message-ID: <20070429230727.GL32602149@melbourne.sgi.com>
References: <Pine.LNX.4.64.0704291218190.10418@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704291218190.10418@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On Sun, Apr 29, 2007 at 12:20:26PM -0400, Justin Piszcz wrote:
> >From the manpage:
> 
>        -b     Block size options.
> 
>               This option specifies the fundamental block size of the 
>               filesys-
>               tem.   The  valid suboptions are: log=value and size=value; 
>               only
>               one can be supplied.  The block size is specified  either  as 
>               a
>               base two logarithm value with log=, or in bytes with size=.  
>               The
>               default value is 4096 bytes (4 KiB), the minimum is 512, and 
>               the
>               maximum is 65536 (64 KiB).  XFS on Linux currently only 
>               supports
>               pagesize or smaller blocks.
> 
> The maximum size is 64 KiB, yet it seems only up to 32 KiB is valid?
> I am running x86_64.

First question - What's the page size on x86_64?

Answer: 4k.

So while mkfs will allow you to make >4k block size filesystems,
you can't mount them on x86_64 (yet).

> p34:~# mkfs.xfs -b size=65536 /dev/md3
> illegal sector size 65536

That's not an illegal block size it's complaining about - that's a sector
size that it thinks is wrong. By the time we check this, we've already
validated the block size:


   1312         if (sectorsize < XFS_MIN_SECTORSIZE ||
   1313             sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
   1314                 fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
   1315                 usage();
   1316         }

But then we probe the underlying volume and get a "sectoralign" variable:

   1301         if (!nodsflag && !xi.disfile)
   1302                 get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
   1303                                 &xlv_dsunit, &xlv_dswidth, &sectoralign);
   1304         if (sectoralign) {
   1305                 sectorsize = blocksize;
   1306                 sectorlog = libxfs_highbit32(sectorsize);
   1307                 if (loginternal) {
   1308                         lsectorsize = sectorsize;
   1309                         lsectorlog = sectorlog;
   1310                 }
   1311         }
   1312         if (sectorsize < XFS_MIN_SECTORSIZE ||
   1313             sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
   1314                 fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
   1315                 usage();
   1316         }

And if we have sectoralign returned, we adjust the sector size to the
block size and then we fail due to (xfs_alloc_btree.h):

#define XFS_MAX_SECTORSIZE_LOG       15       /* i.e. 32768 bytes */

Hmmmm - I bet this is because you are using md raid here - this is probably
the code that ensures that XFS doesn't use 512 byte writes that cause md
raid cache flushes. This is triggers on:

                *sectalign = (md.level == 4 || md.level == 5 || md.level == 6);

So I bet that you're using RAID4/5/6 on your md device.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
