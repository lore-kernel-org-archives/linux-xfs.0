Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40334 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731918AbeGZR21 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jul 2018 13:28:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6QFwuw7191861
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jul 2018 16:10:56 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2kbvsp3tff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jul 2018 16:10:56 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6QGAtIf020206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jul 2018 16:10:56 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6QGAtgo022070
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jul 2018 16:10:55 GMT
Date: Thu, 26 Jul 2018 09:10:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove deprecated barrier/nobarrier mount options
Message-ID: <20180726161053.GE30972@magnolia>
References: <20180726160119.GD30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180726160119.GD30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

On Thu, Jul 26, 2018 at 09:01:19AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the deprecated barrier and nobarrier mount options since they do
> nothing and were listed for removal some time around v4.15.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

NAK, Eric Sandeen already sent a patch doing this, will take that
instead.

--D

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
