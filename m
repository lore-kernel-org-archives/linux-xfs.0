Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751719AbdATMJn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Jan 2017 07:09:43 -0500
Date: Fri, 20 Jan 2017 07:09:42 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] xfs_logprint: handle log operation split of inode
 item correctly
Message-ID: <20170120120942.GB7220@bfoster.bfoster>
References: <1484832767-39865-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484832767-39865-1-git-send-email-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Thu, Jan 19, 2017 at 09:32:47PM +0800, Hou Tao wrote:
> If an inode log item has 4 log operations, and the 4th operation
> (attr fork op) is splitted to the next log record due to the size
> limitation of log record, xfs_logprint doesn't check whether or not
> the 4th operation is in the current log record and print invalid data.
> 
> xfs_logprint also needs to calculate the count of splitted log
> operations correctly instead of just returning 1.
> 
> The following is the output before patch applied:
...
> 

I wasn't necessarily asking to put the full output into the commit log,
but then again I suppose it doesn't hurt. Eric may want to trim this
down...

> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---

Otherwise this looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the fixups.

Brian

>  logprint/log_misc.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
> 
> v3:
> - update commit log description as suggested by Brian Foster
> - add ASSERT(skip_count == 0) as suggested by Brian Foster
> 
> v2: https://www.spinics.net/lists/linux-xfs/msg03500.html
> - rewrite the commit message to clarify the patch
> - use "skip_count" suggested by Brian Foster
> - fix the indentation
> 
> v1: http://www.spinics.net/lists/linux-xfs/msg03430.html
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index a0f1766..0dfcfd1 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -524,6 +524,7 @@ xlog_print_trans_inode(
>      xfs_inode_log_format_t *f;
>      int			   mode;
>      int			   size;
> +    int			   skip_count;
>  
>      /*
>       * print inode type header region
> @@ -555,15 +556,17 @@ xlog_print_trans_inode(
>  	return f->ilf_size;
>      }
>  
> +    skip_count = f->ilf_size-1;
> +
>      if (*i >= num_ops)			/* end of LR */
> -	    return f->ilf_size-1;
> +	    return skip_count;
>  
>      /* core inode comes 2nd */
>      op_head = (xlog_op_header_t *)*ptr;
>      xlog_print_op_header(op_head, *i, ptr);
>  
>      if (op_head->oh_flags & XLOG_CONTINUE_TRANS)  {
> -	return f->ilf_size-1;
> +        return skip_count;
>      }
>  
>      memmove(&dino, *ptr, sizeof(dino));
> @@ -571,13 +574,7 @@ xlog_print_trans_inode(
>      size = (int)dino.di_size;
>      xlog_print_trans_inode_core(&dino);
>      *ptr += xfs_log_dinode_size(dino.di_version);
> -
> -    if (*i == num_ops-1 && f->ilf_size == 3)  {
> -	return 1;
> -    }
> -
> -    /* does anything come next */
> -    op_head = (xlog_op_header_t *)*ptr;
> +    skip_count--;
>  
>      switch (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
>      case XFS_ILOG_DEV:
> @@ -595,7 +592,12 @@ xlog_print_trans_inode(
>      ASSERT(f->ilf_size <= 4);
>      ASSERT((f->ilf_size == 3) || (f->ilf_fields & XFS_ILOG_AFORK));
>  
> +    /* does anything come next */
> +    op_head = (xlog_op_header_t *)*ptr;
> +
>      if (f->ilf_fields & XFS_ILOG_DFORK) {
> +	    if (*i == num_ops-1)
> +	        return skip_count;
>  	    (*i)++;
>  	    xlog_print_op_header(op_head, *i, ptr);
>  
> @@ -618,11 +620,14 @@ xlog_print_trans_inode(
>  
>  	    *ptr += be32_to_cpu(op_head->oh_len);
>  	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
> -		return 1;
> +	        return skip_count;
>  	    op_head = (xlog_op_header_t *)*ptr;
> +	    skip_count--;
>      }
>  
>      if (f->ilf_fields & XFS_ILOG_AFORK) {
> +	    if (*i == num_ops-1)
> +	        return skip_count;
>  	    (*i)++;
>  	    xlog_print_op_header(op_head, *i, ptr);
>  
> @@ -644,9 +649,12 @@ xlog_print_trans_inode(
>  	    }
>  	    *ptr += be32_to_cpu(op_head->oh_len);
>  	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
> -		return 1;
> +	        return skip_count;
> +	    skip_count--;
>      }
>  
> +    ASSERT(skip_count == 0);
> +
>      return 0;
>  }	/* xlog_print_trans_inode */
>  
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
