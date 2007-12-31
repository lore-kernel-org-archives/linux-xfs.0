Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Dec 2007 11:07:57 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBVJ7iUu021562
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 11:07:53 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92CE44D10DA
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 11:07:59 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id Dv27Uq4qQ2kJ6RBz for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 11:07:59 -0800 (PST)
Date: Mon, 31 Dec 2007 14:07:27 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raid 10 su, sw settings
In-Reply-To: <1199126586.3437.10.camel@up>
Message-ID: <Pine.LNX.4.64.0712311406190.1239@p34.internal.lan>
References: <1199059239.13944.65.camel@up>  <Pine.LNX.4.64.0712311203220.23402@p34.internal.lan>
 <1199126586.3437.10.camel@up>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Brad Langhorst <brad@langhorst.com>
Cc: xfs@oss.sgi.com



On Mon, 31 Dec 2007, Brad Langhorst wrote:

>
> On Mon, 2007-12-31 at 12:04 -0500, Justin Piszcz wrote:
>
>>>
>>> Typical blocks/sec from iostat during large file movements is about
>>> 100M/s read and 80M/s write.
>>>
>>
>> #1 What type of performance do you expect with a 4-disk raid10?
>
> Are you saying that i should not expect more?
> I expect about 70% better performance, since I think a single disk
> should be able to do 100M/s. Maybe this is unreasonable?
A single disk may do 90MiB/s burst but not sustained for read or write, at 
least not cheap SATA disks and when you get toward the middle part of the 
disk the speed wil drop off significantly.  100MiB/s read and 80MiB/s 
write for RAID10 sounds about right to me.  Maybe someone else on the list 
with a similar configuration can chime in with their benchmarks.

>
>
>> #2 You should be able to umount/mount with the new sizes, although I have
>> not tested it myself b/c I typically use sw raid here (sunit/etc is
>> optimized for sw raid).
> I am able to do the remount, but it seems to have had no impact.
> I don't know why but I see 3 possibilities:
> - Perhaps because su/sw settings  don't matter very much.
> - maybe it didn't take effect (rebooting this system is not a preferred
> option)
> - maybe it doesn't matter if the partition layout is not optimized.
>
> Brad
>
>
