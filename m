Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 15:34:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JMXxuw027365
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 15:34:02 -0700
Message-ID: <46F1A3D7.5090805@sandeen.net>
Date: Wed, 19 Sep 2007 17:33:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Cant find sunit and swidth on luks encrypted raid6 device
References: <728b8e3b0709191129j27b7c319h2efd51ffc9cb64f3@mail.gmail.com> <46F17BBE.7060304@sandeen.net>
In-Reply-To: <46F17BBE.7060304@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Jochen K." <jochen.f.k@googlemail.com>, xfs@oss.sgi.com

Eric Sandeen wrote:

> What does "blockdev --getsize64" and "blockdev --getsize" and/or
> /proc/partitions say about how big /dev/mapper/raid6 is?
> 
> Can you use dd to write to the last 128k of the device, as reported by
> blockdev --getsize64?

Not a cryptsetup problem, FWIW:

[root@inode obj]# /tmp/truncate fsfile 7000893943808
Truncating fsfile to 7000893943808
[root@inode obj]# ls -l fsfile
-rw-r--r-- 1 root root 7000893943808 Sep 19 17:23 fsfile
[root@inode obj]# mkfs.xfs -f fsfile
meta-data=fsfile                 isize=256    agcount=32,
agsize=53412581 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=1709202592, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
2b2d4c133680: Badness in key lookup (length)
bp=(bno 13673620728, len 131072 bytes) key=(bno 13673620728, len 4096 bytes)

If we take out the pwrite that does the end-of-device zeroing, we don't
get the error... but that's been there since forever, so again, I'm a
bit confused here.

-Eric
