Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F5BB7F78
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 16:07:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F783304048
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 14:07:53 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id s49FTIhC8DTV33EQ for <xfs@oss.sgi.com>;
	Tue, 07 Apr 2015 14:07:52 -0700 (PDT)
Date: Tue, 7 Apr 2015 17:07:47 -0400
Subject: Re: [PATCH] xfs: unlock i_mutex in xfs_break_layouts
Message-ID: <20150407210747.GD3363@fieldses.org>
References: <1428420944-20965-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428420944-20965-1-git-send-email-hch@lst.de>
From: bfields@fieldses.org (J. Bruce Fields)
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nfs@vger.kernel.org, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Tue, Apr 07, 2015 at 05:35:44PM +0200, Christoph Hellwig wrote:
> We want to drop all I/O path locks when recalling layouts, and that includes
> i_mutex for the write path.  Without this we get stuck processe when recalls
> take too long.

Also if the writer is an nfsd thread than we'd rather just error out
than wait.

--b.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c  | 4 ++--
>  fs/xfs/xfs_ioctl.c | 2 +-
>  fs/xfs/xfs_iops.c  | 2 +-
>  fs/xfs/xfs_pnfs.c  | 7 ++++++-
>  fs/xfs/xfs_pnfs.h  | 2 +-
>  5 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a2e1cb8..963dfb2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -559,7 +559,7 @@ restart:
>  	if (error)
>  		return error;
>  
> -	error = xfs_break_layouts(inode, iolock);
> +	error = xfs_break_layouts(inode, iolock, true);
>  	if (error)
>  		return error;
>  
> @@ -843,7 +843,7 @@ xfs_file_fallocate(
>  		return -EOPNOTSUPP;
>  
>  	xfs_ilock(ip, iolock);
> -	error = xfs_break_layouts(inode, &iolock);
> +	error = xfs_break_layouts(inode, &iolock, false);
>  	if (error)
>  		goto out_unlock;
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index ac4feae..3a21cc7 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -639,7 +639,7 @@ xfs_ioc_space(
>  		return error;
>  
>  	xfs_ilock(ip, iolock);
> -	error = xfs_break_layouts(inode, &iolock);
> +	error = xfs_break_layouts(inode, &iolock, false);
>  	if (error)
>  		goto out_unlock;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index e53a903..79520c7 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -975,7 +975,7 @@ xfs_vn_setattr(
>  		uint		iolock = XFS_IOLOCK_EXCL;
>  
>  		xfs_ilock(ip, iolock);
> -		error = xfs_break_layouts(dentry->d_inode, &iolock);
> +		error = xfs_break_layouts(dentry->d_inode, &iolock, true);
>  		if (!error)
>  			error = xfs_setattr_size(ip, iattr);
>  		xfs_iunlock(ip, iolock);
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 365dd57..981a657 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -31,7 +31,8 @@
>  int
>  xfs_break_layouts(
>  	struct inode		*inode,
> -	uint			*iolock)
> +	uint			*iolock,
> +	bool			with_imutex)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
> @@ -40,8 +41,12 @@ xfs_break_layouts(
>  
>  	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
>  		xfs_iunlock(ip, *iolock);
> +		if (with_imutex && (*iolock & XFS_IOLOCK_EXCL))
> +			mutex_unlock(&inode->i_mutex);
>  		error = break_layout(inode, true);
>  		*iolock = XFS_IOLOCK_EXCL;
> +		if (with_imutex)
> +			mutex_lock(&inode->i_mutex);
>  		xfs_ilock(ip, *iolock);
>  	}
>  
> diff --git a/fs/xfs/xfs_pnfs.h b/fs/xfs/xfs_pnfs.h
> index b7fbfce..f749475 100644
> --- a/fs/xfs/xfs_pnfs.h
> +++ b/fs/xfs/xfs_pnfs.h
> @@ -8,7 +8,7 @@ int xfs_fs_map_blocks(struct inode *inode, loff_t offset, u64 length,
>  int xfs_fs_commit_blocks(struct inode *inode, struct iomap *maps, int nr_maps,
>  		struct iattr *iattr);
>  
> -int xfs_break_layouts(struct inode *inode, uint *iolock);
> +int xfs_break_layouts(struct inode *inode, uint *iolock, bool with_imutex);
>  #else
>  static inline int xfs_break_layouts(struct inode *inode, uint *iolock)
>  {
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
