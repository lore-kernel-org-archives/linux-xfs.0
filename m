Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2Q20t8v179527 for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 21:00:55 -0500
Received: from bifrost.lang.hm (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B57421A58087
	for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 19:02:37 -0700 (PDT)
Received: from bifrost.lang.hm (mail.lang.hm [64.81.33.126]) by cuda.sgi.com
	with ESMTP id cbnAs38xYUWeT2uV for <xfs@oss.sgi.com>;
	Thu, 25 Mar 2010 19:02:37 -0700 (PDT)
Date: Thu, 25 Mar 2010 19:02:31 -0700 (PDT)
From: david@lang.hm
Subject: Re: 128TB filesystem limit?
In-Reply-To: <20100326003511.GN3335@dastard>
Message-ID: <alpine.DEB.2.00.1003251900110.12435@asgard.lang.hm>
References: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
	<20100325235433.GM3335@dastard>
	<alpine.DEB.2.00.1003251702190.12435@asgard.lang.hm>
	<20100326003511.GN3335@dastard>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, 26 Mar 2010, Dave Chinner wrote:

> On Thu, Mar 25, 2010 at 05:03:52PM -0700, david@lang.hm wrote:
>> On Fri, 26 Mar 2010, Dave Chinner wrote:
>>
>>> On Thu, Mar 25, 2010 at 04:15:42PM -0700, david@lang.hm wrote:
>>>> I'm working with a raid 0 (md) array on top of 10 16x1TB raid 6
>>>> hardware arrays.
> ....
>>>> I then did mkfs.xfs /dev/md0
>>>>
>>>> but a df is showing me 128TB
>>>
>>> What is in /proc/partitions?
>>
>> # cat /proc/partitions
>> major minor  #blocks  name
>>
>>    8        0  292542464 sda
>>    8        1    2048287 sda1
>>    8        2    2048287 sda2
>>    8        3    2048287 sda3
>>    8        4  286390755 sda4
>>    8       16 13671874048 sdb
>>    8       17 13671874014 sdb1
>>    8       32 13671874048 sdc
>>    8       33 13671874014 sdc1
> ....
>>    8      160 13671874048 sdk
>>    8      161 13671874014 sdk1
>>    9        0 136718739840 md0
>
> Is there any reason for putting partitions on these block devices?
> You could just use the block devices without partitions, and that
> will avoid alignment potential problems....

I would like to raid to auto-assemble and I can't do that without 
partitions, can I

>>>> is this just rounding error combined with the 1000=1k vs 1024=1k
>>>> marketing stuff,
>>>
>>> Probably.
>>>
>>>> or is there some limit I am bumping into here.
>>>
>>> Unlikely to be an XFS limit - I was doing some "what happens if"
>>> testing on multi-PB sized XFS filesystems hosted on sparse files
>>> a couple of days ago....
>>
>> Ok, 128TB is a suspiciously round (in computer terms) number,
>> especially when the math is 10 sets of 14 drives (each 1TB), so I
>> figured I'd double check.
>
> 136718739840 / 10^9 = 136.72TB    <==== marketing number
> 136718739840 / 2^30 = 127.33TiB   <==== what df shows

Thanks.

the next fun thing is figuring out what sort of stride, etc parameters I 
should have used for this filesystem.

David Lang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
