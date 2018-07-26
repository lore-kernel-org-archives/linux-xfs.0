Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56137 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731405AbeG0Ajc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jul 2018 20:39:32 -0400
Date: Fri, 27 Jul 2018 09:20:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: verify icount in superblock write
Message-ID: <20180726232028.GC2234@dastard>
References: <153262651940.8934.17525988748289196893.stgit@magnolia>
 <153262652554.8934.816888163232208002.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153262652554.8934.816888163232208002.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, billodo@redhat.com

On Thu, Jul 26, 2018 at 10:35:25AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a helper predicate to check the inode count for sanity, then use it
> in the superblock write verifier to inspect sb_icount.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c    |    1 +
>  fs/xfs/libxfs/xfs_types.c |   34 ++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_types.h |    1 +
>  3 files changed, 36 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index b2c683588519..1659016875f9 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -714,6 +714,7 @@ xfs_sb_write_verify(
>  	 * cases.
>  	 */
>  	if (sb.sb_fdblocks > sb.sb_dblocks ||
> +	    !xfs_verify_icount(mp, sb.sb_icount) ||
>  	    sb.sb_ifree > sb.sb_icount) {
>  		xfs_notice(mp, "SB summary counter sanity check failed");
>  		error = -EFSCORRUPTED;
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index 2e2a243cef2e..2e9c0c25ccb6 100644
> --- a/fs/xfs/libxfs/xfs_types.c
> +++ b/fs/xfs/libxfs/xfs_types.c
> @@ -171,3 +171,37 @@ xfs_verify_rtbno(
>  {
>  	return rtbno < mp->m_sb.sb_rblocks;
>  }
> +
> +/* Calculate the range of valid icount values. */
> +static void
> +xfs_icount_range(
> +	struct xfs_mount	*mp,
> +	unsigned long long	*min,
> +	unsigned long long	*max)
> +{
> +	unsigned long long	nr_inos = 0;
> +	xfs_agnumber_t		agno;
> +
> +	/* root, rtbitmap, rtsum all live in the first chunk */
> +	*min = XFS_INODES_PER_CHUNK;
> +
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		xfs_agino_t	first, last;
> +
> +		xfs_agino_range(mp, agno, &first, &last);
> +		nr_inos += first - last + 1;
> +	}
> +	*max = nr_inos;
> +}

And the effect of the inode32 mount option on the valid icount range?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
