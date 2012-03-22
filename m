Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2ML7TVL035678 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 16:07:30 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Bme6sEZWZTT5raZb for <xfs@oss.sgi.com>;
	Thu, 22 Mar 2012 14:07:27 -0700 (PDT)
Date: Fri, 23 Mar 2012 08:07:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/8] xfs: initialise xfssync work before running
	quotachecks
Message-ID: <20120322210723.GC5091@dastard>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-4-git-send-email-david@fromorbit.com>
	<20120322151548.GS7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120322151548.GS7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 22, 2012 at 10:15:48AM -0500, Ben Myers wrote:
> On Thu, Mar 22, 2012 at 04:15:08PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because the mount process can run a quotacheck and consume lots of
> > inodes, we need to be able to run periodic inode reclaim during the
> > mount process. This will prevent running the system out of memory
> > during quota checks.
> > 
> > This essentially reverts 2bcf6e97, but that is safe to do now that
> > the quota sync code that was causing problems during long quotacheck
> > executions is now gone.
> 
> Dave, I've held off on #s 3 and 4 because they appear to be racy.  Being

What race?

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
