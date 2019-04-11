Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbfDKM31 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Apr 2019 08:29:27 -0400
Date: Thu, 11 Apr 2019 08:29:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/8] xfs: bump XFS_IOC_FSGEOMETRY to v5 structures
Message-ID: <20190411122919.GD2888@bfoster>
References: <155494712442.1090518.2784809287026447547.stgit@magnolia>
 <155494715170.1090518.14151782984794662058.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155494715170.1090518.14151782984794662058.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Wed, Apr 10, 2019 at 06:45:51PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Unfortunately, the V4 XFS_IOC_FSGEOMETRY structure is out of space so we
> can't just add a new field to it. Hence we need to bump the definition
> to V5 and and treat the V4 ioctl and structure similar to v1 to v3.
> 
> While doing this, clean up all the definitions associated with the
> XFS_IOC_FSGEOMETRY ioctl.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> [darrick: forward port to 5.1, expand structure size to 256 bytes]
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_fs.h |   87 +++++++++++++++++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_sb.c |    5 +++
>  fs/xfs/xfs_ioctl.c     |   48 ++++++++++----------------
>  fs/xfs/xfs_ioctl32.c   |    3 +-
>  4 files changed, 84 insertions(+), 59 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index f3aa59302fef..cb7d0b1453cd 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -124,7 +124,7 @@ typedef struct xfs_flock64 {
>  /*
>   * Output for XFS_IOC_FSGEOMETRY_V1
>   */
> -typedef struct xfs_fsop_geom_v1 {
> +struct xfs_fsop_geom_v1 {
>  	__u32		blocksize;	/* filesystem (data) block size */
>  	__u32		rtextsize;	/* realtime extent size		*/
>  	__u32		agblocks;	/* fsblocks in an AG		*/
> @@ -145,12 +145,39 @@ typedef struct xfs_fsop_geom_v1 {
>  	__u32		logsectsize;	/* log sector size, bytes	*/
>  	__u32		rtsectsize;	/* realtime sector size, bytes	*/
>  	__u32		dirblocksize;	/* directory block size, bytes	*/
> -} xfs_fsop_geom_v1_t;
> +};
> +
> +/*
> + * Output for XFS_IOC_FSGEOMETRY_V4
> + */
> +struct xfs_fsop_geom_v4 {
> +	__u32		blocksize;	/* filesystem (data) block size */
> +	__u32		rtextsize;	/* realtime extent size		*/
> +	__u32		agblocks;	/* fsblocks in an AG		*/
> +	__u32		agcount;	/* number of allocation groups	*/
> +	__u32		logblocks;	/* fsblocks in the log		*/
> +	__u32		sectsize;	/* (data) sector size, bytes	*/
> +	__u32		inodesize;	/* inode size in bytes		*/
> +	__u32		imaxpct;	/* max allowed inode space(%)	*/
> +	__u64		datablocks;	/* fsblocks in data subvolume	*/
> +	__u64		rtblocks;	/* fsblocks in realtime subvol	*/
> +	__u64		rtextents;	/* rt extents in realtime subvol*/
> +	__u64		logstart;	/* starting fsblock of the log	*/
> +	unsigned char	uuid[16];	/* unique id of the filesystem	*/
> +	__u32		sunit;		/* stripe unit, fsblocks	*/
> +	__u32		swidth;		/* stripe width, fsblocks	*/
> +	__s32		version;	/* structure version		*/
> +	__u32		flags;		/* superblock version flags	*/
> +	__u32		logsectsize;	/* log sector size, bytes	*/
> +	__u32		rtsectsize;	/* realtime sector size, bytes	*/
> +	__u32		dirblocksize;	/* directory block size, bytes	*/
> +	__u32		logsunit;	/* log stripe unit, bytes	*/
> +};
>  
>  /*
>   * Output for XFS_IOC_FSGEOMETRY
>   */
> -typedef struct xfs_fsop_geom {
> +struct xfs_fsop_geom {
>  	__u32		blocksize;	/* filesystem (data) block size */
>  	__u32		rtextsize;	/* realtime extent size		*/
>  	__u32		agblocks;	/* fsblocks in an AG		*/
> @@ -171,8 +198,9 @@ typedef struct xfs_fsop_geom {
>  	__u32		logsectsize;	/* log sector size, bytes	*/
>  	__u32		rtsectsize;	/* realtime sector size, bytes	*/
>  	__u32		dirblocksize;	/* directory block size, bytes	*/
> -	__u32		logsunit;	/* log stripe unit, bytes */
> -} xfs_fsop_geom_t;
> +	__u32		logsunit;	/* log stripe unit, bytes	*/
> +	__u64		reserved[18];	/* reserved space		*/
> +};
>  
>  /* Output for XFS_FS_COUNTS */
>  typedef struct xfs_fsop_counts {
> @@ -188,28 +216,30 @@ typedef struct xfs_fsop_resblks {
>  	__u64  resblks_avail;
>  } xfs_fsop_resblks_t;
>  
> -#define XFS_FSOP_GEOM_VERSION	0
> -
> -#define XFS_FSOP_GEOM_FLAGS_ATTR	0x0001	/* attributes in use	*/
> -#define XFS_FSOP_GEOM_FLAGS_NLINK	0x0002	/* 32-bit nlink values	*/
> -#define XFS_FSOP_GEOM_FLAGS_QUOTA	0x0004	/* quotas enabled	*/
> -#define XFS_FSOP_GEOM_FLAGS_IALIGN	0x0008	/* inode alignment	*/
> -#define XFS_FSOP_GEOM_FLAGS_DALIGN	0x0010	/* large data alignment */
> -#define XFS_FSOP_GEOM_FLAGS_SHARED	0x0020	/* read-only shared	*/
> -#define XFS_FSOP_GEOM_FLAGS_EXTFLG	0x0040	/* special extent flag	*/
> -#define XFS_FSOP_GEOM_FLAGS_DIRV2	0x0080	/* directory version 2	*/
> -#define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
> -#define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
> -#define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
> -#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800	/* 32-bit project IDs	*/
> -#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
> -#define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
> -#define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
> -#define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
> -#define XFS_FSOP_GEOM_FLAGS_FINOBT	0x20000	/* free inode btree */
> -#define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
> -#define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* reverse mapping btree */
> -#define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* files can share blocks */
> +#define XFS_FSOP_GEOM_VERSION		0
> +#define XFS_FSOP_GEOM_VERSION_V5	5
> +
> +#define XFS_FSOP_GEOM_FLAGS_ATTR	(1 << 0)  /* attributes in use	   */
> +#define XFS_FSOP_GEOM_FLAGS_NLINK	(1 << 1)  /* 32-bit nlink values   */
> +#define XFS_FSOP_GEOM_FLAGS_QUOTA	(1 << 2)  /* quotas enabled	   */
> +#define XFS_FSOP_GEOM_FLAGS_IALIGN	(1 << 3)  /* inode alignment	   */
> +#define XFS_FSOP_GEOM_FLAGS_DALIGN	(1 << 4)  /* large data alignment  */
> +#define XFS_FSOP_GEOM_FLAGS_SHARED	(1 << 5)  /* read-only shared	   */
> +#define XFS_FSOP_GEOM_FLAGS_EXTFLG	(1 << 6)  /* special extent flag   */
> +#define XFS_FSOP_GEOM_FLAGS_DIRV2	(1 << 7)  /* directory version 2   */
> +#define XFS_FSOP_GEOM_FLAGS_LOGV2	(1 << 8)  /* log format version 2  */
> +#define XFS_FSOP_GEOM_FLAGS_SECTOR	(1 << 9)  /* sector sizes >1BB	   */
> +#define XFS_FSOP_GEOM_FLAGS_ATTR2	(1 << 10) /* inline attributes rework */
> +#define XFS_FSOP_GEOM_FLAGS_PROJID32	(1 << 11) /* 32-bit project IDs	   */
> +#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	(1 << 12) /* ASCII only CI names   */
> +	/*  -- Do not use --		(1 << 13)    SGI parent pointers   */
> +#define XFS_FSOP_GEOM_FLAGS_LAZYSB	(1 << 14) /* lazy superblock counters */
> +#define XFS_FSOP_GEOM_FLAGS_V5SB	(1 << 15) /* version 5 superblock  */
> +#define XFS_FSOP_GEOM_FLAGS_FTYPE	(1 << 16) /* inode directory types */
> +#define XFS_FSOP_GEOM_FLAGS_FINOBT	(1 << 17) /* free inode btree	   */
> +#define XFS_FSOP_GEOM_FLAGS_SPINODES	(1 << 18) /* sparse inode chunks   */
> +#define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
> +#define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> @@ -620,8 +650,9 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
>  #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
>  #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
> -#define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
> +#define XFS_IOC_FSGEOMETRY_V4	     _IOR ('X', 124, struct xfs_fsop_geom_v4)
>  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
> +#define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index dc5be0c631c8..6fab49f6070b 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1166,6 +1166,11 @@ xfs_fs_geometry(
>  
>  	geo->logsunit = sbp->sb_logsunit;
>  
> +	if (struct_version < 5)
> +		return 0;
> +
> +	geo->version = XFS_FSOP_GEOM_VERSION_V5;
> +
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 67d12027f563..d243660f1826 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -778,41 +778,28 @@ xfs_ioc_bulkstat(
>  	return 0;
>  }
>  
> -STATIC int
> -xfs_ioc_fsgeometry_v1(
> -	xfs_mount_t		*mp,
> -	void			__user *arg)
> -{
> -	xfs_fsop_geom_t         fsgeo;
> -	int			error;
> -
> -	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Caller should have passed an argument of type
> -	 * xfs_fsop_geom_v1_t.  This is a proper subset of the
> -	 * xfs_fsop_geom_t that xfs_fs_geometry() fills in.
> -	 */
> -	if (copy_to_user(arg, &fsgeo, sizeof(xfs_fsop_geom_v1_t)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
>  STATIC int
>  xfs_ioc_fsgeometry(
> -	xfs_mount_t		*mp,
> -	void			__user *arg)
> +	struct xfs_mount	*mp,
> +	void			__user *arg,
> +	int			struct_version)
>  {
> -	xfs_fsop_geom_t		fsgeo;
> +	struct xfs_fsop_geom	fsgeo;
> +	size_t			len;
>  	int			error;
>  
> -	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 4);
> +	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
>  	if (error)
>  		return error;
>  
> -	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
> +	if (struct_version <= 3)
> +		len = sizeof(struct xfs_fsop_geom_v1);
> +	else if (struct_version == 4)
> +		len = sizeof(struct xfs_fsop_geom_v4);
> +	else
> +		len = sizeof(fsgeo);
> +
> +	if (copy_to_user(arg, &fsgeo, len))
>  		return -EFAULT;
>  	return 0;
>  }
> @@ -2016,10 +2003,11 @@ xfs_file_ioctl(
>  		return xfs_ioc_bulkstat(mp, cmd, arg);
>  
>  	case XFS_IOC_FSGEOMETRY_V1:
> -		return xfs_ioc_fsgeometry_v1(mp, arg);
> -
> +		return xfs_ioc_fsgeometry(mp, arg, 3);
> +	case XFS_IOC_FSGEOMETRY_V4:
> +		return xfs_ioc_fsgeometry(mp, arg, 4);
>  	case XFS_IOC_FSGEOMETRY:
> -		return xfs_ioc_fsgeometry(mp, arg);
> +		return xfs_ioc_fsgeometry(mp, arg, 5);
>  
>  	case XFS_IOC_GETVERSION:
>  		return put_user(inode->i_generation, (int __user *)arg);
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 5001dca361e9..55ace6308637 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -52,7 +52,7 @@ xfs_compat_ioc_fsgeometry_v1(
>  	struct xfs_mount	  *mp,
>  	compat_xfs_fsop_geom_v1_t __user *arg32)
>  {
> -	xfs_fsop_geom_t		  fsgeo;
> +	struct xfs_fsop_geom	  fsgeo;
>  	int			  error;
>  
>  	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
> @@ -561,6 +561,7 @@ xfs_file_compat_ioctl(
>  	switch (cmd) {
>  	/* No size or alignment issues on any arch */
>  	case XFS_IOC_DIOINFO:
> +	case XFS_IOC_FSGEOMETRY_V4:
>  	case XFS_IOC_FSGEOMETRY:
>  	case XFS_IOC_FSGETXATTR:
>  	case XFS_IOC_FSSETXATTR:
> 
