Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2421 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbfHFSVe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Aug 2019 14:21:34 -0400
Date: Tue, 6 Aug 2019 14:21:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 17/24] xfs: don't block kswapd in inode reclaim
Message-ID: <20190806182131.GE2979@bfoster>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-18-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801021752.4986-18-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Thu, Aug 01, 2019 at 12:17:45PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We have a number of reasons for blocking kswapd in XFS inode
> reclaim, mainly all to do with the fact that memory reclaim has no
> feedback mechanisms to throttle on dirty slab objects that need IO
> to reclaim.
> 
> As a result, we currently throttle inode reclaim by issuing IO in
> the reclaim context. The unfortunate side effect of this is that it
> can cause long tail latencies in reclaim and for some workloads this
> can be a problem.
> 
> Now that the shrinkers finally have a method of telling kswapd to
> back off, we can start the process of making inode reclaim in XFS
> non-blocking. The first thing we need to do is not block kswapd, but
> so that doesn't cause immediate serious problems, make sure inode
> writeback is always underway when kswapd is running.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0b0fd10a36d4..2fa2f8dcf86b 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1378,11 +1378,22 @@ xfs_reclaim_inodes_nr(
>  	struct xfs_mount	*mp,
>  	int			nr_to_scan)
>  {
> -	/* kick background reclaimer and push the AIL */
> +	int			sync_mode = SYNC_TRYLOCK;
> +
> +	/* kick background reclaimer */
>  	xfs_reclaim_work_queue(mp);
> -	xfs_ail_push_all(mp->m_ail);
>  
> -	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT, &nr_to_scan);
> +	/*
> +	 * For kswapd, we kick background inode writeback. For direct
> +	 * reclaim, we issue and wait on inode writeback to throttle
> +	 * reclaim rates and avoid shouty OOM-death.
> +	 */
> +	if (current_is_kswapd())
> +		xfs_ail_push_all(mp->m_ail);

So we're unblocking kswapd from dirty items, but we already kick the AIL
regardless of kswapd or not in inode reclaim. Why the change to no
longer kick the AIL in the !kswapd case? Whatever the reasoning, a
mention in the commit log would be helpful...

Brian

> +	else
> +		sync_mode |= SYNC_WAIT;
> +
> +	return xfs_reclaim_inodes_ag(mp, sync_mode, &nr_to_scan);
>  }
>  
>  /*
> -- 
> 2.22.0
> 
