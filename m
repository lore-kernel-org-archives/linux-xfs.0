Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 140017F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 13:26:52 -0500 (CDT)
Date: Tue, 23 Jul 2013 13:26:48 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 03/48] libxfs: add crc format changes to generic btrees
Message-ID: <20130723182648.GI3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-4-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:26AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This patch mostly corresponds to commit ee1a47ab0e, and in some areas it is
equivalent but slightly different.  There are some other things in here too:

* Addition of XFS_BUF_DADDR_NULL
* rename of b_blkno to b_bn in struct xfs_buf
* rename of b_fsprivate to b_fspriv in struct xfs_buf
* addition of uuid_copy and uuid_equal, and libuuid to build

It all looks fine to me, except as below:

>  static void
> @@ -733,13 +760,29 @@ xfs_bmbt_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	xfs_bmbt_verify(bp);
	^^^^^^^^^^^^^^^^^^^^
In commit ee1a47ab0e we removed this call.

> +	if (!(xfs_btree_lblock_verify_crc(bp) &&
> +	      xfs_bmbt_verify(bp))) {
> +		trace_xfs_btree_corrupt(bp, _RET_IP_);
> +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> +				     bp->b_target->bt_mount, bp->b_addr);
> +		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +	}
> +
>  }
>  
>  static void
>  xfs_bmbt_write_verify(
>  	struct xfs_buf	*bp)
>  {
> -	xfs_bmbt_verify(bp);
	^^^^^^^^^^^^^^^^^^^^
As we did here

> +	if (!xfs_bmbt_verify(bp)) {
> +		xfs_warn(bp->b_target->bt_mount, "bmbt daddr 0x%llx failed", bp->b_bn);
> +		trace_xfs_btree_corrupt(bp, _RET_IP_);
> +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> +				     bp->b_target->bt_mount, bp->b_addr);
> +		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		return;
> +	}
> +	xfs_btree_lblock_calc_crc(bp);

Is that addressed later in the series?

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
