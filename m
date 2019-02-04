Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbfBDTZC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 14:25:02 -0500
Date: Mon, 4 Feb 2019 14:24:59 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/10] xfs: add xfs_verify_agino_or_null helper
Message-ID: <20190204192458.GC47560@bfoster>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930316106.31814.17027370821230009757.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154930316106.31814.17027370821230009757.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 09:59:21AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new helper to check that a per-AG inode pointer is either null or
> points somewhere valid within that AG.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_buf.c |    3 +--
>  fs/xfs/libxfs/xfs_types.c     |   13 +++++++++++++
>  fs/xfs/libxfs/xfs_types.h     |    2 ++
>  fs/xfs/scrub/agheader.c       |    8 +++-----
>  4 files changed, 19 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 8fa1050c1ae2..77e412a4b6ea 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -99,8 +99,7 @@ xfs_inode_buf_verify(
>  		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
>  		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
>  			xfs_dinode_good_version(mp, dip->di_version) &&
> -			(unlinked_ino == NULLAGINO ||
> -			 xfs_verify_agino(mp, agno, unlinked_ino));
> +			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
>  		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
>  						XFS_ERRTAG_ITOBP_INOTOBP))) {
>  			if (readahead) {
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index 0e35b4bdfef7..5b37c99b2811 100644
> --- a/fs/xfs/libxfs/xfs_types.c
> +++ b/fs/xfs/libxfs/xfs_types.c
> @@ -115,6 +115,19 @@ xfs_verify_agino(
>  	return agino >= first && agino <= last;
>  }
>  
> +/*
> + * Verify that an AG inode number pointer neither points outside the AG
> + * nor points at static metadata, or is NULLAGINO.
> + */
> +bool
> +xfs_verify_agino_or_null(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_agino_t		agino)
> +{
> +	return agino == NULLAGINO || xfs_verify_agino(mp, agno, agino);
> +}
> +
>  /*
>   * Verify that an FS inode number pointer neither points outside the
>   * filesystem nor points at static AG metadata.
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 704b4f308780..c5a25403b4db 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -183,6 +183,8 @@ void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		xfs_agino_t *first, xfs_agino_t *last);
>  bool xfs_verify_agino(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		xfs_agino_t agino);
> +bool xfs_verify_agino_or_null(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		xfs_agino_t agino);
>  bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
>  bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
>  bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 90955ab1e895..9d4e8293d37e 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -864,19 +864,17 @@ xchk_agi(
>  
>  	/* Check inode pointers */
>  	agino = be32_to_cpu(agi->agi_newino);
> -	if (agino != NULLAGINO && !xfs_verify_agino(mp, agno, agino))
> +	if (!xfs_verify_agino_or_null(mp, agno, agino))
>  		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
>  
>  	agino = be32_to_cpu(agi->agi_dirino);
> -	if (agino != NULLAGINO && !xfs_verify_agino(mp, agno, agino))
> +	if (!xfs_verify_agino_or_null(mp, agno, agino))
>  		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
>  
>  	/* Check unlinked inode buckets */
>  	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
>  		agino = be32_to_cpu(agi->agi_unlinked[i]);
> -		if (agino == NULLAGINO)
> -			continue;
> -		if (!xfs_verify_agino(mp, agno, agino))
> +		if (!xfs_verify_agino_or_null(mp, agno, agino))
>  			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
>  	}
>  
> 
