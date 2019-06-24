Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfFXR4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 13:56:18 -0400
Date: Mon, 24 Jun 2019 10:55:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/10] xfs: mount api - add xfs_reconfigure()
Message-ID: <20190624175541.GX5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134513640.2519.16288235480703050854.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134513640.2519.16288235480703050854.stgit@fedora-28>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ian Kent <raven@themaw.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

On Mon, Jun 24, 2019 at 10:58:56AM +0800, Ian Kent wrote:
> Add the fs_context_operations method .reconfigure that performs
> remount validation as previously done by the super_operations
> .remount_fs method.
> 
> An attempt has also been made to update the comment about options
> handling problems with mount(8) to reflect the current situation.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |  171 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 171 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 0ec0142b94e1..7326b21b32d1 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1721,6 +1721,176 @@ xfs_validate_params(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_reconfigure(
> +	struct fs_context *fc)
> +{
> +	struct xfs_fs_context	*ctx = fc->fs_private;
> +	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
> +	struct xfs_mount        *new_mp = fc->s_fs_info;
> +	xfs_sb_t		*sbp = &mp->m_sb;
> +	int			flags = fc->sb_flags;
> +	int			error;
> +
> +	error = xfs_validate_params(new_mp, ctx, fc->purpose);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * There have been problems in the past with options
> +	 * passed from mount(8).
> +	 *
> +	 * The problem being that options passed by mount(8) in
> +	 * the case where only the the mount point path is given
> +	 * would consist of the existing fstab options with the
> +	 * options from mtab for the current mount merged in and
> +	 * the options given on the command line last. But the
> +	 * result couldn't be relied upon to accurately reflect the
> +	 * current mount options so that rejecting options that
> +	 * can't be changed on reconfigure could erronously cause
> +	 * mount failure.
> +	 *
> +	 * The mount-api uses a legacy mount options handler
> +	 * in the VFS to accomodate mount(8) so these options
> +	 * will continue to be passed. Even if mount(8) is
> +	 * updated to use fsopen()/fsconfig()/fsmount() it's
> +	 * likely to continue to set the existing options so
> +	 * options problems with reconfigure could continue.
> +	 *
> +	 * For the longest time mtab locking was a problem and
> +	 * this could have been one possible cause. It's also
> +	 * possible there could have been options order problems.
> +	 *
> +	 * That has changed now as mtab is a link to the proc
> +	 * file system mount table so mtab options should be
> +	 * always accurate.
> +	 *
> +	 * Consulting the util-linux maintainer (Karel Zak) he
> +	 * is confident that, in this case, the options passed
> +	 * by mount(8) will be those of the current mount and
> +	 * the options order should be a correct merge of fstab
> +	 * and mtab options, and new options given on the command
> +	 * line.

I don't know if it's too late to do this, but could we mandate this
behavior for the new mount api that dhowells has been working on, and
then pass a flag to all the fs parsers so that they know when it's safe
to complain about attempts to remount with changes to options that can't
be changed?

> +	 *
> +	 * So, in theory, it should be possible to compare incoming
> +	 * options and return an error for options that differ from
> +	 * the current mount and can't be changed on reconfigure to
> +	 * prevent users from believing they might have changed mount
> +	 * options using remount which can't be changed.
> +	 *
> +	 * But for now continue to return success for every reconfigure
> +	 * request, and silently ignore all options that can't actually
> +	 * be changed.

The comment lines could be longer (i.e. wrapped at column 80 instead of
72 or wherever they are now) and moved to be part of the comment for the
function instead of inside the body.

> +	 */
> +
> +	/* inode32 -> inode64 */
> +	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> +	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> +	}
> +
> +	/* inode64 -> inode32 */
> +	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> +	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> +	}
> +
> +	/* ro -> rw */
> +	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
> +		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> +			xfs_warn(mp,
> +		"ro->rw transition prohibited on norecovery mount");
> +			return -EINVAL;
> +		}
> +
> +		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		    xfs_sb_has_ro_compat_feature(sbp,
> +					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> +			xfs_warn(mp,
> +"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
> +				(sbp->sb_features_ro_compat &
> +					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> +			return -EINVAL;
> +		}
> +
> +		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> +
> +		/*
> +		 * If this is the first remount to writeable state we
> +		 * might have some superblock changes to update.
> +		 */
> +		if (mp->m_update_sb) {
> +			error = xfs_sync_sb(mp, false);
> +			if (error) {
> +				xfs_warn(mp, "failed to write sb changes");
> +				return error;
> +			}
> +			mp->m_update_sb = false;
> +		}
> +
> +		/*
> +		 * Fill out the reserve pool if it is empty. Use the stashed
> +		 * value if it is non-zero, otherwise go with the default.
> +		 */
> +		xfs_restore_resvblks(mp);
> +		xfs_log_work_queue(mp);
> +
> +		/* Recover any CoW blocks that never got remapped. */
> +		error = xfs_reflink_recover_cow(mp);
> +		if (error) {
> +			xfs_err(mp,
> +	"Error %d recovering leftover CoW allocations.", error);
> +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +			return error;
> +		}
> +		xfs_start_block_reaping(mp);
> +
> +		/* Create the per-AG metadata reservation pool .*/
> +		error = xfs_fs_reserve_ag_blocks(mp);
> +		if (error && error != -ENOSPC)
> +			return error;

Ugh, could you please refactor everything from the "ro -> rw" case in
xfs_fs_remount into a separate function and then call it from here?
Then both functions can shrink to:

	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
		error = xfs_remount_rw(mp);
		if (error)
			return error;
	} else if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
		error = xfs_remount_ro(mp);
		if (error)
			return error;
	}

> +	}
> +
> +	/* rw -> ro */
> +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
> +		/*
> +		 * Cancel background eofb scanning so it cannot race with the
> +		 * final log force+buftarg wait and deadlock the remount.
> +		 */
> +		xfs_stop_block_reaping(mp);
> +
> +		/* Get rid of any leftover CoW reservations... */
> +		error = xfs_icache_free_cowblocks(mp, NULL);
> +		if (error) {
> +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +			return error;
> +		}
> +
> +		/* Free the per-AG metadata reservation pool. */
> +		error = xfs_fs_unreserve_ag_blocks(mp);
> +		if (error) {
> +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +			return error;
> +		}
> +
> +		/*
> +		 * Before we sync the metadata, we need to free up the reserve
> +		 * block pool so that the used block count in the superblock on
> +		 * disk is correct at the end of the remount. Stash the current
> +		 * reserve pool size so that if we get remounted rw, we can
> +		 * return it to the same size.
> +		 */
> +		xfs_save_resvblks(mp);
> +
> +		xfs_quiesce_attr(mp);
> +		mp->m_flags |= XFS_MOUNT_RDONLY;

...and here?

> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Second stage of a freeze. The data is already frozen so we only
>   * need to take care of the metadata. Once that's done sync the superblock
> @@ -2246,6 +2416,7 @@ static const struct super_operations xfs_super_operations = {
>  static const struct fs_context_operations xfs_context_ops = {
>  	.parse_param = xfs_parse_param,
>  	.get_tree    = xfs_get_tree,
> +	.reconfigure = xfs_reconfigure,
>  };
>  
>  static struct file_system_type xfs_fs_type = {
> 
