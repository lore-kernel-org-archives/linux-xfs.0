Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S7OXLG198271 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 02:24:33 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EHxuTOpCxA3LdFo8 for <xfs@oss.sgi.com>;
	Fri, 28 Sep 2012 00:25:52 -0700 (PDT)
Date: Fri, 28 Sep 2012 17:25:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 6/8] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
Message-ID: <20120928072550.GK25626@dastard>
References: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
	<1348767952-24229-7-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348767952-24229-7-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 27, 2012 at 01:45:50PM -0400, Brian Foster wrote:
> The XFS_IOC_FREE_EOFBLOCKS ioctl allows users to invoke an EOFBLOCKS
> scan. The xfs_eofblocks structure is defined to support the command
> parameters (scan mode).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_fs.h    |   14 ++++++++++++++
>  fs/xfs/xfs_ioctl.c |   12 ++++++++++++
>  2 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index c13fed8..32bb2e8 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -339,6 +339,19 @@ typedef struct xfs_error_injection {
>  
>  
>  /*
> + * Speculative preallocation trimming.
> + */
> +struct xfs_eofblocks {
> +	__u32		eof_flags;
> +	__s32		version;
        __u32

> +	unsigned char	pad[12];
> +};
> +
> +/* eof_flags values */
> +#define XFS_EOF_FLAGS_FORCE		0x01	/* force/wait mode scan */

Might be better defined as XFS_EOF_FLAGS_SYNC as that is more
consistent with what users see as a blocking operation that waits
for completion to occur.

Also, you need to define the structure version here as well (i.e. v1).

> +
> +
> +/*
>   * The user-level Handle Request interface structure.
>   */
>  typedef struct xfs_fsop_handlereq {
> @@ -456,6 +469,7 @@ typedef struct xfs_handle {
>  /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
>  #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
>  #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
> +#define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_eofblocks)
>  
>  /*
>   * ioctl commands that replace IRIX syssgi()'s
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0e0232c..216ca7a 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1602,6 +1602,18 @@ xfs_file_ioctl(
>  		error = xfs_errortag_clearall(mp, 1);
>  		return -error;
>  
> +	case XFS_IOC_FREE_EOFBLOCKS: {
> +		struct xfs_eofblocks eofb;
> +		int flags;
> +
> +		if (copy_from_user(&eofb, arg, sizeof(eofb)))
> +			return -XFS_ERROR(EFAULT);

And check the version here, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
