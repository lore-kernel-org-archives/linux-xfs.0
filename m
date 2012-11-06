Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6M9Irr093234 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 16:09:19 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IWNrnPgt2hQYJcVA for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 14:11:14 -0800 (PST)
Date: Wed, 7 Nov 2012 09:11:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 06/10] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
Message-ID: <20121106221111.GF24575@dastard>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352213447-59791-7-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352213447-59791-7-git-send-email-bfoster@redhat.com>
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

On Tue, Nov 06, 2012 at 09:50:43AM -0500, Brian Foster wrote:
> The XFS_IOC_FREE_EOFBLOCKS ioctl allows users to invoke an EOFBLOCKS
> scan. The xfs_eofblocks structure is defined to support the command
> parameters (scan mode).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_fs.h     |   17 +++++++++++++++++
>  fs/xfs/xfs_icache.c |   10 +++++++---
>  fs/xfs/xfs_icache.h |    2 +-
>  fs/xfs/xfs_ioctl.c  |   20 ++++++++++++++++++++
>  4 files changed, 45 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index c13fed8..26ff43a 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -339,6 +339,22 @@ typedef struct xfs_error_injection {
>  
>  
>  /*
> + * Speculative preallocation trimming.
> + */
> +#define XFS_EOFBLOCKS_VERSION		1
> +struct xfs_eofblocks {
> +	__u32		eof_version;
> +	__u32		eof_flags;
> +	__u64		pad[15];
> +};
> +
> +/* eof_flags values */
> +#define XFS_EOF_FLAGS_SYNC		(1 << 0) /* sync/wait mode scan */
> +#define XFS_EOF_FLAGS_VALID	\
> +	(XFS_EOF_FLAGS_SYNC)
> +
> +
> +/*
>   * The user-level Handle Request interface structure.
>   */
>  typedef struct xfs_fsop_handlereq {
> @@ -456,6 +472,7 @@ typedef struct xfs_handle {
>  /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
>  #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
>  #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
> +#define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_eofblocks)
>  
>  /*
>   * ioctl commands that replace IRIX syssgi()'s
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index b02a3df..d0d9273 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1206,11 +1206,15 @@ xfs_inode_free_eofblocks(
>  int
>  xfs_icache_free_eofblocks(
>  	struct xfs_mount	*mp,
> -	int			flags)
> +	struct xfs_eofblocks	*eofb)
>  {
> -	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
> +	int flags = SYNC_TRYLOCK;
> +
> +	if (eofb && eofb->eof_flags & XFS_EOF_FLAGS_SYNC)

gcc will throw a warning about that.

	if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC))

Apart from that, looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
