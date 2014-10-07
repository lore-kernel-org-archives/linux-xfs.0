Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 787BB7F3F
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 05:57:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0707CAC002
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 03:57:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QmLWyePNtZBFrYze for <xfs@oss.sgi.com>;
	Tue, 07 Oct 2014 03:57:29 -0700 (PDT)
Date: Tue, 7 Oct 2014 21:56:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corrupted filesystem: thoughts?
Message-ID: <20141007105657.GO2301@dastard>
References: <20141007093533.66ba8c7b@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141007093533.66ba8c7b@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 07, 2014 at 09:35:33AM +0200, Emmanuel Florac wrote:
> 
> Here we go again: Adaptec RAID adapters don't play well with HGST 3TB
> drives for some reason. When a drive fails, the filesystem is almost
> always corrupted. This one looks pretty bad according to the output of
> the latest "xfs_repair -n" of the 15 TB filesystem. Here is a sample 
> of the 2MB log:

Is the log clean? (use xfs_logprint -t <dev> to determine that)

xfs_repair -n ignores dirty logs, so the state on disk it may be
reporting on can be inconsistent and that inconsistency is "fixed"
by running log recovery.

> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
> out-of-order bno btree record 83 (332943 42) block 27/4681
> out-of-order bno btree record 90 (322762 76) block 27/4681
> out-of-order bno btree record 91 (331903 125) block 27/4681

That implies that some updates to the btree block haven't occurred
that compact out the old entries (that are now out of order). That
can either occur due to writes going missing, or log recovery not
being run....

Most of the issues could be caused by having a dirty log that needs
recovery, so that is the first thing to check. Note that a
non-dry-run xfs_repair will warn and abort if the log is dirty,
unlike "xfs_repair -n".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
