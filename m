Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9537B7CA2
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 09:43:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8ECE58F8035
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 07:43:51 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6DfEHmZ4DnEY4GGx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2016 07:43:50 -0800 (PST)
Date: Mon, 25 Jan 2016 10:43:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/8] xfs: move v1 inode conversion to xfs_inode_from_disk
Message-ID: <20160125154348.GD4108@bfoster.bfoster>
References: <1452751765-4420-1-git-send-email-david@fromorbit.com>
	<1452751765-4420-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452751765-4420-5-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Thu, Jan 14, 2016 at 05:09:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So we don't have to carry an di_onlink variable around anymore, move
> the inode conversion from v1 inode format to v2 inode format into
> xfs_inode_from_disk(). This means we can remove the di_onlink fields
> from the struct xfs_icdinode.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_buf.c  | 42 ++++++++++++++++++++----------------------
>  fs/xfs/libxfs/xfs_inode_buf.h  |  1 -
>  fs/xfs/libxfs/xfs_log_format.h |  2 +-
>  fs/xfs/xfs_inode.c             |  2 --
>  fs/xfs/xfs_inode_item.c        |  2 +-
>  5 files changed, 22 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 17ff4e8..8a1b460 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -204,13 +204,25 @@ xfs_inode_from_disk(
>  
>  	to->di_mode = be16_to_cpu(from->di_mode);
>  	to->di_version = from ->di_version;
> +
> +	/*
> +	 * Convert v1 inodes immediately to v2 inode format as this is the
> +	 * minimum inode version format we support in the rest of the code.
> +	 */
> +	if (to->di_version == 1) {
> +		to->di_nlink = be16_to_cpu(from->di_onlink);
> +		to->di_projid_lo = 0;
> +		to->di_projid_hi = 0;
> +		to->di_version = 2;
> +	} else {
> +		to->di_nlink = be32_to_cpu(from->di_nlink);
> +		to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
> +		to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
> +	}
> +
>  	to->di_format = from->di_format;
> -	to->di_onlink = be16_to_cpu(from->di_onlink);
>  	to->di_uid = be32_to_cpu(from->di_uid);
>  	to->di_gid = be32_to_cpu(from->di_gid);
> -	to->di_nlink = be32_to_cpu(from->di_nlink);
> -	to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
> -	to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
>  	to->di_flushiter = be16_to_cpu(from->di_flushiter);
>  
>  	/*
> @@ -256,11 +268,11 @@ xfs_inode_to_disk(
>  	struct inode		*inode = VFS_I(ip);
>  
>  	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> +	to->di_onlink = 0;
>  
>  	to->di_mode = cpu_to_be16(from->di_mode);
>  	to->di_version = from->di_version;
>  	to->di_format = from->di_format;
> -	to->di_onlink = cpu_to_be16(from->di_onlink);
>  	to->di_uid = cpu_to_be32(from->di_uid);
>  	to->di_gid = cpu_to_be32(from->di_gid);
>  	to->di_nlink = cpu_to_be32(from->di_nlink);
> @@ -310,9 +322,9 @@ xfs_log_dinode_to_disk(
>  {
>  	to->di_magic = cpu_to_be16(from->di_magic);
>  	to->di_mode = cpu_to_be16(from->di_mode);
> -	to->di_version = from ->di_version;
> +	to->di_version = from->di_version;
>  	to->di_format = from->di_format;
> -	to->di_onlink = cpu_to_be16(from->di_onlink);
> +	to->di_onlink = 0;
>  	to->di_uid = cpu_to_be32(from->di_uid);
>  	to->di_gid = cpu_to_be32(from->di_gid);
>  	to->di_nlink = cpu_to_be32(from->di_nlink);
> @@ -492,21 +504,7 @@ xfs_iread(
>  		ip->i_d.di_mode = 0;
>  	}
>  
> -	/*
> -	 * Automatically convert version 1 inode formats in memory to version 2
> -	 * inode format. If the inode is modified, it will get logged and
> -	 * rewritten as a version 2 inode. We can do this because we set the
> -	 * superblock feature bit for v2 inodes unconditionally during mount
> -	 * and it means the reast of the code can assume the inode version is 2
> -	 * or higher.
> -	 */
> -	if (ip->i_d.di_version == 1) {
> -		ip->i_d.di_version = 2;
> -		ip->i_d.di_nlink = ip->i_d.di_onlink;
> -		ip->i_d.di_onlink = 0;
> -		xfs_set_projid(ip, 0);
> -	}
> -
> +	ASSERT(ip->i_d.di_version >= 2);
>  	ip->i_delayed_blks = 0;
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 69d626e..feb04e6 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -31,7 +31,6 @@ struct xfs_icdinode {
>  	__uint16_t	di_mode;	/* mode and type of file */
>  	__int8_t	di_version;	/* inode version */
>  	__int8_t	di_format;	/* format of di_c data */
> -	__uint16_t	di_onlink;	/* old number of links to file */
>  	__uint16_t	di_flushiter;	/* incremented on flush */
>  	__uint32_t	di_uid;		/* owner's user id */
>  	__uint32_t	di_gid;		/* owner's group id */
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index d00ed63..03f90b9 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -369,7 +369,7 @@ struct xfs_log_dinode {
>  	__uint16_t	di_mode;	/* mode and type of file */
>  	__int8_t	di_version;	/* inode version */
>  	__int8_t	di_format;	/* format of di_c data */
> -	__uint16_t	di_onlink;	/* old number of links to file */
> +	__uint8_t	di_pad3[2];	/* unused in v2/3 inodes */
>  	__uint32_t	di_uid;		/* owner's user id */
>  	__uint32_t	di_gid;		/* owner's group id */
>  	__uint32_t	di_nlink;	/* number of links to file */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3f020b5..914ec41 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -794,9 +794,7 @@ xfs_ialloc(
>  		ip->i_d.di_version = 2;
>  
>  	ip->i_d.di_mode = mode;
> -	ip->i_d.di_onlink = 0;
>  	ip->i_d.di_nlink = nlink;
> -	ASSERT(ip->i_d.di_nlink == nlink);
>  	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
>  	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
>  	xfs_set_projid(ip, prid);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index ae60087..d777b7a 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -336,7 +336,6 @@ xfs_inode_to_log_dinode(
>  	to->di_mode = from->di_mode;
>  	to->di_version = from->di_version;
>  	to->di_format = from->di_format;
> -	to->di_onlink = from->di_onlink;
>  	to->di_uid = from->di_uid;
>  	to->di_gid = from->di_gid;
>  	to->di_nlink = from->di_nlink;
> @@ -344,6 +343,7 @@ xfs_inode_to_log_dinode(
>  	to->di_projid_hi = from->di_projid_hi;
>  
>  	memset(to->di_pad, 0, sizeof(to->di_pad));
> +	memset(to->di_pad3, 0, sizeof(to->di_pad3));
>  	to->di_atime.t_sec = inode->i_atime.tv_sec;
>  	to->di_atime.t_nsec = inode->i_atime.tv_nsec;
>  	to->di_mtime.t_sec = inode->i_mtime.tv_sec;
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
