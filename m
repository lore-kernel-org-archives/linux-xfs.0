Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31251 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752112AbcLWVC0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Dec 2016 16:02:26 -0500
Date: Fri, 23 Dec 2016 13:01:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4] xfs: fix the size of xfs_mode_to_ftype table
Message-ID: <20161223210110.GC12622@birch.djwong.org>
References: <1482343293-9028-1-git-send-email-amir73il@gmail.com>
 <1482440841-10819-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482440841-10819-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Dec 22, 2016 at 11:07:21PM +0200, Amir Goldstein wrote:
> Fix the size of the xfs_mode_to_ftype conversion table,
> which was too small to handle a malformed on-disk value
> of mode=S_IFMT.
> 
> Use a convenience macros S_DT(mode) to convert from
> mode to dirent file type and change the name of the table
> to xfs_dtype_to_ftype to correctly describe its index values.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_dir2.c | 17 ++++++++---------
>  fs/xfs/libxfs/xfs_dir2.h |  4 +++-
>  fs/xfs/xfs_iops.c        |  2 +-
>  3 files changed, 12 insertions(+), 11 deletions(-)
> 
> Darrick,
> 
> So my holiday season cleanup is now down to this one patch.
> I pulled back the common code and added the needed macros in
> xfs code, so this can be safely applied to xfsprogs as well.
> I will send a patch to xfsprogs later.
> 
> Tested with generic/396 with -n ftype=0|1.

Hm... the 396 test looks ok, but I think we'd need a fs-specific
testcase to go write a corrupt i_mode = S_IFMT filesystem to try
to trigger the verifiers, right?

> Amir.
> 
> v4:
> - independent fix patch for xfs
> 
> v3:
> - resort to simpler cleanup with macros DT_MAX and S_DT()
> - mention the minor bug fix in commit message
> 
> v2:
> - add private conversion from common to on-disk values
> 
> v1:
> - use common conversion functions to get on-disk values
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index c58d72c..539f498 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -41,15 +41,14 @@ struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
>   * for file type specification. This will be propagated into the directory
>   * structure if appropriate for the given operation and filesystem config.
>   */
> -const unsigned char xfs_mode_to_ftype[S_IFMT >> S_SHIFT] = {
> -	[0]			= XFS_DIR3_FT_UNKNOWN,
> -	[S_IFREG >> S_SHIFT]    = XFS_DIR3_FT_REG_FILE,
> -	[S_IFDIR >> S_SHIFT]    = XFS_DIR3_FT_DIR,
> -	[S_IFCHR >> S_SHIFT]    = XFS_DIR3_FT_CHRDEV,
> -	[S_IFBLK >> S_SHIFT]    = XFS_DIR3_FT_BLKDEV,
> -	[S_IFIFO >> S_SHIFT]    = XFS_DIR3_FT_FIFO,
> -	[S_IFSOCK >> S_SHIFT]   = XFS_DIR3_FT_SOCK,
> -	[S_IFLNK >> S_SHIFT]    = XFS_DIR3_FT_SYMLINK,
> +const unsigned char xfs_dtype_to_ftype[S_DT_MAX] = {
> +	[DT_REG]    = XFS_DIR3_FT_REG_FILE,
> +	[DT_DIR]    = XFS_DIR3_FT_DIR,
> +	[DT_CHR]    = XFS_DIR3_FT_CHRDEV,
> +	[DT_BLK]    = XFS_DIR3_FT_BLKDEV,
> +	[DT_FIFO]   = XFS_DIR3_FT_FIFO,
> +	[DT_SOCK]   = XFS_DIR3_FT_SOCK,
> +	[DT_LNK]    = XFS_DIR3_FT_SYMLINK,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 0197590..a069c3e 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -35,7 +35,9 @@ extern struct xfs_name	xfs_name_dotdot;
>   * directory filetype conversion tables.
>   */
>  #define S_SHIFT 12
> -extern const unsigned char xfs_mode_to_ftype[];
> +#define S_DT(mode)     (((mode) & S_IFMT) >> S_SHIFT)
> +#define S_DT_MAX       (S_DT(S_IFMT) + 1)
> +extern const unsigned char xfs_dtype_to_ftype[];
>  
>  /*
>   * directory operations vector for encode/decode routines
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 308bebb..d2da9ca 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -103,7 +103,7 @@ xfs_dentry_to_name(
>  {
>  	namep->name = dentry->d_name.name;
>  	namep->len = dentry->d_name.len;
> -	namep->type = xfs_mode_to_ftype[(mode & S_IFMT) >> S_SHIFT];
> +	namep->type = xfs_dtype_to_ftype[S_DT(mode)];

So I think your concern here is that we could read a inode in from disk
that has an invalid i_mode such that we'd overflow xfs_mode_to_ftype
when trying to set the dirent ftype while linking the inode into a
directory, correct?

In that case, xfs_iread calls xfs_iformat_fork as part of pulling the
inode in off disk, and xfs_iformat_fork validates that the S_IFMT part
of i_mode actually corresponds to a known inode type and sends back 
-EFSCORRUPTED if not.

I think that checking suffices to handle this.  I prefer that we look
for invalid on-disk metadata and prevent it from being loaded into
memory at all, rather than try to catch all the problems that happen as
a result of insufficient validation.

--D

>  }
>  
>  STATIC void
> -- 
> 2.7.4
> 
