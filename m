Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728207AbeGZTGP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jul 2018 15:06:15 -0400
Date: Thu, 26 Jul 2018 12:48:21 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 2/2] xfs: verify icount in superblock write
Message-ID: <20180726174820.GA20780@redhat.com>
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
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 26, 2018 at 10:35:25AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a helper predicate to check the inode count for sanity, then use it
> in the superblock write verifier to inspect sb_icount.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks good.
Thanks.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
