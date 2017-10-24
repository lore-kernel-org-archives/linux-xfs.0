Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932273AbdJXMyO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Oct 2017 08:54:14 -0400
Date: Tue, 24 Oct 2017 08:54:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: validate sb_logsunit is a multiple of the fs
 blocksize
Message-ID: <20171024125412.GC56184@bfoster.bfoster>
References: <20171024002844.GM5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171024002844.GM5483@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 23, 2017 at 05:28:44PM -0700, Darrick J. Wong wrote:
> Make sure the log stripe unit is sane before proceeding with mounting.
> AFAICT this means that logsunit has to be 0, 1, or a multiple of the fs
> block size.  Found this by setting the LSB of logsunit in xfs/350 and
> watching the system crash as soon as we try to write to the log.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index d729e00..da4dcab 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -659,6 +659,12 @@ xfs_log_mount(
>  			 XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks),
>  			 XFS_MAX_LOG_BYTES);
>  		error = -EINVAL;
> +	} else if (mp->m_sb.sb_logsunit > 1 &&
> +		   mp->m_sb.sb_logsunit % mp->m_sb.sb_blocksize) {
> +		xfs_warn(mp,
> +		"log stripe unit %u bytes must be a multiple of block size",
> +			 mp->m_sb.sb_logsunit);
> +		error = -EINVAL;

Looks fine, but I notice that the error handling just below only fails
the mount on v5 filesystems. Otherwise we warn and carry on. I'm not
sure why that is.. but is this a crash vector on v4 filesystems as well?

Brian

>  	}
>  	if (error) {
>  		if (xfs_sb_version_hascrc(&mp->m_sb)) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
