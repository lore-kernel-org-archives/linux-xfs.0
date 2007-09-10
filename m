Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 08:45:50 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AFjg4p012971
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 08:45:44 -0700
Date: Mon, 10 Sep 2007 11:45:44 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Attempt to Access Beyond End of Device
In-Reply-To: <1189436396.4385.49.camel@auctoritas.fs3.ph>
Message-ID: <Pine.LNX.4.64.0709101145260.897@p34.internal.lan>
References: <1189432747.4385.27.camel@auctoritas.fs3.ph>
 <Pine.LNX.4.64.0709101041390.897@p34.internal.lan> <1189436396.4385.49.camel@auctoritas.fs3.ph>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Federico Sevilla III <jijo@fs3.ph>
Cc: linux-xfs@oss.sgi.com, Alec Joseph Rivera <agi@fs3.ph>



On Mon, 10 Sep 2007, Federico Sevilla III wrote:

> On Mon, 2007-09-10 at 10:44 -0400, Justin Piszcz wrote:
>> I believe the logbsize should be in bytes, so 262144, it may also take
>> 256k though I have not tried it.
>
> It accepts 256k. The initial mount succeeded, and the problem did not
> surface until after some reboot (ie: not the first reboot, either, that
> went fine).
>
>> That looks mighty strange, what kind of raid card?
>
> This is the built-in Adaptec AACRAID of the IBM x3400, doing a pretty
> simplistic RAID 1.
>
> -- 
> Federico Sevilla III
> F S 3 Consulting Inc.
> http://www.fs3.ph
>

Have you checked the following page?

http://linuxmafia.com/faq/Hardware/sata.html

Does the error occur if you use a different filesystem?

Justin.
