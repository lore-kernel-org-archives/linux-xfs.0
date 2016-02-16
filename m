Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E84D7CA3
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 13:20:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D94D0AC009
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 11:20:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VOMdbMZmNiEidDrW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2016 11:20:38 -0800 (PST)
Date: Tue, 16 Feb 2016 14:20:36 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 10/14] xfs: handle dquot buffer readahead in log recovery
	correctly
Message-ID: <20160216192036.GG39655@bfoster.bfoster>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
	<1455517105-20033-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455517105-20033-11-git-send-email-david@fromorbit.com>
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

On Mon, Feb 15, 2016 at 05:18:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Source kernel commit 7d6a13f023567d573ac362502bb702eda716e654
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
> Note: we also need to fix the inode buffer readahead error handling
> to mark the buffer with EIO. Brian noticed the code I copied from
> there wrong during review, so fix it at the same time. Add comments
> linking the two functions that handle readahead verifier errors
> together so we don't forget this behavioural link in future.
> 
> cc: <stable@vger.kernel.org> # 3.12 - current
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  libxfs/xfs_dquot_buf.c  | 36 ++++++++++++++++++++++++++++++------
>  libxfs/xfs_inode_buf.c  |  2 ++
>  libxfs/xfs_quota_defs.h |  2 +-
>  libxfs/xfs_shared.h     |  1 +
>  4 files changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
> index fd4aa4b..025d49b 100644
> --- a/libxfs/xfs_dquot_buf.c
> +++ b/libxfs/xfs_dquot_buf.c
...
> @@ -282,13 +301,18 @@ xfs_dquot_buf_write_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	if (!xfs_dquot_buf_verify(mp, bp)) {
> +	if (!xfs_dquot_buf_verify(mp, bp, XFS_QMOPT_DOWARN)) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  		xfs_verifier_error(bp);
>  		return;
>  	}
>  }
>  
> +const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
> +	.name = "xfs_dquot_ra",
> +	.verify_read = xfs_dquot_buf_readahead_verify,
> +	.verify_write = xfs_dquot_buf_write_verify,
> +};
>  const struct xfs_buf_ops xfs_dquot_buf_ops = {
>  	.name = "xfs_dquot",
>  	.verify_read = xfs_dquot_buf_read_verify,

Nit: the readahead ops structure comes after the buf_ops structure in
the kernel code.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
> index 546af74..89c05ad 100644
> --- a/libxfs/xfs_inode_buf.c
> +++ b/libxfs/xfs_inode_buf.c
> @@ -77,6 +77,8 @@ xfs_dinode_good_version(
>   * recovery and we don't get unnecssary panics on debug kernels. We use EIO here
>   * because all we want to do is say readahead failed; there is no-one to report
>   * the error to, so this will distinguish it from a non-ra verifier failure.
> + * Changes to this readahead error behavour also need to be reflected in
> + * xfs_dquot_buf_readahead_verify().
>   */
>  static void
>  xfs_inode_buf_verify(
> diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
> index 1b0a083..f51078f 100644
> --- a/libxfs/xfs_quota_defs.h
> +++ b/libxfs/xfs_quota_defs.h
> @@ -153,7 +153,7 @@ typedef __uint16_t	xfs_qwarncnt_t;
>  #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
>  
>  extern int xfs_dqcheck(struct xfs_mount *mp, xfs_disk_dquot_t *ddq,
> -		       xfs_dqid_t id, uint type, uint flags, char *str);
> +		       xfs_dqid_t id, uint type, uint flags, const char *str);
>  extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
>  
>  #endif	/* __XFS_QUOTA_H__ */
> diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
> index 5be5297..15c3ceb 100644
> --- a/libxfs/xfs_shared.h
> +++ b/libxfs/xfs_shared.h
> @@ -49,6 +49,7 @@ extern const struct xfs_buf_ops xfs_inobt_buf_ops;
>  extern const struct xfs_buf_ops xfs_inode_buf_ops;
>  extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
>  extern const struct xfs_buf_ops xfs_dquot_buf_ops;
> +extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
>  extern const struct xfs_buf_ops xfs_sb_buf_ops;
>  extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
>  extern const struct xfs_buf_ops xfs_symlink_buf_ops;
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
