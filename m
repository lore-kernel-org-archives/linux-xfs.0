Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41554 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753818AbeGFDeT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 23:34:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w663XYxj156001
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:34:19 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2k0dnjr20e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 03:34:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w663YHi5019867
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:34:18 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w663YHaG014651
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:34:17 GMT
Date: Thu, 5 Jul 2018 20:34:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 1/8] xfs: introduce inline data superblock feature bit
Message-ID: <20180706033416.GN32415@magnolia>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-2-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530846750-6686-2-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 11:12:22AM +0800, Shan Hai wrote:
> The data inlining is an on-disk format change, so introduce a new
> superblock feature bit to work with the mkfs tool to handle the
> inline data, the feature bit is set at mkfs time.
> 
> Signed-off-by: Shan Hai <shan.hai@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 10 +++++++++-
>  fs/xfs/libxfs/xfs_fs.h     |  1 +
>  fs/xfs/libxfs/xfs_sb.c     |  2 ++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 059bc44c27e8..6066ba7fdaf7 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -469,10 +469,12 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
>  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> +#define XFS_SB_FEAT_INCOMPAT_INLINEDATA (1 << 3)	/* inline inode data */
>  #define XFS_SB_FEAT_INCOMPAT_ALL \
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
> +		 XFS_SB_FEAT_INCOMPAT_META_UUID|\
> +		 XFS_SB_FEAT_INCOMPAT_INLINEDATA)

Uh... don't go enabling this feature in the _ALL flags until you've
finished putting all the code in...

>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> @@ -550,6 +552,12 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
>  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
>  }
>  
> +static inline bool xfs_sb_version_hasinlinedata(struct xfs_sb *sbp)
> +{
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_INLINEDATA);
> +}
> +
>  /*
>   * end of superblock version macros
>   */
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index f3aa59302fef..ee1f7621c0e4 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -210,6 +210,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
>  #define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* reverse mapping btree */
>  #define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* files can share blocks */
> +#define XFS_FSOP_GEOM_FLAGS_INLINEDATA	0x200000 /* inline data into inode */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 350119eeaecb..4002ed105b6b 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1068,6 +1068,8 @@ xfs_fs_geometry(
>  		geo->logsectsize = sbp->sb_logsectsize;
>  	else
>  		geo->logsectsize = BBSIZE;
> +	if (xfs_sb_version_hasinlinedata(sbp))
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_INLINEDATA;
>  	geo->rtsectsize = sbp->sb_blocksize;
>  	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
