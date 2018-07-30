Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58156 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbeGaBDu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 21:03:50 -0400
Subject: Re: [PATCH 3/3] xfs: verify icount in superblock write
References: <153292860880.19274.14533449137039985963.stgit@magnolia>
 <153292862751.19274.16285578072920087708.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <091b2c87-d6d1-e8c5-7ee7-175095252fe8@sandeen.net>
Date: Mon, 30 Jul 2018 18:26:29 -0500
MIME-Version: 1.0
In-Reply-To: <153292862751.19274.16285578072920087708.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Bill O'Donnell <billodo@redhat.com>

On 7/30/18 12:30 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a helper predicate to check the inode count for sanity, then use it
> in the superblock write verifier to inspect sb_icount.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c    |    1 +
>  fs/xfs/libxfs/xfs_types.c |   34 ++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_types.h |    1 +
>  3 files changed, 36 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 64bc471d57e6..e5972121e82d 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -160,6 +160,7 @@ xfs_validate_sb_write(
>  	 * cases.
>  	 */
>  	if (sbp->sb_fdblocks > sbp->sb_dblocks ||
> +	    !xfs_verify_icount(mp, sbp->sb_icount) ||
>  	    sbp->sb_ifree > sbp->sb_icount) {
>  		xfs_warn(mp, "SB summary counter sanity check failed");
>  		return -EFSCORRUPTED;
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index 2e2a243cef2e..57f4fd028898 100644
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
> +		nr_inos += last - first + 1;
> +	}
> +	*max = nr_inos;

I still think this is more work than we need to do for a verifier,
TBH.

In practice how far off is this from do_div(dblocks, inodes_per_block) ?

Oh well.   I guess computationally it's pretty cheap...

> +}
> +
> +/* Sanity-checking of inode counts. */
> +bool
> +xfs_verify_icount(
> +	struct xfs_mount	*mp,
> +	unsigned long long	icount)
> +{
> +	unsigned long long	min, max;
> +
> +	xfs_icount_range(mp, &min, &max);
> +	return icount >= min && icount < max;

Since you've calculated it down to the very last inode, why is
"= max" out of range?

> +}
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 4055d62f690c..b9e6c89284c3 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -165,5 +165,6 @@ bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
>  bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
>  bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
>  bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
> +bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
>  
>  #endif	/* __XFS_TYPES_H__ */

