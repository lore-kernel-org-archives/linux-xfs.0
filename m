Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AF0NQc168975 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 10:00:28 -0500
Message-ID: <4F844B02.2030301@sgi.com>
Date: Tue, 10 Apr 2012 10:00:18 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: kill XBF_LOCK
References: <1334052213-26870-1-git-send-email-david@fromorbit.com>
	<1334052213-26870-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1334052213-26870-2-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/10/12 05:03, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Buffers are always returned locked from the lookup routines. Hence
> we don't need to tell the lookup routines to return locked buffers,
> on to try and lock them. Remove XBF_LOCK from all the callers and
> from internal buffer cache usage.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_attr.c        |    5 ++---
>   fs/xfs/xfs_attr_leaf.c   |    2 +-
>   fs/xfs/xfs_buf.c         |   20 +++++---------------
>   fs/xfs/xfs_buf.h         |    4 +---
>   fs/xfs/xfs_fsops.c       |   13 +++++--------
>   fs/xfs/xfs_ialloc.c      |    3 +--
>   fs/xfs/xfs_inode.c       |   16 +++++++---------
>   fs/xfs/xfs_log_recover.c |    7 +++----
>   fs/xfs/xfs_rw.c          |    2 +-
>   fs/xfs/xfs_trans_buf.c   |    4 ++--
>   fs/xfs/xfs_vnodeops.c    |    2 +-
>   11 files changed, 29 insertions(+), 49 deletions(-)
>

> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 7a945fd..8d76df1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -179,7 +179,7 @@ xfs_buf_alloc(
>   	/*
>   	 * We don't want certain flags to appear in b_flags.
>   	 */
> -	flags&= ~(XBF_LOCK|XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
> +	flags&= ~(XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
>
>   	atomic_set(&bp->b_hold, 1);
>   	atomic_set(&bp->b_lru_ref, 1);
> @@ -578,19 +578,14 @@ found:
>   		if (unlikely(error)) {
>   			xfs_warn(target->bt_mount,
>   				"%s: failed to map pages\n", __func__);
> -			goto no_buffer;
> +			xfs_buf_relse(bp);
> +			return NULL;
>   		}
>   	}
>
>   	XFS_STATS_INC(xb_get);
>   	trace_xfs_buf_get(bp, flags, _RET_IP_);
>   	return bp;
> -
> -no_buffer:
> -	if (flags&  (XBF_LOCK | XBF_TRYLOCK))
> -		xfs_buf_unlock(bp);
> -	xfs_buf_rele(bp);
> -	return NULL;
>   }


Do you have a new copy of the "xfs: fix buffer lookup race on allocation 
failure" patch. It would go about here in the sources.

The reason I ask, the sources that I have for xfs_buf_get() seems to 
still have a "goto no_buffer" for the failed xfs_buf_allocate_memory() 
call and this patch removes that call. I did not find anything in the 8 
buf clean-up series that would alter this area.


Thank-you,

--Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
