Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754630AbeEAOSf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 10:18:35 -0400
Date: Tue, 1 May 2018 10:18:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/5] xfs: implement online get/set fs label
Message-ID: <20180501141833.GG4525@bfoster.bfoster>
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
 <698bd41a-9281-83a2-ff51-64547025442a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698bd41a-9281-83a2-ff51-64547025442a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 30, 2018 at 10:46:37AM -0500, Eric Sandeen wrote:
> The GET ioctl is trivial, just return the current label.
> 
> The SET ioctl is more involved:
> It transactionally modifies the superblock to write a new filesystem
> label to the primary super.
> 
> It then also checkpoints the log to disk so that the change lands in
> block 0, invalidates any page cache that userspace might have previously
> read, and updates all secondary superblocks as userspace relable does.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> nb: the growfs trylock is just cargo-culting; growfs also trylocks.  *shrug*
> 
>  fs/xfs/xfs_ioctl.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 83 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 89fb1eb..12c6711 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -20,6 +20,7 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
> +#include "xfs_log.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> @@ -1811,6 +1812,84 @@ struct getfsmap_info {
>  	return error;
>  }
>  
> +static int
> +xfs_ioc_getlabel(
> +	struct xfs_mount	*mp,
> +	char			__user *label)
> +{
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +
> +	/* Paranoia */
> +	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
> +
> +	if (copy_to_user(label, sbp->sb_fname, sizeof(sbp->sb_fname)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int
> +xfs_ioc_setlabel(
> +	struct file		*filp,
> +	struct xfs_mount	*mp,
> +	char			__user *newlabel)
> +{
> +	struct address_space	*mapping;
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	char			label[FSLABEL_MAX];
> +	size_t			len;
> +	int			error;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (copy_from_user(label, newlabel, FSLABEL_MAX))
> +		return -EFAULT;
> +	/*
> +	 * The generic ioctl allows up to FSLABEL_MAX chars, but xfs is much
> +	 * smaller, at 12 bytes.
> +	 * NB: The on disk label doesn't need to be null terminated.
> +	 */
> +	len = strnlen(label, FSLABEL_MAX);
> +	if (len > sizeof(sbp->sb_fname)) {
> +		xfs_warn(mp, "label %s is too long, max %zu chars",
> +			label, sizeof(sbp->sb_fname));
> +		return -EINVAL;
> +	}
> +
> +	error = mnt_want_write_file(filp);
> +	if (error)
> +		return error;
> +
> +	spin_lock(&mp->m_sb_lock);
> +	memset(sbp->sb_fname, 0, sizeof(sbp->sb_fname));
> +	strncpy(sbp->sb_fname, label, sizeof(sbp->sb_fname));
> +	spin_unlock(&mp->m_sb_lock);
> +
> +	error = xfs_sync_sb(mp, true);
> +	if (error)
> +		goto out;

Is there a reason this all has to be synchronous in the first place, as
opposed to using xfs_log_sb() and committing a transaction for example?
Is it because we essentially don't have a way to recover if we crash
partway through? (Whatever the reason, a brief comment around why is
useful for future reference).

> +
> +	/* checkpoint the log to update primary super in fs itself */
> +	error = xfs_log_checkpoint(mp);
> +	if (error)
> +		goto out;
> +

xfs_sync_sb() with wait == true marks the transaction sync, which does
the log force part (but doesn't push the ail) based on the lsn of the
commit. Also note that you should be able to push the AIL based on the
lsn in the log item, which is set on AIL insertion, as opposed to doing
a full AIL push as well.

> +	/* invalidate any cached bdev page for userspace visibility */
> +	mapping = mp->m_ddev_targp->bt_bdev->bd_inode->i_mapping;
> +	error = invalidate_inode_pages2_range(mapping, 0, 0);
> +	if (error)
> +		goto out;

A more detailed comment on why this is necessary would be helpful. :)

> +
> +	/* update the backup superblocks like userspace does */
> +	if (mutex_trylock(&mp->m_growlock)) {
> +		error = xfs_update_secondary_supers(mp, mp->m_sb.sb_agcount, 0);
> +		mutex_unlock(&mp->m_growlock);
> +	}

It looks like growfs returns an error if the lock not available. Did you
intend to perform the primary update and then skip the secondary updates
if the lock is not acquired?

Perhaps we should just trylock earlier and hold the lock across the
entire operation..? It's not like grow or relabel are frequent
operations.

Brian

> +out:
> +	mnt_drop_write_file(filp);
> +	return error;
> +}
> +
>  /*
>   * Note: some of the ioctl's return positive numbers as a
>   * byte count indicating success, such as readlink_by_handle.
> @@ -1834,6 +1913,10 @@ struct getfsmap_info {
>  	switch (cmd) {
>  	case FITRIM:
>  		return xfs_ioc_trim(mp, arg);
> +	case FS_IOC_GET_FSLABEL:
> +		return xfs_ioc_getlabel(mp, arg);
> +	case FS_IOC_SET_FSLABEL:
> +		return xfs_ioc_setlabel(filp, mp, arg);
>  	case XFS_IOC_ALLOCSP:
>  	case XFS_IOC_FREESP:
>  	case XFS_IOC_RESVSP:
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
