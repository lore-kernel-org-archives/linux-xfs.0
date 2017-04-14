Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24925 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbdDNSnl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Apr 2017 14:43:41 -0400
Date: Fri, 14 Apr 2017 11:43:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove the trailing newline used in the fmt
 parameter of TP_printk
Message-ID: <20170414184309.GB8502@birch.djwong.org>
References: <1492139578-5261-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1492139578-5261-1-git-send-email-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 14, 2017 at 11:12:58AM +0800, Hou Tao wrote:
> The trailing newlines wil lead to extra newlines in the trace file
> which looks like the following output, so remove them.
> >kworker/4:1H-1508  [004] .... 47879.101608: xfs_discard_extent: dev 8:0
> >
> >kworker/u16:2-238  [004] .... 47879.101725: xfs_extent_busy_clear: dev 8:0
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trace.h | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 383ac22..3ee5ecc 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2190,7 +2190,7 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
>  		__entry->agbno = agbno;
>  		__entry->len = len;
>  	),
> -	TP_printk("dev %d:%d agno %u agbno %u len %u\n",
> +	TP_printk("dev %d:%d agno %u agbno %u len %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -2262,7 +2262,7 @@ DECLARE_EVENT_CLASS(xfs_defer_class,
>  		__entry->committed = dop->dop_committed;
>  		__entry->low = dop->dop_low;
>  	),
> -	TP_printk("dev %d:%d ops %p committed %d low %d\n",
> +	TP_printk("dev %d:%d ops %p committed %d low %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->dop,
>  		  __entry->committed,
> @@ -2290,7 +2290,7 @@ DECLARE_EVENT_CLASS(xfs_defer_error_class,
>  		__entry->low = dop->dop_low;
>  		__entry->error = error;
>  	),
> -	TP_printk("dev %d:%d ops %p committed %d low %d err %d\n",
> +	TP_printk("dev %d:%d ops %p committed %d low %d err %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->dop,
>  		  __entry->committed,
> @@ -2319,7 +2319,7 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_class,
>  		__entry->committed = dfp->dfp_done != NULL;
>  		__entry->nr = dfp->dfp_count;
>  	),
> -	TP_printk("dev %d:%d optype %d intent %p committed %d nr %d\n",
> +	TP_printk("dev %d:%d optype %d intent %p committed %d nr %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->type,
>  		  __entry->intent,
> @@ -2614,7 +2614,8 @@ DECLARE_EVENT_CLASS(xfs_ag_resv_class,
>  		__entry->asked = r ? r->ar_asked : 0;
>  		__entry->len = len;
>  	),
> -	TP_printk("dev %d:%d agno %u resv %d freeblks %u flcount %u resv %u ask %u len %u\n",
> +	TP_printk("dev %d:%d agno %u resv %d freeblks %u flcount %u "
> +		  "resv %u ask %u len %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->resv,
> @@ -2667,7 +2668,7 @@ DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
>  		__entry->agbno = agbno;
>  		__entry->dir = dir;
>  	),
> -	TP_printk("dev %d:%d agno %u agbno %u cmp %s(%d)\n",
> +	TP_printk("dev %d:%d agno %u agbno %u cmp %s(%d)",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -2700,7 +2701,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
>  		__entry->blockcount = irec->rc_blockcount;
>  		__entry->refcount = irec->rc_refcount;
>  	),
> -	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u\n",
> +	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startblock,
> @@ -2735,7 +2736,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
>  		__entry->refcount = irec->rc_refcount;
>  		__entry->agbno = agbno;
>  	),
> -	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u @ agbno %u\n",
> +	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u @ agbno %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startblock,
> @@ -2776,7 +2777,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
>  		__entry->i2_refcount = i2->rc_refcount;
>  	),
>  	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
> -		  "agbno %u len %u refcount %u\n",
> +		  "agbno %u len %u refcount %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->i1_startblock,
> @@ -2822,7 +2823,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
>  		__entry->agbno = agbno;
>  	),
>  	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
> -		  "agbno %u len %u refcount %u @ agbno %u\n",
> +		  "agbno %u len %u refcount %u @ agbno %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->i1_startblock,
> @@ -2875,7 +2876,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
>  	),
>  	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
>  		  "agbno %u len %u refcount %u -- "
> -		  "agbno %u len %u refcount %u\n",
> +		  "agbno %u len %u refcount %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->i1_startblock,
> @@ -3227,7 +3228,7 @@ TRACE_EVENT(xfs_ioctl_clone,
>  	),
>  	TP_printk("dev %d:%d "
>  		  "ino 0x%lx isize 0x%llx -> "
> -		  "ino 0x%lx isize 0x%llx\n",
> +		  "ino 0x%lx isize 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->src_ino,
>  		  __entry->src_isize,
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
