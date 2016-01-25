Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0906D7CA5
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 12:25:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7F75304039
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 10:25:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uWAjIzqdNvNheuye (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2016 10:25:10 -0800 (PST)
Date: Mon, 25 Jan 2016 13:25:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/8] xfs: use vfs inode nlink field everywhere
Message-ID: <20160125182508.GA27301@bfoster.bfoster>
References: <1452751765-4420-1-git-send-email-david@fromorbit.com>
	<1452751765-4420-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452751765-4420-6-git-send-email-david@fromorbit.com>
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

On Thu, Jan 14, 2016 at 05:09:22PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The Vfs tracks the inodenlink just like the xfs_icdinode. We can
> remove the variable from the icdinode and use the vfs inode variable
> everywhere, reducing the size of the xfs_icdinode by a further 4
> bytes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  6 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h |  1 -
>  fs/xfs/xfs_inode.c            | 73 ++++++++++++++++++++-----------------------
>  fs/xfs/xfs_inode.h            |  2 --
>  fs/xfs/xfs_inode_item.c       |  2 +-
>  fs/xfs/xfs_iops.c             |  3 +-
>  fs/xfs/xfs_itable.c           |  2 +-
>  fs/xfs/xfs_log_recover.c      |  2 +-
>  8 files changed, 41 insertions(+), 50 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index feb04e6..774d71f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -34,7 +34,6 @@ struct xfs_icdinode {
>  	__uint16_t	di_flushiter;	/* incremented on flush */
>  	__uint32_t	di_uid;		/* owner's user id */
>  	__uint32_t	di_gid;		/* owner's group id */
> -	__uint32_t	di_nlink;	/* number of links to file */
>  	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
>  	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 914ec41..9ee766b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -58,7 +58,7 @@ kmem_zone_t *xfs_inode_zone;
>  #define	XFS_ITRUNC_MAX_EXTENTS	2
>  
>  STATIC int xfs_iflush_int(xfs_inode_t *, xfs_buf_t *);
> -
> +STATIC int xfs_iunlink(xfs_trans_t *, xfs_inode_t *, bool);

Nit:			 (struct xfs_trans *, struct xfs_inode *, ...)

Might as well fix the neighbors as well I suppose.

>  STATIC int xfs_iunlink_remove(xfs_trans_t *, xfs_inode_t *);
>  
>  /*
...
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index b008677..c424d4b 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -455,7 +455,7 @@ xfs_vn_getattr(
>  	stat->size = XFS_ISIZE(ip);
>  	stat->dev = inode->i_sb->s_dev;
>  	stat->mode = ip->i_d.di_mode;
> -	stat->nlink = ip->i_d.di_nlink;
> +	stat->nlink = inode->i_nlink;
>  	stat->uid = inode->i_uid;
>  	stat->gid = inode->i_gid;
>  	stat->ino = ip->i_ino;
> @@ -1212,7 +1212,6 @@ xfs_setup_inode(
>  	hlist_add_fake(&inode->i_hash);
>  
>  	inode->i_mode	= ip->i_d.di_mode;
> -	set_nlink(inode, ip->i_d.di_nlink);
>  	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
>  	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
>  

I'm wondering if we have an issue here if we happen to get an inode
that's reclaimable. E.g., we get an xfs_fs_destroy_inode() call on an
inode and set the reclaimable tag. IIUC, a lookup that occurs after that
point but before we actually reclaim the inode can go through the
associated XFS_IRECLAIMABLE section of xfs_iget_cache_hit(). In there,
we call inode_init_always() which fixes inode->i_nlink = 1.

It looks like we'd call into here (xfs_setup_inode()) since we set
XFS_INEW, and thus previously this would update inode->i_nlink based on
the ip->i_d.di_nlink value, but I don't see where that would happen
now..  hmm?

Brian

> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 2acda42..cfb6527 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -85,7 +85,6 @@ xfs_bulkstat_one_int(
>  	/* xfs_iget returns the following without needing
>  	 * further change.
>  	 */
> -	buf->bs_nlink = dic->di_nlink;
>  	buf->bs_projid_lo = dic->di_projid_lo;
>  	buf->bs_projid_hi = dic->di_projid_hi;
>  	buf->bs_ino = ino;
> @@ -94,6 +93,7 @@ xfs_bulkstat_one_int(
>  	buf->bs_gid = dic->di_gid;
>  	buf->bs_size = dic->di_size;
>  
> +	buf->bs_nlink = inode->i_nlink;
>  	buf->bs_atime.tv_sec = inode->i_atime.tv_sec;
>  	buf->bs_atime.tv_nsec = inode->i_atime.tv_nsec;
>  	buf->bs_mtime.tv_sec = inode->i_mtime.tv_sec;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 4b79cf0..611c25c 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4337,7 +4337,7 @@ xlog_recover_process_one_iunlink(
>  	if (error)
>  		goto fail_iput;
>  
> -	ASSERT(ip->i_d.di_nlink == 0);
> +	ASSERT(VFS_I(ip)->i_nlink == 0);
>  	ASSERT(ip->i_d.di_mode != 0);
>  
>  	/* setup for the next pass */
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
