Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932231AbdJZNQu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 09:16:50 -0400
Date: Thu, 26 Oct 2017 09:16:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: validate sb_logsunit is a multiple of the fs
 blocksize
Message-ID: <20171026131648.GC3450@bfoster.bfoster>
References: <150899696463.18095.9642473908739425678.stgit@magnolia>
 <150899697674.18095.8949507524525909891.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150899697674.18095.8949507524525909891.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2017 at 10:49:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure the log stripe unit is sane before proceeding with mounting.
> AFAICT this means that logsunit has to be 0, 1, or a multiple of the fs
> block size.  Found this by setting the LSB of logsunit in xfs/350 and
> watching the system crash as soon as we try to write to the log.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index dc95a49..4edb36f 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -608,6 +608,7 @@ xfs_log_mount(
>  	xfs_daddr_t	blk_offset,
>  	int		num_bblks)
>  {
> +	bool		fatal = xfs_sb_version_hascrc(&mp->m_sb);
>  	int		error = 0;
>  	int		min_logfsbs;
>  
> @@ -659,9 +660,20 @@ xfs_log_mount(
>  			 XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks),
>  			 XFS_MAX_LOG_BYTES);
>  		error = -EINVAL;
> +	} else if (mp->m_sb.sb_logsunit > 1 &&
> +		   mp->m_sb.sb_logsunit % mp->m_sb.sb_blocksize) {
> +		xfs_warn(mp,
> +		"log stripe unit %u bytes must be a multiple of block size",
> +			 mp->m_sb.sb_logsunit);
> +		error = -EINVAL;
> +		fatal = true;
>  	}
>  	if (error) {
> -		if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		/*
> +		 * Log check errors are always fatal on v5; or whenever bad
> +		 * metadata leads to a crash.
> +		 */
> +		if (fatal) {
>  			xfs_crit(mp, "AAIEEE! Log failed size checks. Abort!");
>  			ASSERT(0);
>  			goto out_free_log;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
