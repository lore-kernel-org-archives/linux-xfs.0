Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9P3BLGU183791 for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 22:11:21 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 629F51977D37
	for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 20:12:36 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 68iz9Yx7mo6sicTt
	for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 20:12:36 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 5E1E66C12B
	for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 22:12:36 -0500 (CDT)
Message-ID: <4CC4F5A4.4090203@hardwarefreak.com>
Date: Sun, 24 Oct 2010 22:12:36 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS use within multi-threaded apps
References: <AANLkTi=w1o8EF6-M7o8Qi9VpY-10m+MCR8U+K1_Aze=g@mail.gmail.com>	<AANLkTikcgqA_cPLyMOXkgbu_PLkZRQ7qmch+LZdp_L6H@mail.gmail.com>	<AANLkTi=RZ=qf5xqMQNZjZaikAdw12PzbzD3vo-hZfNHT@mail.gmail.com>	<201010242022.46693@zmi.at>
	<20101024230811.GL12506@dastard>
In-Reply-To: <20101024230811.GL12506@dastard>
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

Dave Chinner put forth on 10/24/2010 6:08 PM:
> On Sun, Oct 24, 2010 at 08:22:46PM +0200, Michael Monnerie wrote:
>> On Samstag, 23. Oktober 2010 Angelo McComis wrote:
>>> They quoted having 10+TB databases running OLTP on EXT3 with
>>> 4-5GB/sec sustained throughput (not XFS).
>>
>> Which servers and storage are these? This is nothing you can do with 
>> "normal" storages. Using 8Gb/s Fibre Channel gives 1GB/s, if you can do 
>> full speed I/O. So you'd need at least 5 parallel Fibre Channel storages 
>> running without any overhead. Also, a single server can't do that high 
>> rates, so there must be several front-end servers. That again means 
>> their database must be especially organised for that type of load 
>> (shared nothing or so).
> 
> Have a look at IBM's TPC-C submission here on RHEL5.2:
> 
> http://www.tpc.org/tpcc/results/tpcc_result_detail.asp?id=108081902
> 
> That's got 8x4GB FC connections to 40 storage arrays with 1920 disks
> behind them. It uses 80x 24 disk raid0 luns, with each lun split
> into 12 data partitions on the outer edge of each lun. That gives
> 960 data partitions for the benchmark.

They're reporting 8 _dual port_ 4Gb FC cards, so that's 16 connections.

> Now, this result uses raw devices for this specific benchmark, but
> it could easily use files in ext3 filesystems. With 960 ext3
> filesystems, you could easily max out the 3.2GB/s of IO that sucker
> has as it is <4MB/s per filesystem.

So the max is 6.4GB/s.  The resulting ~8MB/s per filesystem would still
be a piece of cake.

Also, would anyone in their right mind have their DB write/read directly
to raw partitions in a production environment?  I'm not a DB expert, but
this seems ill advised, unless the DB is really designed well for this.

> So I'm pretty sure IBM are not quoting a single filesystem
> throuhgput result. While you could get that sort of result form a
> single filesytsem with XFS, I think it's an order of magnitude
> higher than a single ext3 filesystem can acheive....

I figured they were quoting the OP a cluster result, as I mentioned
previously.  Thanks for pointing out that a single 8-way multicore x86
box can yield this kind of performance today--2 million TPC-C.  Actually
this result is two years old.  Wow.  I haven't paid attention to TPC
results for a while.

Nonetheless, it's really interesting to see an 8 socket 48 core x86 box
churning out numbers almost double that of an HP Itanium 64 socket/core
SuperDome from only 3 years prior.  The cost of the 8-way x86 server is
a fraction of the 64-way Itanium, but storage cost usually doesn't budge
much:

http://www.tpc.org/tpcc/results/tpcc_result_detail.asp?id=105112801

Did anyone happen to see that SUN, under the Oracle cloak, has finally
started publishing TPC results again?  IIRC SUN had quit publishing
results many many years ago because their E25K with 72 UltraSparcs
couldn't even keep up with an IBM Power box with 16 sockets.  The
current Oracle result for its USparc T2 12 node cluster is pretty
impressive, from a total score at least.  The efficiency is pretty low,
given the 384 core count, and considering the result is only 3.5x that
of the 48 core Xeon IBM xSeries:

http://www.tpc.org/tpcc/results/tpcc_result_detail.asp?id=109110401

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
