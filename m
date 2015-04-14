Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5F5E27F47
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 09:23:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CDA93AC001
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 07:23:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tDgoj8Y6eevHzl8f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 07:23:48 -0700 (PDT)
Date: Tue, 14 Apr 2015 10:23:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/8] xfs: factor DIO write mapping from get_blocks
Message-ID: <20150414142345.GB36198@bfoster.bfoster>
References: <1428996411-1507-1-git-send-email-david@fromorbit.com>
	<1428996411-1507-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428996411-1507-2-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Tue, Apr 14, 2015 at 05:26:44PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clarify and separate the buffer mapping logic so that the direct IO mapping is
> not tangled up in propagating the extent status to teh mapping buffer. This
> makes it easier to extend the direct IO mapping to use an ioend in future.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 3a9b7a1..5f7ddd5 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1233,6 +1233,22 @@ xfs_vm_releasepage(
>  	return try_to_free_buffers(page);
>  }
>  
> +/*
> + * do all the direct IO specific mapping buffer manipulation here.
> + */
> +static void
> +xfs_map_direct(
> +	struct inode		*inode,
> +	struct buffer_head	*bh_result,
> +	struct xfs_bmbt_irec	*imap,
> +	xfs_off_t		offset)
> +{
> +	if (ISUNWRITTEN(imap)) {
> +		bh_result->b_private = inode;
> +		set_buffer_defer_completion(bh_result);
> +	}
> +}
> +
>  STATIC int
>  __xfs_get_blocks(
>  	struct inode		*inode,
> @@ -1332,20 +1348,14 @@ __xfs_get_blocks(
>  	}
>  
>  	if (imap.br_startblock != HOLESTARTBLOCK &&
> -	    imap.br_startblock != DELAYSTARTBLOCK) {
> -		/*
> -		 * For unwritten extents do not report a disk address on
> -		 * the read case (treat as if we're reading into a hole).
> -		 */

Can we keep this comment and move it before this block?

Brian

> -		if (create || !ISUNWRITTEN(&imap))
> -			xfs_map_buffer(inode, bh_result, &imap, offset);
> -		if (create && ISUNWRITTEN(&imap)) {
> -			if (direct) {
> -				bh_result->b_private = inode;
> -				set_buffer_defer_completion(bh_result);
> -			}
> +	    imap.br_startblock != DELAYSTARTBLOCK &&
> +	    (create || !ISUNWRITTEN(&imap))) {
> +		xfs_map_buffer(inode, bh_result, &imap, offset);
> +		if (ISUNWRITTEN(&imap))
>  			set_buffer_unwritten(bh_result);
> -		}
> +		/* direct IO needs special help */
> +		if (create && direct)
> +			xfs_map_direct(inode, bh_result, &imap, offset);
>  	}
>  
>  	/*
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
