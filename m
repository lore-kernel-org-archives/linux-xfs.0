Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EA3C3F2D7
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 22:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57AFA2072A
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 22:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgCCWjM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 17:39:12 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56665 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727274AbgCCWjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 17:39:11 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7174D7E9A95;
        Wed,  4 Mar 2020 09:39:09 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9GBw-0004VE-0G; Wed, 04 Mar 2020 09:39:08 +1100
Date:   Wed, 4 Mar 2020 09:39:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: scrub should mark dir corrupt if entry points
 to unallocated inode
Message-ID: <20200303223907.GX10776@dread.disaster.area>
References: <158294094367.1730101.10848559171120744339.stgit@magnolia>
 <158294096213.1730101.1870315264682758950.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158294096213.1730101.1870315264682758950.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=SvijAAeQkqlb6K_V0NwA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 05:49:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xchk_dir_check_ftype, we should mark the directory corrupt if we try
> to _iget a directory entry's inode pointer and the inode btree says the
> inode is not allocated.  This involves changing the IGET call to force
> the inobt lookup to return EINVAL if the inode isn't allocated; and
> rearranging the code so that we always perform the iget.

There's also a bug fix in this that isn't mentioned...

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/dir.c |   43 ++++++++++++++++++++++++++-----------------
>  1 file changed, 26 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 54afa75c95d1..a775fbf49a0d 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -39,9 +39,12 @@ struct xchk_dir_ctx {
>  	struct xfs_scrub	*sc;
>  };
>  
> -/* Check that an inode's mode matches a given DT_ type. */
> +/*
> + * Check that a directory entry's inode pointer directs us to an allocated
> + * inode and (if applicable) the inode mode matches the entry's DT_ type.
> + */
>  STATIC int
> -xchk_dir_check_ftype(
> +xchk_dir_check_iptr(
>  	struct xchk_dir_ctx	*sdc,
>  	xfs_fileoff_t		offset,
>  	xfs_ino_t		inum,
> @@ -52,13 +55,6 @@ xchk_dir_check_ftype(
>  	int			ino_dtype;
>  	int			error = 0;
>  
> -	if (!xfs_sb_version_hasftype(&mp->m_sb)) {
> -		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
> -			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
> -					offset);
> -		goto out;
> -	}
> -
>  	/*
>  	 * Grab the inode pointed to by the dirent.  We release the
>  	 * inode before we cancel the scrub transaction.  Since we're
> @@ -66,17 +62,30 @@ xchk_dir_check_ftype(
>  	 * eofblocks cleanup (which allocates what would be a nested
>  	 * transaction), we can't use DONTCACHE here because DONTCACHE
>  	 * inodes can trigger immediate inactive cleanup of the inode.
> +	 *
> +	 * We use UNTRUSTED here so that iget will return EINVAL if we have an
> +	 * inode pointer that points to an unallocated inode.

"We use UNTRUSTED here to force validation of the inode number
before we look it up. If it fails validation for any reason we will
get -EINVAL returned and that indicates a corrupt directory entry."

>  	 */
> -	error = xfs_iget(mp, sdc->sc->tp, inum, 0, 0, &ip);
> +	error = xfs_iget(mp, sdc->sc->tp, inum, XFS_IGET_UNTRUSTED, 0, &ip);
> +	if (error == -EINVAL) {
> +		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> +		return -EFSCORRUPTED;
> +	}
>  	if (!xchk_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
>  			&error))
>  		goto out;

Also:
	if (error == -EINVAL)
		error = -EFSCORRUPTED;


>  
> -	/* Convert mode to the DT_* values that dir_emit uses. */
> -	ino_dtype = xfs_dir3_get_dtype(mp,
> -			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
> -	if (ino_dtype != dtype)
> -		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> +	if (xfs_sb_version_hasftype(&mp->m_sb)) {
> +		/* Convert mode to the DT_* values that dir_emit uses. */
> +		ino_dtype = xfs_dir3_get_dtype(mp,
> +				xfs_mode_to_ftype(VFS_I(ip)->i_mode));
> +		if (ino_dtype != dtype)
> +			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> +	} else {
> +		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
> +			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
> +					offset);
> +	}

What is this fixing? xfs_dir3_get_dtype() always returned DT_UNKNOWN
for !hasftype filesystems, so I'm guessing this fixes validation
against dtype == DT_DIR for "." and ".." entries, but didn't we
already check this in xchk_dir_actor() before it calls this
function?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
