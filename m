Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728518AbfHESDD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Aug 2019 14:03:03 -0400
Date: Mon, 5 Aug 2019 14:03:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 15/24] xfs: eagerly free shadow buffers to reduce CIL
 footprint
Message-ID: <20190805180300.GE14760@bfoster>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-16-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801021752.4986-16-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Thu, Aug 01, 2019 at 12:17:43PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The CIL can pin a lot of memory and effectively defines the lower
> free memory boundary of operation for XFS. The way we hang onto
> log item shadow buffers "just in case" effectively doubles the
> memory footprint of the CIL for dubious reasons.
> 
> That is, we hang onto the old shadow buffer in case the next time
> we log the item it will fit into the shadow buffer and we won't have
> to allocate a new one. However, we only ever tend to grow dirty
> objects in the CIL through relogging, so once we've allocated a
> larger buffer the old buffer we set as a shadow buffer will never
> get reused as the amount we log never decreases until the item is
> clean. And then for buffer items we free the log item and the shadow
> buffers, anyway. Inode items will hold onto their shadow buffer
> until they are reclaimed - this could double the inode's memory
> footprint for it's lifetime...
> 
> Hence we should just free the old log item buffer when we replace it
> with a new shadow buffer rather than storing it for later use. It's
> not useful, get rid of it as early as possible.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index fa5602d0fd7f..1863a9bdf4a9 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -238,9 +238,7 @@ xfs_cil_prepare_item(
>  	/*
>  	 * If there is no old LV, this is the first time we've seen the item in
>  	 * this CIL context and so we need to pin it. If we are replacing the
> -	 * old_lv, then remove the space it accounts for and make it the shadow
> -	 * buffer for later freeing. In both cases we are now switching to the
> -	 * shadow buffer, so update the the pointer to it appropriately.
> +	 * old_lv, then remove the space it accounts for and free it.
>  	 */

The comment above xlog_cil_alloc_shadow_bufs() needs a similar update
around how we handle the old buffer when the shadow buffer is used.

>  	if (!old_lv) {
>  		if (lv->lv_item->li_ops->iop_pin)
> @@ -251,7 +249,8 @@ xfs_cil_prepare_item(
>  
>  		*diff_len -= old_lv->lv_bytes;
>  		*diff_iovecs -= old_lv->lv_niovecs;
> -		lv->lv_item->li_lv_shadow = old_lv;
> +		kmem_free(old_lv);
> +		lv->lv_item->li_lv_shadow = NULL;
>  	}

So IIUC this is the case where we allocated a shadow buffer, the item
was already pinned (so old_lv is still around) but we ended up using the
shadow buffer for this relog. Instead of keeping the old buffer around
as a new shadow, we toss it. That makes sense, but if the objective is
to not leave dangling shadow buffers around as such, what about the case
where we allocated a shadow buffer but didn't end up using it because
old_lv was reusable? It looks like we still keep the shadow buffer
around in that scenario with a similar lifetime as the swapout scenario
this patch removes. Hm?

Brian

>  
>  	/* attach new log vector to log item */
> -- 
> 2.22.0
> 
