Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FHjpEL202266 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 12:45:52 -0500
Subject: Re: [PATCH 14/18] xfs: convert buffer cache hash to rbtree
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1284461777-1496-15-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-15-git-send-email-david@fromorbit.com>
Date: Wed, 15 Sep 2010 12:46:35 -0500
Message-ID: <1284572795.2452.13.camel@doink>
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
> The buffer cache hash is showing typical hash scalability problems.
> In large scale testing the number of cached items growing far larger
> than the hash can efficiently handle. Hence we need to move to a
> self-scaling cache indexing mechanism.
> 
> I have selected rbtrees for indexing becuse they can have O(log n)
> search scalability, and insert and remove cost is not excessive,
> even on large trees. Hence we should be able to cache large numbers
> of buffers without incurring the excessive cache miss search
> penalties that the hash is imposing on us.
> 
> To ensure we still have parallel access to the cache, we need
> multiple trees. Rather than hashing the buffers by disk address to
> select a tree, it seems more sensible to separate trees by typical
> access patterns. Most operations use buffers from within a single AG
> at a time, so rather than searching lots of different lists,
> separate the buffer indexes out into per-AG rbtrees. This means that
> searches during metadata operation have a much higher chance of
> hitting cache resident nodes, and that updates of the tree are less
> likely to disturb trees being accessed on other CPUs doing
> independent operations.

I didn't review this time as carefully as I did
when you originally posted this.  Some parts from
the original are now in separate patches.  But this
looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |  138 +++++++++++++++++++++----------------------
>  fs/xfs/linux-2.6/xfs_buf.h |    8 +--
>  fs/xfs/xfs_ag.h            |    4 +
>  fs/xfs/xfs_mount.c         |    2 +
>  4 files changed, 75 insertions(+), 77 deletions(-)

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
