Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752974AbdCFNvt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Mar 2017 08:51:49 -0500
Date: Mon, 6 Mar 2017 08:51:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: allow zero-length symlinks (and directories), sort
 of
Message-ID: <20170306135143.GC3223@bfoster.bfoster>
References: <20170304000529.GB5073@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170304000529.GB5073@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 03, 2017 at 04:05:29PM -0800, Darrick J. Wong wrote:
> In commit ef388e2054 ("don't allow di_size with high bit set") and
> commit 3c6f46eacd87 ("sanity check directory inode di_size") we
> erroneously fail the inode verification checks for symlinks or
> directories with di_size == 0.
> 
> This is proven incorrect by generic/388 because the unlink process uses
> multiple unconnected transactions to truncate the remote symlink /
> directory and to unlink and free the inode.  If the fs goes down after
> the truncate commit but before the unlink happens, we are left with a
> zero-length inode.  Worse yet, if the unlink /does/ commit, log recovery
> will now break after the first transaction because we've zeroed di_size.
> 
> In order to prevent the crashes and ASSERTs that the old patches
> covered, re-allow the zero-length inodes and change the functions that
> interface with the vfs to return the appropriate error codes to
> userspace.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Interesting, thanks. I suppose this means we should drop the repair side
fix..? I'm a bit leery on repair modifying a filesystem that is
technically in a "valid" state, unless there's no other option to
recover from that state.

>  fs/xfs/libxfs/xfs_inode_buf.c |    4 ----
>  fs/xfs/xfs_dir2_readdir.c     |    6 ++----
>  fs/xfs/xfs_iops.c             |    9 ++++++++-
>  3 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 3752bac..6e62999 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -402,10 +402,6 @@ xfs_dinode_verify(
>  	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
>  		return false;
>  
> -	/* No zero-length symlinks/dirs. */
> -	if ((S_ISLNK(mode) || S_ISDIR(mode)) && dip->di_size == 0)
> -		return false;
> -

What's the reasoning for dropping the S_ISDIR() logic here? Is the same
scenario possible on a directory?

>  	/* only version 3 or greater inodes are extensively verified here */
>  	if (dip->di_version < 3)
>  		return true;
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 0b3b636..be1367a 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -74,10 +74,8 @@ xfs_dir2_sf_getdents(
>  	/*
>  	 * Give up if the directory is way too short.
>  	 */
> -	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
> -		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
> -		return -EIO;
> -	}
> +	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent))
> +		return -EFSCORRUPTED;

This seems reasonable if it is truly an unexpected state...

>  
>  	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 22c1615..b7b6807 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -457,6 +457,9 @@ xfs_vn_get_link(
>  	char			*link;
>  	int			error = -ENOMEM;
>  
> +	if (i_size_read(inode) == 0)
> +		return ERR_PTR(-EFSCORRUPTED);
> +

... but this one to me seems to qualify as an expected state, based on
what you've described in the commit log description. Can we actually now
"recover" from this situation at runtime (i.e., can we unlink the
inode)? If so, it seems a little ominous to return a corruption errror
as opposed to EINVAL or EIO or something (though I suppose either one
may confuse a user enough into running xfs_repair anyways). Thoughts?

Brian

>  	if (!dentry)
>  		return ERR_PTR(-ECHILD);
>  
> @@ -483,8 +486,12 @@ xfs_vn_get_link_inline(
>  	struct inode		*inode,
>  	struct delayed_call	*done)
>  {
> +	char			*p;
>  	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
> -	return XFS_I(inode)->i_df.if_u1.if_data;
> +	p = XFS_I(inode)->i_df.if_u1.if_data;
> +	if (p)
> +		return p;
> +	return ERR_PTR(-EFSCORRUPTED);
>  }
>  
>  STATIC int
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
