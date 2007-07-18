Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 09:26:34 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IGQQbm016574
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 09:26:28 -0700
Date: Wed, 18 Jul 2007 12:26:29 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
In-Reply-To: <469DF039.4040906@theendofthetunnel.de>
Message-ID: <Pine.LNX.4.64.0707181225560.26004@p34.internal.lan>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
 <469DF039.4040906@theendofthetunnel.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hannes Dorbath <light@theendofthetunnel.de>
Cc: linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org



On Wed, 18 Jul 2007, Hannes Dorbath wrote:

> On 18.07.2007 12:23, Justin Piszcz wrote:
>> I am sure one of your questions is, well, why use SW RAID5 on the 
>> controller?  Because SW RAID5 is usually much faster than HW RAID5, at 
>> least in my tests:
>
> Though that's no answer to your question, I really can't confirm that. I'm 
> running a 3Ware 9650 with 8x 7200 SATAs in HW RAID 6. Writes are between 
> 340-360MB/sec and reads peak at 430-450MB/sec. That seems to be the absolute 
> possible maximum those drives can deliver. The card even seems to do some 
> really smart stuff, as the read speed is in excess of the physical raw speed 
> of 6 drives.
>
> You have done the usual settings, 3Ware recommends?
>
> echo 64 > /sys/block/sda/queue/max_sectors_kb
> echo 512 > /sys/block/sda/queue/nr_requests
> echo "deadline" > /sys/block/sda/queue/scheduler
> blockdev --setra 16384 /dev/sdX
>
> Have you set the correct su,sw options for XFS?
>
>
> -- 
> Regards,
> Hannes Dorbath
>

I will try these options during future testing and re-visit the speeds of 
regular HW RAID5, thanks!  I know they are part of the 3ware doc and I 
need to re-bench with these.
