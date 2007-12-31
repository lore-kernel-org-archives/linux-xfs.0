Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Dec 2007 12:23:36 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBVKNSKn031513
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 12:23:32 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 418AFBD5220
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 12:23:42 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154]) by cuda.sgi.com with ESMTP id QQ6xyGA2QuTdTWJn for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 12:23:42 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so2884370fga.8
        for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 12:23:41 -0800 (PST)
Date: Mon, 31 Dec 2007 21:17:12 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: raid 10 su, sw settings
Message-ID: <20071231201712.GA3679@teal.hq.k1024.org>
References: <1199059239.13944.65.camel@up> <Pine.LNX.4.64.0712311203220.23402@p34.internal.lan> <1199126586.3437.10.camel@up> <Pine.LNX.4.64.0712311406190.1239@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712311406190.1239@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Brad Langhorst <brad@langhorst.com>, xfs@oss.sgi.com

On Mon, Dec 31, 2007 at 02:07:27PM -0500, Justin Piszcz wrote:
>
>
> On Mon, 31 Dec 2007, Brad Langhorst wrote:
>
>>
>> On Mon, 2007-12-31 at 12:04 -0500, Justin Piszcz wrote:
>>
>>>>
>>>> Typical blocks/sec from iostat during large file movements is about
>>>> 100M/s read and 80M/s write.
>>>>
>>>
>>> #1 What type of performance do you expect with a 4-disk raid10?
>>
>> Are you saying that i should not expect more?
>> I expect about 70% better performance, since I think a single disk
>> should be able to do 100M/s. Maybe this is unreasonable?
> A single disk may do 90MiB/s burst but not sustained for read or write, at 
> least not cheap SATA disks and when you get toward the middle part of the 
> disk the speed wil drop off significantly.  100MiB/s read and 80MiB/s write 
> for RAID10 sounds about right to me.  Maybe someone else on the list with a 
> similar configuration can chime in with their benchmarks.

I agree about the disk speed - 100MiB/s for SATA drives is a little bit
too much to expect. And certainly, *only* in purely single-reader or
single-writer sequential workloads.

I have the same config - 4 drive hw raid10 on 9650. A recent zcav log
shows read speeds start at around 140MiB/s and decrease toward 75MiB/s.
Since this is zcav from the bonie++ package, it doesn't take into
account any filesystem or partitioning overhead.

regards,
iustin
