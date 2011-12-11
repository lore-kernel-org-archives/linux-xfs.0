Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBBNdeRh061014 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 17:39:40 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A08D1EA91EB
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 15:39:39 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	IownoxT4UApLtQYG for <xfs@oss.sgi.com>;
	Sun, 11 Dec 2011 15:39:39 -0800 (PST)
Date: Mon, 12 Dec 2011 10:39:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
Message-ID: <20111211233929.GI14273@dastard>
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
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
To: Xupeng Yun <xupeng@xupeng.me>
Cc: XFS group <xfs@oss.sgi.com>

On Sun, Dec 11, 2011 at 08:45:14PM +0800, Xupeng Yun wrote:
> Hi,
> 
> I am using XFS + 2.6.29 on my MySQL servers, they perform great.
> 
> I am testing XFS on SSD these days, due to the fact that FITRIM support of
> XFS was
> shipped with Linux kernel 2.6.38 or newer, I tested XFS + 2.6.38 and XFS +
> 2.6.39, but
> it surprises me that the performance of XFS with these two versions of
> kernel drops so
> much.
> 
> Here are the results of my tests with fio, all these two tests were taken
> on the same hardware
> with same testing environment (except for different kernel version).
> 
> ====== XFS + 2.6.29 ======

Read 21GB @ 11k iops, 210MB/s, av latency of 1.3ms/IO
Wrote 2.3GB @ 1250 iops, 20MB/s, av latency of 0.27ms/IO
Total 1.5m IOs, 95% @ <= 2ms

> ====== XFS + 2.6.39 ======

Read 6.5GB @ 3.5k iops, 55MB/s, av latency of 4.5ms/IO
Wrote 700MB @ 386 iops, 6MB/s, av latency of 0.39ms/IO
Total 460k IOs, 95% @ <= 10ms, 4ms > 50% < 10ms

Looking at the IO stats there, this doesn't look to me like an XFS
problem. The IO times are much, much longer on 2.6.39, so that's the
first thing to understand. If the two tests are doing identical IO
patterns, then I'd be looking at validating raw device performance
first.

> I tried different XFS format options and different mount options, but
> it did not help.

It won't if the problem is inthe layers below XFS.

e.g. IO scheduler behavioural changes could be the cause (esp. if
you are using CFQ), the SSD could be in different states or running
garbage collection intermittently and slowing things down, the
filesystem could be in different states (did you use a fresh
filesystem for each of these tests?), etc, recent mkfs.xfs will trim
the entire device if the kernel supports it, etc.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
