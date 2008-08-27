Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 17:51:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7R0pS54000309
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 17:51:28 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AF7AFCA89B
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 17:52:50 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Zw5PhHFOf5XcYam7 for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 17:52:50 -0700 (PDT)
Date: Wed, 27 Aug 2008 10:52:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS issue under 2.6.25.13 kernel
Message-ID: <20080827005243.GB5706@disturbed>
References: <50ed5c760808220303p37e03e8dge5b868a572374e0b@mail.gmail.com> <20080823010524.GM5706@disturbed> <50ed5c760808250408o44aeaf07me262eab8da8340ba@mail.gmail.com> <20080826014133.GS5706@disturbed> <50ed5c760808260553i7def5e93qb0bcb4d2206a4a38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50ed5c760808260553i7def5e93qb0bcb4d2206a4a38@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?utf-8?B?U8WCYXdvbWly?= Nowakowski <nailman23@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 26, 2008 at 02:53:23PM +0200, Sławomir Nowakowski wrote:
> 2008/8/26 Dave Chinner <david@fromorbit.com>:
> run under 2.6.17.17 and 2.6.25.13 kernels?
> 
> Here is a situation on 2.6.17.13 kernel:
> 
> xfs_io -x -c 'statfs' /mnt/point
>
> fd.path = "/mnt/sda"
> statfs.f_bsize = 4096
> statfs.f_blocks = 487416
> statfs.f_bavail = 6
> statfs.f_files = 160
> statfs.f_ffree = 154
> geom.bsize = 4096
> geom.agcount = 8
> geom.agblocks = 61247
> geom.datablocks = 489976
> geom.rtblocks = 0
> geom.rtextents = 0
> geom.rtextsize = 1
> geom.sunit = 0
> geom.swidth = 0
> counts.freedata = 6
> counts.freertx = 0
> counts.freeino = 58
> counts.allocino = 64

The counts.* numbers are the real numbers, not th statfs numbers
which are somewhat made up - the inode count for example is
influenced by the amount of free space....

> xfs_io -x -c 'resblks' /mnt/point
> 
> reserved blocks = 0
> available reserved blocks = 0
....

> 
> But under 2.6.25.13 kernel the situation looks different:
> 
> xfs_io -x -c 'statfs' /mnt/point:
> 
> fd.path = "/mnt/-sda4"
> statfs.f_bsize = 4096
> statfs.f_blocks = 487416
> statfs.f_bavail = 30
> statfs.f_files = 544
> statfs.f_ffree = 538

More free space, therefore more inodes....

> geom.bsize = 4096
> geom.agcount = 8
> geom.agblocks = 61247
> geom.datablocks = 489976
> geom.rtblocks = 0
> geom.rtextents = 0
> geom.rtextsize = 1
> geom.sunit = 0
> geom.swidth = 0
> counts.freedata = 30
> counts.freertx = 0
> counts.freeino = 58
> counts.allocino = 64

but the counts.* values show that the inode counts are the same.
However, the free space is different, partially due to a different
set of ENOSPC deadlock fixes that were done that required different
calculations of space usage....

> xfs_io -x -c 'resblks' /mnt/point:
> 
> reserved blocks = 18446744073709551586
> available reserved blocks = 18446744073709551586

Well, that is wrong - that's a large negative number.

FWIW, I can't reproduce this on a pure 2.6.24 on ia32 or 2.6.27-rc4 kernel
on x86_64-UML:

# mount /mnt/xfs2
# df -k /mnt/xfs2
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/ubd/2             2086912      1176   2085736   1% /mnt/xfs2
# xfs_io -x -c 'resblks 0' /mnt/xfs2
reserved blocks = 0
available reserved blocks = 0
# df -k /mnt/xfs2
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/ubd/2             2086912       160   2086752   1% /mnt/xfs2
# xfs_io -f -c 'truncate 2g' -c 'resvsp 0 2086720k' /mnt/xfs2/fred
# df -k /mnt/xfs2
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/ubd/2             2086912   2086880        32 100% /mnt/xfs2
# xfs_io -x -c statfs /mnt/xfs2
fd.path = "/mnt/xfs2"
statfs.f_bsize = 4096
statfs.f_blocks = 521728
statfs.f_bavail = 8
statfs.f_files = 192
statfs.f_ffree = 188
....
counts.freedata = 8
counts.freertx = 0
counts.freeino = 60
counts.allocino = 64
death:/mnt# umount /mnt/xfs2
death:/mnt# mount /mnt/xfs2
# xfs_io -x -c statfs /mnt/xfs2
fd.path = "/mnt/xfs2"
statfs.f_bsize = 4096
statfs.f_blocks = 521728
statfs.f_bavail = 0
statfs.f_files = 64
statfs.f_ffree = 60
....
counts.freedata = 0
counts.freertx = 0
counts.freeino = 60
counts.allocino = 64
# df -k /mnt/xfs2
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/ubd/2             2086912   2086912         0 100% /mnt/xfs2
# xfs_io -x -c resblks /mnt/xfs2
reserved blocks = 8
available reserved blocks = 8

Can you produce a metadump of the filesystem image that your have produced
on 2.6.17 that results in bad behaviour on later kernels so I can see if
I can reproduce the same results here? If you've only got a handful of files
the image will be small enough to mail to me....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
