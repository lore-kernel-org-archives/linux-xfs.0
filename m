Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 04:32:35 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IBWUbm017040
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 04:32:31 -0700
Date: Wed, 18 Jul 2007 07:32:33 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
In-Reply-To: <469DF8D3.8020908@theendofthetunnel.de>
Message-ID: <Pine.LNX.4.64.0707180732140.7659@p34.internal.lan>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
 <20070718110525.GF13772@boogie.lpds.sztaki.hu> <Pine.LNX.4.64.0707180718000.7659@p34.internal.lan>
 <469DF8D3.8020908@theendofthetunnel.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hannes Dorbath <light@theendofthetunnel.de>
Cc: Gabor Gombas <gombasg@sztaki.hu>, linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org



On Wed, 18 Jul 2007, Hannes Dorbath wrote:

> On 18.07.2007 13:19, Justin Piszcz wrote:
>> For the HW RAID tests (2) at the bottom of the e-mail, no, I did not set 
>> nr_requests or use the deadline scheduler.
>> 
>> For the SW RAID tests, I applied similar optimizations, I am probably not 
>> at the latest firmware.  The main thing I wanted to use though was SW RAID 
>> because the card itself offers so many ports, however, with write speed 
>> being that slow I am not sure its a good idea.
>
> I think what you might be experiencing is that XFS can read su,sw values from 
> the MD device and will automatically optimize itself, while it can't do that 
> for the HW RAID device. It is absolutely essential to align your file system, 
> to prevent implicit reads, needed for parity calculations.
>
> Set su to the stripe size you have configured in your controller (like 128K) 
> and sw to 9 (for a 10 disk RAID 5 array).
>
>
> -- 
> Regards,
> Hannes Dorbath
>

Yes I agree here, but I guess my question is why is SW RAID5 so slow on 
the 3ware card?

Justin.
