Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4421A29DFF
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 14:09:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 23628304048
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 12:09:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kIFOCuFfFrev4CFf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Sep 2014 12:09:42 -0700 (PDT)
Date: Mon, 29 Sep 2014 15:09:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/11] xfs: simplify xfs_zero_remaining_bytes
Message-ID: <20140929190939.GC35666@bfoster.bfoster>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
	<1411648461-29003-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411648461-29003-12-git-send-email-david@fromorbit.com>
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

On Thu, Sep 25, 2014 at 10:34:21PM +1000, Dave Chinner wrote:
> From: Christoph Hellwig <hch@infradead.org>
> 
> xfs_zero_remaining_bytes() open codes a log of buffer manupulations
					  lot
> to do a read forllowed by a write. It can simply be replaced by an
	       followed
> uncached read followed by a xfs_bwrite() call.
			    an
> 
> [Christoph, can I get your sign-off for this?]
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_util.c | 44 ++++++++++++++------------------------------
>  1 file changed, 14 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 41d9488..c2aaa58 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1122,14 +1122,6 @@ xfs_zero_remaining_bytes(
>  	if (endoff > XFS_ISIZE(ip))
>  		endoff = XFS_ISIZE(ip);
>  
> -	bp = xfs_buf_get_uncached(XFS_IS_REALTIME_INODE(ip) ?
> -					mp->m_rtdev_targp : mp->m_ddev_targp,
> -				  BTOBB(mp->m_sb.sb_blocksize), 0);
> -	if (!bp)
> -		return -ENOMEM;
> -
> -	xfs_buf_unlock(bp);
> -
>  	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
>  		uint lock_mode;
>  
> @@ -1152,32 +1144,24 @@ xfs_zero_remaining_bytes(
>  		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
>  		if (imap.br_state == XFS_EXT_UNWRITTEN)
>  			continue;
> -		XFS_BUF_UNDONE(bp);
> -		XFS_BUF_UNWRITE(bp);
> -		XFS_BUF_READ(bp);
> -		XFS_BUF_SET_ADDR(bp, xfs_fsb_to_db(ip, imap.br_startblock));
>  
> -		error = xfs_buf_submit_wait(bp);
> -		if (error) {
> -			xfs_buf_ioerror_alert(bp,
> -					"xfs_zero_remaining_bytes(read)");
> -			break;
> -		}
> +		error = xfs_buf_read_uncached(XFS_IS_REALTIME_INODE(ip) ?
> +				mp->m_rtdev_targp : mp->m_ddev_targp,
> +				xfs_fsb_to_db(ip, imap.br_startblock),
> +				BTOBB(mp->m_sb.sb_blocksize),
> +				0, &bp, NULL);
> +		if (error)
> +			return error;
> +
>  		memset(bp->b_addr +
> -			(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
> -		      0, lastoffset - offset + 1);
> -		XFS_BUF_UNDONE(bp);
> -		XFS_BUF_UNREAD(bp);
> -		XFS_BUF_WRITE(bp);
> +				(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
> +		       0, lastoffset - offset + 1);
>  
> -		error = xfs_buf_submit_wait(bp);
> -		if (error) {
> -			xfs_buf_ioerror_alert(bp,
> -					"xfs_zero_remaining_bytes(write)");
> -			break;
> -		}
> +		error = xfs_bwrite(bp);
> +		xfs_buf_relse(bp);
> +		if (error)
> +			return error;
>  	}
> -	xfs_buf_free(bp);
>  	return error;
>  }
>  
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
