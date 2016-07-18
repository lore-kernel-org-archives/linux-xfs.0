Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE49B7CA4
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 08:34:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A361F304039
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 06:34:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gQwORE7xNhUW53ej (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jul 2016 06:34:25 -0700 (PDT)
Date: Mon, 18 Jul 2016 09:34:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 046/119] xfs: add rmap btree block detection to log
	recovery
Message-ID: <20160718133423.GE27380@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612656689.12839.658842468753557889.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612656689.12839.658842468753557889.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Thu, Jun 16, 2016 at 06:22:46PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So such blocks can be correctly identified and have their operations
> structutes attached to validate recovery has not resulted in a

  structures					not?

> correct block.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_recover.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index f7f9635..dbfbc26 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2233,6 +2233,7 @@ xlog_recover_get_buf_lsn(
>  	case XFS_ABTC_CRC_MAGIC:
>  	case XFS_ABTB_MAGIC:
>  	case XFS_ABTC_MAGIC:
> +	case XFS_RMAP_CRC_MAGIC:
>  	case XFS_IBT_CRC_MAGIC:
>  	case XFS_IBT_MAGIC: {
>  		struct xfs_btree_block *btb = blk;
> @@ -2401,6 +2402,9 @@ xlog_recover_validate_buf_type(
>  		case XFS_BMAP_MAGIC:
>  			bp->b_ops = &xfs_bmbt_buf_ops;
>  			break;
> +		case XFS_RMAP_CRC_MAGIC:
> +			bp->b_ops = &xfs_rmapbt_buf_ops;
> +			break;
>  		default:
>  			xfs_warn(mp, "Bad btree block magic!");
>  			ASSERT(0);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
