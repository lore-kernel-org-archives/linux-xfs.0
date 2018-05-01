Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:62567 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750863AbeEAWLc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 18:11:32 -0400
Date: Wed, 2 May 2018 08:11:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: implement online get/set fs label
Message-ID: <20180501221113.GW23861@dastard>
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

Just to close the loop on what Eric and I just talked about on
IRC....

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

This is all good up to here. We want a synchronous transaction to
force the change to the log and *unpin the superblock buffer* at the
same time.

However, we want to also write the superblock buffer, and so we
really should have a function that does this directly: i.e.

	/* Force superblock label changes to disk */
	error = xfs_sync_sb_buf(mp);
	if (error)
		goto out;

which does:

xfs_sync_sb_buf()
{
	/* same transaction preamble and logging as xfs_sync_sb() */
	.....

	xfs_trans_bhold(tp, bp);
	xfs_trans_set_sync(tp);
	error = xfs_trans_commit(tp);
	if (error)
		goto out;

	/*
	 * write out the sb buffer to get the changes to disk
	 */
	error = xfs_bwrite(bp);
	xfs_buf_relse(bp);
	return error;
}


> +	/* checkpoint the log to update primary super in fs itself */
> +	error = xfs_log_checkpoint(mp);
> +	if (error)
> +		goto out;
> +
> +	/* invalidate any cached bdev page for userspace visibility */
> +	mapping = mp->m_ddev_targp->bt_bdev->bd_inode->i_mapping;
> +	error = invalidate_inode_pages2_range(mapping, 0, 0);
> +	if (error)
> +		goto out;

invalidate_bdev()? We don't use this block device
mapping, so just invalidating it completely is probably appropriate.
FWIW, ISTR that userspace points at a different address space
mapping and we can't invalidate that directly ourselves? Worth
checking...


> +	/* update the backup superblocks like userspace does */
> +	if (mutex_trylock(&mp->m_growlock)) {
> +		error = xfs_update_secondary_supers(mp, mp->m_sb.sb_agcount, 0);
> +		mutex_unlock(&mp->m_growlock);
> +	}

Why not just block here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
