Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 381437F5D
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 17:26:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 241B08F8033
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 15:26:21 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	14KqDaoJJvTAJgRI for <xfs@oss.sgi.com>;
	Mon, 04 Feb 2013 15:26:19 -0800 (PST)
Date: Tue, 5 Feb 2013 10:26:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: another memory barrier before wake_up_bit()
Message-ID: <20130204232617.GO2667@dastard>
References: <510FDDE5.4050103@inktank.com>
 <510FDE23.9050801@inktank.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <510FDE23.9050801@inktank.com>
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
To: Alex Elder <elder@inktank.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 04, 2013 at 10:13:23AM -0600, Alex Elder wrote:
> In xfs_inode_item_unpin() there is a call to wake_up_bit() following
> an independent test for whether waiters should be awakened.  This
> requires a memory barrier in order to guarantee correct operation
> (see the comment above wake_up_bit()).
> 
> Signed-off-by: Alex Elder <elder@inktank.com>
> ---
>  fs/xfs/xfs_inode_item.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index d041d47..a7cacf7 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -474,8 +474,10 @@ xfs_inode_item_unpin(
> 
>  	trace_xfs_inode_unpin(ip, _RET_IP_);
>  	ASSERT(atomic_read(&ip->i_pincount) > 0);
> -	if (atomic_dec_and_test(&ip->i_pincount))
> -		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
> +	if (!atomic_dec_and_test(&ip->i_pincount))
> +		return;
> +	smp_mb();
> +	wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);

I'm not sure this a barrier is actually needed here.  The "wake up"
bit is never stored or cleared anywhere in this case, it is used
only to define a wait channel and directed wake up. Hence the "need
a barrier so all CPUs see the cleared bit" case doesn't arise here.
We use an atomic variable instead, and that makes it safe.

If you read Documentation/atomic_ops.txt, you'll find that atomic
modification operations are required to have explicit barrier
semantics. i.e. that atomic_dec_and_test() must behave like it has
both a smp_mb() before and after the atomic operation. i.e:

	Unlike the above routines, it is required that explicit memory
	barriers are performed before and after the operation.  It must be
	done such that all memory operations before and after the atomic
	operation calls are strongly ordered with respect to the atomic
	operation itself.

So, the smp_mb() that is added here is redundant - the
atomic_dec_and_test() call already has the necesary memory barriers
that wake_up_bit() requires.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
