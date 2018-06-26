Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37530 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932544AbeFZLXe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 07:23:34 -0400
Received: by mail-wm0-f68.google.com with SMTP id n17-v6so883796wmh.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jun 2018 04:23:33 -0700 (PDT)
Date: Tue, 26 Jun 2018 13:23:30 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4.19 V2] xfs: remove deprecated barrier/nobarrier mount
 options
Message-ID: <20180626112330.7xgexrmseaasudmk@odin.usersys.redhat.com>
References: <56f0a68c-9c1b-712a-a0e8-e596f8272561@redhat.com>
 <819f15b2-ab0d-2f91-559f-08b558e06e25@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <819f15b2-ab0d-2f91-559f-08b558e06e25@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 25, 2018 at 07:43:36PM -0500, Eric Sandeen wrote:
> The barrier mount options have been no-ops and deprecated since
> 
> 4cf4573 xfs: deprecate barrier/nobarrier mount option
> 
> i.e. kernel 4.10 / December 2016, with a stated deprecation schedule
> after v4.15.  Should be fair game to remove them now.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: plan for 4.19.
> (now wait, it'll be 5.0)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
>  Documentation/filesystems/xfs.txt |    4 ++--
>  fs/xfs/xfs_mount.h                |    1 -
>  fs/xfs/xfs_super.c                |   34 ++++------------------------------
>  3 files changed, 6 insertions(+), 33 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 4d9ff0a..07dbd4e 100644
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
> index 245349d..0f9115c 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -216,7 +216,6 @@ struct xfs_error_cfg {
>  #define XFS_MOUNT_SMALL_INUMS	(1ULL << 14)	/* user wants 32bit inodes */
>  #define XFS_MOUNT_32BITINODES	(1ULL << 15)	/* inode32 allocator active */
>  #define XFS_MOUNT_NOUUID	(1ULL << 16)	/* ignore uuid during mount */
> -#define XFS_MOUNT_BARRIER	(1ULL << 17)
>  #define XFS_MOUNT_IKEEP		(1ULL << 18)	/* keep empty inode clusters*/
>  #define XFS_MOUNT_SWALLOC	(1ULL << 19)	/* turn on stripe width
>  						 * allocation */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 9d791f1..03c5677 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -65,11 +65,10 @@ enum {
>  	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
>  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
>  	Opt_mtpt, Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
> -	Opt_allocsize, Opt_norecovery, Opt_barrier, Opt_nobarrier,
> -	Opt_inode64, Opt_inode32, Opt_ikeep, Opt_noikeep,
> -	Opt_largeio, Opt_nolargeio, Opt_attr2, Opt_noattr2, Opt_filestreams,
> -	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota,
> -	Opt_uquota, Opt_gquota, Opt_pquota,
> +	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32, Opt_ikeep,
> +	Opt_noikeep, Opt_largeio, Opt_nolargeio, Opt_attr2, Opt_noattr2,
> +	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
> +	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
>  	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
>  };
> @@ -118,14 +117,7 @@ enum {
>  	{Opt_qnoenforce, "qnoenforce"},	/* same as uqnoenforce */
>  	{Opt_discard,	"discard"},	/* Discard unused blocks */
>  	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
> -
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
> @@ -209,7 +201,6 @@ enum {
>  	 * Set some default flags that could be cleared by the mount option
>  	 * parsing.
>  	 */
> -	mp->m_flags |= XFS_MOUNT_BARRIER;
>  	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
>  
>  	/*
> @@ -362,14 +353,6 @@ enum {
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
> @@ -487,7 +470,6 @@ struct proc_xfs_info {
>  	static struct proc_xfs_info xfs_info_unset[] = {
>  		/* the few simple ones we can get from the mount struct */
>  		{ XFS_MOUNT_COMPAT_IOSIZE,	",largeio" },
> -		{ XFS_MOUNT_BARRIER,		",nobarrier" },
>  		{ XFS_MOUNT_SMALL_INUMS,	",inode64" },
>  		{ 0, NULL }
>  	};
> @@ -1278,14 +1260,6 @@ struct proc_xfs_info {
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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
