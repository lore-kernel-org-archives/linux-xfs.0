Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 13:59:28 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TKxQ4X013906
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 13:59:26 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B6EF175819B
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 14:00:17 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.249]) by cuda.sgi.com with ESMTP id eNOXVfTilAFH8NiY for <xfs@oss.sgi.com>; Thu, 29 May 2008 14:00:17 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so3369508rvb.32
        for <xfs@oss.sgi.com>; Thu, 29 May 2008 14:00:16 -0700 (PDT)
Message-ID: <3607657a0805291400h3c50165lea6fbea919deed0f@mail.gmail.com>
Date: Thu, 29 May 2008 17:00:16 -0400
From: "Spam Magnet" <spam.wax@gmail.com>
Subject: Re: XFS: SB validate failed
In-Reply-To: <483F0BC3.2050901@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>
	 <483EE5BD.8020407@sandeen.net>
	 <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>
	 <483F0BC3.2050901@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> Byte ordering is only an issue for the log replay; you'd get a message
> about that if it were the issue.
>
> Does file -s /dev/sdb? say that any of those things even look like an
> xfs filesystem?
>
> If so point xfs_db at it like:
>
> xfs_db -r -c "sb 0" -c "p" /dev/sdb<whatever>
>
it's indeed an xfs filesystem:
$ sudo file -s /dev/sdb8
/dev/sdb8: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)

And this is output of xfs_db:

magicnum = 0x58465342
blocksize = 4096
dblocks = 488936
rblocks = 0
rextents = 0
uuid = bc45ebf5-b625-102c-8d9d-0800690be5b3
logstart = 262148
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 16
agblocks = 61117
agcount = 8
rbmblocks = 0
logblocks = 1200
versionnum = 0x3084
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 16
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 64
ifree = 53
fdblocks = 486371
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0

I can mount and see the content of this disk: using:
mount -t xfs /dev/sdb8 /mnt

But xfs_check still crashes on me :(
/usr/sbin/xfs_check: line 28: 26782 Segmentation fault (core dumped)
xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1

Will it be ok if I made a 1:1 image of my disks under Irix (using dd):

$ dd if=/dev/dsk/dks1d3vol of=disk.img bs=512 conv=ignerror,sync

And tried to use xfs module in Linux to mount them ? or this programs
are only meant to work with actual device rather than an image file ?

thanks for your patience
