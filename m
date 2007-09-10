Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 08:04:24 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AF4H4p002528
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 08:04:19 -0700
Date: Mon, 10 Sep 2007 10:44:24 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Attempt to Access Beyond End of Device
In-Reply-To: <1189432747.4385.27.camel@auctoritas.fs3.ph>
Message-ID: <Pine.LNX.4.64.0709101041390.897@p34.internal.lan>
References: <1189432747.4385.27.camel@auctoritas.fs3.ph>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Federico Sevilla III <jijo@fs3.ph>
Cc: linux-xfs@oss.sgi.com, Alec Joseph Rivera <agi@fs3.ph>



On Mon, 10 Sep 2007, Federico Sevilla III wrote:

> Hi,
>
> We've set up Debian GNU/Linux 4.0 "Etch" on an IBM x3400 machine with
> two 73.4GB SAS hard drives in hardware RAID 1 with a battery-backed
> cache. We are using the stock Debian 2.6.18-4-686 kernel.
>
> The filesystems were created using the following optimization:
>
>        -l size=32768b,version=2 -n 64k
>
> The filesystems are mounted using the following optimization:
>
>        logbufs=8,logbsize=256k
>
> Today, we were unable to mount the "large" (not really at < 70GB) /var
> (/dev/sda8), getting the following error:
>
>        Attempt to access beyond end of device
>        sda: rw=0, want=143139140, limit=143134720
>        I/O error in filesystem ("sda8") meta-data dev sda8 block
>        0x75cd27f
>        ("xf:read_buf") errors buf count 512
>        XFS: size check 2 failed
>        Mount: /dev/sda8: can't read superblock
>
> An attempted repair also fails:
>
>        # xfs_repair /dev/sda8
>        Phase 1 - find and verify superblock...
>        Attempt to access beyond end of device
>        Sda: rw=0, want=143139140, limit=143134720
>        Xfs_repair: read failed.      Input/output error
>
> The partition table looks okay:
>
>        #Partition table of /dev/sda
>        /dev/sda1 : start=          63,size        9637, Id=83, bootable
>        /dev/sda2 : start=       96390,size   143042760, Id=5
>        /dev/sda3 : start=           0,size           0, Id=0
>        /dev/sda4 : start=           0,size           0, Id=0
>        /dev/sda5 : start=       96453,size     3903732, Id=82
>        /dev/sda6 : start=     4000248,size     7807527, Id=83
>        /dev/sda7 : start=    11807838,size     7807527, Id=83
>        /dev/sda8 : start=    19615428,size   123523722, Id=83
>
> The machine doesn't have valuable data, yet, so a simple reinstall
> should help get it back up. However I'm more concerned about what could
> cause this. It's the first time for me to use a version 2 log, 64k
> directories (?) and 256k in-memory log buffers. Are any of these to
> blame?
>
> We're also looking for generic filesystem tweaks for a PostgreSQL +
> Apache server, which this will be (with more load direct to PostgreSQL
> than to/through Apache). Are the above choices for mkfs.xfs and mount
> well-made?
>
> Please advise.
>
> Thank you very much.
>
> -- 
> Federico Sevilla III
> F S 3 Consulting Inc.
> http://www.fs3.ph
>

I believe the logbsize should be in bytes, so 262144, it may also take
256k though I have not tried it.

As far as the creation, that's a good question, I use SW raid so XFS
auto-tunes it for my hardware.

That looks mighty strange, what kind of raid card?

Justin.
