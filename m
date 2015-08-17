Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C0BC7F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 16:34:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E14F1304077
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 14:34:18 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	klT9PRU04nktSJNU for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 14:34:16 -0700 (PDT)
Date: Tue, 18 Aug 2015 07:34:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/13] xfs: swap leaf buffer into path struct atomically
	during path shift
Message-ID: <20150817213413.GC714@dastard>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
	<1439830072-61117-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439830072-61117-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 17, 2015 at 12:47:52PM -0400, Brian Foster wrote:
> The node directory lookup code uses a state structure that tracks the
> path of buffers used to search for the hash of a filename through the
> leaf blocks. When the lookup encounters a block that ends with the
> requested hash, but the entry has not yet been found, it must shift over
> to the next block and continue looking for the entry (i.e., duplicate
> hashes could continue over into the next block). This shift mechanism
> involves walking back up and down the state structure, replacing buffers
> at the appropriate btree levels as necessary.
> 
> When a buffer is replaced, the old buffer is released and the new buffer
> read into the active slot in the path structure. Because the buffer is
> read directly into the path slot, a buffer read failure can result in
> setting a NULL buffer pointer in an active slot. This throws off the
> state cleanup code in xfs_dir2_node_lookup(), which expects to release a
> buffer from each active slot. Instead, a BUG occurs due to a NULL
> pointer dereference:
> 
>   BUG: unable to handle kernel NULL pointer dereference at 00000000000001e8
>   IP: [<ffffffffa0585063>] xfs_trans_brelse+0x2a3/0x3c0 [xfs]
>   ...
>   RIP: 0010:[<ffffffffa0585063>]  [<ffffffffa0585063>] xfs_trans_brelse+0x2a3/0x3c0 [xfs]
>   ...
>   Call Trace:
>    [<ffffffffa05250c6>] xfs_dir2_node_lookup+0xa6/0x2c0 [xfs]
>    [<ffffffffa0519f7c>] xfs_dir_lookup+0x1ac/0x1c0 [xfs]
>    [<ffffffffa055d0e1>] xfs_lookup+0x91/0x290 [xfs]
>    [<ffffffffa05580b3>] xfs_vn_lookup+0x73/0xb0 [xfs]
>    [<ffffffff8122de8d>] lookup_real+0x1d/0x50
>    [<ffffffff8123330e>] path_openat+0x91e/0x1490
>    [<ffffffff81235079>] do_filp_open+0x89/0x100
>    ...
> 
> This has been reproduced via a parallel fsstress and filesystem shutdown
> workload in a loop. The shutdown triggers the read error in the
> aforementioned codepath and causes the BUG in xfs_dir2_node_lookup().
> 
> Update xfs_da3_path_shift() to update the active path slot atomically
> with respect to the caller when a buffer is replaced. This ensures that
> the caller always sees the old or new buffer in the slot and prevents
> the NULL pointer dereference.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This is just another shutdown/error handling issue I've run into with
> the same testing associated with all of the other fixes. I'm tacking it
> on to the end of this series...
> 
> Brian
> 
>  fs/xfs/libxfs/xfs_da_btree.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 3264d81..04a3765 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -1822,6 +1822,7 @@ xfs_da3_path_shift(
>  	struct xfs_da_args	*args;
>  	struct xfs_da_node_entry *btree;
>  	struct xfs_da3_icnode_hdr nodehdr;
> +	struct xfs_buf		*bp;
>  	xfs_dablk_t		blkno = 0;
>  	int			level;
>  	int			error;
> @@ -1865,21 +1866,27 @@ xfs_da3_path_shift(
>  	 * same depth we were at originally.
>  	 */
>  	for (blk++, level++; level < path->active; blk++, level++) {
> +		struct xfs_buf	**bpp = &blk->bp;
> +

What do we need this for? The new code is:

>  		/*
> +		 * Read the next child block into a local buffer.
>  		 */
> +		error = xfs_da3_node_read(args->trans, dp, blkno, -1, &bp,
> +					  args->whichfork);
> +		if (error)
> +			return error;
>  
>  		/*
> +		 * Release the old block (if it's dirty, the trans doesn't
> +		 * actually let go) and swap the local buffer into the path
> +		 * structure. This ensures failure of the above read doesn't set
> +		 * a NULL buffer in an active slot in the path.
>  		 */
> +		if (release)
> +			xfs_trans_brelse(args->trans, blk->bp);
>  		blk->blkno = blkno;
> +		*bpp = bp;

And this can simply be:

		blk->bp = bp;

so I don't think *bpp is necessary at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
