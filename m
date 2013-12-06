Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A0637F3F
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 02:59:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5008B8F809C
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 00:59:01 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id xyDHjAKNhfWqixLV
	for <xfs@oss.sgi.com>; Fri, 06 Dec 2013 00:58:30 -0800 (PST)
Message-ID: <52A191BA.20800@hardwarefreak.com>
Date: Fri, 06 Dec 2013 02:58:34 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Fwd: Sudden File System Corruption
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>	<52A03513.6030408@hardwarefreak.com>	<CAPd9ww9hsOFK6pxqRY-YtLLAkkJHCuSi1BaM4n9=2XTjNVAn2Q@mail.gmail.com>
	<CAPd9ww9QzFWUnLtzkdktd+fSX9pdft+wL6cvG2MzLpSdLko1dg@mail.gmail.com>
In-Reply-To: <CAPd9ww9QzFWUnLtzkdktd+fSX9pdft+wL6cvG2MzLpSdLko1dg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mike Dacre <mike.dacre@gmail.com>, xfs@oss.sgi.com

On 12/5/2013 9:58 AM, Mike Dacre wrote:

> On Thu, Dec 5, 2013 at 12:10 AM, Stan Hoeppner <stan@hardwarefreak.com>wrote:
>> On 12/4/2013 8:55 PM, Mike Dacre wrote:
>> ...
>
> Definitely RAID6
> 
> 2.  Strip size?  (eg 512KB)
>>
> 64KB

Ok, so 64*14 = 896KB stripe.  This seems pretty sane for a 14 spindle
parity array and mixed workloads.

> 4.  BBU module?
>>
> Yes. iBBU, state optimal, 97% charged.
> 
> 5.  Is write cache enabled?
>>
>> Yes: Cahced IO and Write Back with BBU are enabled.

I should have pointed you this this earlier:
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

but we've got most of it already.  We don't have your fstab mount
options.  Please provide that.

...
> This is also attached as xfs_info.txt

You're not aligning XFS to the RAID geometry (unless you're overriding
in fstab).  No alignment is good though for small (<896KB) file
allocations but less than optimal for large streaming allocation writes.
 But it isn't a factor in the problems you reported.

...
>> Good point.  These happened while trying to ls.  I am not sure why I can't
> find them in the log, they printed out to the console as 'Input/Output'
> errors, simply stating that the ls command failed.

We look for SCSI IO errors preceding an XFS error as a causal indicator.
 I didn't see that here.  You could have run into the bug Ben described
earlier.  I can't really speak to the console errors.

>> With delaylog enabled, which I believe it is in RHEL/CentOS 6, a single
>> big rm shouldn't kill the disks.  But with the combination of other
>> workloads it seems you may have been seeking the disks to death.
>>
> That is possible, workloads can get really high sometimes.  I am not sure
> how to control that without significantly impacting performance - I want a
> single user to be able to use 98% IO capacity sometimes... but other times
> I want the load to be split amongst many users.  

You can't control the seeking at the disks.  You can only schedule
workloads together that don't compete for seeks.  And if you have one
metadata or random read/write heavy workload, with this SATA RAID6
array, it will need exclusive access for the duration of execution, or
the portion that does all the random IO.  Otherwise other workloads
running concurrently will crawl while competing for seek bandwidth.

> Also, each user can
> execute jobs simultaneously on 23 different computers, each acessing the
> same drive via NFS.  This is a great system most of the time, but sometimes
> the workloads on the drive get really high.

So it's a small compute cluster using NFS over Infiniband for shared
file access to a low performance RAID6 array.  The IO resource sharing
is automatic.  But AFAIK there's no easy way to enforce IO quotas on
users or processes, if at all.  You may simply not have sufficient IO to
go around.  Let's ponder that.

Looking at the math, you currently have approximately 14*150=2100
seeks/sec capability with 14x 7.2k RPM data spindles.  That's less than
100 seeks/sec per compute node, i.e. each node is getting about 2/3rd of
the performance of a single SATA disk from this array.  This simply
isn't sufficient for servicing a 23 node cluster, unless all workloads
are compute bound, and none IO/seek bound.  Given the overload/crash
that brought you to our attention, I'd say some of your workloads are
obviously IO/seek bound.  I'd say you probably need more/faster disks.
Or you need to identify which jobs are IO/seek heavy and schedule them
so they're not running concurrently.

...
>> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E
>>
>> "As of kernel 3.2.12, the default i/o scheduler, CFQ, will defeat much
>> of the parallelization in XFS."
...
>> echo deadline > /sys/block/sda/queue/scheduler
>>
> Wow, this is huge, I can't believe I missed that.  I have switched it to
> noop now as we use write caching.  I have been trying to figure out for a
> while why I would keep getting timeouts when the NFS load was high.  If you
> have any other suggestions for how I can improve performance, I would
> greatly appreciate it.

This may not fix NFS timeouts entirely but it should help.  If the NFS
operations are seeking the disks to death you may still see timeouts.

>> This one simple command line may help pretty dramatically, immediately,
>> assuming your hardware array parameters aren't horribly wrong for your
>> workloads, and your XFS alignment correctly matches the hardware geometry.
>>
> Great, thanks.  Our workloads vary considerably as we are a biology
> research lab, sometimes we do lots of seeks, other times we are almost
> maxing out read or write speed with massively parallel processes all
> accessing the disk at the same time.

Do you use munin or something similar?  Sample output:
http://demo.munin-monitoring.org/munin-monitoring.org/demo.munin-monitoring.org/index.html#disk

Project page:
http://munin-monitoring.org/

It also has an NFS module and many others.  The storage oriented metrics
may be very helpful to you.  You would install munin-node on the NFS
server and all compute nodes, and munin on a collector/web server.  This
will allow you to cross reference client and server NFS loads.  You can
then cross reference the time in your PBS logs to see which users were
running which jobs when IO spikes occur on the NFS server.  You'll know
exactly which workloads, or combination thereof, are causing IO spikes.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
