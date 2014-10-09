Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 34AFE7F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 16:07:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0695F304071
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 14:07:39 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Altif76I731ixVqS for <xfs@oss.sgi.com>;
	Thu, 09 Oct 2014 14:07:34 -0700 (PDT)
Date: Fri, 10 Oct 2014 08:07:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: gather write metrics on multiple files
Message-ID: <20141009210732.GC4376@dastard>
References: <543611CF.6030904@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <543611CF.6030904@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 08, 2014 at 11:40:47PM -0500, Stan Hoeppner wrote:
> Does anyone know of a utility that can track writes to files in an
> XFS directory tree, or filesystem wide for that matter, and gather
> filesystem blocks written per second data, or simply KiB/s, etc?
> I need to analyze an application's actual IO behavior to see if it
> matches what I'm being told the application is supposed to be
> doing.

iotop uses the task accounting infrastructure to give you
per-process IO stats:

Total DISK READ :      27.18 K/s | Total DISK WRITE :     395.10 M/s
Actual DISK READ:      27.18 K/s | Actual DISK WRITE:     395.10 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
14822 be/4 dave       27.18 K/s  395.10 M/s  0.00 % 87.43 % dd if=/dev/zero of=foo bs=1024k count=16384 oflag=direct
 5430 be/4 dave        0.00 B/s    3.88 K/s  0.00 %  0.00 % plasma-desktop
    1 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % init [2]
    2 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kthreadd]
....

For whole device stats, "iostat -d -x -m <device> 5" will get you 5
second averages of the IO to a device, request sizes, queue depths,
latencies, etc. blktrace/blkparse can give you way more information
that you care about in the IO subsystem - iowatcher (formerly
seekwatcher) is a good visualation tool that sits on top of
blktrace...

PCP (i.e using pmchart for live graphing of performance metrics) is
probably useful here, too.

As for limiting the stats gathering to a subset of the filesystem
there isn't really anything that does that. You probably would need
to do some perf or system tap magic to filter read/write ops
in some way. A good place to start might be here:

http://www.brendangregg.com/perf.html

Specifically his iosnoop tool is a simple template that you can customise to your
own needs:

http://www.brendangregg.com/blog/2014-07-16/iosnoop-for-linux.html
http://www.brendangregg.com/blog/2014-07-23/linux-iosnoop-latency-heat-maps.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
