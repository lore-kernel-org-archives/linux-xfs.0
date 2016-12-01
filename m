Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43705 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751451AbcLAJym (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 04:54:42 -0500
Date: Thu, 1 Dec 2016 10:54:39 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] xfs: deprecate barrier/nobarrier mount option
Message-ID: <20161201095439.GB16028@quack2.suse.cz>
References: <20161130225444.15869-1-david@fromorbit.com>
 <20161130225444.15869-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161130225444.15869-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu 01-12-16 09:54:44, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We always perform integrity operations now, so these mount options
> don't do anything. Deprecate them and mark them for removal in
> in a year.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

We use 'nobarrier' mount option to simulate disks with battery-backed
caches in some of our IO performance testing. I don't say we cannot live
with this mount option but it was convenient...

								Honza

> ---
>  Documentation/filesystems/xfs.txt | 12 ++++--------
>  fs/xfs/xfs_super.c                | 25 ++++++++++++++++---------
>  2 files changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index c2d44e6e117b..68a057c8fccf 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -51,13 +51,6 @@ default behaviour.
>  	CRC enabled filesystems always use the attr2 format, and so
>  	will reject the noattr2 mount option if it is set.
>  
> -  barrier (*)
> -  nobarrier
> -	Enables/disables the use of block layer write barriers for
> -	writes into the journal and for data integrity operations.
> -	This allows for drive level write caching to be enabled, for
> -	devices that support write barriers.
> -
>    discard
>    nodiscard (*)
>  	Enable/disable the issuing of commands to let the block
> @@ -228,7 +221,10 @@ default behaviour.
>  Deprecated Mount Options
>  ========================
>  
> -None at present.
> +  Name				Removal Schedule
> +  ----				----------------
> +  barrier			December 2017
> +  nobarrier			December 2017
>  
>  
>  Removed Mount Options
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 563d1d146b8c..eecbaac08eba 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -104,9 +104,6 @@ static const match_table_t tokens = {
>  	{Opt_sysvgroups,"sysvgroups"},	/* group-ID from current process */
>  	{Opt_allocsize,	"allocsize=%s"},/* preferred allocation size */
>  	{Opt_norecovery,"norecovery"},	/* don't run XFS recovery */
> -	{Opt_barrier,	"barrier"},	/* use writer barriers for log write and
> -					 * unwritten extent conversion */
> -	{Opt_nobarrier,	"nobarrier"},	/* .. disable */
>  	{Opt_inode64,	"inode64"},	/* inodes can be allocated anywhere */
>  	{Opt_inode32,   "inode32"},	/* inode allocation limited to
>  					 * XFS_MAXINUMBER_32 */
> @@ -134,6 +131,12 @@ static const match_table_t tokens = {
>  	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
>  
>  	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
> +
> +	/* Deprecated mount options scheduled for removal */
> +	{Opt_barrier,	"barrier"},	/* use writer barriers for log write and
> +					 * unwritten extent conversion */
> +	{Opt_nobarrier,	"nobarrier"},	/* .. disable */
> +
>  	{Opt_err,	NULL},
>  };
>  
> @@ -301,12 +304,6 @@ xfs_parseargs(
>  		case Opt_nouuid:
>  			mp->m_flags |= XFS_MOUNT_NOUUID;
>  			break;
> -		case Opt_barrier:
> -			mp->m_flags |= XFS_MOUNT_BARRIER;
> -			break;
> -		case Opt_nobarrier:
> -			mp->m_flags &= ~XFS_MOUNT_BARRIER;
> -			break;
>  		case Opt_ikeep:
>  			mp->m_flags |= XFS_MOUNT_IKEEP;
>  			break;
> @@ -374,6 +371,14 @@ xfs_parseargs(
>  			mp->m_flags |= XFS_MOUNT_DAX;
>  			break;
>  #endif
> +		case Opt_barrier:
> +			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
> +			mp->m_flags |= XFS_MOUNT_BARRIER;
> +			break;
> +		case Opt_nobarrier:
> +			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
> +			mp->m_flags &= ~XFS_MOUNT_BARRIER;
> +			break;
>  		default:
>  			xfs_warn(mp, "unknown mount option [%s].", p);
>  			return -EINVAL;
> @@ -1238,9 +1243,11 @@ xfs_fs_remount(
>  		token = match_token(p, tokens, args);
>  		switch (token) {
>  		case Opt_barrier:
> +			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
>  			mp->m_flags |= XFS_MOUNT_BARRIER;
>  			break;
>  		case Opt_nobarrier:
> +			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
>  			mp->m_flags &= ~XFS_MOUNT_BARRIER;
>  			break;
>  		case Opt_inode64:
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
