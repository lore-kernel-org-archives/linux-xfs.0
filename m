Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C18C7CB1
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 19:25:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3DCE38F8040
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 17:25:26 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fczOfPa8dN6iPG0c for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2016 17:25:24 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C7C8B63C6064
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 19:25:23 -0600 (CST)
Subject: Re: [PATCH 3/3] xfs: RT bitmap and summary buffers need verifiers
References: <1454373550-3102-1-git-send-email-david@fromorbit.com>
	<1454373550-3102-4-git-send-email-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56B00582.2070506@sandeen.net>
Date: Mon, 1 Feb 2016 19:25:22 -0600
MIME-Version: 1.0
In-Reply-To: <1454373550-3102-4-git-send-email-david@fromorbit.com>
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
> Buffers without verifiers issue runtime warnings on XFS. We don't
> have anything we can actually verify in the RT buffers (no CRCs, not
> magic numbers, etc), but we still need verifiers to avoid the
> warnings.
> 
> Add a set of dummy verifier operations for the realtime buffers and
> apply them in the appropriate places.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c | 27 ++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_shared.h   |  1 +
>  fs/xfs/xfs_log_recover.c     |  4 ++--
>  3 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index bfa7b85..01c0cdb 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -42,6 +42,31 @@
>   */
>  
>  /*
> + * Real time buffers need verifiers to avoid runtime warnigns during IO.

"warnings" ;)

Otherwise:
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> + * We don't have anything to verify, however, so these are just dummy
> + * operations.
> + */
> +static void
> +xfs_rtbuf_verify_read(
> +	struct xfs_buf	*bp)
> +{
> +	return;
> +}
> +
> +static void
> +xfs_rtbuf_verify_write(
> +	struct xfs_buf	*bp)
> +{
> +	return;
> +}
> +
> +const struct xfs_buf_ops xfs_rtbuf_ops = {
> +	.name = "rtbuf",
> +	.verify_read = xfs_rtbuf_verify_read,
> +	.verify_write = xfs_rtbuf_verify_write,
> +};
> +
> +/*
>   * Get a buffer for the bitmap or summary file block specified.
>   * The buffer is returned read and locked.
>   */
> @@ -68,7 +93,7 @@ xfs_rtbuf_get(
>  	ASSERT(map.br_startblock != NULLFSBLOCK);
>  	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
>  				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
> -				   mp->m_bsize, 0, &bp, NULL);
> +				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 15c3ceb..81ac870 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -53,6 +53,7 @@ extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
>  extern const struct xfs_buf_ops xfs_sb_buf_ops;
>  extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
>  extern const struct xfs_buf_ops xfs_symlink_buf_ops;
> +extern const struct xfs_buf_ops xfs_rtbuf_ops;
>  
>  /*
>   * Transaction types.  Used to distinguish types of buffers. These never reach
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e2d7533..9d09a0d 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2475,8 +2475,8 @@ xlog_recover_validate_buf_type(
>  		break;
>  	case XFS_BLFT_RTBITMAP_BUF:
>  	case XFS_BLFT_RTSUMMARY_BUF:
> -		/* no verification of RT buffers is done */
> -		bp->b_ops = NULL;
> +		/* no magic numbers for verification of RT buffers */
> +		bp->b_ops = &xfs_rtbuf_ops;
>  		break;
>  	default:
>  		xfs_warn(mp, "Unknown buffer type %d!",
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
