Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21041 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbdGAEny (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Jul 2017 00:43:54 -0400
Date: Fri, 30 Jun 2017 21:43:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfs: always verify the log tail during recovery
Message-ID: <20170701044349.GU5874@birch.djwong.org>
References: <1498574436-57561-1-git-send-email-bfoster@redhat.com>
 <1498574436-57561-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498574436-57561-3-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 27, 2017 at 10:40:34AM -0400, Brian Foster wrote:
> Log tail verification currently only occurs when torn writes are
> detected at the head of the log. This was introduced because a
> change in the head block due to torn writes can lead to a change in
> the tail block (each log record header references the current tail)
> and the tail block should be verified before log recovery proceeds.
> 
> Tail corruption is possible outside of torn write scenarios,
> however. For example, partial log writes can be detected and cleared
> during the initial head/tail block discovery process. If the partial
> write coincides with a tail overwrite, the log tail is corrupted and
> recovery fails.
> 
> To facilitate correct handling of log tail overwites, update log
> recovery to always perform tail verification. This is necessary to
> detect potential tail overwrite conditions when torn writes may not
> have occurred. This changes normal (i.e., no torn writes) recovery
> behavior slightly to detect and return CRC related errors near the
> tail before actual recovery starts.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_log_recover.c | 24 +-----------------------
>  1 file changed, 1 insertion(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 9efcd12..269d5f9 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1183,31 +1183,9 @@ xlog_verify_head(
>  			ASSERT(0);
>  			return 0;
>  		}
> -
> -		/*
> -		 * Now verify the tail based on the updated head. This is
> -		 * required because the torn writes trimmed from the head could
> -		 * have been written over the tail of a previous record. Return
> -		 * any errors since recovery cannot proceed if the tail is
> -		 * corrupt.
> -		 *
> -		 * XXX: This leaves a gap in truly robust protection from torn
> -		 * writes in the log. If the head is behind the tail, the tail
> -		 * pushes forward to create some space and then a crash occurs
> -		 * causing the writes into the previous record's tail region to
> -		 * tear, log recovery isn't able to recover.
> -		 *
> -		 * How likely is this to occur? If possible, can we do something
> -		 * more intelligent here? Is it safe to push the tail forward if
> -		 * we can determine that the tail is within the range of the
> -		 * torn write (e.g., the kernel can only overwrite the tail if
> -		 * it has actually been pushed forward)? Alternatively, could we
> -		 * somehow prevent this condition at runtime?
> -		 */
> -		error = xlog_verify_tail(log, *head_blk, *tail_blk);
>  	}
>  
> -	return error;
> +	return xlog_verify_tail(log, *head_blk, *tail_blk);

What if (error != 0 && error != -EFSBADCRC) here?  If the CRC checking log
recovery pass failed due to some other reason (EIO, ENOMEM, etc.) then is
there really a point to verifying the tail, vs. bubbling the error up and
(I presume) failing the mount?

--D

>  }
>  
>  /*
> -- 
> 2.7.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
