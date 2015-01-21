Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0CDF87F4E
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 16:06:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF9B98F8059
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 14:06:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CZ2UIl4k7IZHWBmE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 14:06:33 -0800 (PST)
Date: Wed, 21 Jan 2015 17:06:27 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/3] xfs: set superblock buffer type correctly
Message-ID: <20150121220627.GE7960@laptop.bfoster>
References: <1421800780-26008-1-git-send-email-david@fromorbit.com>
	<20150121023444.GI16552@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150121023444.GI16552@dastard>
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

On Wed, Jan 21, 2015 at 01:34:44PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When the superblock is modified in a transaction, the commonly
> modified fields are not actually copied to the superblock buffer to
> avoid the buffer lock becoming a serialisation point. However, there
> are some other operations that modify the superblock fields within
> the transaction that don't directly log to the superblock but rely
> on the changes to be applied during the transaction commit (to
> minimise the buffer lock hold time).
> 
> When we do this, we fail to mark the buffer log item as being a
> superblock buffer and that can lead to the buffer not being marked
> with the corect type in the log and hence causing recovery issues.
> Fix it by setting the type correctly, similar to xfs_mod_sb()...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index fa3135b..eb90cd5 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -472,6 +472,7 @@ xfs_trans_apply_sb_deltas(
>  		whole = 1;
>  	}
>  
> +	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
>  	if (whole)
>  		/*
>  		 * Log the whole thing, the fields are noncontiguous.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
