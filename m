Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KNM12d012930 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 18:22:02 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	KYGzPV4donF8y6R4 for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 16:22:00 -0700 (PDT)
Date: Tue, 21 Aug 2012 09:21:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix race while discarding buffers [V4]
Message-ID: <20120820232158.GN19235@dastard>
References: <1344621711-8049-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1344621711-8049-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 10, 2012 at 03:01:51PM -0300, Carlos Maiolino wrote:
> While xfs_buftarg_shrink() is freeing buffers from the dispose list (filled with
> buffers from lru list), there is a possibility to have xfs_buf_stale() racing
> with it, and removing buffers from dispose list before xfs_buftarg_shrink() does
> it.
> 
> This happens because xfs_buftarg_shrink() handle the dispose list without
> locking and the test condition in xfs_buf_stale() checks for the buffer being in
> *any* list:
> 
> if (!list_empty(&bp->b_lru)
> 
> If the buffer happens to be on dispose list, this causes the buffer counter of
> lru list (btp->bt_lru_nr) to be decremented twice (once in xfs_buftarg_shrink()
> and another in xfs_buf_stale()) causing a wrong account usage of the lru list.
> 
> This may cause xfs_buftarg_shrink() to return a wrong value to the memory
> shrinker shrink_slab(), and such account error may also cause an underflowed
> value to be returned; since the counter is lower than the current number of
> items in the lru list, a decrement may happen when the counter is 0, causing
> an underflow on the counter.
> 
> The fix uses a new flag field (and a new buffer flag) to serialize buffer
> handling during the shrink process. The new flag field has been designed to use
> btp->bt_lru_lock/unlock instead of xfs_buf_lock/unlock mechanism.
> 
> dchinner, sandeen, aquini and aris also deserve credits for this.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
