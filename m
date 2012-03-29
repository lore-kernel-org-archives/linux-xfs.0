Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2T0Tsph252518 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 19:29:55 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	sHwKoGDTLqc1r6Ta for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 17:29:52 -0700 (PDT)
Date: Thu, 29 Mar 2012 11:29:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/8] xfs: initialise xfssync work before running
	quotachecks
Message-ID: <20120329002949.GA692@dastard>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-4-git-send-email-david@fromorbit.com>
	<20120322151548.GS7762@sgi.com> <20120322210723.GC5091@dastard>
	<4F6C7BE7.3060100@sgi.com> <20120325232253.GJ5091@dastard>
	<4F7086FA.9010003@sgi.com> <20120326215709.GM5091@dastard>
	<20120328194018.GE7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120328194018.GE7762@sgi.com>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Mar 28, 2012 at 02:40:18PM -0500, Ben Myers wrote:

[ snip repeated arguments about startup races ]

[ insert repeated responses about "fixed in next patch" ]

[ wait for circle to go around again ]

> I suggest 3 and 4 should be combined into one patch.

Why didn't you just say that's what you want? I have no problem
doing that.  I just kept them separate as there are two logical
changes to the fix - startup order changes, and MS_ACTIVE guard
changes.  Do you want me to send a new combined patch?

FWIW, arguing that a patch in a series is unacceptable because
introduces a temporary problem that is fixed by another patch in the
series is not really helpful, as is saying "it has races" and not
explaining them. If you want the temporary problematic state removed
from the series, just *say so* - it is easy to do.

> You've reordered xfs_syncd_stop with respect to xfs_unmount in the
> error path of xfs_fs_fill_super, but not in the regular unmount
> path xfs_fs_put_super.  I think for consistency they should not be
> reordered in the error path of xfs_fs_fill_super.

[ the circle goes around again ]

The second patch makes it consistent in that xfs_syncd_stop() is
always called after xfs_unmountfs().

> As long as workers can run before xfs_mountfs is run, they need to protect
> themselves to ensure that the structures they are using are initialized.
> It looks like xfs_reclaim_worker would do this in the next patch by using
> MS_ACTIVE, but FWICS xfs_sync_worker still does not protect itself.

Go back and read the second patch, and then review what you wrote
here.  Don't waste my time by making me have to explain it again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
