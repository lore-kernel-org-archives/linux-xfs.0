Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2BEA47CA2
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 03:50:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C819304053
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 01:50:46 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id WLIwKnGKDAryOyZA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2016 01:50:45 -0800 (PST)
Date: Wed, 10 Feb 2016 01:50:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160210095010.GC23904@birch.djwong.org>
References: <20160210093011.GA19147@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210093011.GA19147@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

[past-1am posting, reader beware...]

On Wed, Feb 10, 2016 at 01:30:11AM -0800, Christoph Hellwig wrote:
> I've been chasing asserts about reserved blocks when testing the reflink
> feature over NFS.  I was right with my suspicion that the full allocator
> recursion from xfs_refcountbt_alloc_block was the culprit, but I should
> have read the assert before jumping to conclusions:  we're running out
> of space reservations, not log reservations.

Oh, there are ways to run out of log reservation too, and fixing that is
also on my todo lits.

> The problem is that we need reserve the space for these normal allocator
> block pools used by the refcount btree, which we may use up for allocations
> and frees given that we use the normal space allocator for it.
> 
> This means we need a reservation for each transaction that truncates
> extents, including those allocated in xfs_trans_roll.  The patch below
> demonstrates a local hack that makes things work for me so far, but
> I don't think it's a viable solution.

That's odd... I'd have thought that the AG reservation would always be able
to handle a refcount btree expansion, since it calculates how many blocks
are needed to handle the worst case of 1 record per extent.  There's also
a bug where we undercount the number of blocks already used, so it should
have an extra big reservation.

OTOH I've seen occasional ENOSPCs in generic/186 and generic/168 too, so I
guess something's going wrong.  Maybe the xfs_ag_resv* tracepoints can help?

> Darrick, Dave - can you explain the design decisions behind the
> refcount btree block allocations to me?  This whole area still seems
> to be in constant flux, so it seems there are lots of tradeoffs to make.

ISTR Dave told me to use the regular allocator (instead of the AGFL) for
the refcount btree because it's not a free space btree and exists at a higher
level than, say, the rmap btree.  The per-AG reservation code selectively hides
part of an AG's free space from the regular allocator so that regular file
requests can't eat up so much space in the AG that future cow/reflink/whatever
operations encounter ENOSPC during a btree split and take the FS offline.

------

WRT xfstests, I think I fixed all the things Dave was complaining about.
Running tests overnight to make sure I didn't break anything, and I'll be
ready to send another pull req (I can patchbomb too, but know that there
are even more tests now that I cleaned up the style problems) tomorrow
morning if nothing breaks.

--D

> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 338c457..3b8a25e 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -967,7 +967,7 @@ xfs_free_eofblocks(
>  			}
>  		}
>  
> -		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 2, 0);
>  		if (error) {
>  			ASSERT(XFS_FORCED_SHUTDOWN(mp));
>  			xfs_trans_cancel(tp);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d1311ef..ec530d7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1783,7 +1783,7 @@ xfs_inactive_truncate(
>  	int			error;
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 2, 0);
>  	if (error) {
>  		ASSERT(XFS_FORCED_SHUTDOWN(mp));
>  		xfs_trans_cancel(tp);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ab3619c..a8c55bd 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -871,7 +871,7 @@ xfs_setattr_size(
>  	truncate_setsize(inode, newsize);
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 2, 0);
>  	if (error)
>  		goto out_trans_cancel;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 4d63836..a661430 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4144,7 +4144,7 @@ xlog_recover_process_efi(
>  	}
>  
>  	tp = xfs_trans_alloc(mp, 0);
> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 2, 0);
>  	if (error)
>  		goto abort_error;
>  	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 3640c6e..33ff98f 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -237,7 +237,7 @@ xfs_qm_scall_trunc_qfile(
>  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_TRUNCATE_FILE);
> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 2, 0);
>  	if (error) {
>  		xfs_trans_cancel(tp);
>  		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 9503ccc..585a94a 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1026,7 +1026,7 @@ xfs_reflink_update_dest(
>  		return 0;
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 2, 0);
>  
>  	/*
>  	 * check for running out of space
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index b44284c..7538f39 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -456,7 +456,7 @@ xfs_inactive_symlink_rmt(
>  	ASSERT(ip->i_d.di_nextents > 0 && ip->i_d.di_nextents <= 2);
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 2, 0);
>  	if (error) {
>  		xfs_trans_cancel(tp);
>  		return error;
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 748b16a..2ef46de 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1065,7 +1065,7 @@ __xfs_trans_roll(
>  	 * the prior and the next transactions.
>  	 */
>  	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> -	error = xfs_trans_reserve(trans, &tres, 0, 0);
> +	error = xfs_trans_reserve(trans, &tres, 2, 0);
>  	/*
>  	 *  Ensure that the inode is in the new transaction and locked.
>  	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
