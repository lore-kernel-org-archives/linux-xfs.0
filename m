Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o816i5RM112898 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 01:44:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 490AC3E281
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 23:44:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	L6g4yW0EceiJOw0R for <xfs@oss.sgi.com>;
	Tue, 31 Aug 2010 23:44:42 -0700 (PDT)
Date: Wed, 1 Sep 2010 16:44:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
Message-ID: <20100901064439.GR705@dastard>
References: <201009010130.41500@zmi.at> <20100901000631.GO705@dastard>
	<201009010222.57350@zmi.at> <20100901031954.GP705@dastard>
	<4C7DD99F.7000401@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C7DD99F.7000401@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 31, 2010 at 11:42:07PM -0500, Stan Hoeppner wrote:
> Dave Chinner put forth on 8/31/2010 10:19 PM:
> > On Wed, Sep 01, 2010 at 02:22:31AM +0200, Michael Monnerie wrote:
> >>
> >> This is a hexa-core AMD Phenom(tm) II X6 1090T Processor with up to 
> >> 3.2GHz per core, so that shouldn't be
> > 
> > I'm getting a 8core/16thread server being CPU bound with multithreaded
> > unlink workloads using delaylog, so it's entirely possible that all
> > CPU cores are fully utilised on your machine.
> 
> What's your disk configuration on this 8 core machine?

Depends on where I place the disk image for the VM's I run on it ;)

For example, running fs_mark with 4 threads to create then delete
200k files in a directory per thread in a 4p VM w/ 2GB RAM with the
disk image on a hw-RAID1 device make up of 2x500Gb SATA drives (create
and remove 800k files):

$ sudo mkfs.xfs -f -l size=128m -d agcount=16 /dev/vdb
meta-data=/dev/vdb               isize=256    agcount=16, agsize=163840 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo mount -o delaylog,logbsize=262144,nobarrier /dev/vdb /mnt/scratch
$ sudo chmod 777 /mnt/scratch
$ ./fs_mark -S0 -k -n 200000 -s 0 -d /mnt/scratch/0 -d /mnt/scratch/1 -d /mnt/scratch/3 -d /mnt/scratch/2

#  ./fs_mark  -S0  -k  -n  200000  -s  0  -d  /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/3  -d  /mnt/scratch/2
#       Version 3.3, 4 thread(s) starting at Wed Sep  1 16:08:20 2010
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  no subdirectories used
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 0 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     2       800000            0      54517.1          6465501
$

The same test run on a 8p VM w/ 16Gb RAM, with the disk image hosted
on a 12x2TB SAS dm RAID-0 array:

FSUse%        Count         Size    Files/sec     App Overhead
     2       800000            0      51409.5          6186336

It was a bit slower despite having a disk subsystem with 10x the
bandwidth and 20-30x the iops capability...

> Are you implying/stating that the performance of the disk subsystem is
> irrelevant WRT multithreaded unlink workloads with delaylog enabled?

Not entirely irrelevant, just mostly. ;) For workloads that have all
the data cached in memory, anyway (i.e. not read latency bound).

> If so, this CPU hit you describe is specific to this workload scenario
> only, not necessarily all your XFS test workloads, correct?

It's not a CPU hit - the CPU is gainfully employed doing more work.
e.g. The same test as above without delayed logging on the 4p VM:

FSUse%        Count         Size    Files/sec     App Overhead
     2       800000            0      15118.3          7524424

delayed logging is 3.6x faster on the same filesystem. It went from
15k files/s at ~120% CPU utilisation, to 54k files/s at 400% CPU
utilisation. IOWs, it is _clearly_ CPU bound with delayed logging as
there is no idle CPU left in the VM at all.

When trying to improve filesystem performance, there are two goals
we are trying to acheive depending on the limiting factor:

	1. If the workload is IO bound, we want to improve the IO
	patterns enough that performance becomes CPU bound.

	2. If the workload is CPU bound, we want to reduce the
	per-operation CPU overhead to the point where the workload
	becomes IO bound.

Delayed logging has acheived #1 for metadata operations. To get
further improvements, we now need to start optimising based on
#2....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
