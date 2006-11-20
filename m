Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Nov 2006 16:37:29 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAK0bIaG007242
	for <xfs@oss.sgi.com>; Sun, 19 Nov 2006 16:37:20 -0800
Date: Mon, 20 Nov 2006 11:36:22 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_growfs failed when crossing 1TB boundary
Message-ID: <20061120003622.GY11034@melbourne.sgi.com>
References: <1bc1cb170611191338l44425f5k37320aebcb79688e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1bc1cb170611191338l44425f5k37320aebcb79688e@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rami =?iso-8859-1?Q?V=E4stil=E4?= <bulpper@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Nov 19, 2006 at 11:38:09PM +0200, Rami Västilä wrote:
> Hi,
> 
> I'm trying to grow my filesystem over 1TB on top of LVM, but
> unfortunatelly the whole filesystem just shuts down and comes
> unusable.
> 
> xfs_growfs causes these error messages dumped into console when
> running it for bigger filesystem than 1TB (actually lvextend and
> 'xfs_growfs' commands was used to do the things...)
> 
> >xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Input/output error
> 
> >attempt to access beyond end of device
> >fe:00: rw=1, want=2137593089, limit=1086410752

You tried to grow past the end of the volume.

......

> ...after climbing between walls and jumping on my head, I was able to
> shrink it back under 1 TB barrier - 1023 GB in fact - and everything
> work just fine....;-)
> 
> ---
> 
> Here's some system info:
> 
> # uname -a
> Linux sweetums 2.4.27-3-686-smp #1 SMP Thu Sep 14 07:44:00 UTC 2006
> i686 GNU/Linux
.....
> # vgdisplay
>  --- Volume group ---
>  VG Name               lvmdisk
>  System ID
>  Format                lvm2
>  Metadata Areas        4
>  Metadata Sequence No  22
>  VG Access             read/write
>  VG Status             resizable
>  MAX LV                0
>  Cur LV                1
>  Open LV               1
>  Max PV                0
>  Cur PV                4
>  Act PV                4
>  VG Size               1.11 TB
>  PE Size               4.00 MB
>  Total PE              290885
>  Alloc PE / Size       261899 / 1023.04 GB
>  Free  PE / Size       28986 / 113.23 GB
>  VG UUID               8B6OW6-YOBj-Weit-LOUL-Rhzb-prO1-OQtEA0

So you have allocated 1023.04GB of your volume group. I assume
that's a single 1023GB logical volume that you have XFS on.

Hence if you want your XFS filesystem to be larger than 1023GB, then
you need to grow your logical volume to larger than 1023GB
first.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
