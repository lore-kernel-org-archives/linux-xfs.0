Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 505F97F50
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 23:59:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2DD8A8F8033
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 21:59:02 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	D7xUtqafBX4TpITW for <xfs@oss.sgi.com>;
	Sun, 11 Oct 2015 21:58:58 -0700 (PDT)
Date: Mon, 12 Oct 2015 15:58:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: validate metadata LSNs against log on v5 superblocks
Message-ID: <20151012045817.GE27164@dastard>
References: <1443183869-16487-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1443183869-16487-1-git-send-email-bfoster@redhat.com>
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

On Fri, Sep 25, 2015 at 08:24:29AM -0400, Brian Foster wrote:
> Since the onset of v5 superblocks, the LSN of the last modification has
> been included in a variety of on-disk data structures. This LSN is used
> to provide log recovery ordering guarantees (e.g., to ensure an older
> log recovery item is not replayed over a newer target data structure).
> 
> While this works correctly from the point a filesystem is formatted and
> mounted, userspace tools have some problematic behaviors that defeat
> this mechanism. For example, xfs_repair historically zeroes out the log
> unconditionally (regardless of whether corruption is detected). If this
> occurs, the LSN of the filesystem is reset and the log is now in a
> problematic state with respect to on-disk metadata structures that might
> have a larger LSN. Until either the log catches up to the highest
> previously used metadata LSN or each affected data structure is modified
> and written out without incident (which resets the metadata LSN), log
> recovery is susceptible to filesystem corruption.
> 
> This problem is ultimately addressed and repaired in the associated
> userspace tools. The kernel is still responsible to detect the problem
> and notify the user that something is wrong. Check the superblock LSN at
> mount time and fail the mount if it is invalid. From that point on,
> trigger verifier failure on any metadata I/O where an invalid LSN is
> detected. This results in a filesystem shutdown and guarantees that we
> do not log metadata changes with invalid LSNs on disk. Since this is a
> known issue with a known recovery path, present a warning to instruct
> the user how to recover.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Here's a first non-rfc version of v5 sb metadata LSN verification. The
> biggest difference with this version is the attempt to mitigate lock
> contention in the LSN helper and corresponding tweak to how the log
> fields are updated when the head wraps around the end of the log. The
> idea is to do a racy check and only acquire the lock when there appears
> to be risk of an invalid LSN.
> 
> AFAICS, this is not safe with the current code as the current LSN can be
> sampled in a state that transiently pushes the LSN forward to the end of
> the next cycle (if the cycle is updated, both cycle/block are sampled,
> and then the block is updated). This means that a false negative can
> occur if an invalid LSN happens to exist but is within the bounds of the
> next full log cycle. Therefore, this patch also tweaks the current LSN
> update and sample code to rewind the current block before the cycle is
> updated and uses a memory barrier to guarantee that the sample code
> always sees the rewound current block if it sees the updated cycle. Note
> that it is still possible to see the rewound block before the cycle
> update (a transient backwards LSN), but this is safe because such false
> positives are explicitly reverified with the lock held before failure is
> triggered.
> 
> Otherwise, this refactors/relocates the helpers and converts back to the
> more simple behavior of verifier failure on detection of invalid
> metadata LSN. Thoughts, reviews, flames appreciated.
> 
> Brian
.....
> @@ -243,8 +244,14 @@ bool
>  xfs_btree_lblock_verify_crc(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
> +	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +
> +	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {

mp->m_sb.

>  xfs_btree_sblock_verify_crc(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
> +	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +
> +	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {

Ditto.

> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index be43248..e89a0f8 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -39,6 +39,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_cksum.h"
>  #include "xfs_buf_item.h"
> +#include "xfs_log.h"
>  
>  /*
>   * xfs_da_btree.c
> @@ -150,6 +151,8 @@ xfs_da3_node_verify(
>  			return false;
>  		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
>  			return false;
> +		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
> +			return false;
>  	} else {
>  		if (ichdr.magic != XFS_DA_NODE_MAGIC)
>  			return false;
> @@ -322,6 +325,7 @@ xfs_da3_node_create(
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
>  
> +		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
>  		ichdr.magic = XFS_DA3_NODE_MAGIC;
>  		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
>  		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);

Is this a bug fix or just cleanliness? The LSN gets written into the
header before it goes to disk, so there is nothing uninitialised
that I am unaware of ending up on disk from this. 

> @@ -60,6 +61,7 @@ xfs_symlink_hdr_set(
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return 0;
>  
> +	memset(dsl, 0, sizeof(struct xfs_dsymlink_hdr));
>  	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
>  	dsl->sl_offset = cpu_to_be32(offset);
>  	dsl->sl_bytes = cpu_to_be32(size);

Ditto.

> index aaadee0..0c8ef76 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3165,11 +3165,19 @@ xlog_state_switch_iclogs(
>  	}
>  
>  	if (log->l_curr_block >= log->l_logBBsize) {
> +		/*
> +		 * Rewind the current block before the cycle is bumped to make
> +		 * sure that the combined LSN never transiently moves forward
> +		 * when the log wraps to the next cycle. This is to support the
> +		 * unlocked sample of these fields from xlog_valid_lsn(). Most
> +		 * other cases should acquire l_icloglock.
> +		 */
> +		log->l_curr_block -= log->l_logBBsize;
> +		ASSERT(log->l_curr_block >= 0);
> +		smp_wmb();
>  		log->l_curr_cycle++;

OK, so we make sure the write of the l_curr_block cannot be
reordered to after the write of the l_curr_cycle.

> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 950f3f9..8daba74 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -560,4 +560,55 @@ static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
>  	remove_wait_queue(wq, &wait);
>  }
>  
> +/*
> + * The LSN is valid so long as it is behind the current LSN. If it isn't, this
> + * means that the next log record that includes this metadata could have a
> + * smaller LSN. In turn, this means that the modification in the log would not
> + * replay.
> + */
> +static inline bool
> +xlog_valid_lsn(
> +	struct xlog	*log,
> +	xfs_lsn_t	lsn)
> +{
> +	int		cur_cycle;
> +	int		cur_block;
> +	bool		valid = true;
> +
> +	/*
> +	 * First, sample the current lsn without locking to avoid added
> +	 * contention from metadata I/O. The current cycle and block are updated
> +	 * (in xlog_state_switch_iclogs()) and read here in a particular order
> +	 * to avoid false negatives (e.g., thinking the metadata LSN is valid
> +	 * when it is not).
> +	 *
> +	 * The current block is always rewound before the cycle is bumped in
> +	 * xlog_state_switch_iclogs() to ensure the current LSN is never seen in
> +	 * a transiently forward state. Instead, we can see the LSN in a
> +	 * transiently behind state if we happen to race with a cycle wrap.
> +	 */
> +	cur_cycle = ACCESS_ONCE(log->l_curr_cycle);
> +	smp_rmb();
> +	cur_block = ACCESS_ONCE(log->l_curr_block);

And we make sure the read of the block cannot be reordered to before
the l_curr_cycle. Looks ok to me.

I'm going to commit this as is because I don't think the memset()s
above actuallly change anything on disk. I can always redo the
commit if this is in error...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
