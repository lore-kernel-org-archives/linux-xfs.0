Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A58C57F4E
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 12:05:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32C11AC009
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 10:05:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rJ1nBTUbV1KLOE3h for
	<xfs@oss.sgi.com>; Wed, 05 Mar 2014 10:05:24 -0800 (PST)
Date: Wed, 5 Mar 2014 11:06:02 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: inode log reservations are still too small
Message-ID: <20140305160555.GB55736@bfoster.bfoster>
References: <1393981893-2497-1-git-send-email-david@fromorbit.com>
	<1393981893-2497-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393981893-2497-3-git-send-email-david@fromorbit.com>
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

On Wed, Mar 05, 2014 at 12:11:33PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Back in commit 23956703 ("xfs: inode log reservations are too
> small"), the reservation size was increased to take into account the
> difference in size between the in-memory BMBT block headers and the
> on-disk BMDR headers. This solved a transaction overrun when logging
> the inode size.
> 
> Recently, however, we've seen a number of these same overruns on
> kernels with the above fix in it. All of them have been by 4 bytes,
> so we must still not be accounting for something correctly.
> 
> Through inspection it turns out the above commit didn't take into
> account everything it should have. That is, it only accounts for a
> single log op_hdr structure, when it can actually require up to four
> op_hdrs - one for each region (log iovec) that is formatted. These
> regions are the inode log format header, the inode core, and the two
> forks that can be held in the literal area of the inode.
> 
> This means we are not accounting for 36 bytes of log space that the
> transaction can use, and hence when we get inodes in certain formats
> with particular fragmentation patterns we can overrun the
> transaction. Fix this by adding the correct accounting for log
> op_headers in the transaction.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

You can add:

Tested-by: Brian Foster <bfoster@redhat.com>

... to Eric's review as well. I'm still throwing a workload at it, but
this has survived a few hours of a reproducer that consistently caused
the overrun in 5-10 seconds. Thanks for catching this.

Brian

>  fs/xfs/xfs_trans_resv.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
> index 8515b04..d2c8e4a 100644
> --- a/fs/xfs/xfs_trans_resv.c
> +++ b/fs/xfs/xfs_trans_resv.c
> @@ -81,20 +81,28 @@ xfs_calc_buf_res(
>   * on disk. Hence we need an inode reservation function that calculates all this
>   * correctly. So, we log:
>   *
> - * - log op headers for object
> + * - 4 log op headers for object
> + *	- for the ilf, the inode core and 2 forks
>   * - inode log format object
> - * - the entire inode contents (core + 2 forks)
> - * - two bmap btree block headers
> + * - the inode core
> + * - two inode forks containing bmap btree root blocks.
> + *	- the btree data contained by both forks will fit into the inode size,
> + *	  hence when combined with the inode core above, we have a total of the
> + *	  actual inode size.
> + *	- the BMBT headers need to be accounted separately, as they are
> + *	  additional to the records and pointers that fit inside the inode
> + *	  forks.
>   */
>  STATIC uint
>  xfs_calc_inode_res(
>  	struct xfs_mount	*mp,
>  	uint			ninodes)
>  {
> -	return ninodes * (sizeof(struct xlog_op_header) +
> -			  sizeof(struct xfs_inode_log_format) +
> -			  mp->m_sb.sb_inodesize +
> -			  2 * XFS_BMBT_BLOCK_LEN(mp));
> +	return ninodes *
> +		(4 * sizeof(struct xlog_op_header) +
> +		 sizeof(struct xfs_inode_log_format) +
> +		 mp->m_sb.sb_inodesize +
> +		 2 * XFS_BMBT_BLOCK_LEN(mp));
>  }
>  
>  /*
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
