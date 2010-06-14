Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5E4PBSt019851 for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 23:25:11 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A25553C3B93
	for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 21:27:45 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	8XqUuHUUdycX80IG for <xfs@oss.sgi.com>;
	Sun, 13 Jun 2010 21:27:45 -0700 (PDT)
Date: Mon, 14 Jun 2010 14:27:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100614042700.GC6590@dastard>
References: <20100610110.764742110@firstfloor.org>
	<20100610111052.3DDC5B1A2B@basil.firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100610111052.3DDC5B1A2B@basil.firstfloor.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jun 10, 2010 at 01:10:52PM +0200, Andi Kleen wrote:
> 
> For my configuration, that is without quota or RT.
> 
> Mostly dead code removed I think (but needs additional review) 
>
> That is there were one or two bad error handling cases,
> but they were not easily fixable, with comments 
> and I left the warnings in for those for you to remember.
> 
> e.g. if there is a ENOSPC down in xfs_trans.c while
> modifying the superblock it would not be handled.

See my comments about these below.

> Unused statements were mostly related to stub macros for disabled
> features like QUOTA or RT ALLOC. I replace those with
> inlines.

Did you compile with/without XFS_DEBUG (I don't think so)? when
changing code that affects ASSERT statements, CONFIG_XFS_DEBUG needs to
be selected to test that this code compiles. Most XFs developers
build with XFS_CONFIG_DEBUG for everything other than performance
testing, so ensuring this builds is definitely required. ;)

I'd also be interested if any fixes are needed with all options
enabled. Seems silly just to fix a few warnings in just one
particular configuration rather than all of them...

> There were also some problems with variables used in ASSERT()
> I partly moved those into the ASSERT itself and partly
> used a new QASSERT that always evaluates.

That's a pretty ugly hack for a single occurrence of a warning.
Re-arrnaging the code is a much better idea than introducing a new
ASSERT type. e.g:

-	ASSERT(ref >= 0);
+	if (ref < 0)
+		ASSERT(0);

> Cc: xfs@oss.sgi.com
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  fs/xfs/linux-2.6/xfs_sync.c |    3 +++
>  fs/xfs/support/debug.h      |    4 ++++
>  fs/xfs/xfs_alloc.c          |   10 +++-------
>  fs/xfs/xfs_da_btree.c       |   15 +++++----------
>  fs/xfs/xfs_dir2_block.c     |    6 +++---
>  fs/xfs/xfs_filestream.c     |   10 ++--------
>  fs/xfs/xfs_iget.c           |    3 ---
>  fs/xfs/xfs_inode.c          |    4 ----
>  fs/xfs/xfs_inode_item.c     |    8 ++------
>  fs/xfs/xfs_log.c            |    2 --
>  fs/xfs/xfs_quota.h          |   14 ++++++++++----
>  fs/xfs/xfs_trans.c          |    1 +
>  12 files changed, 33 insertions(+), 47 deletions(-)
> 
> Index: linux-2.6.35-rc2-gcc/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- linux-2.6.35-rc2-gcc.orig/fs/xfs/linux-2.6/xfs_sync.c
> +++ linux-2.6.35-rc2-gcc/fs/xfs/linux-2.6/xfs_sync.c
> @@ -554,6 +554,9 @@ xfs_sync_worker(
>  		xfs_log_force(mp, 0);
>  		xfs_reclaim_inodes(mp, 0);
>  		/* dgc: errors ignored here */
> +		/* ak: yes and you'll get a warning for it now when you
> +		 * upgrade compilers.
> +		 */
>  		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
>  		if (xfs_log_need_covered(mp))
>  			error = xfs_commit_dummy_trans(mp, 0);

I don't think the coment is necessary - the compiler will remind us
that we are ignoring errors.

FWIW, we've now got a situation where external static code checkers
will tell us that we are not handling an error case (which is where
this code and comment came from), and now the compiler will warn us
we are assigning but not using the return value. It's a bit of a
Catch-22 situation. Hence my question is this - how are we supposed
to "safely" ignore a return value seeing as the compiler is now
making the current method rather noisy?

> Index: linux-2.6.35-rc2-gcc/fs/xfs/xfs_da_btree.c
> ===================================================================
> --- linux-2.6.35-rc2-gcc.orig/fs/xfs/xfs_da_btree.c
> +++ linux-2.6.35-rc2-gcc/fs/xfs/xfs_da_btree.c
> @@ -581,10 +581,8 @@ xfs_da_node_add(xfs_da_state_t *state, x
>  	xfs_da_intnode_t *node;
>  	xfs_da_node_entry_t *btree;
>  	int tmp;
> -	xfs_mount_t *mp;
>  
>  	node = oldblk->bp->data;
> -	mp = state->mp;
>  	ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
>  	ASSERT((oldblk->index >= 0) && (oldblk->index <= be16_to_cpu(node->hdr.count)));
>  	ASSERT(newblk->blkno != 0);

That'll break a CONFIG_XFS_DEBUG build as the next statement:

        if (state->args->whichfork == XFS_DATA_FORK)
                ASSERT(newblk->blkno >= mp->m_dirleafblk &&
                       newblk->blkno < mp->m_dirfreeblk);

uses mp inside ASSERT statements.

> Index: linux-2.6.35-rc2-gcc/fs/xfs/xfs_dir2_block.c
> ===================================================================
> --- linux-2.6.35-rc2-gcc.orig/fs/xfs/xfs_dir2_block.c
> +++ linux-2.6.35-rc2-gcc/fs/xfs/xfs_dir2_block.c
> @@ -1073,10 +1073,10 @@ xfs_dir2_sf_to_block(
>  	 */
>  
>  	buf_len = dp->i_df.if_bytes;
> -	buf = kmem_alloc(dp->i_df.if_bytes, KM_SLEEP);
> +	buf = kmem_alloc(buf_len, KM_SLEEP);
>  
> -	memcpy(buf, sfp, dp->i_df.if_bytes);
> -	xfs_idata_realloc(dp, -dp->i_df.if_bytes, XFS_DATA_FORK);
> +	memcpy(buf, sfp, buf_len);
> +	xfs_idata_realloc(dp, -buf_len, XFS_DATA_FORK);
>  	dp->i_d.di_size = 0;
>  	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
>  	/*

Just remove the buf_len variable in this case.

> Index: linux-2.6.35-rc2-gcc/fs/xfs/xfs_filestream.c
> ===================================================================
> --- linux-2.6.35-rc2-gcc.orig/fs/xfs/xfs_filestream.c
> +++ linux-2.6.35-rc2-gcc/fs/xfs/xfs_filestream.c
> @@ -140,9 +140,8 @@ _xfs_filestream_pick_ag(
>  	int		flags,
>  	xfs_extlen_t	minlen)
>  {
> -	int		streams, max_streams;
>  	int		err, trylock, nscan;
> -	xfs_extlen_t	longest, free, minfree, maxfree = 0;
> +	xfs_extlen_t	longest, minfree, maxfree = 0;
>  	xfs_agnumber_t	ag, max_ag = NULLAGNUMBER;
>  	struct xfs_perag *pag;
>  
> @@ -174,7 +173,6 @@ _xfs_filestream_pick_ag(
>  		/* Keep track of the AG with the most free blocks. */
>  		if (pag->pagf_freeblks > maxfree) {
>  			maxfree = pag->pagf_freeblks;
> -			max_streams = atomic_read(&pag->pagf_fstrms);
>  			max_ag = ag;
>  		}
>  
> @@ -196,8 +194,6 @@ _xfs_filestream_pick_ag(
>  		     (flags & XFS_PICK_LOWSPACE))) {
>  
>  			/* Break out, retaining the reference on the AG. */
> -			free = pag->pagf_freeblks;
> -			streams = atomic_read(&pag->pagf_fstrms);
>  			xfs_perag_put(pag);
>  			*agp = ag;
>  			break;
> @@ -234,8 +230,6 @@ next_ag:
>  		if (max_ag != NULLAGNUMBER) {
>  			xfs_filestream_get_ag(mp, max_ag);
>  			TRACE_AG_PICK1(mp, max_ag, maxfree);
> -			streams = max_streams;
> -			free = maxfree;
>  			*agp = max_ag;
>  			break;
>  		}
> @@ -364,7 +358,7 @@ xfs_fstrm_free_func(
>  	/* Drop the reference taken on the AG when the item was added. */
>  	ref = xfs_filestream_put_ag(ip->i_mount, item->ag);
>  
> -	ASSERT(ref >= 0);
> +	QASSERT(ref >= 0);
>  	TRACE_FREE(ip->i_mount, ip, item->pip, item->ag,
>  		xfs_filestream_peek_ag(ip->i_mount, item->ag));

These are all "unused" because they are used in debug code only. i.e.
in XFS_FILESTREAMS_TRACE configs. This is manual debug code that
needs to be converted to the trace infrastructure - the compiler may
say it is unused, but it is not dead code, so shoul dnot be removed.

See also my comment about QASSERT() above.

>  #define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
> Index: linux-2.6.35-rc2-gcc/fs/xfs/xfs_trans.c
> ===================================================================
> --- linux-2.6.35-rc2-gcc.orig/fs/xfs/xfs_trans.c
> +++ linux-2.6.35-rc2-gcc/fs/xfs/xfs_trans.c
> @@ -1120,6 +1120,7 @@ xfs_trans_unreserve_and_mod_sb(
>  		error = xfs_mod_incore_sb_batch(tp->t_mountp, msb,
>  			(uint)(msbp - msb), rsvd);
>  		ASSERT(error == 0);
> +		/* FIXME: need real error handling here, error can be ENOSPC */

That comment is wrong and hence is not needed.  By design, we should
never, ever get an error here because we've already reserved all the
space we need and this is just an accounting call.  That's what the
ASSERT(error == 0) is documenting. It's ben placed there to catch
any re-occurrence of the race condition that is documented in the
function head comment during development.  Anyway, if we do get an
error here, we cannot handle it anyway - it's too late to do
anything short of a complete shutdown as we've already written the
transaction to the log.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
