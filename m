Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Apr 2007 09:20:36 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3TGKXfB006291
	for <xfs@oss.sgi.com>; Sun, 29 Apr 2007 09:20:34 -0700
Received: from localhost (localhost [127.0.0.1])
	by lucidpixels.com (Postfix) with ESMTP id BF6CC5000165
	for <xfs@oss.sgi.com>; Sun, 29 Apr 2007 12:20:26 -0400 (EDT)
Date: Sun, 29 Apr 2007 12:20:26 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: mkfs.xfs cannot make sector size 64 KiB?
Message-ID: <Pine.LNX.4.64.0704291218190.10418@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

>From the manpage:

        -b     Block size options.

               This option specifies the fundamental block size of the filesys-
               tem.   The  valid suboptions are: log=value and size=value; only
               one can be supplied.  The block size is specified  either  as  a
               base two logarithm value with log=, or in bytes with size=.  The
               default value is 4096 bytes (4 KiB), the minimum is 512, and the
               maximum is 65536 (64 KiB).  XFS on Linux currently only supports
               pagesize or smaller blocks.

The maximum size is 64 KiB, yet it seems only up to 32 KiB is valid?

I am running x86_64.

$ uname -m
x86_64


p34:~# mkfs.xfs -b size=512 /dev/md3
mkfs.xfs: /dev/md3 appears to contain an existing filesystem (xfs).
mkfs.xfs: Use the -f option to force overwrite.
p34:~# mkfs.xfs -b size=4096 /dev/md3
mkfs.xfs: /dev/md3 appears to contain an existing filesystem (xfs).
mkfs.xfs: Use the -f option to force overwrite.
p34:~# mkfs.xfs -b size=8192 /dev/md3
mkfs.xfs: /dev/md3 appears to contain an existing filesystem (xfs).
mkfs.xfs: Use the -f option to force overwrite.
p34:~# mkfs.xfs -b size=16384 /dev/md3
mkfs.xfs: /dev/md3 appears to contain an existing filesystem (xfs).
mkfs.xfs: Use the -f option to force overwrite.
p34:~# mkfs.xfs -b size=32768 /dev/md3
mkfs.xfs: /dev/md3 appears to contain an existing filesystem (xfs).
mkfs.xfs: Use the -f option to force overwrite.
p34:~# mkfs.xfs -b size=65536 /dev/md3
illegal sector size 65536
Usage: mkfs.xfs
/* blocksize */         [-b log=n|size=num]
/* data subvol */       [-d agcount=n,agsize=n,file,name=xxx,size=num,
                             (sunit=value,swidth=value|su=num,sw=num),
                             sectlog=n|sectsize=num,unwritten=0|1]
/* inode size */        [-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2]
/* log subvol */        [-l agnum=n,internal,size=num,logdev=xxx,version=n
                             sunit=value|su=num,sectlog=n|sectsize=num]
/* label */             [-L label (maximum 12 characters)]
/* naming */            [-n log=n|size=num,version=n]
/* prototype file */    [-p fname]
/* quiet */             [-q]
/* realtime subvol */   [-r extsize=num,size=num,rtdev=xxx]
/* sectorsize */        [-s log=n|size=num]
/* version */           [-V]
                         devicename
<devicename> is required unless -d name=xxx is given.
<num> is xxx (bytes), xxxs (sectors), xxxb (fs blocks), xxxk (xxx KiB),
       xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).
<value> is xxx (512 byte blocks).
p34:~#

Unless, the page size is not <= 64 for x86_64?

Justin.
