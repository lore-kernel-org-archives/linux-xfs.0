Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35818 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbeEGVi3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 17:38:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w47Lbjko177497
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 21:38:28 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2hs24se673-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 May 2018 21:38:28 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w47LcRNV023375
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 21:38:27 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w47LcQO6017955
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 21:38:26 GMT
Date: Mon, 7 May 2018 14:38:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 19/21] xfs: Add the parent pointer support to the
 superblock version 5.
Message-ID: <20180507213825.GC11261@magnolia>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-20-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525627494-12873-20-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, May 06, 2018 at 10:24:52AM -0700, Allison Henderson wrote:
> [dchinner: forward ported and cleaned up]
> [achender: rebased and added parent pointer attribute to
>            compatible attributes mask]
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Old kernels can't accidentally start returning the ATTR_PARENT
attributes, right?  I think the answer is yes.....?

If so,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h | 7 +++++--
>  fs/xfs/libxfs/xfs_fs.h     | 1 +
>  fs/xfs/libxfs/xfs_sb.c     | 2 ++
>  fs/xfs/xfs_super.c         | 4 ++++
>  4 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 5e946c8..d05ffc5 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -462,10 +462,12 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
>  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
>  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
> +#define XFS_SB_FEAT_RO_COMPAT_PARENT	(1 << 3)		/* parent inode ptr */
>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
>  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> -		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
> +		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
> +		 XFS_SB_FEAT_RO_COMPAT_PARENT)
>  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
>  static inline bool
>  xfs_sb_has_ro_compat_feature(
> @@ -561,7 +563,8 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
>  
>  static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
>  {
> -	return false; /* We'll enable this at the end of the set */
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_PARENT));
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index faf1a4e..641e0af 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -222,6 +222,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
>  #define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* reverse mapping btree */
>  #define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* files can share blocks */
> +#define XFS_FSOP_GEOM_FLAGS_PARENT	0x200000 /* parent pointers */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index d9b94bd..e1f0ac1 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -955,6 +955,8 @@ xfs_fs_geometry(
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_RMAPBT;
>  	if (xfs_sb_version_hasreflink(sbp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
> +	if(xfs_sb_version_hasparent(sbp))
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
>  	if (xfs_sb_version_hassector(sbp))
>  		geo->logsectsize = sbp->sb_logsectsize;
>  	else
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index dce3baf..366deee 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1731,6 +1731,10 @@ xfs_fs_fill_super(
>  		goto out_filestream_unmount;
>  	}
>  
> +	if (xfs_sb_version_hasparent(&mp->m_sb))
> +		xfs_alert(mp,
> +	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
> +
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
