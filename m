Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62301 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751155AbeAYRbe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jan 2018 12:31:34 -0500
Date: Thu, 25 Jan 2018 12:31:32 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/11] xfs: make tracepoint inode number format consistent
Message-ID: <20180125173132.GD44175@bfoster.bfoster>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676033957.12349.16083428926683751541.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676033957.12349.16083428926683751541.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 06:18:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix all the inode number formats to be consistently (0x%llx) in all
> trace point definitions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/trace.h |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 732775f..eb420a41 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -50,7 +50,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_class,
>  		__entry->flags = sm->sm_flags;
>  		__entry->error = error;
>  	),
> -	TP_printk("dev %d:%d ino %llu type %u agno %u inum %llu gen %u flags 0x%x error %d",
> +	TP_printk("dev %d:%d ino 0x%llx type %u agno %u inum %llu gen %u flags 0x%x error %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->type,
> @@ -121,7 +121,7 @@ TRACE_EVENT(xfs_scrub_file_op_error,
>  		__entry->error = error;
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu error %d ret_ip %p",
> +	TP_printk("dev %d:%d ino 0x%llx fork %d type %u offset %llu error %d ret_ip %p",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->whichfork,
> @@ -207,7 +207,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_ino_error_class,
>  		__entry->bno = bno;
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d ino %llu type %u agno %u agbno %u ret_ip %p",
> +	TP_printk("dev %d:%d ino 0x%llx type %u agno %u agbno %u ret_ip %p",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->type,
> @@ -246,7 +246,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_fblock_error_class,
>  		__entry->offset = offset;
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu ret_ip %p",
> +	TP_printk("dev %d:%d ino 0x%llx fork %d type %u offset %llu ret_ip %p",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->whichfork,
> @@ -354,7 +354,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_op_error,
>  		__entry->error = error;
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %p",
> +	TP_printk("dev %d:%d ino 0x%llx fork %d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %p",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->whichfork,
> @@ -433,7 +433,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_error,
>  		__entry->ptr = cur->bc_ptrs[level];
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %p",
> +	TP_printk("dev %d:%d ino 0x%llx fork %d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %p",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->whichfork,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
