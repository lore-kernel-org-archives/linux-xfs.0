Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 05:26:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5HCQnrD019247
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 05:26:49 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 612BF23DC9E
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 05:27:47 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id ydxWzOAcGQTnugUH for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 05:27:47 -0700 (PDT)
Date: Tue, 17 Jun 2008 08:27:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS mkfs/mount options
In-Reply-To: <153266.85236.qm@web34501.mail.mud.yahoo.com>
Message-ID: <alpine.DEB.1.10.0806170827400.32440@p34.internal.lan>
References: <153266.85236.qm@web34501.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark <musicman529@yahoo.com>
Cc: xfs@oss.sgi.com

How did you tune your IRQ delivery?

Justin.

On Tue, 17 Jun 2008, Mark wrote:

> --- On Tue, 6/17/08, Dave Chinner <david@fromorbit.com> wrote:
>
>>> For each of these kernel threads, only those on CPU #2
>> are actually pulling notable load. Why is this?
>>
>> Because your disk interrupts are delivered to that CPU
>> only.
>
> Thank you! Tuning my IRQ delivery gave a noticeable speed-up.
>
> -- 
> Mark
>
> "What better place to find oneself than
> on the streets of one's home village?"
>      --Capt. Jean-Luc Picard, "Family"
>
>
