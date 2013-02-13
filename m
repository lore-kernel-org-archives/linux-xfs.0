Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6BB647F8A
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 23:16:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 584F5304039
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 21:15:56 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wFqTpLlmHc6aC2ET for <linux-xfs@oss.sgi.com>;
	Tue, 12 Feb 2013 21:15:55 -0800 (PST)
Date: Wed, 13 Feb 2013 16:15:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hung in D state during fclose
Message-ID: <20130213051552.GF26694@dastard>
References: <loom.20130212T071115-446@post.gmane.org>
	<20130212065545.GC10731@dastard>
	<3542214BE3A3EF419F236DFE0F878BC90512DC@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<20130212102014.GA26694@dastard>
	<3542214BE3A3EF419F236DFE0F878BC90517D2@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<20130212202246.GB26694@dastard>
	<3542214BE3A3EF419F236DFE0F878BC905190D@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<3542214BE3A3EF419F236DFE0F878BC9051A09@BL2PRD0310MB374.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3542214BE3A3EF419F236DFE0F878BC9051A09@BL2PRD0310MB374.namprd03.prod.outlook.com>
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
To: "Cheung, Norman" <Norman.Cheung@kla-tencor.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On Wed, Feb 13, 2013 at 12:12:47AM +0000, Cheung, Norman wrote:
> Dave,
> 
> One other point I have forgotten to mention is that the parent
> thread will wait for 5 minutes and then lower the thread priority
> (from -2 back to 20) and set a global variable to signal the
> threads to exit.  The blocked thread responded well and exit from
> D state and fclose completed with no error.

So it's not hung - it's just very slow?

You have 256GB of memory. It's entirely possible that you've dirtied
a large amount of memory and everything is simply stuck waiting for
writeback to occur. Perhaps you should have a look at the
utilisation of your disks when this still occurs. 'iostat -x -d -m
5' will give you some insight into utilsation when a hang occurs...

> This cause me to wonder if it  is possible that  some XFS threads
> and my application thread might be in a deadlock.  

Deadlocks are permanent, so what you are seeing is not a deadlock....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
