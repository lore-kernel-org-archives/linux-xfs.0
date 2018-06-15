Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54850 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965083AbeFOB5d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 21:57:33 -0400
Subject: Re: [PATCH] xfs: symlinks can be zero length during log recovery
References: <20180615014314.27574-1-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2a19410d-171e-37b0-c4d4-5ae427ee8901@sandeen.net>
Date: Thu, 14 Jun 2018 20:57:32 -0500
MIME-Version: 1.0
In-Reply-To: <20180615014314.27574-1-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 6/14/18 8:43 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A log recovery failure has been reproduced where a symlink inode has
> a zero length in extent form. It was caused by a shutdown during a
> combined fstress+fsmark workload.
> 
> To fix it, we have to allow zero length symlink inodes through
> xfs_dinode_verify() during log recovery. We already specifically
> check and allow this case in the shortform symlink fork verifier,
> but in this case we don't get that far, and the inode is not in
> shortform format.
> 
> Update the dinode verifier to handle this case, and change the
> symlink fork verifier to only allow this case to exist during log
> recovery.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks reasonable.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c      | 16 +++++++++++++---
>  fs/xfs/libxfs/xfs_symlink_remote.c | 12 +++++++++---
>  fs/xfs/xfs_log.c                   | 11 +++++++++++
>  fs/xfs/xfs_log.h                   |  3 ++-
>  4 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index d38d724534c4..bec9178377e3 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -19,6 +19,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_dir2.h"
> +#include "xfs_log.h"
>  
>  #include <linux/iversion.h>
>  
> @@ -411,9 +412,18 @@ xfs_dinode_verify(
>  	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
>  		return __this_address;
>  
> -	/* No zero-length symlinks/dirs. */
> -	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
> -		return __this_address;
> +	/*
> +	 * Normally both symlinks and dirs cannot be zero length. However, if a
> +	 * symlink is in the process of being torn down and there's a
> +	 * shutdown/crash, the symlink on disk may have a zero size. Hence we
> +	 * only allow zero length symlinks during log recovery.
> +	 */
> +	if (di_size == 0) {
> +		if (S_ISDIR(mode))
> +			return __this_address;
> +		if (S_ISLNK(mode) && !xfs_log_in_recovery(mp))
> +			return __this_address;
> +	}
>  
>  	/* Fork checks carried over from xfs_iformat_fork */
>  	if (mode &&
> diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> index 95374ab2dee7..b1f0dd14f805 100644
> --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> @@ -215,9 +215,15 @@ xfs_symlink_shortform_verify(
>  	size = ifp->if_bytes;
>  	endp = sfp + size;
>  
> -	/* Zero length symlinks can exist while we're deleting a remote one. */
> -	if (size == 0)
> -		return NULL;
> +	/*
> +	 * Zero length symlinks can only pass through here during log recovery
> +	 * while recovering deletion of a remote symlink.
> +	 */
> +	if (size == 0) {
> +		if (xfs_log_in_recovery(ip->i_mount))
> +			return NULL;
> +		return __this_address;
> +	}
>  
>  	/* No negative sizes or overly long symlink targets. */
>  	if (size < 0 || size > XFS_SYMLINK_MAXLEN)
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5e56f3b93d4b..012397f6ec5a 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -4083,3 +4083,14 @@ xfs_log_check_lsn(
>  
>  	return valid;
>  }
> +
> +bool
> +xfs_log_in_recovery(
> +	struct xfs_mount	*mp)
> +{
> +	if (!mp->m_log)
> +		return false;
> +	if (mp->m_log->l_flags & XLOG_ACTIVE_RECOVERY)
> +		return true;
> +	return false;
> +}
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 3c1f6a8b4b70..410d4b3a20d3 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -152,6 +152,7 @@ bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>  
>  void	xfs_log_work_queue(struct xfs_mount *mp);
>  void	xfs_log_quiesce(struct xfs_mount *mp);
> -bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
> +bool	xfs_log_check_lsn(struct xfs_mount *mp, xfs_lsn_t lsn);
> +bool	xfs_log_in_recovery(struct xfs_mount *mp);
>  
>  #endif	/* __XFS_LOG_H__ */
> 
