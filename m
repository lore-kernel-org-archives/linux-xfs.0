Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o813fNqL100887 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 22:41:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 612121799BE5
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 20:42:01 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	B90FeaXfBalWbGWE for <xfs@oss.sgi.com>;
	Tue, 31 Aug 2010 20:42:01 -0700 (PDT)
Date: Wed, 1 Sep 2010 13:41:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
Message-ID: <20100901034156.GQ705@dastard>
References: <201009010130.41500@zmi.at> <20100901000631.GO705@dastard>
	<4C7DC21B.1040705@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C7DC21B.1040705@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 31, 2010 at 10:01:47PM -0500, Stan Hoeppner wrote:
> Dave Chinner put forth on 8/31/2010 7:06 PM:
> 
> > You're probably CPU bound, not IO bound.
> 
> 7200 rpm is the highest spindle speed for 2TB drives--5400 is most
> common.  None of them are going to do much over 200 random seeks/second,
> if that.  That's 400 tops for two drives.
> 
> Using any modern Intel/AMD ~2 GHz CPU, you think he's CPU bound?

Absolutely.

> Apparently this "rm -rf" type operation is much more complex than I
> previously believed.

Nothing in XFS is simple. ;)

Unlinks that free the inode clusters results in no inode writeback
load, so the majority of the IO is log traffic. Hence they are
either log IO bound or read latency bound.  A pair of 2TB SATA
drives will be good for at least 150MB/s of log throughput, but
the numbers are nowhere near that.

Without delayed logging, 150MB/s is enough for a single threaded
unlink to consume an entire CPU core on any modern CPU, and there
maybe enough bandwidth for two threads to max out 2 CPUs. With
delaylog, log throughput is reduced by an order of magnitude, so
should be good for at least 10x that number of CPU cores running
flat out unless they are latency bound reading the directories
and inodes into memory.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
