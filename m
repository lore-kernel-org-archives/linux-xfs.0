Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 15:50:31 -0700 (PDT)
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JMoPuw030645
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 15:50:28 -0700
Received: by rv-out-0910.google.com with SMTP id k20so269981rvb
        for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 15:50:28 -0700 (PDT)
Message-ID: <728b8e3b0709191550q3adad31bx53e759f66808d8b@mail.gmail.com>
Date: Thu, 20 Sep 2007 00:50:28 +0200
From: "Jochen K." <jochen.f.k@googlemail.com>
Subject: Re: Cant find sunit and swidth on luks encrypted raid6 device
In-Reply-To: <46F1A703.6040309@sandeen.net>
MIME-Version: 1.0
References: <728b8e3b0709191129j27b7c319h2efd51ffc9cb64f3@mail.gmail.com>
	 <46F17BBE.7060304@sandeen.net> <46F1A3D7.5090805@sandeen.net>
	 <33249.192.168.3.1.1190241583.squirrel@mail.aconex.com>
	 <46F1A703.6040309@sandeen.net>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: nscott@aconex.com, xfs@oss.sgi.com

Hi, Eric

Here is the output you wanted. I also did some debuging with strace but its
kinda big to paste it in here.
I also tried with the size option using a smaller device size which was
working but still using wrong optimized values for the raid6 device.
I guess you found the bug up there so should I add that and recompile
xfsprogs to try again ?

mkfs.xfs -f -dsize=5t /dev/mapper/raid6

meta-data=/dev/mapper/raid6      isize=256    agcount=32, agsize=41943040
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=1342177280, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0


Here is the output of blockdev and proc:

blockdev --getsize64 /dev/mapper/raid6
7000893943808

cat /proc/partitions
 9     0 6836811520 md0
   7     0    2150400 loop0
 253     2    2149372 dm-2
 253     3 6836810492 dm-3

-Jochen


[[HTML alternate version deleted]]
