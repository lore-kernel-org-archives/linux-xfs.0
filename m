Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B5D797F53
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 21:33:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A105304048
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 19:33:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id L9pL2LBp1Fa0VvF5 for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 19:33:23 -0800 (PST)
Message-ID: <53169B02.1030709@sandeen.net>
Date: Tue, 04 Mar 2014 21:33:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: inode log reservations are still too small
References: <1393981893-2497-1-git-send-email-david@fromorbit.com>
	<1393981893-2497-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 3/4/14, 7:11 PM, Dave Chinner wrote:
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

Makes sense to me; 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
