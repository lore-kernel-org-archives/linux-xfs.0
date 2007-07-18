Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 04:38:15 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IBc9bm019778
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 04:38:11 -0700
Date: Wed, 18 Jul 2007 07:38:12 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
In-Reply-To: <469DFB6B.2000103@theendofthetunnel.de>
Message-ID: <Pine.LNX.4.64.0707180738070.7659@p34.internal.lan>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
 <20070718110525.GF13772@boogie.lpds.sztaki.hu> <Pine.LNX.4.64.0707180718000.7659@p34.internal.lan>
 <469DF8D3.8020908@theendofthetunnel.de> <Pine.LNX.4.64.0707180732140.7659@p34.internal.lan>
 <469DFB6B.2000103@theendofthetunnel.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hannes Dorbath <light@theendofthetunnel.de>
Cc: Gabor Gombas <gombasg@sztaki.hu>, linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org



On Wed, 18 Jul 2007, Hannes Dorbath wrote:

> On 18.07.2007 13:32, Justin Piszcz wrote:
>> Yes I agree here, but I guess my question is why is SW RAID5 so slow on the 
>> 3ware card?
>
> I think the controller does disable the drives write cache when exported 
> unconfigured. It does always disable, unless you put the drive in a unit  and 
> explicit set the profile to `Performance'.
>
>
> -- 
> Regards,
> Hannes Dorbath
>

Ahh, that could explain it!
