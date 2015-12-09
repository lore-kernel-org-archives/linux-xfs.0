Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C367B7F50
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 02:37:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BB07AC003
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 00:37:26 -0800 (PST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id wwfBEcSDefFLunFt
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 09 Dec 2015 00:37:23 -0800 (PST)
Received: by wmww144 with SMTP id w144so62363102wmw.0
	for <xfs@oss.sgi.com>; Wed, 09 Dec 2015 00:37:22 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com>
	<20151201185113.GG26129@bfoster.bfoster>
	<565DF472.8080101@scylladb.com> <20151202001329.GA9633@bfoster.bfoster>
	<565EAD06.5060403@scylladb.com> <20151208060343.GC19802@dastard>
	<5666E1A4.4070805@scylladb.com> <20151208233219.GH19802@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <5667E840.6030208@scylladb.com>
Date: Wed, 9 Dec 2015 10:37:20 +0200
MIME-Version: 1.0
In-Reply-To: <20151208233219.GH19802@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com



On 12/09/2015 01:32 AM, Dave Chinner wrote:
> On Tue, Dec 08, 2015 at 03:56:52PM +0200, Avi Kivity wrote:
>> On 12/08/2015 08:03 AM, Dave Chinner wrote:
>>> On Wed, Dec 02, 2015 at 10:34:14AM +0200, Avi Kivity wrote:
>>>> On 12/02/2015 02:13 AM, Brian Foster wrote:
>>>>> Metadata is modified in-core and handed off to the logging
>>>>> infrastructure via a transaction. The log is flushed to disk some time
>>>>> later and metadata writeback occurs asynchronously via the xfsaild
>>>>> thread.
>>>> Unless, I expect, if the log is full.  Since we're hammering on the
>>>> disk quite heavily, the log would be fighting with user I/O and
>>>> possibly losing.
>>>>
>>>> Does XFS throttle user I/O in order to get the log buffers recycled faster?
>>> No. XFS tags the metadata IO with REQ_META that the IO schedulers
>>> can tell the difference between metadata and data IO, and schedule
>>> them appropriately. Further. log buffers are also tagged with
>>> REQ_SYNC to indicate they are latency sensitive IOs, whcih the IO
>>> schedulers again treat differently to minimise latency in the face
>>> of bulk async IO which is not latency sensitive.
>>>
>>> IOWs, IO prioritisation and dispatch scheduling is the job of the IO
>>> scheduler, not the filesystem. The filesystem just tells the
>>> scheduler how to treat the different types of IO...
>>>
>>>> Is there any way for us to keep track of it, and reduce disk
>>>> pressure when it gets full?
>>> Only if you want to make more problems for yourself - second
>>> guessing what the filesystem is going to do will only lead you to
>>> dancing the Charlie Foxtrot on a regular basis. :/
>> So far the best approach I found that doesn't conflict with this is
>> to limit io_submit iodepth to the natural disk iodepth (or a small
>> multiple thereof).  This seems to keep XFS in its comfort zone, and
>> is good for latency anyway.
> That's pretty much what I just explained in my previous reply.  ;)
>
>> The only issue is that the only way to obtain this parameter is to
>> measure it.
> Yup, exactly what I've been saying ;)
>
> However, You can get a pretty good guess on max concurrency from the
> device characteristics in sysfs:
>
> /sys/block/<dev>/queue/nr_requests

That's just a fixed number. AFAICT, it isn't derived from the actual device.

"measure it" is better than nothing, but when you want to distribute 
software that works out of the box and does not need extensive tuning, 
it leaves something to be desired.

I'm thinking about detecting the limit dynamically (below the limit, 
throughput is roughly proportional to concurrency; above the limit, 
throughput is fixed while latency is proportional to concurrency). The 
problem is that the measurement is very noisy, the more so because we 
are two layers above the hardware, and driving it from cores that try 
very hard not to communicate.

The right place to do this is the block layer.

> gives you the maximum IO scheduler request queue depth, and
>
> /sys/block/<dev>/device/queue_depth
>
> gives you the hardware command queue depth.

That's more useful, but it really describes the bus/link/protocol rather 
than the device itself.

I don't have this queue_depth attribute for my nvme0n1 device (4.1.7).

>
> E.g. a random iscsi device I have attached to a test VM:
>
> $ cat /sys/block/sdc/device/queue_depth
> 32
> $ cat /sys/block/sdc/queue/nr_requests
> 127
>
> Which means 32 physical IOs can be in flight concurrently, and the
> IO scheduler will queue up to roughly another 100 discrete IOs
> before it starts blocking incoming IO requests (127 is the typical
> io scheduler queue depth default). That means maximum non-blocking
> concurrency is going to be around 100-130 IOs in flight at once.
>
>> I wrote a small tool to do this [1], but it's a hassle for users.
>>
>> [1] https://github.com/avikivity/diskplorer
> I note that the NVMe device you tested in the description hits
> maximum performance with concurrency at around 110-120 read IOs in
> flight. :)
>
>

We increased nr_requests for the test so it wouldn't block.  So it's the 
actual device characteristics, not an artifact of the software stack.  
If you consider a RAID of these, you can easily need a few hundred 
concurrent ops.

IIRC nvme's maximum iodepth is 64k.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
