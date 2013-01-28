Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B0CA7F4C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 08:09:42 -0600 (CST)
Message-ID: <510686A9.3080600@sgi.com>
Date: Mon, 28 Jan 2013 08:09:45 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] xfsprogs: sync xfs_calc_buf_res() to the user space
References: <51067F4B.8000605@oracle.com>
In-Reply-To: <51067F4B.8000605@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On 01/28/13 07:38, Jeff Liu wrote:
> Sync the new helper xfs_calc_buf_res() to the user space.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---
>   libxfs/xfs_trans.c |   29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
>
> diff --git a/libxfs/xfs_trans.c b/libxfs/xfs_trans.c
> index 635de8f..d7ff1a9 100644
> --- a/libxfs/xfs_trans.c
> +++ b/libxfs/xfs_trans.c
> @@ -23,6 +23,35 @@ kmem_zone_t	*xfs_trans_zone;
>   kmem_zone_t	*xfs_log_item_desc_zone;
>
>   /*
> + * A buffer has a format structure overhead in the log in addition
> + * to the data, so we need to take this into account when reserving
> + * space in a transaction for a buffer.  Round the space required up
> + * to a multiple of 128 bytes so that we don't change the historical
> + * reservation that has been used for this overhead.
> + */
> +STATIC uint
> +xfs_buf_log_overhead(void)
> +{
> +	return round_up(sizeof(struct xlog_op_header) +
> +			sizeof(struct xfs_buf_log_format), 128);
> +}
> +
> +/*
> + * Calculate out transaction log reservation per item in bytes.
> + *
> + * The nbufs argument is used to indicate the number of items that
> + * will be changed in a transaction.  size is used to tell how many
> + * bytes should be reserved per item.
> + */
> +STATIC uint
> +xfs_calc_buf_res(
> +	uint		nbufs,
> +	uint		size)
> +{
> +	return nbufs * (size + xfs_buf_log_overhead());
> +}
> +
> +/*
>    * Various log reservation values.
>    *
>    * These are based on the size of the file system block because that is what

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
