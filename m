Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3PK981x232480 for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 15:09:08 -0500
Message-ID: <4F9859E1.6010601@sgi.com>
Date: Wed, 25 Apr 2012 15:09:05 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 37/37] xfs: make XBF_MAPPED the default behaviour
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-38-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-38-git-send-email-david@fromorbit.com>
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

PS.
On 04/23/12 00:59, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Rather than specifying XBF_MAPPED for almost all buffers, introduce
> XBF_UNMAPPED for the couple of users that use unmapped buffers.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_buf.c         |   28 +++++++++++++---------------
>   fs/xfs/xfs_buf.h         |    4 ++--
>   fs/xfs/xfs_fsops.c       |   10 +++++-----
>   fs/xfs/xfs_inode.c       |    1 +
>   fs/xfs/xfs_log_recover.c |    4 ++--
>   fs/xfs/xfs_trans_buf.c   |    6 ------
>   fs/xfs/xfs_vnodeops.c    |    3 +--
>   7 files changed, 24 insertions(+), 32 deletions(-)
>
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> @@ -707,7 +707,6 @@ xfs_buf_set_empty(
>   	bp->b_length = numblks;
>   	bp->b_io_length = numblks;
>   	bp->b_bn = XFS_BUF_DADDR_NULL;
> -	bp->b_flags&= ~XBF_MAPPED;
>   }
>

I know that bp->baddr is set to NULL and denotes that this is not
mapped, but why not set the XBF_UNMAPPED?

>   static inline struct page *
> @@ -759,7 +758,6 @@ xfs_buf_associate_memory(
>
>   	bp->b_io_length = BTOBB(len);
>   	bp->b_length = BTOBB(buflen);
> -	bp->b_flags |= XBF_MAPPED;
>
>   	return 0;
>   }

I think the answer is no, but can XBF_UNMAPPED be set and leaked here?

Thanks

--Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
