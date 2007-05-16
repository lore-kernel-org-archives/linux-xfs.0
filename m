Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 20:29:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4G3T4fB019177
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 20:29:06 -0700
Date: Wed, 16 May 2007 13:32:28 +1000
Subject: Re: xfs_repair: buf calloc failed (4132 bytes): Cannot allocate memory
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <slrnf4j7ge.aje.robert.sander@snell.epigenomics.epi>
Message-ID: <op.tsehgekef8dyj1@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <slrnf4j7ge.aje.robert.sander@snell.epigenomics.epi>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@ml.epigenomics.com, xfs@oss.sgi.com

On Tue, 15 May 2007 21:48:30 +1000, <linux-xfs@ml.epigenomics.com> wrote:

> Hi!
>
> We have a RAID0 set of 3 400GB disks.
>
> After a crash we needed to run xfs_repair, but it bails out with the
> error message:
>
>         - ensuring existence of lost+found directory
>         - traversing filesystem starting at / ...
> xfs_repair: buf calloc failed (4132 bytes): Cannot allocate memory
>
> The filesystem contains many hardlinked files as it is a dirvish
> repository (www.dirvish.org) with the hardlinks created by rsync.
>
> This is the xfs_db info:
>
> # xfs_db -r -c "sb 0" -c "p" /dev/md0
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 293031424
> rblocks = 0
> rextents = 0
> uuid = e8d3a22c-716f-4f3e-9e95-e06afb3559d0
> logstart = 268435472
> rootino = 256
> rbmino = 257
> rsumino = 258
> rextsize = 48
> agblocks = 9157232
> agcount = 32
> rbmblocks = 0
> logblocks = 32768
> versionnum = 0x3184
> sectsize = 512
> inodesize = 256
> inopblock = 16
> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog = 12
> sectlog = 9
> inodelog = 8
> inopblog = 4
> agblklog = 24
> rextslog = 0
> inprogress = 0
> imax_pct = 25
> icount = 18882496
> ifree = 373596
> fdblocks = 27494887
> frextents = 0
> uquotino = 0
> gquotino = 0
> qflags = 0
> flags = 0
> shared_vn = 0
> inoalignmt = 2
> unit = 16
> width = 48
> dirblklog = 0
> logsectlog = 0
> logsectsize = 0
> logsunit = 0
> features2 = 0
>
> Kernel is 2.6.20.6 on a dual PIII machine with 1GB RAM and 10GB swap.
>
> Mounting the filesystem is possible, but what about its current state?
>
> Greetings

With 18 million inodes, 1.2TB of space, it will use a lot of memory.
Assuming you are using a recent xfsprogs (2.8.11 or later), you can
reduce memory usage by adding "-o bhash=512" which will limit the
number of buffers cached in xfs_repair. In this scenario, the cache
will overflow RAM rather easily with the number of inodes to be
scanned.

Regards,
Barry.
