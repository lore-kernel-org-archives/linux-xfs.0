Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E53D87F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 15:49:31 -0500 (CDT)
Message-ID: <521E625A.2070109@sgi.com>
Date: Wed, 28 Aug 2013 15:49:30 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: check LSN ordering for v5 superblocks during
	recovery
References: <1377688967-6480-1-git-send-email-david@fromorbit.com>
	<1377688967-6480-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1377688967-6480-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/28/13 06:22, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Log recovery has some strict ordering requirements which unordered
> or reordered metadata writeback can defeat. This can occur when an
> item is logged in a transaction, written back to disk, and then
> logged in a new transaction before the tail of the log is moved past
> the original modification.
>
> The result of this is that when we read an object off disk for
> recovery purposes, the buffer that we read may not contain the
> object type that recovery is expecting and hence at the end of the
> checkpoint being recovered we have an invalid object in memory.
>
> This isn't usually a problem, as recovery will then replay all the
> other checkpoints and that brings the object back to a valid and
> correct state, but the issue is that while the object is in the
> invalid state it can be flushed to disk. This results in the object
> verifier failing and triggering a corruption shutdown of log
> recover. This is correct behaviour for the verifiers - the problem
> is that we are not detecting that the object we've read off disk is
> newer than the transaction we are replaying.
>
> All metadata in v5 filesystems has the LSN of it's last modification
> stamped in it. This enabled log recover to read that field and
> determine the age of the object on disk correctly. If the LSN of the
> object on disk is older than the transaction being replayed, then we
> replay the modification. If the LSN of the object matches or is more
> recent than the transaction's LSN, then we should avoid overwriting
> the object as that is what leads to the transient corrupt state.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


> @@ -2488,7 +2595,7 @@ xlog_recover_buffer_pass2(
>   		xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
>   	}
>   	if (error)
> -		return XFS_ERROR(error);
> +		goto out_release;
>

This adds a xfs_buf_relse() on the buffer in the error path. The 
reference was taken in this routine. The callers do not know of the 
buffer and can't release it. convinced me.


>   	/*
>   	 * Perform delayed write on the buffer.  Asynchronous writes will be
> @@ -2517,6 +2624,7 @@ xlog_recover_buffer_pass2(
>   		xfs_buf_delwri_queue(bp, buffer_list);
>   	}
>
> +out_release:
>   	xfs_buf_relse(bp);
>   	return error;

Looks good. Nice to get into Linux 3.12 and possibly back to stable.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
