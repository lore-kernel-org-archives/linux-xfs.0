Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q120QCZX020014 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 18:26:12 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OfxkbhGHn2dA0CBj for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 16:26:10 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1RskV6-0001lH-6m
	for xfs@oss.sgi.com; Thu, 02 Feb 2012 11:26:08 +1100
Date: Thu, 2 Feb 2012 11:26:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs task blocked for more than 120 seconds
Message-ID: <20120202002608.GY9090@dastard>
References: <20120130002026.GG10174@sli.dy.fi> <20120130010530.GI15102@dastard>
	<2504_1327964557_4F27218D_2504_92_2_20120130223527.GH10174@sli.dy.fi>
	<20120131233034.GK10174@sli.dy.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120131233034.GK10174@sli.dy.fi>
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

On Wed, Feb 01, 2012 at 01:30:34AM +0200, Sami Liedes wrote:
> On Tue, Jan 31, 2012 at 12:35:28AM +0200, Sami Liedes wrote:
> > The workloads do eventually complete. I tried the tar extraction again
> > but this time extracting the tar from a different disk and saw no such
> > warnings (and the time taken seems reasonable at 96 minutes).
> 
> Extracting a 105 GB tar that resides on the same (target) XFS
> partition on an otherwise idle disk does trigger warnings, but only
> for kworker, not the tar process. The time taken to extract was a
> reasonable-sounding 140 minutes, so maybe these are just harmless
> warnings.

It is indicating that superblock IO is taking more than 120s to
complete. That's an indication that the IO subsystem is not
throttling the IO queue (and so queuing up minutes worth of IO) or
not processing the IO queue in a fair/timely manner. IO should never
take more than a couple of seconds to complete unless there is
something wrong, so the warnings are quite valid at the default
timeout of 120s....

I'd suggest reporting the problem to the dm-crypt folks and see if
they have any ideas on why IO completion is taking so long.

> Perhaps something should/could be done to silence them in
> that case?

You can turn the hangcheck timer off or adjust it's timeout yourself
via these proc files:

$ ls /proc/sys/kernel/ |grep hung
hung_task_check_count
hung_task_panic
hung_task_timeout_secs
hung_task_warnings

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
