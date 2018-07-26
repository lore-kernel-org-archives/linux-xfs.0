Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55662 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731851AbeGZR2O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jul 2018 13:28:14 -0400
Subject: Re: [PATCH] xfs: remove deprecated barrier/nobarrier mount options
References: <20180726160119.GD30972@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c3d8c6de-1680-686d-a16d-351b6ca4736e@sandeen.net>
Date: Thu, 26 Jul 2018 09:10:42 -0700
MIME-Version: 1.0
In-Reply-To: <20180726160119.GD30972@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On 7/26/18 9:01 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the deprecated barrier and nobarrier mount options since they do
> nothing and were listed for removal some time around v4.15.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks at least as good as the one you reviewed from me on
6/26/18 ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

if you prefer this flavor ;)

> ---
>  Documentation/filesystems/xfs.txt |    4 ++--
>  fs/xfs/xfs_mount.h                |    1 -
>  fs/xfs/xfs_super.c                |   26 +-------------------------
>  3 files changed, 3 insertions(+), 28 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 4d9ff0a7f8e1..a9ae82fb9d13 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -223,8 +223,6 @@ Deprecated Mount Options
>  
>    Name				Removal Schedule
>    ----				----------------
> -  barrier			no earlier than v4.15
> -  nobarrier			no earlier than v4.15
>  
>  
>  Removed Mount Options
> @@ -236,6 +234,8 @@ Removed Mount Options
>    ihashsize			v4.0
>    irixsgid			v4.0
>    osyncisdsync/osyncisosync	v4.0
> +  barrier			v4.19
> +  nobarrier			v4.19
>  
>  
>  sysctls
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 16869d771b71..387b3868c66a 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -229,7 +229,6 @@ typedef struct xfs_mount {
>  #define XFS_MOUNT_SMALL_INUMS	(1ULL << 14)	/* user wants 32bit inodes */
>  #define XFS_MOUNT_32BITINODES	(1ULL << 15)	/* inode32 allocator active */
>  #define XFS_MOUNT_NOUUID	(1ULL << 16)	/* ignore uuid during mount */
> -#define XFS_MOUNT_BARRIER	(1ULL << 17)
>  #define XFS_MOUNT_IKEEP		(1ULL << 18)	/* keep empty inode clusters*/
>  #define XFS_MOUNT_SWALLOC	(1ULL << 19)	/* turn on stripe width
>  						 * allocation */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 9dd7df216fc3..afe59ce33876 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -65,7 +65,7 @@ enum {
>  	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
>  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
>  	Opt_mtpt, Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
> -	Opt_allocsize, Opt_norecovery, Opt_barrier, Opt_nobarrier,
> +	Opt_allocsize, Opt_norecovery,
>  	Opt_inode64, Opt_inode32, Opt_ikeep, Opt_noikeep,
>  	Opt_largeio, Opt_nolargeio, Opt_attr2, Opt_noattr2, Opt_filestreams,
>  	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota,
> @@ -120,12 +120,6 @@ static const match_table_t tokens = {
>  	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
>  
>  	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
> -
> -	/* Deprecated mount options scheduled for removal */
> -	{Opt_barrier,	"barrier"},	/* use writer barriers for log write and
> -					 * unwritten extent conversion */
> -	{Opt_nobarrier,	"nobarrier"},	/* .. disable */
> -
>  	{Opt_err,	NULL},
>  };
>  
> @@ -209,7 +203,6 @@ xfs_parseargs(
>  	 * Set some default flags that could be cleared by the mount option
>  	 * parsing.
>  	 */
> -	mp->m_flags |= XFS_MOUNT_BARRIER;
>  	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
>  
>  	/*
> @@ -362,14 +355,6 @@ xfs_parseargs(
>  			mp->m_flags |= XFS_MOUNT_DAX;
>  			break;
>  #endif
> -		case Opt_barrier:
> -			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
> -			mp->m_flags |= XFS_MOUNT_BARRIER;
> -			break;
> -		case Opt_nobarrier:
> -			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
> -			mp->m_flags &= ~XFS_MOUNT_BARRIER;
> -			break;
>  		default:
>  			xfs_warn(mp, "unknown mount option [%s].", p);
>  			return -EINVAL;
> @@ -487,7 +472,6 @@ xfs_showargs(
>  	static struct proc_xfs_info xfs_info_unset[] = {
>  		/* the few simple ones we can get from the mount struct */
>  		{ XFS_MOUNT_COMPAT_IOSIZE,	",largeio" },
> -		{ XFS_MOUNT_BARRIER,		",nobarrier" },
>  		{ XFS_MOUNT_SMALL_INUMS,	",inode64" },
>  		{ 0, NULL }
>  	};
> @@ -1322,14 +1306,6 @@ xfs_fs_remount(
>  
>  		token = match_token(p, tokens, args);
>  		switch (token) {
> -		case Opt_barrier:
> -			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
> -			mp->m_flags |= XFS_MOUNT_BARRIER;
> -			break;
> -		case Opt_nobarrier:
> -			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
> -			mp->m_flags &= ~XFS_MOUNT_BARRIER;
> -			break;
>  		case Opt_inode64:
>  			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
>  			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
