Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9040C7F8E
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 01:51:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5D4CA8F8037
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 23:51:21 -0700 (PDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
	[209.85.212.175]) by cuda.sgi.com with ESMTP id
	iJzB8LTrjRQ2ArLn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 23:51:18 -0700 (PDT)
Received: by wiaa2 with SMTP id a2so15018863wia.0
	for <xfs@oss.sgi.com>; Thu, 09 Apr 2015 23:51:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150410063210.GJ15810@dastard>
References: <CABppvi6pC4qEFZUTesbT0v5agbd67MP4dEoUbaVFwEyCv4h21g@mail.gmail.com>
	<20150410063210.GJ15810@dastard>
Date: Thu, 9 Apr 2015 23:51:17 -0700
Message-ID: <CABppvi4e_xEMY7tDHtEo6miZcN2AZ-mFMHXKaUS0hfpx6AMt0w@mail.gmail.com>
Subject: Re: XFS Syncd
From: Shrinand Javadekar <shrinand@maginatics.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Thanks for the reply Dave!

>
> Oh, right, it's that workqueue we removed in late 2012 (in the 3.7
> cycle) because it was redundant. The only remaining fragment of it
> is the xfslogd. What kernel are you running?

I am running 3.13.0-39-generic on Ubuntu 14.04.

# uname -a
Linux tf-hippo-1 3.13.0-39-generic #66-Ubuntu SMP Tue Oct 28 13:30:27
UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

>
>> I am seeing a behavior where the system pretty much stalls for ~5
>> seconds after every 30 seconds. I see that the # of ios goes up but
>> the actual write bandwidth during this 5 second period is very low
>> (see attached images). After a fair bit of investigation, we've
>> narrowed down the problem to XFS's syncd (fs.xfs.xfssyncd_centisecs).
>> This runs at a default interval of 30 seconds.
>
> It's doing background inode reclaim which, under some circumstances,
> involves truncating specualtive allocation beyond EOF before reclaim
> occurs, which results in transactions and inode writeback. It was
> highly inefficient, which is why we replaced it.

Oh.. I see. So, this isn't even actual filesystem metadata. And there
is no option to turn the speculative allocation on/off?

What's the downside of not doing the truncation of the speculative
allocation? Does that result in wasted disk space? If so, how much?

>
>> I have a couple of questions:
>>
>> 1. If all file writes are done with an fsync() at the end, what is
>> xfssyncd doing for several seconds?
>> 2. How does xfssyncd actually work across several disks? Currently, it
>> seems that when it runs, it pretty much stalls the entire system.
>
> xfssyncd was actually a workqueue, so it services multiple
> filesystems at once. Before that, there was a kernel thread per
> filesystem for it. Anyway, it's doing lots of random write IO and
> saturating your disks, which will stall any system that is dependent
> on IO throughput to function.
>
>> 3. I see that fs.xfs.xfssyncd_centisecs is the parameter to tune the
>> interval. But that doesn't give us much. Increasing the interval
>> simply postpones the work. When xfssyncd runs, it takes more time. Are
>> there any other options I can try to make xfssyncd not stall the
>> system when it runs?
>
> Upgrade your kernel to something more recent, and the problem should
> go away.

We have several other dependencies on the OS. Not sure if upgrading
above Ubuntu 14.04 and kernel 3.13.0-39-generic is an option. Any
other options to try out?

-Shri

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
