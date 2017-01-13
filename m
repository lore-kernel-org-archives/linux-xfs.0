Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751771AbdAMPtm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jan 2017 10:49:42 -0500
Date: Fri, 13 Jan 2017 10:49:41 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs_logprint: handle log operation split of inode
 item correctly
Message-ID: <20170113154941.GG22013@bfoster.bfoster>
References: <1484305530-19129-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484305530-19129-1-git-send-email-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Fri, Jan 13, 2017 at 07:05:30PM +0800, Hou Tao wrote:
> If the data/attr fork log operations of an inode log item are splitted to
> the next log record, xfs_logprint doesn't check the remaining log operations
> in current log record and still tries to print these log operations which
> don't exist in the log record. The content of these log operations will be
> incorrect, or worse xfs_logprint will trigger a segment-fault and exit.
> 
> xfs_logprint also doesn't calculate the count of the splitted log operations
> correctly. It just returns 1 when the current log operation is splitted to
> the next log record. It needs to consider the log operations behind.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---

A couple minor things..

First, could you please update the commit log as noted in my last reply
to v1?

>  logprint/log_misc.c | 28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> v2:
> - rewrite the commit message to clarify the patch
> - use "skip_count" suggested by Brian Foster
> - fix the indentation
> 
> v1: http://www.spinics.net/lists/linux-xfs/msg03430.html
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index a0f1766..4fa0ce1 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
...
> @@ -644,7 +649,8 @@ xlog_print_trans_inode(
>  	    }
>  	    *ptr += be32_to_cpu(op_head->oh_len);
>  	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
> -		return 1;
> +	        return skip_count;
> +	    skip_count--;
>      }
>  
>      return 0;

Could we ASSERT(skip_count == 0) before we return here?

Otherwise this looks Ok to me.

Brian

> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
