Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EIlucX142364 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 13:47:56 -0500
Subject: Re: [PATCH 01/18] xfs: single thread inode cache shrinking.
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1284461777-1496-2-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-2-git-send-email-david@fromorbit.com>
Date: Tue, 14 Sep 2010 13:48:26 -0500
Message-ID: <1284490106.2098.161.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2010-09-14 at 20:56 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Having multiple CPUs trying to do the same cache shrinking work can
> be actively harmful to perforamnce when the shrinkers land in the
> same AGs.  They then lockstep on perag locks, causing contention and
> slowing each other down. Reclaim walking is sufficiently efficient
> that we do no need parallelism to make significant progress, so stop
> parallel access at the door.
> 
> Instead, keep track of the number of objects the shrinkers want
> cleaned and make sure the single running shrinker does not stop
> until it has hit the threshold that the other shrinker calls have
> built up.
> 
> This increases the cold-cache unlink rate of a 8-way parallel unlink
> workload from about 15,000 unlinks/s to 60-70,000 unlinks/s for the
> same CPU usage (~700%), resulting in the runtime for a 200M inode
> unlink workload dropping from 4h50m to just under 1 hour.

This is an aside, but...

Shrinking still hits the first AG's more than the rest,
right?  I.e. if AG 0 has nr_to_scan reclaimable inodes, no
other AG's get their inodes reclaimed?

Anyway, this change looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/linux-2.6/xfs_sync.c |   21 +++++++++++++++++++--
>  fs/xfs/xfs_mount.h          |    2 ++
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index d59c4a6..bc54cd6 100644

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
