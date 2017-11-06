Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1577 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750739AbdKFGTp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 01:19:45 -0500
Date: Mon, 6 Nov 2017 17:19:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Supposedly identical file system wastes space
Message-ID: <20171106061928.GD5858@dastard>
References: <20171007114343.3bd42f98@lubh.lubhome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171007114343.3bd42f98@lubh.lubhome>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2017 at 01:15:50AM -0200, Luciano ES wrote:
> I have two 1TB disks, one of them on USB. The USB disk is supposed 
> to be a backup copy of the internal disk.
> 
> I run this command:
> 
> rsync -aSHxv --delete-before /xx/ /media/usbxx/
> 
> After all the copying, I get this output from df -h:
> 
> Filesystem         Size  Used Avail Use% Mounted on
> /dev/mapper/cxx    931G  520G  411G  56% /xx
> /dev/mapper/usbxx  932G  529G  403G  57% /media/usbxx
> 
> So the USB disk takes up 9GB more than the internal disk.
> 
> Why?
> 
> That is not a problem now, but will be when the disks are nearly full.
> 
> I investigate:
> 
> ---------------- 8< ----------------
> #> xfs_info /xx
> meta-data=/dev/mapper/cxx    isize=256    agcount=8, agsize=30506944 blks
>          =                   sectsz=4096  attr=2, projid32bit=1
>          =                   crc=0        finobt=0 spinodes=0 rmapbt=0
>          =                   reflink=0
> data     =                   bsize=4096   blocks=244055552, imaxpct=25
>          =                   sunit=0      swidth=0 blks
> naming   =version 2          bsize=4096   ascii-ci=0 ftype=0
> log      =internal           bsize=4096   blocks=119167, version=2
>          =                   sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none               extsz=4096   blocks=0, rtextents=0
> 
> #> xfs_info /media/usbxx
> meta-data=/dev/mapper/usbxx  isize=512    agcount=8, agsize=30523735 blks
>          =                   sectsz=512   attr=2, projid32bit=1
>          =                   crc=1        finobt=1 spinodes=0 rmapbt=0
>          =                   reflink=0
> data     =                   bsize=4096   blocks=244189877, imaxpct=25
>          =                   sunit=0      swidth=0 blks
> naming   =version 2          bsize=4096   ascii-ci=0 ftype=1
> log      =internal           bsize=4096   blocks=119233, version=2
>          =                   sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none               extsz=4096   blocks=0, rtextents=0
> ---------------- >8 ----------------
> 
> Looks like the only difference between them is the isize. But both were 
> formatted with the exact same line:
> 
> mkfs.xfs -f -b size=2048 -d agcount=8 /dev/target

With different versions of mkfs. One is a old v4 format filesystem,
the other is a v5 format filesystem which uses metadata CRCs, uses
larger inodes, has a free inode btree, has ftype enabled on
directories, etc....

> For the first time, I tried to introduce the -i size=256 option, 
> but mkfs.xfs is not having it:
> 
> "Minimum inode size for CRCs is 512 bytes"
> 
> Why not? They are the same size! Why do they have different inode sizes?

Because the v5 format is enabled by default now and that requires
512 byte inodes.

> Why is the external disk "wasting" space and how do I avoid that?

Its not wasting space. If you want it to be identical to your old
disk, then use "mkfs.xfs -m crc=0 ....", but I really don't advise
that because you are using USB drives for your backups and they need
all the silent corruption detection help they can get....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
