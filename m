Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41340 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfEOMtV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 08:49:21 -0400
Subject: Re: [PATCH 11/11] libxfs: minor sync-ups to kernel-ish functions
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-12-git-send-email-sandeen@redhat.com>
 <20190515062522.GZ29573@dread.disaster.area>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <50fca55e-539f-9ff1-0945-15c366e82001@sandeen.net>
Date: Wed, 15 May 2019 07:49:19 -0500
MIME-Version: 1.0
In-Reply-To: <20190515062522.GZ29573@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 5/15/19 1:25 AM, Dave Chinner wrote:
> On Fri, May 10, 2019 at 03:18:30PM -0500, Eric Sandeen wrote:
>> Change typedefs to structs, add comments, and other very
>> minor changes to userspace libxfs/ functions so that they
>> more closely match kernelspace.  Should be no functional
>> changes.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Ah, there's the typedef removal....
> 
> ....
>>  /*
>>   * Free the transaction structure.  If there is more clean up
>>   * to do when the structure is freed, add it here.
>>   */
>> -static void
>> +STATIC void
>>  xfs_trans_free(
>>  	struct xfs_trans	*tp)
>>  {
>> @@ -106,7 +102,7 @@ xfs_trans_reserve(
>>  	uint			blocks,
>>  	uint			rtextents)
>>  {
>> -	int			error = 0;
>> +	int		error = 0;
>>  
>>  	/*
>>  	 * Attempt to reserve the needed disk blocks by decrementing
>> @@ -114,8 +110,9 @@ xfs_trans_reserve(
>>  	 * fail if the count would go below zero.
>>  	 */
>>  	if (blocks > 0) {
>> -		if (tp->t_mountp->m_sb.sb_fdblocks < blocks)
>> +		if (tp->t_mountp->m_sb.sb_fdblocks < blocks) {
>>  			return -ENOSPC;
>> +		}
>>  		tp->t_blk_res += blocks;
>>  	}
> 
> These seem a bit weird by themselves. I know, the kernel code has
> more code in the branches and this reduces the diff a bit, but
> it does look a inconsistent now...

The goal would be to add the other bits back in later.  But doing it
in small steps like this just causes confusion, I guess?

>> @@ -235,18 +233,24 @@ xfs_trans_alloc_empty(
>>   * Record the indicated change to the given field for application
>>   * to the file system's superblock when the transaction commits.
>>   * For now, just store the change in the transaction structure.
>> + *
>>   * Mark the transaction structure to indicate that the superblock
>>   * needs to be updated before committing.
>> - *
>> - * Originally derived from xfs_trans_mod_sb().
>>   */
>>  void
>>  xfs_trans_mod_sb(
>> -	xfs_trans_t		*tp,
>> -	uint			field,
>> -	long			delta)
>> +	xfs_trans_t	*tp,
> 
> typedef removal :)
> 
> Kernel side, too, I guess...

Right, the goal here is to sync up with the kernel, not diverge more.

>>  
>> -xfs_buf_t *
>> +/*
>> + * Get and lock the buffer for the caller if it is not already
>> + * locked within the given transaction.  If it is already locked
>> + * within the transaction, just increment its lock recursion count
>> + * and return a pointer to it.
>> + *
>> + * If the transaction pointer is NULL, make this just a normal
>> + * get_buf() call.
>> + */
>> +struct xfs_buf *
>>  xfs_trans_get_buf_map(
>> -	xfs_trans_t		*tp,
>> -	struct xfs_buftarg	*btp,
>> +	struct xfs_trans	*tp,
>> +	struct xfs_buftarg	*target,
>>  	struct xfs_buf_map	*map,
>>  	int			nmaps,
>> -	uint			f)
>> +	uint			flags)
>>  {
>>  	xfs_buf_t		*bp;
> 
> You missed a typedef.

kernel missed a typedef ;)

[sandeen@sandeen linux-xfs]$ grep -A7 ^xfs_trans_get_buf_map fs/xfs/*.c fs/xfs/*/*.c
fs/xfs/xfs_trans_buf.c:xfs_trans_get_buf_map(
fs/xfs/xfs_trans_buf.c-	struct xfs_trans	*tp,
fs/xfs/xfs_trans_buf.c-	struct xfs_buftarg	*target,
fs/xfs/xfs_trans_buf.c-	struct xfs_buf_map	*map,
fs/xfs/xfs_trans_buf.c-	int			nmaps,
fs/xfs/xfs_trans_buf.c-	xfs_buf_flags_t		flags)
fs/xfs/xfs_trans_buf.c-{
fs/xfs/xfs_trans_buf.c-	xfs_buf_t		*bp;

>>  
>> +/*
>> + * Get and lock the superblock buffer of this file system for the
>> + * given transaction.
>> + *
>> + * We don't need to use incore_match() here, because the superblock
>> + * buffer is a private buffer which we keep a pointer to in the
>> + * mount structure.
>> + */
>>  xfs_buf_t *
> 
> typedef
> 
>>  xfs_trans_getsb(
>>  	xfs_trans_t		*tp,
> 
> Another
> 
>> -	xfs_mount_t		*mp,
>> +	struct xfs_mount	*mp,
>>  	int			flags)
>>  {
>>  	xfs_buf_t		*bp;
> 
> And another.
> 
> yup, kernel code needs fixing, too.

"you go first!" ;)

> .....
>> + * transaction began, then also free the buf_log_item associated with it.
>> + *
>> + * If the transaction pointer is NULL, this is a normal xfs_buf_relse() call.
>> + */
>>  void
>>  xfs_trans_brelse(
>> -	xfs_trans_t		*tp,
>> -	xfs_buf_t		*bp)
>> +	struct xfs_trans	*tp,
>> +	struct xfs_buf		*bp)
>>  {
>> -	xfs_buf_log_item_t	*bip;
>> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
>>  #ifdef XACT_DEBUG
>>  	fprintf(stderr, "released buffer %p, transaction %p\n", bp, tp);
>>  #endif
>>  
>> -	if (tp == NULL) {
>> +	if (!tp) {
>>  		ASSERT(bp->b_transp == NULL);
>>  		libxfs_putbuf(bp);
>>  		return;
>>  	}
>>  	ASSERT(bp->b_transp == tp);
>> -	bip = bp->b_log_item;
>>  	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
>> +
>> +	/*
>> +	 * If the release is for a recursive lookup, then decrement the count
>> +	 * and return.
>> +	 */
>>  	if (bip->bli_recur > 0) {
>>  		bip->bli_recur--;
>>  		return;
>>  	}
>> -	/* If dirty/stale, can't release till transaction committed */
>> -	if (bip->bli_flags & XFS_BLI_STALE)
>> -		return;
>> +
>> +	/*
>> +	 * If the buffer is invalidated or dirty in this transaction, we can't
>> +	 * release it until we commit.
>> +	 */
>>  	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
>>  		return;
>> +	if (bip->bli_flags & XFS_BLI_STALE)
>> +		return;
> 
> THis is a change of behaviour for userspace, right? What does
> checking for a dirty log item do?

No, it just re-orders an existing test, look up a few lines.

>> +/*
>> + * Invalidate a buffer that is being used within a transaction.
>> + *
>> + * Typically this is because the blocks in the buffer are being freed, so we
>> + * need to prevent it from being written out when we're done.  Allowing it
>> + * to be written again might overwrite data in the free blocks if they are
>> + * reallocated to a file.
>> + *
>> + * We prevent the buffer from being written out by marking it stale.  We can't
>> + * get rid of the buf log item at this point because the buffer may still be
>> + * pinned by another transaction.  If that is the case, then we'll wait until
>> + * the buffer is committed to disk for the last time (we can tell by the ref
>> + * count) and free it in xfs_buf_item_unpin().  Until that happens we will
>> + * keep the buffer locked so that the buffer and buf log item are not reused.
>> + *
>> + * We also set the XFS_BLF_CANCEL flag in the buf log format structure and log
>> + * the buf item.  This will be used at recovery time to determine that copies
>> + * of the buffer in the log before this should not be replayed.
>> + *
>> + * We mark the item descriptor and the transaction dirty so that we'll hold
>> + * the buffer until after the commit.
>> + *
>> + * Since we're invalidating the buffer, we also clear the state about which
>> + * parts of the buffer have been logged.  We also clear the flag indicating
>> + * that this is an inode buffer since the data in the buffer will no longer
>> + * be valid.
>> + *
>> + * We set the stale bit in the buffer as well since we're getting rid of it.
>> + */
>>  void
>>  xfs_trans_binval(
> 
> Does userspace even have half of this functionality? Does marking
> the buffer stale in userspace give the same guarantees as the kernel?
> There's no point bringing across comments that don't reflect how
> userspace works at this point in time...

We have a lot of comments in userspace libxfs/* that reference locking that is 
defined away, etc.  IOWs we have this today, and I thought it was 
understood that shared kernelspace comments didn't always reflect userspace
reality...

*shrug*

Thanks for looking it over,

-Eric


> Cheers,
> 
> Dave.
> 
