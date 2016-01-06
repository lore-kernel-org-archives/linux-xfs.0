Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C7C2E7F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 08:34:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9361304066
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 06:34:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wWn9ddmDBvfmEkOv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2016 06:34:12 -0800 (PST)
Date: Wed, 6 Jan 2016 09:34:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: handle dquot buffer readahead in log recovery
	correctly
Message-ID: <20160106143409.GA14682@bfoster.bfoster>
References: <1452052834-20605-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452052834-20605-1-git-send-email-david@fromorbit.com>
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

On Wed, Jan 06, 2016 at 03:00:34PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we do dquot readahead in log recovery, we do not use a verifier
> as the underlying buffer may not have dquots in it. e.g. the
> allocation operation hasn't yet been replayed. Hence we do not want
> to fail recovery because we detect an operation to be replayed has
> not been run yet. This problem was addressed for inodes in commit
> d891400 ("xfs: inode buffers may not be valid during recovery
> readahead") but the problem was not recognised to exist for dquots
> and their buffers as the dquot readahead did not have a verifier.
> 
> The result of not using a verifier is that when the buffer is then
> next read to replay a dquot modification, the dquot buffer verifier
> will only be attached to the buffer if *readahead is not complete*.
> Hence we can read the buffer, replay the dquot changes and then add
> it to the delwri submission list without it having a verifier
> attached to it. This then generates warnings in xfs_buf_ioapply(),
> which catches and warns about this case.
> 
> Fix this and make it handle the same readahead verifier error cases
> as for inode buffers by adding a new readahead verifier that has a
> write operation as well as a read operation that marks the buffer as
> not done if any corruption is detected.  Also make sure we don't run
> readahead if the dquot buffer has been marked as cancelled by
> recovery.
> 
> This will result in readahead either succeeding and the buffer
> having a valid write verifier, or readahead failing and the buffer
> state requiring the subsequent read to resubmit the IO with the new
> verifier.  In either case, this will result in the buffer always
> ending up with a valid write verifier on it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c  | 32 ++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_quota_defs.h |  2 +-
>  fs/xfs/libxfs/xfs_shared.h     |  1 +
>  fs/xfs/xfs_log_recover.c       |  9 +++++++--
>  4 files changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 11cefb2..936952d 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
...
> @@ -264,6 +264,21 @@ xfs_dquot_buf_read_verify(
>  }
>  
>  /*
> + * readahead errors are silent and simply leave the buffer as !done so
> + * a real read will then be run with the xfs_dquot_buf_ops verifier.
> + */
> +static void
> +xfs_dquot_buf_readahead_verify(
> +	struct xfs_buf	*bp)
> +{
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +
> +	if (!xfs_dquot_buf_verify_crc(mp, bp) &&
> +	    !xfs_dquot_buf_verify(mp, bp, 0))
> +		bp->b_flags &= ~XBF_DONE;

Shouldn't this condition trigger if either the crc or buffer
verification fails (not if both fail)?

Also, xfs_buf_ioend() sets XBF_DONE when bp->b_error == 0 after the read
verifier is invoked. I don't see bp->b_error being set here, so it looks
like clearing this flag wouldn't have any effect.

Brian

> +}
> +
> +/*
>   * we don't calculate the CRC here as that is done when the dquot is flushed to
>   * the buffer after the update is done. This ensures that the dquot in the
>   * buffer always has an up-to-date CRC value.
> @@ -274,7 +289,7 @@ xfs_dquot_buf_write_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	if (!xfs_dquot_buf_verify(mp, bp)) {
> +	if (!xfs_dquot_buf_verify(mp, bp, XFS_QMOPT_DOWARN)) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  		xfs_verifier_error(bp);
>  		return;
> @@ -287,3 +302,8 @@ const struct xfs_buf_ops xfs_dquot_buf_ops = {
>  	.verify_write = xfs_dquot_buf_write_verify,
>  };
>  
> +const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
> +	.name = "xfs_dquot_ra",
> +	.verify_read = xfs_dquot_buf_readahead_verify,
> +	.verify_write = xfs_dquot_buf_write_verify,
> +};
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index 1b0a083..f51078f 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -153,7 +153,7 @@ typedef __uint16_t	xfs_qwarncnt_t;
>  #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
>  
>  extern int xfs_dqcheck(struct xfs_mount *mp, xfs_disk_dquot_t *ddq,
> -		       xfs_dqid_t id, uint type, uint flags, char *str);
> +		       xfs_dqid_t id, uint type, uint flags, const char *str);
>  extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
>  
>  #endif	/* __XFS_QUOTA_H__ */
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 5be5297..15c3ceb 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -49,6 +49,7 @@ extern const struct xfs_buf_ops xfs_inobt_buf_ops;
>  extern const struct xfs_buf_ops xfs_inode_buf_ops;
>  extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
>  extern const struct xfs_buf_ops xfs_dquot_buf_ops;
> +extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
>  extern const struct xfs_buf_ops xfs_sb_buf_ops;
>  extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
>  extern const struct xfs_buf_ops xfs_symlink_buf_ops;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 26e67b4..da37beb 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3521,6 +3521,7 @@ xlog_recover_dquot_ra_pass2(
>  	struct xfs_disk_dquot	*recddq;
>  	struct xfs_dq_logformat	*dq_f;
>  	uint			type;
> +	int			len;
>  
>  
>  	if (mp->m_qflags == 0)
> @@ -3541,8 +3542,12 @@ xlog_recover_dquot_ra_pass2(
>  	ASSERT(dq_f);
>  	ASSERT(dq_f->qlf_len == 1);
>  
> -	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno,
> -			  XFS_FSB_TO_BB(mp, dq_f->qlf_len), NULL);
> +	len = XFS_FSB_TO_BB(mp, dq_f->qlf_len);
> +	if (xlog_peek_buffer_cancelled(log, dq_f->qlf_blkno, len, 0))
> +		return;
> +
> +	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno, len,
> +			  &xfs_dquot_buf_ra_ops);
>  }
>  
>  STATIC void
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
