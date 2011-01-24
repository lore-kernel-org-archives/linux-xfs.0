Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0OM2PJf122626 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 16:02:26 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3512B1052DB4
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 14:04:47 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VXO50Mv7Zzth25Zv for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 14:04:47 -0800 (PST)
Date: Tue, 25 Jan 2011 09:04:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_bmap_add_extent_delay_real should set
	br_startblock to nullstartblock
Message-ID: <20110124220444.GE16267@dastard>
References: <20110119174158.28574.63968.stgit@lady3jane.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110119174158.28574.63968.stgit@lady3jane.americas.sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com, aelder@sgi.com

On Wed, Jan 19, 2011 at 11:41:58AM -0600, Ben Myers wrote:
> When filling in the middle of a previous delayed allocation in
> xfs_bmap_add_extent_delay_real, set br_startblock of the new delay extent to
> the right to nullstartblock instead of 0 before inserting the extent into the
> ifork (xfs_iext_insert), rather than setting br_startblock afterward.
> 
> Adding the extent into the ifork with br_startblock=0 can lead to the extent
> being copied into the btree by xfs_bmap_extent_to_btree if we happen to convert
> from extents format to btree format before updating br_startblock with the
> correct value.  The unexpected addition of this delay extent to the btree can
> cause subsequent XFS_WANT_CORRUPTED_GOTO filesystem shutdown in several
> xfs_bmap_add_extent_delay_real cases where we are converting a delay extent to
> real and unexpectedly find an extent already inserted.  For example:
> 
> 911         case BMAP_LEFT_FILLING:
> 912                 /*
> 913                  * Filling in the first part of a previous delayed allocation.
> 914                  * The left neighbor is not contiguous.
> 915                  */
> 916                 trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
> 917                 xfs_bmbt_set_startoff(ep, new_endoff);
> 918                 temp = PREV.br_blockcount - new->br_blockcount;
> 919                 xfs_bmbt_set_blockcount(ep, temp);
> 920                 xfs_iext_insert(ip, idx, 1, new, state);
> 921                 ip->i_df.if_lastex = idx;
> 922                 ip->i_d.di_nextents++;
> 923                 if (cur == NULL)
> 924                         rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> 925                 else {
> 926                         rval = XFS_ILOG_CORE;
> 927                         if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
> 928                                         new->br_startblock, new->br_blockcount,
> 929                                         &i)))
> 930                                 goto done;
> 931                         XFS_WANT_CORRUPTED_GOTO(i == 0, done);
> 
> With the bogus extent in the btree we shutdown the filesystem at 931.  The
> conversion from extents to btree format happens when the number of extents in
> the inode increases above ip->i_df.if_ext_max.  xfs_bmap_extent_to_btree copies
> extents from the ifork into the btree, ignoring all delalloc extents which are
> denoted by br_startblock having some value of nullstartblock.
> 
> SGI-PV: 1013221
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> ---
>  fs/xfs/xfs_bmap.c |   33 +++++++++++++++++++++++++--------
>  1 files changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 4111cd3..c1db779 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -1038,17 +1038,34 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in the middle part of a previous delayed allocation.
>  		 * Contiguity is impossible here.
>  		 * This case is avoided almost all the time.
> +		 *
> +		 * We start with a delayed allocation:
> +		 *
> +		 * +ddddddddddddddddddddddddddddddddddddddddddddddddddddddd+
> +		 *  PREV @ idx
> +		 *
> +	         * and we are allocating:
> +		 *                     +rrrrrrrrrrrrrrrrr+	 
> +		 *			      new
> +		 *
> +		 * and we set it up for insertion as:
> +		 * +ddddddddddddddddddd+rrrrrrrrrrrrrrrrr+ddddddddddddddddd+
> +		 *                            new
> +		 *  PREV @ idx          LEFT              RIGHT
> +		 *                      inserted at idx + 1 
>  		 */
>  		temp = new->br_startoff - PREV.br_startoff;
> -		trace_xfs_bmap_pre_update(ip, idx, 0, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep, temp);
> -		r[0] = *new;
> -		r[1].br_state = PREV.br_state;
> -		r[1].br_startblock = 0;
> -		r[1].br_startoff = new_endoff;
>  		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
> -		r[1].br_blockcount = temp2;
> -		xfs_iext_insert(ip, idx + 1, 2, &r[0], state);
> +		trace_xfs_bmap_pre_update(ip, idx, 0, _THIS_IP_);
> +		xfs_bmbt_set_blockcount(ep, temp);	/* truncate PREV */
> +		LEFT = *new;
> +		RIGHT.br_state = PREV.br_state;	
> +		RIGHT.br_startblock = nullstartblock(
> +				(int)xfs_bmap_worst_indlen(ip, temp2));
> +		RIGHT.br_startoff = new_endoff;
> +		RIGHT.br_blockcount = temp2;
> +		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
> +		xfs_iext_insert(ip, idx + 1, 2, &LEFT, state);
>  		ip->i_df.if_lastex = idx + 1;
>  		ip->i_d.di_nextents++;
>  		if (cur == NULL)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
