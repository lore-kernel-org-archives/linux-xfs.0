Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2DA0xWg080461 for <xfs@oss.sgi.com>; Sat, 13 Mar 2010 04:00:59 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 595FB23AFB6
	for <xfs@oss.sgi.com>; Sat, 13 Mar 2010 02:02:31 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id f3xWEgkvsbEZnBZb
	for <xfs@oss.sgi.com>; Sat, 13 Mar 2010 02:02:31 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 5D77B6C3DF
	for <xfs@oss.sgi.com>; Sat, 13 Mar 2010 04:02:31 -0600 (CST)
Message-ID: <4B9B62DE.4090301@hardwarefreak.com>
Date: Sat, 13 Mar 2010 04:03:10 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS buffered sequential read performance low after kernel upgrade
References: <4B9A2A00.1050304@hardwarefreak.com>
	<20100313001626.GE4732@dastard>
In-Reply-To: <20100313001626.GE4732@dastard>
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
To: xfs@oss.sgi.com

Dave Chinner put forth on 3/12/2010 6:16 PM:

Thanks for the tips Dave.

> Those tests don't go through the filesystem - they go directly to the
> block device. Hence if these are different to your old kernel, the
> problem is outside XFS. I'd suggest the most likely cause is the
> elevator - if you are using CFQ try turning off the new low-latency
> mode, or changing to deadline or noop and see if the problem goes
> away.

I'm using the deadline elevator as the kernel default on both the old and
new kernels.  I have been for quite some time as it seems to yield over
double the random I/O seek performance of the cfq elevator for threaded or
multi-tasking workloads.  My SATA controller doesn't support NCQ.  In my
testing the deadline elevator seems to "restore" the lost performance that
NCQ would have provided, at the cost of a little more kernel/CPU overhead.

> Also, the XFS partitions are on the inner edge of the disk, so they
> are always going to be slower (can be as low as half the speed) than
> partitions on the outer edge of the disk for sequential access...

It's a 500GB single platter drive.  I've partitioned a little less than
250GB of it, starting at the outer edge (at least that's what I instructed
cfdisk to do).  Relatively speaking, the two 100GB XFS partitions should be
closer to the outer than inner tracks.  The EXT2 / partition is obviously
right on the outer edge.  The start of the first XFS partition is at the
~35GB mark out of 500GB, so it's right there too, and should have very
similar direct block read performance.  Yes?

What boggles me is why my dd write speeds are 15-20MB/s faster than the read
speeds on the XFS partitions, considering, as you state, that the reads are
direct block I/O reads, bypassing the FS.  Since I'm writing to a file in
the write tests, doesn't the writing have to go through XFS?  If so, why is
it so much faster than the reads?  Linux kernel and XFS write buffers?  The
16MB cache chip on the drive?

~$ dd if=/dev/sda6 of=/dev/null bs=4096 count=100000
100000+0 records in
100000+0 records out
409600000 bytes (410 MB) copied, 9.07389 s, 45.1 MB/s

~$ dd if=/dev/zero of=/home/stan/test.xfs bs=4096 count=100000
100000+0 records in
100000+0 records out
409600000 bytes (410 MB) copied, 6.16098 s, 66.5 MB/s

I'm by no means an expert on this stuff.  You guys are.  That's why I'm
asking here.  ;)  I'm just trying to learn how to best optimize my kernel
and filesystem performance.  There may be nothing "wrong" here, but it seems
that way at first glance.  If so, I'd like to fix/optimize if possible.

Thanks for sharing your expertise, and your time.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
