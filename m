Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45578 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfDBReE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Apr 2019 13:34:04 -0400
Date: Tue, 2 Apr 2019 13:34:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/10] xfs: expand xfs_fsop_geom
Message-ID: <20190402173401.GH2899@bfoster>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413863414.4966.13609556795695536711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155413863414.4966.13609556795695536711.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 01, 2019 at 10:10:34AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename the current (v2-v4) geometry ioctl XFS_IOC_FSGEOMETRY_V2 and
> expand the existing xfs_fsop_geom to reserve empty space for more
> fields.  This means that newly built binaries will pick up the new
> format and existing programs will simply end up in the V2 handler.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h |   32 +++++++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_sb.c |    5 +++++
>  fs/xfs/xfs_ioctl.c     |   22 ++++++++++++++++++++--
>  fs/xfs/xfs_ioctl32.c   |    1 +
>  4 files changed, 57 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index f3aa59302fef..1dba751cde60 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -148,7 +148,34 @@ typedef struct xfs_fsop_geom_v1 {
>  } xfs_fsop_geom_v1_t;
>  
>  /*
> - * Output for XFS_IOC_FSGEOMETRY
> + * Output for XFS_IOC_FSGEOMETRY_V2
> + */
> +typedef struct xfs_fsop_geom_v2 {
...
> +} xfs_fsop_geom_v2_t;
> +

Do we need the typedef for a new struct?

> +/*
> + * Output for XFS_IOC_FSGEOMETRY (v5)
>   */
>  typedef struct xfs_fsop_geom {
>  	__u32		blocksize;	/* filesystem (data) block size */
...
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index f0309b74e377..c2ca3a816c41 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1168,6 +1168,11 @@ xfs_fs_geometry(
>  
>  	geo->logsunit = sbp->sb_logsunit;
>  
> +	if (struct_version < 5)
> +		return 0;
> +
> +	geo->version = XFS_FSOP_GEOM_V5;
> +

It's interesting that we've presumably had the version field since
struct_version >= 4, but it's always been set to zero. Now we go and set
it to 5. I'm not sure it really matters, but any idea what's behind
that?

Brian

>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6ecdbb3af7de..7fd8815633dc 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -801,7 +801,7 @@ xfs_ioc_fsgeometry_v1(
>  }
>  
>  STATIC int
> -xfs_ioc_fsgeometry(
> +xfs_ioc_fsgeometry_v2(
>  	xfs_mount_t		*mp,
>  	void			__user *arg)
>  {
> @@ -812,6 +812,23 @@ xfs_ioc_fsgeometry(
>  	if (error)
>  		return error;
>  
> +	if (copy_to_user(arg, &fsgeo, sizeof(struct xfs_fsop_geom_v2)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +STATIC int
> +xfs_ioc_fsgeometry(
> +	struct xfs_mount	*mp,
> +	void			__user *arg)
> +{
> +	struct xfs_fsop_geom	fsgeo;
> +	int			error;
> +
> +	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 5);
> +	if (error)
> +		return error;
> +
>  	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
>  		return -EFAULT;
>  	return 0;
> @@ -1938,7 +1955,8 @@ xfs_file_ioctl(
>  
>  	case XFS_IOC_FSGEOMETRY_V1:
>  		return xfs_ioc_fsgeometry_v1(mp, arg);
> -
> +	case XFS_IOC_FSGEOMETRY_V2:
> +		return xfs_ioc_fsgeometry_v2(mp, arg);
>  	case XFS_IOC_FSGEOMETRY:
>  		return xfs_ioc_fsgeometry(mp, arg);
>  
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 5001dca361e9..323cfd4b15dc 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -561,6 +561,7 @@ xfs_file_compat_ioctl(
>  	switch (cmd) {
>  	/* No size or alignment issues on any arch */
>  	case XFS_IOC_DIOINFO:
> +	case XFS_IOC_FSGEOMETRY_V2:
>  	case XFS_IOC_FSGEOMETRY:
>  	case XFS_IOC_FSGETXATTR:
>  	case XFS_IOC_FSSETXATTR:
> 
