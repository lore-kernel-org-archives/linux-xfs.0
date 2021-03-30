Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC16BC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64FAA619CB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhC3STF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232746AbhC3SSe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 14:18:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3A2D61983;
        Tue, 30 Mar 2021 18:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617128313;
        bh=iQsucNfwSUrbWrmSR0D6eVOtmU8qa6kxkGqxGF5F6wQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uIUWjMzJnDcHj4SfhckEHvzGyFRtac97UJX4daoJwtWRaj80zts5fUpEqVYky7gHg
         tjPkeT5n8ijXkVfTSzlzbIpLk3mzDb/1oHwUt7j5k6VfjKnFx3jlo8690pWxqX8WUx
         cvpIhjU0+c8U5u/PHDr8jqOGLDVatQrlcaYO3NjbhMS3bCzcFlLReB7zelUIlk+ahs
         RNZadRwBueGkM+LimOkDeTLuJtTbXkaFIMzxMI9j0XDms/4RlZ1TBPGX867CfWxfau
         SxB/TRi4gmu7ZRrUWvaOIUmdATZfbkMH1ldHV4zOJKvTnLT3GvgR4DSS0zll3eq3gF
         PfGyWvt/2+o5g==
Date:   Tue, 30 Mar 2021 11:18:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH v3 5/8] repair: parallelise phase 6
Message-ID: <20210330181832.GW4090233@magnolia>
References: <20210330142531.19809-1-hsiangkao@aol.com>
 <20210330142531.19809-6-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330142531.19809-6-hsiangkao@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 10:25:28PM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A recent metadump provided to us caused repair to take hours in
> phase6. It wasn't IO bound - it was fully CPU bound the entire time.
> The only way to speed it up is to make phase 6 run multiple
> concurrent processing threads.
> 
> The obvious way to do this is to spread the concurrency across AGs,
> like the other phases, and while this works it is not optimal. When
> a processing thread hits a really large directory, it essentially
> sits CPU bound until that directory is processed. IF an AG has lots
> of large directories, we end up with a really long single threaded
> tail that limits concurrency.
> 
> Hence we also need to have concurrency /within/ the AG. This is
> realtively easy, as the inode chunk records allow for a simple
> concurrency mechanism within an AG. We can simply feed each chunk
> record to a workqueue, and we get concurrency within the AG for
> free. However, this allows prefetch to run way ahead of processing
> and this blows out the buffer cache size and can cause OOM.
> 
> However, we can use the new workqueue depth limiting to limit the
> number of inode chunks queued, and this then backs up the inode
> prefetching to it's maximum queue depth. Hence we prevent having the
> prefetch code queue the entire AG's inode chunks on the workqueue
> blowing out memory by throttling the prefetch consumer.
> 
> This takes phase 6 from taking many, many hours down to:
> 
> Phase 6:        10/30 21:12:58  10/30 21:40:48  27 minutes, 50 seconds
> 
> And burning 20-30 cpus that entire time on my test rig.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  repair/phase6.c | 42 ++++++++++++++++++++++++++++++++++--------
>  1 file changed, 34 insertions(+), 8 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 14464befa8b6..e51784521d28 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -6,6 +6,7 @@
>  
>  #include "libxfs.h"
>  #include "threads.h"
> +#include "threads.h"
>  #include "prefetch.h"
>  #include "avl.h"
>  #include "globals.h"
> @@ -3105,20 +3106,44 @@ check_for_orphaned_inodes(
>  }
>  
>  static void
> -traverse_function(
> +do_dir_inode(
>  	struct workqueue	*wq,
> -	xfs_agnumber_t 		agno,
> +	xfs_agnumber_t		agno,
>  	void			*arg)
>  {
> -	ino_tree_node_t 	*irec;
> +	struct ino_tree_node	*irec = arg;
>  	int			i;
> +
> +	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
> +		if (inode_isadir(irec, i))
> +			process_dir_inode(wq->wq_ctx, agno, irec, i);
> +	}
> +}
> +
> +static void
> +traverse_function(
> +	struct workqueue	*wq,
> +	xfs_agnumber_t		agno,
> +	void			*arg)
> +{
> +	struct ino_tree_node	*irec;
>  	prefetch_args_t		*pf_args = arg;
> +	struct workqueue	lwq;
> +	struct xfs_mount	*mp = wq->wq_ctx;
>  
>  	wait_for_inode_prefetch(pf_args);
>  
>  	if (verbose)
>  		do_log(_("        - agno = %d\n"), agno);
>  
> +	/*
> +	 * The more AGs we have in flight at once, the fewer processing threads
> +	 * per AG. This means we don't overwhelm the machine with hundreds of
> +	 * threads when we start acting on lots of AGs at once. We just want
> +	 * enough that we can keep multiple CPUs busy across multiple AGs.
> +	 */
> +	workqueue_create_bound(&lwq, mp, ag_stride, 1000);

At some point I realized that two reviews ago I mixed up the last two
arguments and thought that we were creating 1000 threads.  We're not,
we're creating ag_stride threads and saying that we want to throttle
queue_work if the queue reaches 1000 directory inodes.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +
>  	for (irec = findfirst_inode_rec(agno); irec; irec = next_ino_rec(irec)) {
>  		if (irec->ino_isa_dir == 0)
>  			continue;
> @@ -3126,18 +3151,19 @@ traverse_function(
>  		if (pf_args) {
>  			sem_post(&pf_args->ra_count);
>  #ifdef XR_PF_TRACE
> +			{
> +			int	i;
>  			sem_getvalue(&pf_args->ra_count, &i);
>  			pftrace(
>  		"processing inode chunk %p in AG %d (sem count = %d)",
>  				irec, agno, i);
> +			}
>  #endif
>  		}
>  
> -		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
> -			if (inode_isadir(irec, i))
> -				process_dir_inode(wq->wq_ctx, agno, irec, i);
> -		}
> +		queue_work(&lwq, do_dir_inode, agno, irec);
>  	}
> +	destroy_work_queue(&lwq);
>  	cleanup_inode_prefetch(pf_args);
>  }
>  
> @@ -3165,7 +3191,7 @@ static void
>  traverse_ags(
>  	struct xfs_mount	*mp)
>  {
> -	do_inode_prefetch(mp, 0, traverse_function, false, true);
> +	do_inode_prefetch(mp, ag_stride, traverse_function, false, true);
>  }
>  
>  void
> -- 
> 2.20.1
> 
