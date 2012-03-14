Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2EHhlTO217667 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 12:43:47 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id 8jSM74oadKBdWzrq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Mar 2012 10:43:45 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1S7sEi-0003ru-Op
	for xfs@oss.sgi.com; Wed, 14 Mar 2012 10:43:44 -0700
Message-ID: <33504048.post@talk.nabble.com>
Date: Wed, 14 Mar 2012 10:43:44 -0700 (PDT)
From: troby <Thorn.Roby@harlandfs.com>
Subject: Re: How to deal with XFS stripe geometry mismatch with hardware RAID5
In-Reply-To: <4F605877.2030304@hardwarefreak.com>
MIME-Version: 1.0
References: <33498437.post@talk.nabble.com>
	<4F605877.2030304@hardwarefreak.com>
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


/dev/sdb1       /data   xfs    
defaults,logdev=/dev/sda3,logbsize=256k,logbufs=8,largeio,nobarrier

meta-data=/dev/sdb1              isize=256    agcount=32, agsize=251772920
blks
         =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=8056733408, imaxpct=2
         =                       sunit=2      swidth=24 blks, unwritten=1
naming   =version 2              bsize=4096
log      =external               bsize=4096   blocks=16000, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


Mongo pre-allocates its datafiles and zero-fills them (there is a short
header at the start of each, not rewritten as far as I know)  and then
writes to them sequentially, wrapping around when it hits the end. In this
case the entire load is inserts, no updates, hence the sequential writes.
The data will not wrap around for about 6 months, at which time old files
will be overwritten starting from the beginning. The BBU is functioning and
the cache is set to write-back. The files are memory-mapped, I'll check
whether fsync is used. Flushing is done about every 30 seconds and takes
about 8 seconds.

One thing I'm wondering is whether the incorrect stripe structure I
specified with mkfs is actually written into the file system structure or
effectively just a hint to the kernel for what to use for a write size. If
not, could I specify the correct stripe width in the mount options and
override the incorrect width used by mkfs? Since the current average write
size is only about half the specified stripe size, and since I'm not using
md or xfs v.3 it seems the kernel is ignoring it for now. 


Stan Hoeppner wrote:
> 
> On 3/13/2012 6:21 PM, troby wrote:
> 
>> Short of recreating the filesystem with the correct stripe width, would
>> it
>> make sense to change the mount options to define a stripe width that
>> actually matches either the filesystem (11 stripe elements wide) or the
>> hardware (12 stripe elements wide)? Is there a danger of filesystem
>> corruption if I give fstab a mount geometry that doesn't match the values
>> used at filesystem creation time?
> 
> What would make sense is for you to first show
> 
> $ cat /etc/fstab
> $ xfs_info /dev/raid_device_name
> 
> before we recommend any changes.
> 
>> I'm unclear on the role of the RAID hardware cache in this. Since the
>> writes
>> are sequential, 
> 
> This seems to be an assumption at odds with other information you've
> provided.
> 
>> and since the volume of data written is such that it would
>> take about 3 minutes to actually fill the RAID cache, 
> 
> The PERC 700 operates in write-through cache mode if no BBU is present
> or the battery is degraded or has failed.  You did not state whether
> your PERC 700 has the BBU installed.  If not, you can increase write
> performance and decrease latency pretty substantially by adding the BBU
> which enables the write-back cache mode.
> 
> You may want to check whether MongoDB uses fsync writes by default.  If
> it does, and you don't have the BBU and write-back cache, this is
> affecting your write latency and throughput as well.
> 
>> I would think the data
>> would be resident in the cache long enough to assemble a full-width
>> stripe
>> at the hardware level and avoid the 4 I/O RAID5 penalty. 
> 
> Again, write-back-cache is only enabled with BBU on the PERC 700.  Do
> note that achieving full stripe width writes is as much a function of
> your application workload and filesystem tuning as it is the RAID
> firmware, especially if the cache is in write-through mode, in which
> case the firmware can't do much, if anything, to maximize full width
> stripes.
> 
> And keep in mind you won't hit the parity read-modify-write penalty on
> new stripe writes.  This only happens when rewriting existing stripes.
> Your reported 50ms of latency for 100KB write IOs seems to suggest you
> don't have the BBU installed and you're actually doing RMW on existing
> stripes, not strictly new stripe writes.  This is likely because...
> 
> As an XFS filesystem gets full (you're at ~87%), file blocks may begin
> to be written into free space within existing partially occupied RAID
> stripes.  This is where the RAID5/6 RMW penalty really kicks you in the
> a$$, especially if you have misaligned the filesystem geometry to the
> underlying RAID geometry.
> 
> -- 
> Stan
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
> 

-- 
View this message in context: http://old.nabble.com/How-to-deal-with-XFS-stripe-geometry-mismatch-with-hardware-RAID5-tp33498437p33504048.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
