Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o825b1Hd187615 for <xfs@oss.sgi.com>; Thu, 2 Sep 2010 00:37:01 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34F481BF80C1
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 22:37:40 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id kALDIF62VPmntPWD
	for <xfs@oss.sgi.com>; Wed, 01 Sep 2010 22:37:40 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 0D0176C004
	for <xfs@oss.sgi.com>; Thu,  2 Sep 2010 00:37:40 -0500 (CDT)
Message-ID: <4C7F3823.1040404@hardwarefreak.com>
Date: Thu, 02 Sep 2010 00:37:39 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
References: <201009010130.41500@zmi.at>
	<20100901000631.GO705@dastard>	<201009010222.57350@zmi.at>
	<20100901031954.GP705@dastard>	<4C7DD99F.7000401@hardwarefreak.com>
	<20100901064439.GR705@dastard>
In-Reply-To: <20100901064439.GR705@dastard>
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
To: xfs@oss.sgi.com

Dave Chinner put forth on 9/1/2010 1:44 AM:

> 4p VM w/ 2GB RAM with the
> disk image on a hw-RAID1 device make up of 2x500Gb SATA drives (create
> and remove 800k files):

> FSUse%        Count         Size    Files/sec     App Overhead
>      2       800000            0      54517.1          6465501
> $
> 
> The same test run on a 8p VM w/ 16Gb RAM, with the disk image hosted
> on a 12x2TB SAS dm RAID-0 array:
> 
> FSUse%        Count         Size    Files/sec     App Overhead
>      2       800000            0      51409.5          6186336

Is this a single socket quad core Intel machine with hyperthreading
enabled?  That would fully explain the results above.  Looks like you
ran out of memory bandwidth in the 4 "processor" case.  Adding phantom
CPUs merely made them churn without additional results.

> It was a bit slower despite having a disk subsystem with 10x the
> bandwidth and 20-30x the iops capability...
> 
>> Are you implying/stating that the performance of the disk subsystem is
>> irrelevant WRT multithreaded unlink workloads with delaylog enabled?
> 
> Not entirely irrelevant, just mostly. ;) For workloads that have all
> the data cached in memory, anyway (i.e. not read latency bound).
> 
>> If so, this CPU hit you describe is specific to this workload scenario
>> only, not necessarily all your XFS test workloads, correct?
> 
> It's not a CPU hit - the CPU is gainfully employed doing more work.
> e.g. The same test as above without delayed logging on the 4p VM:
> 
> FSUse%        Count         Size    Files/sec     App Overhead
>      2       800000            0      15118.3          7524424
> 
> delayed logging is 3.6x faster on the same filesystem. It went from
> 15k files/s at ~120% CPU utilisation, to 54k files/s at 400% CPU
> utilisation. IOWs, it is _clearly_ CPU bound with delayed logging as
> there is no idle CPU left in the VM at all.

Without seeing all of what you have available, going on strictly the
data above, I disagree.  I'd say your bottleneck is your memory/IPC
bandwidth.

> When trying to improve filesystem performance, there are two goals
> we are trying to acheive depending on the limiting factor:
> 
> 	1. If the workload is IO bound, we want to improve the IO
> 	patterns enough that performance becomes CPU bound.
> 
> 	2. If the workload is CPU bound, we want to reduce the
> 	per-operation CPU overhead to the point where the workload
> 	becomes IO bound.
> 
> Delayed logging has acheived #1 for metadata operations. To get
> further improvements, we now need to start optimising based on
> #2....

If my guess about your platform is correct, try testing on a dual socket
quad core Opteron with quad memory channels.  Test with 2, 4, 6, and 8
fs_mark threads.  I'm guessing at some point between 4 and 8 threads
you'll run out of memory bandwidth, and from then on you won't see the
additional CPU burn that you are with Intel hyperthreading.

Also, I've not looked at the code, but is there possibly a delayed
logging global data structure stored in a shared memory location that
each thread accesses frequently?  If so, that might appear as memory B/W
starvation, and make each processor appear busy because they're all
waiting on access to that shared object.  Just a guess from non-dev end
user with a lot of hardware knowledge and not enough coding skillz. ;)

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
