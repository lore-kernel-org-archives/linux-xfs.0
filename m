Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0RIo0bK005274 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 12:50:01 -0600
Subject: Re: [PATCH] xfs_bmap_add_extent_delay_real should set
	br_startblock to nullstartblock
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110119174158.28574.63968.stgit@lady3jane.americas.sgi.com>
References: <20110119174158.28574.63968.stgit@lady3jane.americas.sgi.com>
Date: Thu, 27 Jan 2011 12:52:21 -0600
Message-ID: <1296154341.1973.138.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Wed, 2011-01-19 at 11:41 -0600, Ben Myers wrote:
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

. . .

> SGI-PV: 1013221
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> ---
>  fs/xfs/xfs_bmap.c |   33 +++++++++++++++++++++++++--------
>  1 files changed, 25 insertions(+), 8 deletions(-)

This looks OK, but I want to point something out.
I'm not sure whether it's a significant problem
or not, but I think it could screw up some
reservation counts.

First though, it may be that the LEFT, RIGHT,
etc. were not used here because the xfs_bmbt_irec_t
array was not being used in the same way as it  was
being used elsewhere in this function.  Instead,
they are being overwritten with new extent data.
Same thing happens in xfs_bmap_add_extent_unwritten_real().
Nevertheless, I find that the symbolic names make
the result more readable, so I like the change.


Here's the thing I wanted to point out.  This
change fixes it so the delalloc space after the
new extent has the correct NULL start block address
(encoding the worst case indirect block count in it).

Meanwhile, it does not update the NULL start block
address of PREV (and of course, this is how the
existing code works too).  That means that the
indirect block count encoded therein may be
wrong as a result of the update.

I.e., in addition to:
		xfs_bmbt_set_blockcount(ep, temp);
I think we ought to do:
		int indlen;

		indlen = (int) xfs_bmap_worst_indlen(ip, temp);
		PREV.br_startblock = nullstartblock(indlen);
and then somehow update the in-core extent map with the
new information.  (I don't know if there's an interface
to do that right now.)

Maybe the in-core map doesn't have to accurately reflect
the encoded indirect block reservation, I don't know.

If it does though, the code here (and likely elsewhere)
should probably be rearranged a bit so we can update all
three extents (PREV, LEFT (new), and RIGHT) with one call
to xfs_iext_update().

Note (again) that this doesn't say anything wrong
with this change, just that in looking at it I
noticed something else that might need to be fixed.

					-Alex


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

Somehow I think this call, which inserts *two* extents, is
the reason this problem was a bit difficult to spot.  Almost
all the other calls to this function insert just one.

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
> 



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
