Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751898AbdGGMBl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jul 2017 08:01:41 -0400
Date: Fri, 7 Jul 2017 08:01:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: rename MAXPATHLEN to XFS_SYMLINK_MAXLEN
Message-ID: <20170707120127.GA61756@bfoster.bfoster>
References: <20170707032958.GB4103@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170707032958.GB4103@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Jul 06, 2017 at 08:29:58PM -0700, Darrick J. Wong wrote:
> XFS has a maximum symlink target length of 1024 bytes; this is a
> holdover from the Irix days.  Unfortunately, the constant establishing
> this is 'MAXPATHLEN' and is /not/ the same as the Linux MAXPATHLEN,
> which is 4096.
> 
> The kernel enforces its 1024 byte MAXPATHLEN on symlink targets, but
> xfsprogs picks up the (Linux) system 4096 byte MAXPATHLEN, which means
> that xfs_repair doesn't complain about oversized symlinks.
> 
> Since this is an on-disk format constraint, put the define in the XFS
> namespace and move everything over to use the new name.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_format.h         |    1 +
>  fs/xfs/libxfs/xfs_symlink_remote.c |    2 +-
>  fs/xfs/libxfs/xfs_trans_resv.c     |    4 ++--
>  fs/xfs/xfs_iops.c                  |    2 +-
>  fs/xfs/xfs_linux.h                 |    1 -
>  fs/xfs/xfs_symlink.c               |    6 +++---
>  6 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index e204a94..23229f0 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1211,6 +1211,7 @@ struct xfs_dsymlink_hdr {
>  
>  #define XFS_SYMLINK_CRC_OFF	offsetof(struct xfs_dsymlink_hdr, sl_crc)
>  
> +#define XFS_SYMLINK_MAXLEN	1024
>  /*
>   * The maximum pathlen is 1024 bytes. Since the minimum file system
>   * blocksize is 512 bytes, we can get a max of 3 extents back from
> diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> index 2e2c671..c484877 100644
> --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> @@ -114,7 +114,7 @@ xfs_symlink_verify(
>  	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
>  		return false;
>  	if (be32_to_cpu(dsl->sl_offset) +
> -				be32_to_cpu(dsl->sl_bytes) >= MAXPATHLEN)
> +				be32_to_cpu(dsl->sl_bytes) >= XFS_SYMLINK_MAXLEN)
>  		return false;
>  	if (dsl->sl_owner == 0)
>  		return false;
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index b456cca..6bd916b 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -477,14 +477,14 @@ xfs_calc_mkdir_reservation(
>  /*
>   * Making a new symplink is the same as creating a new file, but
>   * with the added blocks for remote symlink data which can be up to 1kB in
> - * length (MAXPATHLEN).
> + * length (XFS_SYMLINK_MAXLEN).
>   */
>  STATIC uint
>  xfs_calc_symlink_reservation(
>  	struct xfs_mount	*mp)
>  {
>  	return xfs_calc_create_reservation(mp) +
> -	       xfs_calc_buf_res(1, MAXPATHLEN);
> +	       xfs_calc_buf_res(1, XFS_SYMLINK_MAXLEN);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 077e2b2..469c9fa 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -460,7 +460,7 @@ xfs_vn_get_link(
>  	if (!dentry)
>  		return ERR_PTR(-ECHILD);
>  
> -	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
> +	link = kmalloc(XFS_SYMLINK_MAXLEN+1, GFP_KERNEL);
>  	if (!link)
>  		goto out_err;
>  
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index ecdae42..44abaec 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -143,7 +143,6 @@ typedef __u32			xfs_nlink_t;
>  #define __return_address __builtin_return_address(0)
>  
>  #define XFS_PROJID_DEFAULT	0
> -#define MAXPATHLEN	1024
>  
>  #define MIN(a,b)	(min(a,b))
>  #define MAX(a,b)	(max(a,b))
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 49380485..12cd9cf7 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -143,7 +143,7 @@ xfs_readlink(
>  	if (!pathlen)
>  		goto out;
>  
> -	if (pathlen < 0 || pathlen > MAXPATHLEN) {
> +	if (pathlen < 0 || pathlen > XFS_SYMLINK_MAXLEN) {
>  		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
>  			 __func__, (unsigned long long) ip->i_ino,
>  			 (long long) pathlen);
> @@ -202,7 +202,7 @@ xfs_symlink(
>  	 * Check component lengths of the target path name.
>  	 */
>  	pathlen = strlen(target_path);
> -	if (pathlen >= MAXPATHLEN)      /* total string too long */
> +	if (pathlen >= XFS_SYMLINK_MAXLEN)      /* total string too long */
>  		return -ENAMETOOLONG;
>  
>  	udqp = gdqp = NULL;
> @@ -559,7 +559,7 @@ xfs_inactive_symlink(
>  		return 0;
>  	}
>  
> -	if (pathlen < 0 || pathlen > MAXPATHLEN) {
> +	if (pathlen < 0 || pathlen > XFS_SYMLINK_MAXLEN) {
>  		xfs_alert(mp, "%s: inode (0x%llx) bad symlink length (%d)",
>  			 __func__, (unsigned long long)ip->i_ino, pathlen);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
