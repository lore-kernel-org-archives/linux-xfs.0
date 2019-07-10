Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49536 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfGJGKL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 02:10:11 -0400
Date: Tue, 9 Jul 2019 23:09:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mkfs: don't use xfs_verify_fsbno() before m_sb is fully
 set up
Message-ID: <20190710060952.GU1404256@magnolia>
References: <d04c688e-4d67-83f4-8401-d064d13bdc33@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d04c688e-4d67-83f4-8401-d064d13bdc33@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

On Tue, Jul 09, 2019 at 03:09:00PM -0500, Eric Sandeen wrote:
> Commit 8da5298 mkfs: validate start and end of aligned logs stopped
> open-coding log end block checks, and used xfs_verify_fsbno() instead.
> It also used xfs_verify_fsbno() to validate the log start.  This
> seemed to make sense, but then xfs/306 started failing on 4k sector
> filesystems, which leads to a log striep unite being set on a single
> AG filesystem.
> 
> As it turns out, if xfs_verify_fsbno() is testing a block in the
> last AG, it needs to have mp->m_sb.sb_dblocks set, which isn't done
> until later.  With sb_dblocks unset we can't know how many blocks
> are in the last AG, and hence can't validate it.
> 
> To fix all this, go back to open-coding the checks; note that this
> /does/ rely on m_sb.sb_agblklog being set, but that /is/ already
> done in the early call to start_superblock_setup().
> 
> Fixes: 8da5298 ("mkfs: validate start and end of aligned logs")
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Sorry for missing this one in regression testing :/

Sorry for totally not noticing that we're validating using an incomplete
xfs_mount... <grumble>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 468b8fde..4e576a5c 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3040,7 +3040,7 @@ align_internal_log(
>  		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
>  
>  	/* If our log start overlaps the next AG's metadata, fail. */
> -	if (!xfs_verify_fsbno(mp, cfg->logstart)) {
> +	if (XFS_FSB_TO_AGBNO(mp, cfg->logstart) <= XFS_AGFL_BLOCK(mp)) {
>  			fprintf(stderr,
>  _("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
>    "within an allocation group.\n"),
> @@ -3051,10 +3051,9 @@ _("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
>  	/* round up/down the log size now */
>  	align_log_size(cfg, sunit);
>  
> -	/* check the aligned log still fits in an AG. */
> +	/* check the aligned log still starts and ends in the same AG. */
>  	logend = cfg->logstart + cfg->logblocks - 1;
> -	if (XFS_FSB_TO_AGNO(mp, cfg->logstart) != XFS_FSB_TO_AGNO(mp, logend) ||
> -	    !xfs_verify_fsbno(mp, logend)) {
> +	if (XFS_FSB_TO_AGNO(mp, cfg->logstart) != XFS_FSB_TO_AGNO(mp, logend)) {
>  		fprintf(stderr,
>  _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
>    "Must fit within an allocation group.\n"),
> 
