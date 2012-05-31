Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4V1UNXw108924 for <xfs@oss.sgi.com>; Wed, 30 May 2012 20:30:23 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ddScO1BoXRqXH6hb
	for <xfs@oss.sgi.com>; Wed, 30 May 2012 18:30:22 -0700 (PDT)
Message-ID: <4FC6C9AE.1070808@hardwarefreak.com>
Date: Wed, 30 May 2012 20:30:22 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<4F9AA43A.1060509@hardwarefreak.com>
	<CAAxjCEzzMk0TFKy23cAA_cAxbUFLS6cOCjgRBQocDUNtJO2UnA@mail.gmail.com>
	<CAAxjCEyMEtyDXdPN50HmV_k3vUPxCtYN1k5_AD=gZqu8-1wXqg@mail.gmail.com>
In-Reply-To: <CAAxjCEyMEtyDXdPN50HmV_k3vUPxCtYN1k5_AD=gZqu8-1wXqg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On 5/30/2012 6:07 AM, Stefan Ring wrote:
> On Tue, May 1, 2012 at 12:46 PM, Stefan Ring <stefanrin@gmail.com> wrote:
>>> Stefan, you should be able to simply clear the P410i configuration in
>>> the BIOS, power down, then simply connect the 6 drive backplane cable to
>>> the 410i, load the config from the disks, and go.  This allows head to
>>> head RAID6 comparison between the P400 and P410i.  No doubt the 410i
>>> will be quicker.  This procedure will tell you how much quicker.
>>
>> Unfortunately, the server is located at a hosting facility at the
>> opposite end of town, and I'd spend an entire day just traveling to
>> and fro, so that's not currently an option. I might get lucky though,
>> because we should soon get another server with an external P410i.
> 
> The new storage blade has only been upgraded to the P410i controller,
> and even though there is a new setting called "elevatorsort", which is
> enabled, the performance is just as bad. The new one has a
> flash-writeback cache and may be faster by a few percent ticks, but
> that's it. It doesn't even make sense to compare the two in-depth, as
> they perform almost identically.

You now have persistent write cache.  Did you test with XFS barriers
disabled?  If not you should.  You'll likely see a decent, possibly
outstanding, performance improvement with your huge metadata
modification workload, as XFS will no longer flush the cache frequently
when writing to the journal log.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
