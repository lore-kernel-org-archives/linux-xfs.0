Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F404E7F50
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2015 01:16:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 03468304059
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 23:16:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	3UWB6bUsce3LgKJu for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2015 23:15:57 -0700 (PDT)
Date: Fri, 24 Apr 2015 16:15:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Inode and dentry cache behavior
Message-ID: <20150424061554.GN15810@dastard>
References: <CABppvi55C+vE7Ei8u=_ntC_heDQb4HwUcKom-_9hGkunk84Sfw@mail.gmail.com>
	<20150423224324.GM15810@dastard>
	<CABppvi7+Mu78FAM75YvJvekX2CHtKk4yeMrU7j35fvvWRb923Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi7+Mu78FAM75YvJvekX2CHtKk4yeMrU7j35fvvWRb923Q@mail.gmail.com>
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
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 23, 2015 at 04:48:51PM -0700, Shrinand Javadekar wrote:
> > from the iostat log:
> >
> > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> > .....
> > dm-6              0.00     0.00    0.20   22.40     0.00     0.09    8.00    22.28  839.01 1224.00  835.57  44.25 100.00
> > dm-7              0.00     0.00    0.00    1.20     0.00     0.00    8.00     2.82 1517.33    0.00 1517.33 833.33 100.00
> > dm-8              0.00     0.00    0.00  195.20     0.00     0.76    8.00  1727.51 4178.89    0.00 4178.89   5.12 100.00
> > ...
> > dm-7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00    0.00    0.00   0.00 100.00
> > dm-8              0.00     0.00    0.00    0.00     0.00     0.00     0.00  1178.85    0.00    0.00    0.00   0.00 100.00
> >
> > dm-7 is showing almost a second for single IO wait times, when it is
> > actually completing IO. dm-8 has a massive queue depth - I can only
> > assume you've tuned  sys/block/*/queue/nr_requests to something
> > really large? But like dm-7, it's showing very long IO times, and
> > that's likely the source of your latency problems.
> 
> I see that /sys/block/*/queue/nr_requests is set to 128 which is way
> less than the queue depth shown in the iostat numbers. What gives?

No idea, but it's indicative of a problem below XFS. Work out what
is happening with your storage hardware first, then work your way up
the stack...

> One other observation we had was that xfs shows a large amount of
> directory fragmentation. Directory fragmentation was shown at ~40%
> whereas file fragmentation was very low at 0.1%.

Pretty common. Directories are only accessed a single block at a
time, and sequential offset reads are pretty rare, so fragmentation
makes little difference to performance. You're seeing almost zero
read IO load, so the directory layout is not a concern for this
workload.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
