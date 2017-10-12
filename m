Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33280 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752767AbdJLUXG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 16:23:06 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9CKN5Ou005769
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 20:23:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9CKN4aY011490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 20:23:05 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9CKN4jl022353
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 20:23:04 GMT
Date: Thu, 12 Oct 2017 13:23:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/30] xfs: create inode pointer verifiers
Message-ID: <20171012202303.GJ7122@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777247562.1724.7094279740133124537.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777247562.1724.7094279740133124537.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:41:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create some helper functions to check that inode pointers point to
> somewhere within the filesystem and not at the static AG metadata.
> Move xfs_internal_inum and create a directory inode check function.
> We will use these functions in scrub and elsewhere.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dir2.c   |   19 ++--------
>  fs/xfs/libxfs/xfs_ialloc.c |   81 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h |    7 ++++
>  fs/xfs/xfs_itable.c        |   10 -----
>  fs/xfs/xfs_itable.h        |    2 -
>  5 files changed, 91 insertions(+), 28 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index ccf9783..ee4d2a3 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -30,6 +30,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
> +#include "xfs_ialloc.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  
> @@ -202,22 +203,8 @@ xfs_dir_ino_validate(
>  	xfs_mount_t	*mp,
>  	xfs_ino_t	ino)
>  {
> -	xfs_agblock_t	agblkno;
> -	xfs_agino_t	agino;
> -	xfs_agnumber_t	agno;
> -	int		ino_ok;
> -	int		ioff;
> -
> -	agno = XFS_INO_TO_AGNO(mp, ino);
> -	agblkno = XFS_INO_TO_AGBNO(mp, ino);
> -	ioff = XFS_INO_TO_OFFSET(mp, ino);
> -	agino = XFS_OFFBNO_TO_AGINO(mp, agblkno, ioff);
> -	ino_ok =
> -		agno < mp->m_sb.sb_agcount &&
> -		agblkno < mp->m_sb.sb_agblocks &&
> -		agblkno != 0 &&
> -		ioff < (1 << mp->m_sb.sb_inopblog) &&
> -		XFS_AGINO_TO_INO(mp, agno, agino) == ino;
> +	bool		ino_ok = xfs_verify_dir_ino_ptr(mp, ino);
> +
>  	if (unlikely(XFS_TEST_ERROR(!ino_ok, mp, XFS_ERRTAG_DIR_INO_VALIDATE))) {
>  		xfs_warn(mp, "Invalid inode number 0x%Lx",
>  				(unsigned long long) ino);
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 988bb3f..da3652b 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2664,3 +2664,84 @@ xfs_ialloc_pagi_init(
>  		xfs_trans_brelse(tp, bp);
>  	return 0;
>  }
> +
> +/* Calculate the first and last possible inode number in an AG. */
> +void
> +xfs_ialloc_aginode_range(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_agino_t		*first,
> +	xfs_agino_t		*last)
> +{
> +	xfs_agblock_t		eoag;
> +
> +	eoag = xfs_ag_block_count(mp, agno);
> +	*first = round_up(XFS_OFFBNO_TO_AGINO(mp, XFS_AGFL_BLOCK(mp) + 1, 0),
> +			XFS_INODES_PER_CHUNK);
> +	*last = round_down(XFS_OFFBNO_TO_AGINO(mp, eoag, 0),
> +			XFS_INODES_PER_CHUNK) - 1;

This is incorrect; we allocate inode chunks aligned to
xfs_ialloc_cluster_alignment blocks, which doesn't necessarily result in
ir_startino being aligned to XFS_INODES_PER_CHUNK.

I think the correct code is this:

	/* Calculate the first inode. */
	bno = round_up(XFS_AGFL_BLOCK(mp) + 1,
			xfs_ialloc_cluster_alignment(mp));
	*first = XFS_OFFBNO_TO_AGINO(mp, bno, 0);

	/* Calculate the last inode. */
	bno = round_down(eoag, xfs_ialloc_cluster_alignment(mp));
	*last = XFS_OFFBNO_TO_AGINO(mp, bno, 0) - 1;

...which unfortunately I didn't realize until trying to play with
nondefault geometry options (1k blocks, no sparse inodes).

--D

> +}
> +
> +/*
> + * Verify that an AG inode number pointer neither points outside the AG
> + * nor points at static metadata.
> + */
> +bool
> +xfs_verify_agino_ptr(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_agino_t		agino)
> +{
> +	xfs_agino_t		first;
> +	xfs_agino_t		last;
> +	int			ioff;
> +
> +	ioff = XFS_AGINO_TO_OFFSET(mp, agino);
> +	xfs_ialloc_aginode_range(mp, agno, &first, &last);
> +	return agino >= first && agino <= last &&
> +	       ioff < (1 << mp->m_sb.sb_inopblog);
> +}
> +
> +/*
> + * Verify that an FS inode number pointer neither points outside the
> + * filesystem nor points at static AG metadata.
> + */
> +bool
> +xfs_verify_ino_ptr(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino)
> +{
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ino);
> +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
> +
> +	if (agno >= mp->m_sb.sb_agcount)
> +		return false;
> +	if (XFS_AGINO_TO_INO(mp, agno, agino) != ino)
> +		return false;
> +	return xfs_verify_agino_ptr(mp, agno, agino);
> +}
> +
> +/* Is this an internal inode number? */
> +bool
> +xfs_internal_inum(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino)
> +{
> +	return ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
> +		(xfs_sb_version_hasquota(&mp->m_sb) &&
> +		 xfs_is_quota_inode(&mp->m_sb, ino));
> +}
> +
> +/*
> + * Verify that a directory entry's inode number doesn't point at an internal
> + * inode, empty space, or static AG metadata.
> + */
> +bool
> +xfs_verify_dir_ino_ptr(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino)
> +{
> +	if (xfs_internal_inum(mp, ino))
> +		return false;
> +	return xfs_verify_ino_ptr(mp, ino);
> +}
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index b32cfb5..904d69a 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -173,5 +173,12 @@ void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
>  		struct xfs_inobt_rec_incore *irec);
>  
>  int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
> +void xfs_ialloc_aginode_range(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		xfs_agino_t *first, xfs_agino_t *last);
> +bool xfs_verify_agino_ptr(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		xfs_agino_t agino);
> +bool xfs_verify_ino_ptr(struct xfs_mount *mp, xfs_ino_t ino);
> +bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
> +bool xfs_verify_dir_ino_ptr(struct xfs_mount *mp, xfs_ino_t ino);
>  
>  #endif	/* __XFS_IALLOC_H__ */
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index c393a2f..0172d0b 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -31,16 +31,6 @@
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  
> -int
> -xfs_internal_inum(
> -	xfs_mount_t	*mp,
> -	xfs_ino_t	ino)
> -{
> -	return (ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
> -		(xfs_sb_version_hasquota(&mp->m_sb) &&
> -		 xfs_is_quota_inode(&mp->m_sb, ino)));
> -}
> -
>  /*
>   * Return stat information for one inode.
>   * Return 0 if ok, else errno.
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 17e86e0..6ea8b39 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -96,6 +96,4 @@ xfs_inumbers(
>  	void			__user *buffer, /* buffer with inode info */
>  	inumbers_fmt_pf		formatter);
>  
> -int xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
> -
>  #endif	/* __XFS_ITABLE_H__ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
