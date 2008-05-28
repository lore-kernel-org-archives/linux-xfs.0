Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 May 2008 12:27:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4SJR7Y5008237
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 12:27:07 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C02A8119E082
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 12:27:59 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id AY8fIUESmsg5SLJ3 for <xfs@oss.sgi.com>; Wed, 28 May 2008 12:27:59 -0700 (PDT)
Date: Wed, 28 May 2008 15:27:58 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
In-Reply-To: <483DB0EC.3090403@redhat.com>
Message-ID: <alpine.DEB.1.10.0805281523560.29755@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483D7CE8.4000600@redhat.com> <alpine.DEB.1.10.0805281329450.29755@p34.internal.lan> <483DB0EC.3090403@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Wed, 28 May 2008, Chris Snook wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Wed, 28 May 2008, Chris Snook wrote:
>> 
>>> Justin Piszcz wrote:
>>>> Hardware:
>>>> 
>>> Given that one of the greatest benefits of NCQ/TCQ is with parity RAID, 
>>> I'd be fascinated to see how enabling NCQ changes your results.  Of 
>>> course, you'd want to use a single SATA controller with a known good NCQ 
>>> implementation, and hard drives known to not do stupid things like disable 
>>> readahead when NCQ is enabled.
>> Only/usually on multi-threaded jobs/tasks, yes?
>
> Generally, yes, but there's caching and readahead at various layers in 
> software that can expose the benefit on certain single-threaded workloads as 
> well.
>
>> Also, I turn off NCQ on all of my hosts that has it enabled by default 
>> because
>> there are many bugs that occur when NCQ is on, they are working on it in 
>> the
>> libata layer but IMO it is not safe at all for running SATA disks w/NCQ as
>> with it on I have seen drives drop out of the array (with it off, no 
>> problems).
>> 
>
> Are you using SATA drives with RAID-optimized firmware?  Most SATA 
> manufacturers have variants of their drives for a few dollars more that have 
> firmware that provides bounded latency for error recovery operations, for 
> precisely this reason.
I see--however, as I understood it there were bugs utilizing NCQ in libata?

But FYI--
In this test, they were regular SATA drives, not special raid-ones (RE2,etc).

Thanks for the info!

Justin.
