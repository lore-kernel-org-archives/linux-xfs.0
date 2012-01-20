Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0K8ramw093659
	for <linux-xfs@oss.sgi.com>; Fri, 20 Jan 2012 02:53:36 -0600
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id 4UveIOijSnnyNMnz for
	<linux-xfs@oss.sgi.com>; Fri, 20 Jan 2012 00:53:35 -0800 (PST)
Message-ID: <4F192B8C.1050406@tlinx.org>
Date: Fri, 20 Jan 2012 00:53:32 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: concurrent direct IO write in xfs
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
In-Reply-To: <CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Zheng Da <zhengda1936@gmail.com>, Linux-Xfs <linux-xfs@oss.sgi.com>



Zheng Da wrote:
> 
> I create a file of 4GB in XFS (the ramdisk has 5GB of space). My test 
> program overwrites 4G of data to the file  
----
	It sounds like you are asking why multiple threads don't
move memory from one point to another point in memory at a faster rate
than one thread alone.

I.e. if you had 2 processes doing an assembly instruction, memmov to move
a chunk of memory from 1 area to another, would you expect to do the move
any faster if you had 2 processors doing the move vs. 1??

I think the limiting factor (unless you have a slow processor and some
REALLY fast memory, but stock x86-64 parts, today have memory running about
2-4 times slower than the processor -- so the memory is usually the bottleneck.

Two processes wouldn't do it any faster, and might actually do it slower due to
resource contention issues -- I would *think*... but I really don't know the
details of how writing from mem2mem and having the target be in the format of
and xfs file system, would cause cpu-bound delays that would be significant to
change the fact that m2m operations are usually mem-bandwidth limited...?

(I don't know the answers, just clarifying what you are asking)...



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
