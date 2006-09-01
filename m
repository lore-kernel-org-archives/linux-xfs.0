Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Sep 2006 10:43:45 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k81HhWDW032586
	for <linux-xfs@OSS.SGI.com>; Fri, 1 Sep 2006 10:43:33 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1GJCbK-0006s4-L8
	for <linux-xfs@OSS.SGI.com>; Fri, 01 Sep 2006 18:14:42 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17656.27266.222500.130897@base.ty.sabi.co.UK>
Date: Fri, 1 Sep 2006 18:14:42 +0100
Subject: Re: XFS and 3.2TB Partition
In-Reply-To: <44F714F2.7050502@gmail.com>
References: <44F714F2.7050502@gmail.com>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Thu, 31 Aug 2006 12:57:22 -0400, Chris Hane
>>> <chrishane@gmail.com> said:

chrishane> I've tried to use parted without any success.  Here
chrishane> is what I've tried and the errors I get.

chrishane> parted
    parted> mklabel gpt
    parted> mkpart primary 0 3500GB
    parted> quit

Uhm, I had missed the 'mklabel gpt'. Unlike 'fdisk', which only
supports DOS-style partitions with a 2^32 sector limit (2TiB
indeed) the fairly recent GPT partition scheme (disk labeling in
the Linux kernel jargon) should support just about any size
partitions, with a 2^64 sector limit.

It is somewhat worrying that this happens:

chrishane> ok - the partition now exists.  If I use ext2
chrishane> everything works ok.  however, when I run mkfs.xfs
chrishane> /dev/sda1 the file system is formated but is
chrishane> truncated to to 2TB.

Now, you have succeeded in creating a 3.2TiB partition with
'ext2' on '/dev/sda1' with GPT, and with XFS directly on
'/dev/sda'. It is rather strange that it apparently did not
work with XFS on '/dev/sda1' with GPT.

perhaps 'mkfs.xfs' somehow has problems with the GPT scheme,
but that is indeed strange. It would have been interesting to
see what 'grep /dev/sda /proc/partitions' would have returned.

It might have been interesting to follow this suggestion too

  sandeen> mkfs.xfs uses the BLKGETSIZE64 and BLKGETSIZE ioctls
  sandeen> to determine device size; you might either instrument
  sandeen> xfsprogs/libxfs/linux.c and re-run, or strace your
  sandeen> mkfs command looking for those ioctl calls, to see
  sandeen> what size it's getting back from the kernel.

to see why 'mkfs.ext2' seems to get the right size of a GPT
partition but apparently not 'mkfs.xfs'.

BTW, I hope that you have got a 64 bit system and lots of RAM
for that 3.2TiB filesystem...

  http://OSS.SGI.com/archives/linux-xfs/2005-08/msg00045.html

BTW, for those following this thread: what other ways to create
and manage GPT disk labels are available under GNU/Linux other
than 'parted'?
