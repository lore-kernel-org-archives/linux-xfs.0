Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Nov 2006 17:21:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAB1LVaG004456
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 17:21:34 -0800
Date: Sat, 11 Nov 2006 11:22:13 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH] remove old irix log replay cases
Message-ID: <1F3EC1BE248F9904011855D2@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20061019020125.25D9718D90452@sandeen.net>
References: <20061019020125.25D9718D90452@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sandeen@sandeen.net, xfs@oss.sgi.com

Hi Eric,

--On 18 October 2006 9:01:25 PM -0500 sandeen@sandeen.net wrote:

> I think the irix 5.3 and 6.1 log handling can go, since linux
> refuses outright to do anything with irix-style logs, no?
>
Yep this stuff can go.
Could go on IRIX too :)

> The remaining single-case switch statements might be a little
> odd, but I suppose that they still show there's flexibility
> for log format...
Fine.

>
> Maybe the #defines could stay, or at least as comments, for
> hysterical raisins...
Get rid of 'em I say.

Thanks,
--Tim

>
> -Eric
>
>  xfs_buf_item.h    |   18 ----------------
>  xfs_log_recover.c |   58 +-----------------------------------------------------
>  xfs_trans.h       |    4 ---
>  3 files changed, 3 insertions(+), 77 deletions(-)
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>
> Index: xfs-linux-allpatches/xfs_buf_item.h
> ===================================================================
> --- xfs-linux-allpatches.orig/xfs_buf_item.h
> +++ xfs-linux-allpatches/xfs_buf_item.h
> @@ -21,23 +21,7 @@
>  /*
>   * This is the structure used to lay out a buf log item in the
>   * log.  The data map describes which 128 byte chunks of the buffer
> - * have been logged.  This structure works only on buffers that
> - * reside up to the first TB in the filesystem.  These buffers are
> - * generated only by pre-6.2 systems and are known as XFS_LI_6_1_BUF.
> - */
> -typedef struct xfs_buf_log_format_v1 {
> -	unsigned short	blf_type;	/* buf log item type indicator */
> -	unsigned short	blf_size;	/* size of this item */
> -	__int32_t	blf_blkno;	/* starting blkno of this buf */
> -	ushort		blf_flags;	/* misc state */
> -	ushort		blf_len;	/* number of blocks in this buf */
> -	unsigned int	blf_map_size;	/* size of data bitmap in words */
> -	unsigned int	blf_data_map[1];/* variable size bitmap of */
> -					/*   regions of buffer in this item */
> -} xfs_buf_log_format_v1_t;
> -
> -/*
> - * This is a form of the above structure with a 64 bit blkno field.
> + * have been logged.
>   * For 6.2 and beyond, this is XFS_LI_BUF.  We use this to log everything.
>   */
>  typedef struct xfs_buf_log_format_t {
> Index: xfs-linux-allpatches/xfs_log_recover.c
> ===================================================================
> --- xfs-linux-allpatches.orig/xfs_log_recover.c
> +++ xfs-linux-allpatches/xfs_log_recover.c
> @@ -1514,7 +1514,6 @@ xlog_recover_reorder_trans(
>  {
>  	xlog_recover_item_t	*first_item, *itemq, *itemq_next;
>  	xfs_buf_log_format_t	*buf_f;
> -	xfs_buf_log_format_v1_t	*obuf_f;
>  	ushort			flags = 0;
>
>  	first_item = itemq = trans->r_itemq;
> @@ -1522,29 +1521,16 @@ xlog_recover_reorder_trans(
>  	do {
>  		itemq_next = itemq->ri_next;
>  		buf_f = (xfs_buf_log_format_t *)itemq->ri_buf[0].i_addr;
> -		switch (ITEM_TYPE(itemq)) {
> -		case XFS_LI_BUF:
> -			flags = buf_f->blf_flags;
> -			break;
> -		case XFS_LI_6_1_BUF:
> -		case XFS_LI_5_3_BUF:
> -			obuf_f = (xfs_buf_log_format_v1_t*)buf_f;
> -			flags = obuf_f->blf_flags;
> -			break;
> -		}
>
>  		switch (ITEM_TYPE(itemq)) {
>  		case XFS_LI_BUF:
> -		case XFS_LI_6_1_BUF:
> -		case XFS_LI_5_3_BUF:
> +			flags = buf_f->blf_flags;
>  			if (!(flags & XFS_BLI_CANCEL)) {
>  				xlog_recover_insert_item_frontq(&trans->r_itemq,
>  								itemq);
>  				break;
>  			}
>  		case XFS_LI_INODE:
> -		case XFS_LI_6_1_INODE:
> -		case XFS_LI_5_3_INODE:
>  		case XFS_LI_DQUOT:
>  		case XFS_LI_QUOTAOFF:
>  		case XFS_LI_EFD:
> @@ -1583,7 +1569,6 @@ xlog_recover_do_buffer_pass1(
>  	xfs_buf_cancel_t	*nextp;
>  	xfs_buf_cancel_t	*prevp;
>  	xfs_buf_cancel_t	**bucket;
> -	xfs_buf_log_format_v1_t	*obuf_f;
>  	xfs_daddr_t		blkno = 0;
>  	uint			len = 0;
>  	ushort			flags = 0;
> @@ -1594,13 +1579,6 @@ xlog_recover_do_buffer_pass1(
>  		len = buf_f->blf_len;
>  		flags = buf_f->blf_flags;
>  		break;
> -	case XFS_LI_6_1_BUF:
> -	case XFS_LI_5_3_BUF:
> -		obuf_f = (xfs_buf_log_format_v1_t*)buf_f;
> -		blkno = (xfs_daddr_t) obuf_f->blf_blkno;
> -		len = obuf_f->blf_len;
> -		flags = obuf_f->blf_flags;
> -		break;
>  	}
>
>  	/*
> @@ -1746,7 +1724,6 @@ xlog_recover_do_buffer_pass2(
>  	xlog_t			*log,
>  	xfs_buf_log_format_t	*buf_f)
>  {
> -	xfs_buf_log_format_v1_t	*obuf_f;
>  	xfs_daddr_t		blkno = 0;
>  	ushort			flags = 0;
>  	uint			len = 0;
> @@ -1757,13 +1734,6 @@ xlog_recover_do_buffer_pass2(
>  		flags = buf_f->blf_flags;
>  		len = buf_f->blf_len;
>  		break;
> -	case XFS_LI_6_1_BUF:
> -	case XFS_LI_5_3_BUF:
> -		obuf_f = (xfs_buf_log_format_v1_t*)buf_f;
> -		blkno = (xfs_daddr_t) obuf_f->blf_blkno;
> -		flags = obuf_f->blf_flags;
> -		len = (xfs_daddr_t) obuf_f->blf_len;
> -		break;
>  	}
>
>  	return xlog_check_buffer_cancelled(log, blkno, len, flags);
> @@ -1799,7 +1769,6 @@ xlog_recover_do_inode_buffer(
>  	int			inodes_per_buf;
>  	xfs_agino_t		*logged_nextp;
>  	xfs_agino_t		*buffer_nextp;
> -	xfs_buf_log_format_v1_t	*obuf_f;
>  	unsigned int		*data_map = NULL;
>  	unsigned int		map_size = 0;
>
> @@ -1808,12 +1777,6 @@ xlog_recover_do_inode_buffer(
>  		data_map = buf_f->blf_data_map;
>  		map_size = buf_f->blf_map_size;
>  		break;
> -	case XFS_LI_6_1_BUF:
> -	case XFS_LI_5_3_BUF:
> -		obuf_f = (xfs_buf_log_format_v1_t*)buf_f;
> -		data_map = obuf_f->blf_data_map;
> -		map_size = obuf_f->blf_map_size;
> -		break;
>  	}
>  	/*
>  	 * Set the variables corresponding to the current region to
> @@ -1912,7 +1875,6 @@ xlog_recover_do_reg_buffer(
>  	int			i;
>  	int			bit;
>  	int			nbits;
> -	xfs_buf_log_format_v1_t	*obuf_f;
>  	unsigned int		*data_map = NULL;
>  	unsigned int		map_size = 0;
>  	int                     error;
> @@ -1922,12 +1884,6 @@ xlog_recover_do_reg_buffer(
>  		data_map = buf_f->blf_data_map;
>  		map_size = buf_f->blf_map_size;
>  		break;
> -	case XFS_LI_6_1_BUF:
> -	case XFS_LI_5_3_BUF:
> -		obuf_f = (xfs_buf_log_format_v1_t*)buf_f;
> -		data_map = obuf_f->blf_data_map;
> -		map_size = obuf_f->blf_map_size;
> -		break;
>  	}
>  	bit = 0;
>  	i = 1;  /* 0 is the buf format structure */
> @@ -2160,7 +2116,6 @@ xlog_recover_do_buffer_trans(
>  	int			pass)
>  {
>  	xfs_buf_log_format_t	*buf_f;
> -	xfs_buf_log_format_v1_t	*obuf_f;
>  	xfs_mount_t		*mp;
>  	xfs_buf_t		*bp;
>  	int			error;
> @@ -2197,13 +2152,6 @@ xlog_recover_do_buffer_trans(
>  		len = buf_f->blf_len;
>  		flags = buf_f->blf_flags;
>  		break;
> -	case XFS_LI_6_1_BUF:
> -	case XFS_LI_5_3_BUF:
> -		obuf_f = (xfs_buf_log_format_v1_t*)buf_f;
> -		blkno = obuf_f->blf_blkno;
> -		len = obuf_f->blf_len;
> -		flags = obuf_f->blf_flags;
> -		break;
>  	default:
>  		xfs_fs_cmn_err(CE_ALERT, log->l_mp,
>  			"xfs_log_recover: unknown buffer type 0x%x, logdev %s",
> @@ -2830,9 +2778,7 @@ xlog_recover_do_trans(
>  		 * where xfs_daddr_t is 32-bits but mount will warn us
>  		 * off a > 1 TB filesystem before we get here.
>  		 */
> -		if ((ITEM_TYPE(item) == XFS_LI_BUF) ||
> -		    (ITEM_TYPE(item) == XFS_LI_6_1_BUF) ||
> -		    (ITEM_TYPE(item) == XFS_LI_5_3_BUF)) {
> +		if ((ITEM_TYPE(item) == XFS_LI_BUF)) {
>  			if  ((error = xlog_recover_do_buffer_trans(log, item,
>  								 pass)))
>  				break;
> Index: xfs-linux-allpatches/xfs_trans.h
> ===================================================================
> --- xfs-linux-allpatches.orig/xfs_trans.h
> +++ xfs-linux-allpatches/xfs_trans.h
> @@ -39,13 +39,9 @@ typedef struct xfs_trans_header {
>  /*
>   * Log item types.
>   */
> -#define	XFS_LI_5_3_BUF		0x1234	/* v1 bufs, 1-block inode buffers */
> -#define	XFS_LI_5_3_INODE	0x1235	/* 1-block inode buffers */
>  #define	XFS_LI_EFI		0x1236
>  #define	XFS_LI_EFD		0x1237
>  #define	XFS_LI_IUNLINK		0x1238
> -#define	XFS_LI_6_1_INODE	0x1239	/* 4K non-aligned inode bufs */
> -#define	XFS_LI_6_1_BUF		0x123a	/* v1, 4K inode buffers */
>  #define	XFS_LI_INODE		0x123b	/* aligned ino chunks, var-size ibufs */
>  #define	XFS_LI_BUF		0x123c	/* v2 bufs, variable sized inode bufs */
>  #define	XFS_LI_DQUOT		0x123d
>
