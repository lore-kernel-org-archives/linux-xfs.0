Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A8FD17F4E
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 16:05:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 88C898F8040
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 14:05:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6s9NerEkIY4SqkbP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 14:05:40 -0800 (PST)
Date: Wed, 21 Jan 2015 17:05:34 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: ensure buffer types are set correctly
Message-ID: <20150121220534.GB7960@laptop.bfoster>
References: <1421800780-26008-1-git-send-email-david@fromorbit.com>
	<1421800780-26008-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421800780-26008-2-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, xfs@oss.sgi.com

On Wed, Jan 21, 2015 at 11:39:38AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Jan Kara reported that log recovery was finding buffers with invalid
> types in them. This should not happen, and indicates a bug in the
> logging of buffers. To catch this, add asserts to the buffer
> formatting code to ensure that the buffer type is in range when the
> transaction is committed.
> 
> We don't set a type on buffers being marked stale - they are not
> going to get replayed, the format item exists only for recovery to
> be able to prevent replay of the buffer, so the type does not
> matter. Hence that needs special casing here.
> 
> Reported-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf_item.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 925ead2..507d96a 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -319,6 +319,10 @@ xfs_buf_item_format(
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
>  	       (bip->bli_flags & XFS_BLI_STALE));
> +	ASSERT((bip->bli_flags & XFS_BLI_STALE) ||
> +	       (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF
> +	        && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF));
> +
>  
>  	/*
>  	 * If it is an inode buffer, transfer the in-memory state to the
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
