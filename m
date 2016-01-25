Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 78F687CAD
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 09:43:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 597C28F8033
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 07:43:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P4bitZiSraTTTmwJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2016 07:43:46 -0800 (PST)
Date: Mon, 25 Jan 2016 10:43:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/8] xfs; cull unnecessary icdinode fields
Message-ID: <20160125154344.GC4108@bfoster.bfoster>
References: <1452751765-4420-1-git-send-email-david@fromorbit.com>
	<1452751765-4420-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452751765-4420-4-git-send-email-david@fromorbit.com>
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

On Thu, Jan 14, 2016 at 05:09:20PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the struct xfs_icdinode is not directly related to the
> on-disk format, we can cull things in it we really don't need to
> store:
> 
> 	- magic number never changes
> 	- padding is not necessary
> 	- next_unlinked is never used
> 	- inode number is redundant
> 	- uuid is redundant
> 	- lsn is accessed directly from dinode
> 	- inode CRC is only accessed directly from dinode
> 
> Hence we can remove these from the struct xfs_icdinode and redirect
> the code that uses them to the xfs_dinode appripriately.  This
> reduces the size of the struct icdinode from 152 bytes to 88 bytes,
> and removes a fair chunk of unnecessary code, too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

A couple nits and a minor potential bug: you have a semicolon in the
subject header rather than a colon...

>  fs/xfs/libxfs/xfs_inode_buf.c | 39 +++++++++++++--------------------------
>  fs/xfs/libxfs/xfs_inode_buf.h | 27 +++++++--------------------
>  fs/xfs/xfs_inode.c            | 19 +------------------
>  fs/xfs/xfs_inode_item.c       | 19 +++++++++++--------
>  4 files changed, 32 insertions(+), 72 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index adcc9bf..69d626e 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -22,24 +22,22 @@ struct xfs_inode;
>  struct xfs_dinode;
>  
>  /*
> - * In memory representation of the XFS inode. This is held in the in-core
> - * struct xfs_inode to represent the on disk values, but no longer needs to be
> - * identical to the on-disk structure as it is always translated to on-disk
> - * format specific structures at the appropriate time.
> + * In memory representation of the XFS inode. This is held in the in-core struct
> + * xfs_inode to represent the on disk values, but it's struct is in no way

Nit:						     its

> + * related to what is stored on disk. That is, this structure is always
> + * translated to on-disk format specific structures at the appropriate time.

FWIW, it might be more clear to say something like: "This is held in the
in-core struct xfs_inode and represents on-disk values, but the
structure is not in on-disk format. In other words, the structure is
always translated to on-disk format specific structures ... "

>   */
>  struct xfs_icdinode {
> -	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
>  	__uint16_t	di_mode;	/* mode and type of file */
>  	__int8_t	di_version;	/* inode version */
>  	__int8_t	di_format;	/* format of di_c data */
>  	__uint16_t	di_onlink;	/* old number of links to file */
> +	__uint16_t	di_flushiter;	/* incremented on flush */
>  	__uint32_t	di_uid;		/* owner's user id */
>  	__uint32_t	di_gid;		/* owner's group id */
>  	__uint32_t	di_nlink;	/* number of links to file */
>  	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
>  	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
> -	__uint8_t	di_pad[6];	/* unused, zeroed space */
> -	__uint16_t	di_flushiter;	/* incremented on flush */
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
...
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 9dcbf58..ae60087 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -325,12 +325,14 @@ xfs_inode_item_format_attr_fork(
>  static void
>  xfs_inode_to_log_dinode(
>  	struct xfs_inode	*ip,
> -	struct xfs_log_dinode	*to)
> +	struct xfs_log_dinode	*to,
> +	xfs_lsn_t		lsn)
>  {
>  	struct xfs_icdinode	*from = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  
> -	to->di_magic = from->di_magic;
> +	to->di_magic = XFS_DINODE_MAGIC;
> +
>  	to->di_mode = from->di_mode;
>  	to->di_version = from->di_version;
>  	to->di_format = from->di_format;
> @@ -340,8 +342,8 @@ xfs_inode_to_log_dinode(
>  	to->di_nlink = from->di_nlink;
>  	to->di_projid_lo = from->di_projid_lo;
>  	to->di_projid_hi = from->di_projid_hi;
> -	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
>  
> +	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	to->di_atime.t_sec = inode->i_atime.tv_sec;
>  	to->di_atime.t_nsec = inode->i_atime.tv_nsec;
>  	to->di_mtime.t_sec = inode->i_mtime.tv_sec;
> @@ -366,10 +368,11 @@ xfs_inode_to_log_dinode(
>  		to->di_crtime.t_sec = from->di_crtime.t_sec;
>  		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
>  		to->di_flags2 = from->di_flags2;
> -		to->di_ino = from->di_ino;
> -		to->di_lsn = from->di_lsn;
> -		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> -		uuid_copy(&to->di_uuid, &from->di_uuid);
> +
> +		to->di_ino = ip->i_ino;
> +		to->di_lsn = lsn;
> +		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> +		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_uuid);

Shouldn't this be sb_meta_uuid?

Brian

>  		to->di_flushiter = 0;
>  	} else {
>  		to->di_flushiter = from->di_flushiter;
> @@ -390,7 +393,7 @@ xfs_inode_item_format_core(
>  	struct xfs_log_dinode	*dic;
>  
>  	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
> -	xfs_inode_to_log_dinode(ip, dic);
> +	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
>  	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
>  }
>  
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
