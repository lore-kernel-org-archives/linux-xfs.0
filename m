Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Oct 2007 06:03:29 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9ED3Hoc001507
	for <linux-xfs@OSS.SGI.com>; Sun, 14 Oct 2007 06:03:20 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1Ih2YY-0002Lc-UD
	for <linux-xfs@OSS.SGI.com>; Sun, 14 Oct 2007 13:26:54 +0100
Resent-Message-ID: <18194.2830.556977.355055@base.ty.sabi.co.UK>
Resent-To: linux-xfs@oss.sgi.com
Content-Transfer-Encoding: 7bit
Subject: Re: Latencies in XFS.
Date: Sat, 13 Oct 2007 16:35:10 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Message-ID: <18192.58798.363482.613421@base.ty.sabi.co.UK>
References: <20071009163635.413dec0c@zeus.pccl.info>
In-Reply-To: <20071009163635.413dec0c@zeus.pccl.info>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Clayton <andrew@digital-domain.net>

>>> On Tue, 9 Oct 2007 16:36:35 +0100, Andrew Clayton
>>> <andrew@digital-domain.net> said:

andrew> [ ... ] The basic problem I am seeing is that
andrew> applications on client workstations whose home
andrew> directories are NFS mounted are stalling in filesystem
andrew> calls such as open, close, unlink.

Metadata and data sync/flushing can be handled very differently
by the same filesystem and by different filesystems.

[ ... ]

andrew> [ ... ] e.g $ strace -T -e open fslattest test
andrew> And then after a few seconds run
andrew> $ dd if=/dev/zero of=bigfile bs=1M count=500
andrew> I see the following

So metadata and data sync/flush are competing, and also
'dd' is hitting heavily the buffer cache, with 500MB on
a 768MB system.

andrew> Before dd kicks in
andrew> open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.005043>
andrew> [ ... ] while dd is running
andrew> open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <2.000348>
andrew> [ ... ] Doing the same thing with ext3 shows no such
andrew> stalls.

All this does not sound that susprising to me.

[ ... ]

andrew> I Just tried the above on a machine here in the
andrew> office. It seems to have a much faster disk than mine,
andrew> and the latencies aren't quite a dramatic upto about 1.0
andrew> seconds. Mounting with nobarrier reduces that to
andrew> generally < 0.5 seconds.

That's a rather clear hint I suppose.

My suggestion would be to run 'vmstat 1' watching in particular
the cache and 'bi'/'bo' columns while doing experiments with:

* Increasing value of the 'commit' mount option of 'ext3'.
* Different value of the 'data' mount option of 'ext3'.
* The elevator algorithm for the affected disks.
* Changing values of '/proc/sys/net/bdflush'.
* The 'oflag=direct' option of 'dd'.

And the impact the above have on the memory-write-caching of
XFS and the ordering of CPU and disk operations in general.

There are many odd interactions of these parameters, here is an
example of a discussion of a different case:

  http://www.sabi.co.uk/blog/0707jul.html#070701b

Also, having a look at some bits of your Linux RAID list post:

  > /dev/md0 is currently mounted with the following options
  > noatime,logbufs=8,sunit=512,swidth=1024

  > xfs_info shows
  > [ ... ]
  >       =                       sunit=64     swidth=128 blks, unwritten=1

  > Chunk Size : 256K
  > [ ... ]
  >    0       8       17        0      active sync   /dev/sdb1
  >    1       8       33        1      active sync   /dev/sdc1
  >    2       8       49        2      active sync   /dev/sdd1

It might we useful to reconsider some of the build vs. mount
parameters, and the chunk size (consider the non trivial issue
of excessive stripe length).
