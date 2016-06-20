Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A2E07CA4
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 09:32:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 249D5AC002
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 07:32:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id il3MhwIUXQuFL7Hm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2016 07:32:01 -0700 (PDT)
Date: Mon, 20 Jun 2016 10:31:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 011/119] xfs: refactor btree maxlevels computation
Message-ID: <20160620143158.GB2465@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612634260.12839.10495592169777117935.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612634260.12839.10495592169777117935.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:19:02PM -0700, Darrick J. Wong wrote:
> Create a common function to calculate the maximum height of a per-AG
> btree.  This will eventually be used by the rmapbt and refcountbt code
> to calculate appropriate maxlevels values for each.  This is important
> because the verifiers and the transaction block reservations depend on
> accurate estimates of many blocks are needed to satisfy a btree split.

			how many

> 
> We were mistakenly using the max bnobt height for all the btrees,
> which creates a dangerous situation since the larger records and keys
> in an rmapbt make it very possible that the rmapbt will be taller than
> the bnobt and so we can run out of transaction block reservation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c  |   15 ++-------------
>  fs/xfs/libxfs/xfs_btree.c  |   19 +++++++++++++++++++
>  fs/xfs/libxfs/xfs_btree.h  |    2 ++
>  fs/xfs/libxfs/xfs_ialloc.c |   19 +++++--------------
>  4 files changed, 28 insertions(+), 27 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 1c76a0e..c366889 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1839,19 +1839,8 @@ void
>  xfs_alloc_compute_maxlevels(
>  	xfs_mount_t	*mp)	/* file system mount structure */
>  {
> -	int		level;
> -	uint		maxblocks;
> -	uint		maxleafents;
> -	int		minleafrecs;
> -	int		minnoderecs;
> -
> -	maxleafents = (mp->m_sb.sb_agblocks + 1) / 2;
> -	minleafrecs = mp->m_alloc_mnr[0];
> -	minnoderecs = mp->m_alloc_mnr[1];
> -	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
> -	for (level = 1; maxblocks > 1; level++)
> -		maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
> -	mp->m_ag_maxlevels = level;
> +	mp->m_ag_maxlevels = xfs_btree_compute_maxlevels(mp, mp->m_alloc_mnr,
> +			(mp->m_sb.sb_agblocks + 1) / 2);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 5eb4e40..046fbcf 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4158,6 +4158,25 @@ xfs_btree_sblock_verify(
>  }
>  
>  /*
> + * Calculate the number of btree levels needed to store a given number of
> + * records in a short-format btree.
> + */
> +uint
> +xfs_btree_compute_maxlevels(
> +	struct xfs_mount	*mp,
> +	uint			*limits,
> +	unsigned long		len)
> +{
> +	uint			level;
> +	unsigned long		maxblocks;
> +
> +	maxblocks = (len + limits[0] - 1) / limits[0];
> +	for (level = 1; maxblocks > 1; level++)
> +		maxblocks = (maxblocks + limits[1] - 1) / limits[1];
> +	return level;
> +}
> +
> +/*
>   * Calculate the number of blocks needed to store a given number of records
>   * in a short-format (per-AG metadata) btree.
>   */
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index b330f19..b955e5d 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -477,5 +477,7 @@ bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
>  
>  xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
>  		unsigned long long len);
> +uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
> +		unsigned long len);
>  
>  #endif	/* __XFS_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 9d0003c..cda7269 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2394,20 +2394,11 @@ void
>  xfs_ialloc_compute_maxlevels(
>  	xfs_mount_t	*mp)		/* file system mount structure */
>  {
> -	int		level;
> -	uint		maxblocks;
> -	uint		maxleafents;
> -	int		minleafrecs;
> -	int		minnoderecs;
> -
> -	maxleafents = (1LL << XFS_INO_AGINO_BITS(mp)) >>
> -		XFS_INODES_PER_CHUNK_LOG;
> -	minleafrecs = mp->m_inobt_mnr[0];
> -	minnoderecs = mp->m_inobt_mnr[1];
> -	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
> -	for (level = 1; maxblocks > 1; level++)
> -		maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
> -	mp->m_in_maxlevels = level;
> +	uint		inodes;
> +
> +	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
> +	mp->m_in_maxlevels = xfs_btree_compute_maxlevels(mp, mp->m_inobt_mnr,
> +							 inodes);
>  }
>  
>  /*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
