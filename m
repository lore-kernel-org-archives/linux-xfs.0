Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF3EA7CB1
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 19:26:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D08F5304043
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 17:26:18 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id lXfY5HZp1D8K2SAb for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2016 17:26:17 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id EC84063C6064
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 19:26:16 -0600 (CST)
Subject: Re: [PATCH 2/3] xfs: RT bitmap and summary buffers are not typed
References: <1454373550-3102-1-git-send-email-david@fromorbit.com>
	<1454373550-3102-3-git-send-email-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56B005B7.6040605@sandeen.net>
Date: Mon, 1 Feb 2016 19:26:15 -0600
MIME-Version: 1.0
In-Reply-To: <1454373550-3102-3-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com


On 2/1/16 6:39 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When logging buffers, we attach a type to them that follows the
> buffer all the way into the log and is used to identify the buffer
> contents in log recovery. Both the realtime summary buffers and the
> bitmap buffers do not have types defined or set, so when we try to
> log them we see assert failure:
> 
> XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 294
> 
> Fix this by adding buffer log format types for these buffers, and
> add identification support into log recovery for them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_log_format.h | 2 ++
>  fs/xfs/libxfs/xfs_rtbitmap.c   | 3 +++
>  fs/xfs/xfs_log_recover.c       | 5 +++++
>  3 files changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 03f90b9..d54a801 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -496,6 +496,8 @@ enum xfs_blft {
>  	XFS_BLFT_ATTR_LEAF_BUF,
>  	XFS_BLFT_ATTR_RMT_BUF,
>  	XFS_BLFT_SB_BUF,
> +	XFS_BLFT_RTBITMAP_BUF,
> +	XFS_BLFT_RTSUMMARY_BUF,
>  	XFS_BLFT_MAX_BUF = (1 << XFS_BLFT_BITS),
>  };
>  
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index acc71dd..bfa7b85 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -71,6 +71,9 @@ xfs_rtbuf_get(
>  				   mp->m_bsize, 0, &bp, NULL);
>  	if (error)
>  		return error;
> +
> +	xfs_trans_buf_set_type(tp, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
> +					     : XFS_BLFT_RTBITMAP_BUF);
>  	*bpp = bp;
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 464c5d4..e2d7533 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2473,6 +2473,11 @@ xlog_recover_validate_buf_type(
>  		}
>  		bp->b_ops = &xfs_sb_buf_ops;
>  		break;
> +	case XFS_BLFT_RTBITMAP_BUF:
> +	case XFS_BLFT_RTSUMMARY_BUF:
> +		/* no verification of RT buffers is done */
> +		bp->b_ops = NULL;
> +		break;
>  	default:
>  		xfs_warn(mp, "Unknown buffer type %d!",
>  			 xfs_blft_from_flags(buf_f));
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
