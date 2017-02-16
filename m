Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54694 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751732AbdBPCnK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 21:43:10 -0500
Subject: Re: [PATCH] libxfs: sync up FSGETXATTR names and definitions with the
 kernel
References: <20170207010447.GJ3580@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e5b709f9-42c3-430b-a62b-8600f5706a04@sandeen.net>
Date: Wed, 15 Feb 2017 20:43:08 -0600
MIME-Version: 1.0
In-Reply-To: <20170207010447.GJ3580@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 2/6/17 7:04 PM, Darrick J. Wong wrote:
> The rest of xfsprogs uses FS_XFLAG values for FSGETXATTR as defined in
> the kernel, so we should do the same in io/cowextsize.c.  Also, move the
> XFS_IOC_FSGETXATTR definition to the same part of xfs_fs.h as the
> kernel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Beauty.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/cowextsize.c |    6 +++---
>  libxfs/xfs_fs.h |    5 ++---
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/io/cowextsize.c b/io/cowextsize.c
> index b4a1c2e..c4cd6de 100644
> --- a/io/cowextsize.c
> +++ b/io/cowextsize.c
> @@ -50,7 +50,7 @@ get_cowextsize(const char *path, int fd)
>  {
>  	struct fsxattr	fsx;
>  
> -	if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
> +	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
>  		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
>  			progname, path, strerror(errno));
>  		return 0;
> @@ -69,7 +69,7 @@ set_cowextsize(const char *path, int fd, long extsz)
>  		perror("fstat64");
>  		return 0;
>  	}
> -	if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
> +	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
>  		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
>  			progname, path, strerror(errno));
>  		return 0;
> @@ -83,7 +83,7 @@ set_cowextsize(const char *path, int fd, long extsz)
>  	}
>  	fsx.fsx_cowextsize = extsz;
>  
> -	if ((xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx)) < 0) {
> +	if ((xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx)) < 0) {
>  		printf("%s: XFS_IOC_FSSETXATTR %s: %s\n",
>  			progname, path, strerror(errno));
>  		return 0;
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index b828853..157e280 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -56,9 +56,6 @@ struct dioattr {
>  #define	XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
>  #define	XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
>  
> -#define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
> -#define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
> -
>  /*
>   * Structure for XFS_IOC_GETBMAP.
>   * On input, fill in bmv_offset and bmv_length of the first structure
> @@ -508,6 +505,8 @@ typedef struct xfs_swapext
>  #define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
>  #define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
>  #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
> +#define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
> +#define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
>  #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
>  #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
>  #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
