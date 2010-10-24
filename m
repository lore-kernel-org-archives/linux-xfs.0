Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9ON74IS165579 for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 18:07:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C89C12045C
	for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 16:08:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	YUrHpQBVqDUEDABr for <xfs@oss.sgi.com>;
	Sun, 24 Oct 2010 16:08:18 -0700 (PDT)
Date: Mon, 25 Oct 2010 10:08:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS use within multi-threaded apps
Message-ID: <20101024230811.GL12506@dastard>
References: <AANLkTi=w1o8EF6-M7o8Qi9VpY-10m+MCR8U+K1_Aze=g@mail.gmail.com>
	<AANLkTikcgqA_cPLyMOXkgbu_PLkZRQ7qmch+LZdp_L6H@mail.gmail.com>
	<AANLkTi=RZ=qf5xqMQNZjZaikAdw12PzbzD3vo-hZfNHT@mail.gmail.com>
	<201010242022.46693@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201010242022.46693@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Angelo McComis <angelo@mccomis.com>, xfs@oss.sgi.com

On Sun, Oct 24, 2010 at 08:22:46PM +0200, Michael Monnerie wrote:
> On Samstag, 23. Oktober 2010 Angelo McComis wrote:
> > They quoted having 10+TB databases running OLTP on EXT3 with
> > 4-5GB/sec sustained throughput (not XFS).
> 
> Which servers and storage are these? This is nothing you can do with 
> "normal" storages. Using 8Gb/s Fibre Channel gives 1GB/s, if you can do 
> full speed I/O. So you'd need at least 5 parallel Fibre Channel storages 
> running without any overhead. Also, a single server can't do that high 
> rates, so there must be several front-end servers. That again means 
> their database must be especially organised for that type of load 
> (shared nothing or so).

Have a look at IBM's TPC-C submission here on RHEL5.2:

http://www.tpc.org/tpcc/results/tpcc_result_detail.asp?id=108081902

That's got 8x4GB FC connections to 40 storage arrays with 1920 disks
behind them. It uses 80x 24 disk raid0 luns, with each lun split
into 12 data partitions on the outer edge of each lun. That gives
960 data partitions for the benchmark.

Now, this result uses raw devices for this specific benchmark, but
it could easily use files in ext3 filesystems. With 960 ext3
filesystems, you could easily max out the 3.2GB/s of IO that sucker
has as it is <4MB/s per filesystem.

So I'm pretty sure IBM are not quoting a single filesystem
throuhgput result. While you could get that sort of result form a
single filesytsem with XFS, I think it's an order of magnitude
higher than a single ext3 filesystem can acheive....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
