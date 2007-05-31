Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 19:30:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4V2UhWt007569
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 19:30:46 -0700
Date: Thu, 31 May 2007 12:30:31 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
Message-ID: <20070531023031.GH85884050@sgi.com>
References: <20070530125954.706423971@suse.cz> <20070530143043.216024061@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530143043.216024061@suse.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michal Marek <mmarek@suse.cz>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 02:59:55PM +0200, Michal Marek wrote:
> i386 struct xfs_fsop_geom_v1 has no padding after the last member, so
> the size is different.

That's a pain - it's kind of clunky having to redefine the entire
structure just pack it differently. Oh well, not much that
we can do about it...

> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  fs/xfs/linux-2.6/xfs_ioctl32.c |   40 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
> @@ -75,6 +75,40 @@ xfs_ioctl32_flock(
>  	return (unsigned long)p;
>  }
>  
> +typedef struct xfs_fsop_geom_v132 {

xfs_fsop_geom_v1_32

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
> +} __attribute__((packed)) xfs_fsop_geom_v132_t;

xfs_fsop_geom_v1_32_t

> +#define XFS_IOC_FSGEOMETRY_V1_32     _IOR ('X', 100, struct xfs_fsop_geom_v132)
> +
> +STATIC unsigned long xfs_ioctl32_geom_v1(unsigned long arg)
> +{
> +	xfs_fsop_geom_v132_t __user *p32 = (void __user *)arg;
> +	xfs_fsop_geom_v1_t __user *p = compat_alloc_user_space(sizeof(*p));
> +
> +	if (copy_in_user(p, p32, sizeof(*p32)))
> +		return -EFAULT;
> +	return (unsigned long)p;
> +}
> +
>  #else
>  
>  typedef struct xfs_fsop_bulkreq32 {
> @@ -118,7 +152,6 @@ xfs_compat_ioctl(
>  
>  	switch (cmd) {
>  	case XFS_IOC_DIOINFO:
> -	case XFS_IOC_FSGEOMETRY_V1:
>  	case XFS_IOC_FSGEOMETRY:
>  	case XFS_IOC_GETVERSION:
>  	case XFS_IOC_GETXFLAGS:
> @@ -166,6 +199,10 @@ xfs_compat_ioctl(
>  		arg = xfs_ioctl32_flock(arg);
>  		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
>  		break;

	/* xfs_fsop_geom_v1 changes size */
> +	case XFS_IOC_FSGEOMETRY_V1_32:
> +		arg = xfs_ioctl32_geom_v1(arg);
> +		cmd = XFS_IOC_FSGEOMETRY_V1;
> +		break;

cmd = _NATIVE_IOC(cmd, struct xfs_fsop_geom_v1);

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
