Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C47A07F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 18:45:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B2713304039
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 16:45:38 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id zf43vGVYA0WiDXkn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jan 2016 16:45:36 -0800 (PST)
Date: Thu, 21 Jan 2016 16:45:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: introduce per-inode DAX enablement
Message-ID: <20160122004532.GB5500@birch.djwong.org>
References: <1451886892-15548-1-git-send-email-david@fromorbit.com>
	<1451886892-15548-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1451886892-15548-4-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, ext4@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jan 04, 2016 at 04:54:52PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rather than just being able to turn DAX on and off via a mount
> option, some applications may only want to enable DAX for certain
> performance critical files in a filesystem.
> 
> This patch introduces a new inode flag to enable DAX in the v3 inode
> di_flags2 field. It adds support for setting and clearing flags in
> the di_flags2 field via the XFS_IOC_FSSETXATTR ioctl, and sets the
> S_DAX inode flag appropriately when it is seen.
> 
> When this flag is set on a directory, it acts as an "inherit flag".
> That is, inodes created in the directory will automatically inherit
> the on-disk inode DAX flag, enabling administrators to set up
> directory heirarchies that automatically use DAX. Setting this flag
> on an empty root directory will make the entire filesystem use DAX
> by default.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |  9 +++++++++
>  fs/xfs/xfs_inode.c         | 32 +++++++++++++++++++++++---------
>  fs/xfs/xfs_ioctl.c         | 18 +++++++++++++++++-
>  fs/xfs/xfs_iops.c          |  4 ++--
>  include/uapi/linux/fs.h    |  1 +
>  5 files changed, 52 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index f28eeab..b4ae7ce 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1024,6 +1024,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM)
>  
>  /*
> + * Values for di_flags2 These start by being exposed to userspace in the upper

"Values for di_flags2.  These are exposed to userspace in the..."

> + * 16 bits of the XFS_XFLAG_s range.
> + */
> +#define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
> +#define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
> +
> +#define XFS_DIFLAG2_ANY		(XFS_DIFLAG2_DAX)

Heh, I was gonna use bit 0 for reflink and bit 1 for cowextszhint.  Well, I'll
move them up by one.

"cowextszhint"... in which language is that a word? ;)

--D

> +
> +/*
>   * Inode number format:
>   * low inopblog bits - offset in block
>   * next agblklog bits - block number in ag
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ca9ca5a..8929908 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -610,7 +610,9 @@ __xfs_iflock(
>  
>  STATIC uint
>  _xfs_dic2xflags(
> -	__uint16_t		di_flags)
> +	__uint16_t		di_flags,
> +	uint64_t		di_flags2,
> +	bool			has_attr)
>  {
>  	uint			flags = 0;
>  
> @@ -645,25 +647,32 @@ _xfs_dic2xflags(
>  			flags |= FS_XFLAG_FILESTREAM;
>  	}
>  
> +	if (di_flags2 & XFS_DIFLAG2_ANY) {
> +		if (di_flags2 & XFS_DIFLAG2_DAX)
> +			flags |= FS_XFLAG_DAX;
> +	}
> +
> +	if (has_attr)
> +		flags |= FS_XFLAG_HASATTR;
> +
>  	return flags;
>  }
>  
>  uint
>  xfs_ip2xflags(
> -	xfs_inode_t		*ip)
> +	struct xfs_inode	*ip)
>  {
> -	xfs_icdinode_t		*dic = &ip->i_d;
> +	struct xfs_icdinode	*dic = &ip->i_d;
>  
> -	return _xfs_dic2xflags(dic->di_flags) |
> -				(XFS_IFORK_Q(ip) ? FS_XFLAG_HASATTR : 0);
> +	return _xfs_dic2xflags(dic->di_flags, dic->di_flags2, XFS_IFORK_Q(ip));
>  }
>  
>  uint
>  xfs_dic2xflags(
> -	xfs_dinode_t		*dip)
> +	struct xfs_dinode	*dip)
>  {
> -	return _xfs_dic2xflags(be16_to_cpu(dip->di_flags)) |
> -				(XFS_DFORK_Q(dip) ? FS_XFLAG_HASATTR : 0);
> +	return _xfs_dic2xflags(be16_to_cpu(dip->di_flags),
> +				be64_to_cpu(dip->di_flags2), XFS_DFORK_Q(dip));
>  }
>  
>  /*
> @@ -862,7 +871,8 @@ xfs_ialloc(
>  	case S_IFREG:
>  	case S_IFDIR:
>  		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
> -			uint	di_flags = 0;
> +			uint64_t	di_flags2 = 0;
> +			uint		di_flags = 0;
>  
>  			if (S_ISDIR(mode)) {
>  				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
> @@ -898,7 +908,11 @@ xfs_ialloc(
>  				di_flags |= XFS_DIFLAG_NODEFRAG;
>  			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
>  				di_flags |= XFS_DIFLAG_FILESTREAM;
> +			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
> +				di_flags2 |= XFS_DIFLAG2_DAX;
> +
>  			ip->i_d.di_flags |= di_flags;
> +			ip->i_d.di_flags2 |= di_flags2;
>  		}
>  		/* FALLTHROUGH */
>  	case S_IFLNK:
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 94b35eb3..478d04e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -945,6 +945,7 @@ xfs_set_diflags(
>  	unsigned int		xflags)
>  {
>  	unsigned int		di_flags;
> +	uint64_t		di_flags2;
>  
>  	/* can't set PREALLOC this way, just preserve it */
>  	di_flags = (ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
> @@ -977,8 +978,18 @@ xfs_set_diflags(
>  		if (xflags & FS_XFLAG_EXTSIZE)
>  			di_flags |= XFS_DIFLAG_EXTSIZE;
>  	}
> -
>  	ip->i_d.di_flags = di_flags;
> +
> +	/* diflags2 only valid for v3 inodes. */
> +	if (ip->i_d.di_version < 3)
> +		return;
> +
> +	di_flags2 = 0;
> +	if (xflags & FS_XFLAG_DAX)
> +		di_flags2 |= XFS_DIFLAG2_DAX;
> +
> +	ip->i_d.di_flags2 = di_flags2;
> +
>  }
>  
>  STATIC void
> @@ -1004,6 +1015,11 @@ xfs_diflags_to_linux(
>  		inode->i_flags |= S_NOATIME;
>  	else
>  		inode->i_flags &= ~S_NOATIME;
> +	if (xflags & FS_XFLAG_DAX)
> +		inode->i_flags |= S_DAX;
> +	else
> +		inode->i_flags &= ~S_DAX;
> +
>  }
>  
>  static int
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 245268a..a1b8af1 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1201,8 +1201,8 @@ xfs_diflags_to_iflags(
>  		inode->i_flags |= S_SYNC;
>  	if (flags & XFS_DIFLAG_NOATIME)
>  		inode->i_flags |= S_NOATIME;
> -	/* XXX: Also needs an on-disk per inode flag! */
> -	if (ip->i_mount->m_flags & XFS_MOUNT_DAX)
> +	if (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
> +	    ip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
>  		inode->i_flags |= S_DAX;
>  }
>  
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index df175dd..4cad4c8 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -138,6 +138,7 @@ struct fsxattr {
>  #define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
>  #define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
>  #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
> +#define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
>  #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>  
>  /* the read-only stuff doesn't really belong here, but any other place is
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
