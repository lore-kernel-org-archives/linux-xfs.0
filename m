Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750981AbeDRSek (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Apr 2018 14:34:40 -0400
Date: Wed, 18 Apr 2018 14:34:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/11] xfs: avoid ilock games in the quota scrubber
Message-ID: <20180418183438.GD22375@bfoster.bfoster>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401920787.11465.7233707816010481650.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152401920787.11465.7233707816010481650.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 17, 2018 at 07:40:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we have a new QMOPT_QUOTIP_LOCKED flag, use it to dqget in the
> quota scrubber so that we can ilock the quota ip at the start of scrub
> and keep it locked all the way to the end.  This enables us to remove
> quite a bit of locking-related games and manage the quota ip the same
> way we treat other inodes being scrubbed.  Allocate a transaction so
> that we can evade deadlock issues in bmbt lookups.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/quota.c |   46 ++++++++++++++++++----------------------------
>  fs/xfs/scrub/scrub.c |    4 ++++
>  fs/xfs/scrub/scrub.h |    1 +
>  3 files changed, 23 insertions(+), 28 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 363e318..1068a91 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -66,12 +66,24 @@ xfs_scrub_setup_quota(
>  	struct xfs_inode		*ip)
>  {
>  	uint				dqtype;
> +	int				error;
> +
> +	if (!XFS_IS_QUOTA_RUNNING(sc->mp) || !XFS_IS_QUOTA_ON(sc->mp))
> +		return -ENOENT;
>  
>  	dqtype = xfs_scrub_quota_to_dqtype(sc);
>  	if (dqtype == 0)
>  		return -EINVAL;
> +	sc->has_quotaofflock = true;
> +	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
>  	if (!xfs_this_quota_on(sc->mp, dqtype))
>  		return -ENOENT;
> +	error = xfs_scrub_setup_fs(sc, ip);

Looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Not really related, but FYI the ip parameter to xfs_scrub_setup_fs()
appears to be unused.

Brian

> +	if (error)
> +		return error;
> +	sc->ip = xfs_quota_inode(sc->mp, dqtype);
> +	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
> +	sc->ilock_flags = XFS_ILOCK_EXCL;
>  	return 0;
>  }
>  
> @@ -203,7 +215,6 @@ xfs_scrub_quota(
>  	struct xfs_bmbt_irec		irec = { 0 };
>  	struct xfs_scrub_quota_info	sqi;
>  	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_inode		*ip;
>  	struct xfs_quotainfo		*qi = mp->m_quotainfo;
>  	xfs_fileoff_t			max_dqid_off;
>  	xfs_fileoff_t			off = 0;
> @@ -211,25 +222,12 @@ xfs_scrub_quota(
>  	int				nimaps;
>  	int				error = 0;
>  
> -	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> -		return -ENOENT;
> -
> -	mutex_lock(&qi->qi_quotaofflock);
>  	dqtype = xfs_scrub_quota_to_dqtype(sc);
> -	if (!xfs_this_quota_on(sc->mp, dqtype)) {
> -		error = -ENOENT;
> -		goto out_unlock_quota;
> -	}
> -
> -	/* Attach to the quota inode and set sc->ip so that reporting works. */
> -	ip = xfs_quota_inode(sc->mp, dqtype);
> -	sc->ip = ip;
>  
>  	/* Look for problem extents. */
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
> +	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
>  		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
> -		goto out_unlock_inode;
> +		goto out;
>  	}
>  	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
>  	while (1) {
> @@ -238,11 +236,11 @@ xfs_scrub_quota(
>  
>  		off = irec.br_startoff + irec.br_blockcount;
>  		nimaps = 1;
> -		error = xfs_bmapi_read(ip, off, -1, &irec, &nimaps,
> +		error = xfs_bmapi_read(sc->ip, off, -1, &irec, &nimaps,
>  				XFS_BMAPI_ENTIRE);
>  		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, off,
>  				&error))
> -			goto out_unlock_inode;
> +			goto out;
>  		if (!nimaps)
>  			break;
>  		if (irec.br_startblock == HOLESTARTBLOCK)
> @@ -268,26 +266,18 @@ xfs_scrub_quota(
>  		    irec.br_startoff + irec.br_blockcount > max_dqid_off + 1)
>  			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
>  	}
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		goto out;
>  
>  	/* Check all the quota items. */
>  	sqi.sc = sc;
>  	sqi.last_id = 0;
> -	error = xfs_dquot_iterate(mp, dqtype, 0, xfs_scrub_quota_item, &sqi);
> +	error = xfs_dquot_iterate(mp, dqtype, XFS_QMOPT_QUOTIP_LOCKED,
> +			xfs_scrub_quota_item, &sqi);
>  	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK,
>  			sqi.last_id * qi->qi_dqperchunk, &error))
>  		goto out;
>  
>  out:
> -	/* We set sc->ip earlier, so make sure we clear it now. */
> -	sc->ip = NULL;
> -out_unlock_quota:
> -	mutex_unlock(&qi->qi_quotaofflock);
>  	return error;
> -
> -out_unlock_inode:
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	goto out;
>  }
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index cb1e727..c43ee9e 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -42,6 +42,8 @@
>  #include "xfs_refcount_btree.h"
>  #include "xfs_rmap.h"
>  #include "xfs_rmap_btree.h"
> +#include "xfs_quota.h"
> +#include "xfs_qm.h"
>  #include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
> @@ -166,6 +168,8 @@ xfs_scrub_teardown(
>  			iput(VFS_I(sc->ip));
>  		sc->ip = NULL;
>  	}
> +	if (sc->has_quotaofflock)
> +		mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
>  	if (sc->buf) {
>  		kmem_free(sc->buf);
>  		sc->buf = NULL;
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index 0d92af8..5d79731 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -73,6 +73,7 @@ struct xfs_scrub_context {
>  	void				*buf;
>  	uint				ilock_flags;
>  	bool				try_harder;
> +	bool				has_quotaofflock;
>  
>  	/* State tracking for single-AG operations. */
>  	struct xfs_scrub_ag		sa;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
