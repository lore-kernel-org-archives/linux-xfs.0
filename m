Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754680AbdJIOY2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 10:24:28 -0400
Date: Mon, 9 Oct 2017 10:24:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Fix bool initialization/comparison
Message-ID: <20171009142426.GA18663@bfoster.bfoster>
References: <1507383097081-778026979-0-diffsplit-thomas@m3y3r.de>
 <1507383097088-1367347759-14-diffsplit-thomas@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507383097088-1367347759-14-diffsplit-thomas@m3y3r.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Meyer <thomas@m3y3r.de>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Oct 07, 2017 at 04:02:21PM +0200, Thomas Meyer wrote:
> Bool initializations should use true and false. Bool tests don't need
> comparisons.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff -u -p a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1490,14 +1490,14 @@ xfs_bmap_isaeof(
>  	int			is_empty;
>  	int			error;
>  
> -	bma->aeof = 0;
> +	bma->aeof = false;
>  	error = xfs_bmap_last_extent(NULL, bma->ip, whichfork, &rec,
>  				     &is_empty);
>  	if (error)
>  		return error;
>  
>  	if (is_empty) {
> -		bma->aeof = 1;
> +		bma->aeof = true;
>  		return 0;
>  	}
>  
> diff -u -p a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1962,7 +1962,7 @@ xfs_difree_inobt(
>  	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
>  	    rec.ir_free == XFS_INOBT_ALL_FREE &&
>  	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
> -		xic->deleted = 1;
> +		xic->deleted = true;
>  		xic->first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
>  		xic->alloc = xfs_inobt_irec_to_allocmask(&rec);
>  
> @@ -1989,7 +1989,7 @@ xfs_difree_inobt(
>  
>  		xfs_difree_inode_chunk(mp, agno, &rec, dfops);
>  	} else {
> -		xic->deleted = 0;
> +		xic->deleted = false;
>  
>  		error = xfs_inobt_update(cur, &rec);
>  		if (error) {
> diff -u -p a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -761,7 +761,7 @@ xfs_file_fallocate(
>  	enum xfs_prealloc_flags	flags = 0;
>  	uint			iolock = XFS_IOLOCK_EXCL;
>  	loff_t			new_size = 0;
> -	bool			do_file_insert = 0;
> +	bool			do_file_insert = false;
>  
>  	if (!S_ISREG(inode->i_mode))
>  		return -EINVAL;
> @@ -822,7 +822,7 @@ xfs_file_fallocate(
>  			error = -EINVAL;
>  			goto out_unlock;
>  		}
> -		do_file_insert = 1;
> +		do_file_insert = true;
>  	} else {
>  		flags |= XFS_PREALLOC_SET;
>  
> diff -u -p a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2515,7 +2515,7 @@ next_lv:
>  				if (lv)
>  					vecp = lv->lv_iovecp;
>  			}
> -			if (record_cnt == 0 && ordered == false) {
> +			if (record_cnt == 0 && !ordered) {
>  				if (!lv)
>  					return 0;
>  				break;
> diff -u -p a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -704,7 +704,7 @@ xfs_mountfs(
>  	xfs_set_maxicount(mp);
>  
>  	/* enable fail_at_unmount as default */
> -	mp->m_fail_unmount = 1;
> +	mp->m_fail_unmount = true;
>  
>  	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype, NULL, mp->m_fsname);
>  	if (error)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
