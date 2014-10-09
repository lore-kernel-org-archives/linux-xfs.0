Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 59BDF7F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 00:24:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 39176304048
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 22:24:00 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id OSAFvP9AQMdxxCGg
	for <xfs@oss.sgi.com>; Wed, 08 Oct 2014 22:23:59 -0700 (PDT)
Received: from [192.168.100.53] (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221])
	by greer.hardwarefreak.com (Postfix) with ESMTPA id D8FAE6C121
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 00:23:58 -0500 (CDT)
Message-ID: <54361C04.5090404@hardwarefreak.com>
Date: Thu, 09 Oct 2014 00:24:20 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: gather write metrics on multiple files
References: <543611CF.6030904@hardwarefreak.com> <543613E7.70508@gmail.com>
In-Reply-To: <543613E7.70508@gmail.com>
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
To: xfs@oss.sgi.com

On 10/08/2014 11:49 PM, Joe Landman wrote:
> On 10/09/2014 12:40 AM, Stan Hoeppner wrote:
>> Does anyone know of a utility that can track writes to files in an
>> XFS directory tree, or filesystem wide for that matter, and gather
>> filesystem blocks written per second data, or simply KiB/s, etc?  I
>> need to analyze an application's actual IO behavior to see if it
>> matches what I'm being told the application is supposed to be doing.
>>
> 
> We've written a few for this purpose (local IO probing).
> 
> Start with collectl (looks at /proc/diskstats), and others.  Our tools go to /proc/diskstats, and use this to compute BW and IOPs per device.
> 
> If you need to log it for a long time, set up a time series database (we use influxdb and the graphite plugin).  Then grab your favorite metrics tool that talks to graphite/influxdb (I like https://github.com/joelandman/sios-metrics for obvious reasons), and start collecting data.

I'm told we have 800 threads writing to nearly as many files concurrently on a single XFS on a 12+2 spindle RAID6 LUN.  Achieved data rate is currently ~300 MiB/s.  Some of these are files are supposedly being written at a rate of only 32KiB every 2-3 seconds, while some (two) are ~50 MiB/s.  I need to determine how many bytes we're writing to each of the low rate files, and how many files, to figure out RMW mitigation strategies.  Out of the apparent 800 streams 700 are these low data rate suckers, one stream writing per file.  

Nary a stock RAID controller is going to be able to assemble full stripes out of these small slow writes.  With a 768 KiB stripe that's what, 24 seconds to fill it at 2 seconds per 32 KiB IO?  I've been playing with bcache for a few days but it actually drops throughput by about 30% no matter how I turn its knobs.  Unless I can get Kent to respond to some of my questions bcache will be a dead end.  I had high hopes for it, thinking it would turn these small random IOs into larger sequential writes.  It may actually be doing so, but it's doing something else too, and badly.  IO times go through the roof once bcache starts gobbling IOs, and throughput to the LUNs drops significantly even though bcache is writing 50-100 MIB/s to the SSD.  Not sure what's causing that.


>> Thanks, Stan
>>
>> _______________________________________________ xfs mailing list
>> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
