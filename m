Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41DUTG1177575 for <xfs@OSS.SGI.com>; Sun, 1 May 2011 08:30:29 -0500
Received: from hermes2.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB82B1E19727
	for <xfs@OSS.SGI.com>; Sun,  1 May 2011 06:34:03 -0700 (PDT)
Received: from hermes2.dur.ac.uk (hermes2.dur.ac.uk [129.234.248.2]) by
	cuda.sgi.com with ESMTP id GAr2ZLB9WSj2tNQC for
	<xfs@OSS.SGI.com>; Sun, 01 May 2011 06:34:03 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <19901.24858.153461.377763@tree.ty.sabi.co.UK>
Date: Sun, 1 May 2011 14:33:14 +0100
Subject: Re: xfs performance problem
In-Reply-To: <4DB75C6D.1080901@inf.ethz.ch>
References: <4DB72084.8020205@inf.ethz.ch> <4DB74331.3030804@hardwarefreak.com>
	<4DB75C6D.1080901@inf.ethz.ch>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>, Linux fs JFS <jfs-discussion@lists.SourceForge.net>

[ ... ]

> I thought I would do a real measurement to have some numbers.
> On my raid-1 ext3, extracting a kernel archive:

> benjamin@metis ~/software $ time tar xfj
> /usr/portage/distfiles/linux-2.6.38.tar.bz2

> real    0m21.769s
> user    0m13.905s
> sys     0m1.751s

That's a "real measurement" of *something*, and it does give
"some numbers", but to me the numbers are not that interesting
as it is far from clear what they are about.

So I happen to have an otherwise totally unused fastish
contemporary 500GB disk and laptop for a measurement of
something that might be better defined, a bit simplemindedly,
but taking care about a few details (see also appended setup
details), so that the numbers be about as good as possible
(YMMV).

First with 'ext3':

  % mount -t ext3 -o relatime /dev/sdb /mnt/sdb
  % df -BM /mnt/sdb
  Filesystem           1M-blocks      Used Available Use% Mounted on
  /dev/sdb               469455M      687M   444922M   1% /mnt/sdb
  % df -i /mnt/sdb
  Filesystem            Inodes   IUsed   IFree IUse% Mounted on
  /dev/sdb             30531584   38100 30493484    1% /mnt/sdb
  % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar; cd /; umount /mnt/sdb'
  star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

  real    12m49.610s
  user    0m0.990s
  sys     0m8.610s

That's like 570KB/s and 50 files/s, in more or less optimal
conditions. Not so good for 'ext3', which indeed is well known
for appalling small file/metadata write performance, but the
order-of-magnitude of the results is the plausible one.

XFS with 'delaylog' does worse, but then it has a difference
tradeoff envelope:

  % mount -t xfs -o relatime,delaylog /dev/sdb /mnt/sdb
  % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar; cd /; umount /mnt/sdb'
  star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

  real    24m4.282s
  user    0m1.260s
  sys     0m14.030s

I also tried with JFS and it is faster at 1MB/s and 90 files/s
which is pretty good (and I suspect that JFS may be cheating
slightly on the semantics, but I know about its on-disk
structure and twice as fast as 'ext3' is plausible):

  % mount -t jfs -o relatime /dev/sdb /mnt/sdb
  % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar; cd /; umount /mnt/sdb'
  star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

  real    6m56.508s
  user    0m1.000s
  sys     0m7.130s

Consolation notes :-)
=====================

  Naturally the real (and arguably rather more meaningful than
  others) measurements above will be baffling those described
  here:

    [ ... ] many people (some with decades of "experience") just
    don't understand IOPS and metadata and commits and caching and
    who think "performance" is whatever number they can get with
    their clever "benchmarks". 

  So as a consolation prize to them let's rerun with entirely
  different semantics but still taking a bit of care:

    % mount -t ext3 -o relatime /dev/sdb /mnt/sdb
    % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar -no-fsync; cd /; umount /mnt/sdb'
    star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

    real    0m27.414s
    user    0m0.270s
    sys     0m2.430s

  Oh gosh, it looks like much better "performance"! 'ext3' really
  rises and shines with contiguous large IOs! :-)

  And similarly for XFS:

    % mount -t xfs -o relatime,delaylog /dev/sdb /mnt/sdb
    % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar -no-fsync; cd /; umount /mnt/sdb'
    star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

    real    0m33.849s
    user    0m0.310s
    sys     0m2.960s

    % mount -o relatime /dev/sdb /mnt/sdb

  And JFS is quite similar too:

    % mount -t jfs -o relatime /dev/sdb /mnt/sdb
    % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar -no-fsync; cd /; umount /mnt/sdb'
    star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

    real    0m35.191s
    user    0m0.380s
    sys     0m2.920s

Journaling notes
================

  So there. I apologize to the readers who "understand IOPS and
  metadata and commits and caching" (and who may have read the
  man-page for 'star') who will be bored with the beginner-level
  nature of the points made above.

  But I am actually a bit surprised disappointed with the "really"
  numbers above because I would expected something more like 2-3
  minutes duration or 2-4 files/s per IOPS, but I guess such are
  the horrors of seeking crazily between journal and metadata and
  data space, so let's try without a journal with 'ext2':

    % mount -t ext2 -o relatime /dev/sdb /mnt/sdb
    % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar; cd /; umount /mnt/sdb'                             star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

    real    8m12.196s
    user    0m1.120s
    sys     0m6.030s

  Sure it is better, that's 50% faster than 'ext3'.

  Let'a also try as a special case 'ext4' (yes, 'ext4' with its
  many improvements) without a journal:

    % mkfs.ext4 -O ^has_journal /dev/sdb                                                                                    
    mke2fs 1.41.11 (14-Mar-2010)
    /dev/sdb is entire device, not just one partition!
    Proceed anyway? (y,n) y
    [ ... ]
    % mount -t ext4 -o relatime /dev/sdb /mnt/sdb
    % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar; cd /; umount /mnt/sdb'
    star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

    real    0m31.119s
    user    0m0.870s
    sys     0m6.190s

  Well, I don't believe that. That looks like a feature or bug in
  'ext4' where without a journal it won't honor commits. The same
  appears to be the case for JFS, but then the manual explicitly
  says that 'nointegrity' is aptly named, and so it is be;lievable
  that switching off journaling is not its only effect:

    % mount -t jfs -o relatime,nointegrity /dev/sdb /mnt/sdb
    % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar; cd /; umount /mnt/sdb'
    star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

    real    0m35.820s
    user    0m0.610s
    sys     0m5.740s

Setup details
=============

  ULTS10 64b, 2.6.35 kernel, 4GiB RAM, I3-M370 CPU. Quiet except
  for measurements. Every 'tar' extraction is preceded by a
  re-'mkfs'. Note the details below (e.g. the archive is
  uncompressed and stored in in-memory 'tmpfs', the disk is a
  fairly fast 500GB drive on eSATA).

  ----------------------------------------------------------------
    % dd bs=1M if=/tmp/linux-2.6.38.tar of=/dev/null
    420+1 records in
    420+1 records out
    440483840 bytes (440 MB) copied, 0.159935 s, 2.8 GB/s
  ----------------------------------------------------------------
    % hdparm -t /dev/sdb

    /dev/sdb:
     Timing buffered disk reads:  388 MB in  3.01 seconds = 128.98 MB/sec
  ----------------------------------------------------------------
    % lsscsi  | grep sdb
    [4:0:0:0]    disk    ATA      ST3500418AS      CC44  /dev/sdb
  ----------------------------------------------------------------
    % mkfs.ext3 /dev/sdb
    mke2fs 1.41.11 (14-Mar-2010)
    /dev/sdb is entire device, not just one partition!
    Proceed anyway? (y,n) y
    Filesystem label=
    OS type: Linux
    Block size=4096 (log=2)
    Fragment size=4096 (log=2)
    Stride=0 blocks, Stripe width=0 blocks
    30531584 inodes, 122096646 blocks
    6104832 blocks (5.00%) reserved for the super user
    First data block=0
    Maximum filesystem blocks=4294967296
    3727 block groups
    32768 blocks per group, 32768 fragments per group
    8192 inodes per group
    Superblock backups stored on blocks: 
	    32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	    4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
	    102400000

    Writing inode tables: done                            
    Creating journal (32768 blocks): done
    Writing superblocks and filesystem accounting information: done

    This filesystem will be automatically checked every 32 mounts or
    180 days, whichever comes first.  Use tune2fs -c or -i to override.
  ----------------------------------------------------------------
    % mkfs.xfs -f /dev/sdb
    meta-data=/dev/sdb               isize=256    agcount=4, agsize=30524162 blks
	     =                       sectsz=512   attr=2
    data     =                       bsize=4096   blocks=122096646, imaxpct=25
	     =                       sunit=0      swidth=0 blks
    naming   =version 2              bsize=4096   ascii-ci=0
    log      =internal log           bsize=4096   blocks=59617, version=2
	     =                       sectsz=512   sunit=0 blks, lazy-count=1
    realtime =none                   extsz=4096   blocks=0, rtextents=0
  ----------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
