Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q117TW09230203 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 01:29:33 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id JluxSH7BaNPkWXcg
	for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 23:29:31 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 13CAD6C1A4
	for <xfs@oss.sgi.com>; Wed,  1 Feb 2012 01:29:30 -0600 (CST)
Message-ID: <4F28E9DA.8030407@hardwarefreak.com>
Date: Wed, 01 Feb 2012 01:29:30 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Performance problem - reads slower than writes
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org> <20120131141604.GB46571@nsrc.org>
	<20120131202526.GJ9090@dastard>
In-Reply-To: <20120131202526.GJ9090@dastard>
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
To: xfs@oss.sgi.com

On 1/31/2012 2:25 PM, Dave Chinner wrote:
> On Tue, Jan 31, 2012 at 02:16:04PM +0000, Brian Candler wrote:

>> Here we appear to be limited by real seeks. 225 seeks/sec is still very good
> 
> That number indicates 225 IOs/s, not 225 seeks/s.

Yeah, the voice coil actuator and spindle rotation limits the peak
random seek rate of good 7.2k drive/controller combos to about 150/s.
15k drives do about 250-300 seeks/s max.  Simple tool to test max random
seeks/sec for a device:

32bit binary:  http://www.hardwarefreak.com/seekerb
source:        http://www.hardwarefreak.com/seeker_baryluk.c

I'm not the author.  The original seeker program is single threaded.
Baryluk did the thread hacking.  Background info:
http://www.linuxinsight.com/how_fast_is_your_disk.html

Usage:   ./seekerb device [threads]

Results for a single WD 7.2K drive, no NCQ, deadline elevator:

  1 threads Results: 64 seeks/second, 15.416 ms random access time
 16 threads Results: 97 seeks/second, 10.285 ms random access time
128 threads Results: 121 seeks/second, 8.208 ms random access time

Actual output:
$ seekerb /dev/sda 128
Seeker v3.0, 2009-06-17,
http://www.linuxinsight.com/how_fast_is_your_disk.html
Benchmarking /dev/sda [976773168 blocks, 500107862016 bytes, 465 GB,
476940 MB, 500 GiB, 500107 MiB]
[512 logical sector size, 512 physical sector size]
[128 threads]
Wait 30 seconds.............................
Results: 121 seeks/second, 8.208 ms random access time (52614775 <
offsets < 499769984475)

Targeting array devices (mdraid or hardware, or FC SAN LUN) with lots of
spindles, and/or SSDs should yield some interesting results.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
