Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58219442
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 06:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XMA4e1E/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9EDC433C7;
	Tue,  9 Jan 2024 06:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704780883;
	bh=UD/AeWD4drlqGr77bAMJYe0NL3fMlYxWsDJCISDUzeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XMA4e1E/zJN2+g4CnapTbu6A4Fo1ub/rMKnIGwRLCX3JcU/djQV56w4PSXblzJ9Gr
	 W+hfCX83ba5G7S+Bc57hdgsQzV/oHo2l3+CMZ5zsGa/ASb3GvneX392MWlBerMY+PA
	 QuNlw6rIDT+11vZ+Uqh2roxvXKPLJf8Nb/Db3S78IA6+ndcEMoWC3QvWFNHWiVJRiu
	 CPKUvNKqzmKawzY3kE41IBx3iSeX7n9DcL4ZjQHrD3bHu7gErSzncpJTOrPclo9r02
	 L8rVQ/q0wIxLmgC+100Olvj6WELPRwhM9RaEmm8pO7kY8F9RfNXQSuo2xmM6wkyX7p
	 TMwShCGbrhtRQ==
Date: Mon, 8 Jan 2024 22:14:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Jian Wen <wenjianhn@gmail.com>, linux-xfs@vger.kernel.org, hch@lst.de,
	dchinner@redhat.com, Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH v4] xfs: improve handling of prjquot ENOSPC
Message-ID: <20240109061442.GD722975@frogsfrogsfrogs>
References: <20231216153522.52767-1-wenjianhn@gmail.com>
 <20240104062248.3245102-1-wenjian1@xiaomi.com>
 <ZZtDRe+jzM72Y8mY@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZtDRe+jzM72Y8mY@dread.disaster.area>

On Mon, Jan 08, 2024 at 11:35:17AM +1100, Dave Chinner wrote:
> On Thu, Jan 04, 2024 at 02:22:48PM +0800, Jian Wen wrote:
> > From: Jian Wen <wenjianhn@gmail.com>
> > 
> > Currently, xfs_trans_dqresv() return -ENOSPC when the project quota
> > limit is reached. As a result, xfs_file_buffered_write() will flush
> > the whole filesystem instead of the project quota.
> > 
> > Fix the issue by make xfs_trans_dqresv() return -EDQUOT rather than
> > -ENOSPC. Add a helper, xfs_blockgc_nospace_flush(), to make flushing
> > for both EDQUOT and ENOSPC consistent.
> > 
> > Changes since v3:
> >   - rename xfs_dquot_is_enospc to xfs_dquot_hardlimit_exceeded
> >   - acquire the dquot lock before checking the free space
> > 
> > Changes since v2:
> >   - completely rewrote based on the suggestions from Dave
> > 
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
> 
> Please send new patch versions as a new thread, not as a reply to
> a random email in the middle of the review thread for a previous
> version.
> 
> > ---
> >  fs/xfs/xfs_dquot.h       | 22 +++++++++++++++---
> >  fs/xfs/xfs_file.c        | 41 ++++++++++++--------------------
> >  fs/xfs/xfs_icache.c      | 50 +++++++++++++++++++++++++++++-----------
> >  fs/xfs/xfs_icache.h      |  7 +++---
> >  fs/xfs/xfs_inode.c       | 19 ++++++++-------
> >  fs/xfs/xfs_reflink.c     |  5 ++++
> >  fs/xfs/xfs_trans.c       | 41 ++++++++++++++++++++++++--------
> >  fs/xfs/xfs_trans_dquot.c |  3 ---
> >  8 files changed, 121 insertions(+), 67 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> > index 80c8f851a2f3..d28dce0ed61a 100644
> > --- a/fs/xfs/xfs_dquot.h
> > +++ b/fs/xfs/xfs_dquot.h
> > @@ -183,6 +183,22 @@ xfs_dquot_is_enforced(
> >  	return false;
> >  }
> >  
> > +static inline bool
> > +xfs_dquot_hardlimit_exceeded(
> > +	struct xfs_dquot	*dqp)
> > +{
> > +	int64_t freesp;
> > +
> > +	if (!dqp)
> > +		return false;
> > +	if (!xfs_dquot_is_enforced(dqp))
> > +		return false;
> > +	xfs_dqlock(dqp);
> > +	freesp = dqp->q_blk.hardlimit - dqp->q_blk.reserved;
> > +	xfs_dqunlock(dqp);
> > +	return freesp < 0;
> > +}
> 
> Ok, what about if the project quota EDQUOT has come about because we
> are over the inode count limit or the realtime block limit? Both of
> those need to be converted to ENOSPC, too.
> 
> i.e. all the inode creation operation need to be checked against
> both the data device block space and the inode count space, whilst
> data writes need to be checked against data space for normal IO
> and both data space and real time space for inodes that are writing
> to real time devices.

(Yeah.)

> Also, why do we care about locking here? If something is modifying
> dqp->q_blk.reserved concurrently, holding the lock here does nothing
> to protect this code from races. All it means is that we we'll block
> waiting for the transaction that holds the dquot locked to complete
> and we'll either get the same random failure or success as if we
> didn't hold the lock during this calculation...

I thought we had to hold the dquot lock before accessing its fields.

Or are you really saying that it's silly to take the dquot lock *again*
having already decided (under dqlock elsewhere) that we were over a
quota?  In that case, perhaps it makes more sense to have
xfs_trans_dqresv return an unusual errno for "project quota over limits"
so that callers can trap that magic value and translate it into ENOSPC?

(Yes that's clunky but I've suggested that several times now and nobody
has replied to it directly.)

--D

> 
> > +
> >  /*
> >   * Check whether a dquot is under low free space conditions. We assume the quota
> >   * is enabled and enforced.
> > @@ -191,11 +207,11 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
> >  {
> >  	int64_t freesp;
> >  
> > +	xfs_dqlock(dqp);
> >  	freesp = dqp->q_blk.hardlimit - dqp->q_blk.reserved;
> > -	if (freesp < dqp->q_low_space[XFS_QLOWSP_1_PCNT])
> > -		return true;
> > +	xfs_dqunlock(dqp);
> >  
> > -	return false;
> > +	return freesp < dqp->q_low_space[XFS_QLOWSP_1_PCNT];
> >  }
> 
> That doesn't need locking for the same reason - it doesn't
> serialise/synchronise the accounting against anything
> useful, either..
> 
> >  
> >  void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index e33e5e13b95f..c19d82d922c5 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -24,6 +24,9 @@
> >  #include "xfs_pnfs.h"
> >  #include "xfs_iomap.h"
> >  #include "xfs_reflink.h"
> > +#include "xfs_quota.h"
> > +#include "xfs_dquot_item.h"
> > +#include "xfs_dquot.h"
> >  
> >  #include <linux/dax.h>
> >  #include <linux/falloc.h>
> > @@ -785,32 +788,18 @@ xfs_file_buffered_write(
> >  	trace_xfs_file_buffered_write(iocb, from);
> >  	ret = iomap_file_buffered_write(iocb, from,
> >  			&xfs_buffered_write_iomap_ops);
> > -
> > -	/*
> > -	 * If we hit a space limit, try to free up some lingering preallocated
> > -	 * space before returning an error. In the case of ENOSPC, first try to
> > -	 * write back all dirty inodes to free up some of the excess reserved
> > -	 * metadata space. This reduces the chances that the eofblocks scan
> > -	 * waits on dirty mappings. Since xfs_flush_inodes() is serialized, this
> > -	 * also behaves as a filter to prevent too many eofblocks scans from
> > -	 * running at the same time.  Use a synchronous scan to increase the
> > -	 * effectiveness of the scan.
> > -	 */
> > -	if (ret == -EDQUOT && !cleared_space) {
> > -		xfs_iunlock(ip, iolock);
> > -		xfs_blockgc_free_quota(ip, XFS_ICWALK_FLAG_SYNC);
> > -		cleared_space = true;
> > -		goto write_retry;
> > -	} else if (ret == -ENOSPC && !cleared_space) {
> > -		struct xfs_icwalk	icw = {0};
> > -
> > -		cleared_space = true;
> > -		xfs_flush_inodes(ip->i_mount);
> > -
> > -		xfs_iunlock(ip, iolock);
> > -		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
> > -		xfs_blockgc_free_space(ip->i_mount, &icw);
> > -		goto write_retry;
> > +	if (ret == -EDQUOT || ret == -ENOSPC) {
> > +		if (!cleared_space) {
> > +			xfs_iunlock(ip, iolock);
> > +			xfs_blockgc_nospace_flush(ip->i_mount, ip->i_udquot,
> > +						ip->i_gdquot, ip->i_pdquot,
> > +						XFS_ICWALK_FLAG_SYNC, ret);
> > +			cleared_space = true;
> > +			goto write_retry;
> > +		}
> > +		if (ret == -EDQUOT && xfs_dquot_hardlimit_exceeded(
> > +				ip->i_pdquot))
> > +			ret = -ENOSPC;
> >  	}
> 
> This isn't really I suggested. The code needs to be restructured to
> remove the "goto write_retry" case that makes understanding how this
> code works difficult.
> 
> It's also unnecessary to enumerate all the possible dquots for
> xfs_blockgc_nospace_flush() because we already have a blockgc
> function that does this for us - xfs_blockgc_free_quota(). This
> patch is made more complex than it needs to be by you attempt to
> optimise away xfs_blockgc_free_quota()....
> 
> >  
> >  out:
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index dba514a2c84d..d2dcb653befc 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -64,6 +64,10 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
> >  					 XFS_ICWALK_FLAG_RECLAIM_SICK | \
> >  					 XFS_ICWALK_FLAG_UNION)
> >  
> > +static int xfs_blockgc_free_dquots(struct xfs_mount *mp,
> > +		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
> > +		struct xfs_dquot *pdqp, unsigned int iwalk_flags);
> > +
> >  /*
> >   * Allocate and initialise an xfs_inode.
> >   */
> 
> If you need function prototypes, then it is likely that either the
> new code is in the wrong place or the factoring can be improved.
> 
> > @@ -1477,6 +1481,38 @@ xfs_blockgc_free_space(
> >  	return xfs_inodegc_flush(mp);
> >  }
> >  
> > +/*
> > + * If we hit a space limit, try to free up some lingering preallocated
> > + * space before returning an error. In the case of ENOSPC, first try to
> > + * write back all dirty inodes to free up some of the excess reserved
> > + * metadata space. This reduces the chances that the eofblocks scan
> > + * waits on dirty mappings. Since xfs_flush_inodes() is serialized, this
> > + * also behaves as a filter to prevent too many eofblocks scans from
> > + * running at the same time.  Use a synchronous scan to increase the
> > + * effectiveness of the scan.
> > + */
> > +void
> > +xfs_blockgc_nospace_flush(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_dquot	*udqp,
> > +	struct xfs_dquot	*gdqp,
> > +	struct xfs_dquot	*pdqp,
> > +	unsigned int		iwalk_flags,
> > +	int			what)
> > +{
> > +	ASSERT(what == -EDQUOT || what == -ENOSPC);
> > +
> > +	if (what == -EDQUOT) {
> > +		xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, iwalk_flags);
> > +	} else if (what == -ENOSPC) {
> > +		struct xfs_icwalk	icw = {0};
> > +
> > +		xfs_flush_inodes(mp);
> > +		icw.icw_flags = iwalk_flags;
> > +		xfs_blockgc_free_space(mp, &icw);
> > +	}
> > +}
> 
> This is messy, and it's also why you need that forward prototype.
> The EDQUOT case should just call xfs_blockgc_free_quota() and
> return, then there is no need for the "else if (ENOSPC)" case.
> 
> > +
> >  /*
> >   * Reclaim all the free space that we can by scheduling the background blockgc
> >   * and inodegc workers immediately and waiting for them all to clear.
> > @@ -1515,7 +1551,7 @@ xfs_blockgc_flush_all(
> >   * (XFS_ICWALK_FLAG_SYNC), the caller also must not hold any inode's IOLOCK or
> >   * MMAPLOCK.
> >   */
> > -int
> > +static int
> >  xfs_blockgc_free_dquots(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_dquot	*udqp,
> > @@ -1559,18 +1595,6 @@ xfs_blockgc_free_dquots(
> >  	return xfs_blockgc_free_space(mp, &icw);
> >  }
> >  
> > -/* Run cow/eofblocks scans on the quotas attached to the inode. */
> > -int
> > -xfs_blockgc_free_quota(
> > -	struct xfs_inode	*ip,
> > -	unsigned int		iwalk_flags)
> > -{
> > -	return xfs_blockgc_free_dquots(ip->i_mount,
> > -			xfs_inode_dquot(ip, XFS_DQTYPE_USER),
> > -			xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
> > -			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), iwalk_flags);
> > -}
> > -
> >  /* XFS Inode Cache Walking Code */
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> > index 905944dafbe5..c0833450969d 100644
> > --- a/fs/xfs/xfs_icache.h
> > +++ b/fs/xfs/xfs_icache.h
> > @@ -57,11 +57,10 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, unsigned long nr_to_scan);
> >  
> >  void xfs_inode_mark_reclaimable(struct xfs_inode *ip);
> >  
> > -int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
> > -		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
> > -		unsigned int iwalk_flags);
> > -int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
> >  int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
> > +void xfs_blockgc_nospace_flush(struct xfs_mount *mp, struct xfs_dquot *udqp,
> > +			struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
> > +			unsigned int iwalk_flags, int what);
> >  int xfs_blockgc_flush_all(struct xfs_mount *mp);
> >  
> >  void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c0f1c89786c2..0dcb614da7df 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -27,6 +27,8 @@
> >  #include "xfs_errortag.h"
> >  #include "xfs_error.h"
> >  #include "xfs_quota.h"
> > +#include "xfs_dquot_item.h"
> > +#include "xfs_dquot.h"
> >  #include "xfs_filestream.h"
> >  #include "xfs_trace.h"
> >  #include "xfs_icache.h"
> > @@ -1007,12 +1009,6 @@ xfs_create(
> >  	 */
> >  	error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp, resblks,
> >  			&tp);
> > -	if (error == -ENOSPC) {
> > -		/* flush outstanding delalloc blocks and retry */
> > -		xfs_flush_inodes(mp);
> > -		error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp,
> > -				resblks, &tp);
> > -	}
> >  	if (error)
> >  		goto out_release_dquots;
> >  
> > @@ -2951,14 +2947,21 @@ xfs_rename(
> >  	if (spaceres != 0) {
> >  		error = xfs_trans_reserve_quota_nblks(tp, target_dp, spaceres,
> >  				0, false);
> > -		if (error == -EDQUOT || error == -ENOSPC) {
> > +		if (error == -EDQUOT) {
> >  			if (!retried) {
> >  				xfs_trans_cancel(tp);
> > -				xfs_blockgc_free_quota(target_dp, 0);
> > +				xfs_blockgc_nospace_flush(target_dp->i_mount,
> > +							target_dp->i_udquot,
> > +							target_dp->i_gdquot,
> > +							target_dp->i_pdquot,
> > +							0, error);
> 
> Why do we need to change this? The current call to
> xfs_blockgc_free_quota() is correct and there's no need to call
> xfs_blockgc_nospace_flush() because ENOSPC can no longer occur here.
> 
> >  				retried = true;
> >  				goto retry;
> >  			}
> >  
> > +			if (xfs_dquot_hardlimit_exceeded(target_dp->i_pdquot))
> > +				error = -ENOSPC;
> > +
> >  			nospace_error = error;
> >  			spaceres = 0;
> >  			error = 0;
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index e5b62dc28466..a94691348784 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -25,6 +25,8 @@
> >  #include "xfs_bit.h"
> >  #include "xfs_alloc.h"
> >  #include "xfs_quota.h"
> > +#include "xfs_dquot_item.h"
> > +#include "xfs_dquot.h"
> >  #include "xfs_reflink.h"
> >  #include "xfs_iomap.h"
> >  #include "xfs_ag.h"
> > @@ -1270,6 +1272,9 @@ xfs_reflink_remap_extent(
> >  	if (!quota_reserved && !smap_real && dmap_written) {
> >  		error = xfs_trans_reserve_quota_nblks(tp, ip,
> >  				dmap->br_blockcount, 0, false);
> > +		if (error == -EDQUOT && xfs_dquot_hardlimit_exceeded(
> > +				ip->i_pdquot))
> > +			error = -ENOSPC;
> 
> Break the line logically, not at function parameters.
> 
> 		if (error == -EDQUOT &&
> 		    xfs_dquot_hardlimit_exceeded(ip->i_pdquot))
> 			error = -ENOSPC;
> 
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 305c9d07bf1b..3b930f3472c5 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -1217,15 +1217,22 @@ xfs_trans_alloc_inode(
> >  	}
> >  
> >  	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
> > -	if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
> > +	if (error == -EDQUOT && !retried) {
> >  		xfs_trans_cancel(tp);
> >  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -		xfs_blockgc_free_quota(ip, 0);
> > +		xfs_blockgc_nospace_flush(ip->i_mount, ip->i_udquot,
> > +					ip->i_gdquot, ip->i_pdquot,
> > +					0, error);
> 
> Again, xfs_blockgc_free_quota() is the right thing to call here
> because -ENOSPC cannot be returned anymore. 
> 
> >  		retried = true;
> >  		goto retry;
> >  	}
> > -	if (error)
> > +	if (error) {
> > +		if (error == -EDQUOT && xfs_dquot_hardlimit_exceeded(
> > +				ip->i_pdquot))
> > +			error = -ENOSPC;
> > +
> >  		goto out_cancel;
> > +	}
> 
> The error handling can be done much cleaner:
> 
> 	if (error == -EDQUOT) {
> 		if (retries++ > 0) {
> 			if (xfs_dquot_hardlimit_exceeded(pdqp))
> 				error = -ENOSPC;
> 			goto out_cancel;
> 		}
> 		xfs_trans_cancel(tp);
> 		xfs_blockgc_free_quota(ip, 0);
> 		goto retry;
> 	}
> 
> 	if (error)
> 		goto out_cancel;
> 
> >  
> >  	*tpp = tp;
> >  	return 0;
> > @@ -1260,13 +1267,16 @@ xfs_trans_alloc_icreate(
> >  		return error;
> >  
> >  	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, dblocks);
> > -	if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
> > +	if (error == -EDQUOT && !retried) {
> >  		xfs_trans_cancel(tp);
> > -		xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, 0);
> > +		xfs_blockgc_nospace_flush(mp, udqp, gdqp, pdqp, 0, error);
> >  		retried = true;
> >  		goto retry;
> >  	}
> >  	if (error) {
> > +		if (error == -EDQUOT && xfs_dquot_hardlimit_exceeded(pdqp))
> > +			error = -ENOSPC;
> 
> This needs to check fo inode count beeing exceed for ENOSPC.
> 
> > +
> >  		xfs_trans_cancel(tp);
> >  		return error;
> >  	}
> 
> Same comments - xfs_blockgc_free_dquots() is just fine here,
> error handling is neater as per above.
> 
> > @@ -1340,14 +1350,20 @@ xfs_trans_alloc_ichange(
> >  		error = xfs_trans_reserve_quota_bydquots(tp, mp, udqp, gdqp,
> >  				pdqp, ip->i_nblocks + ip->i_delayed_blks,
> >  				1, qflags);
> > -		if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
> > +		if (error == -EDQUOT && !retried) {
> >  			xfs_trans_cancel(tp);
> > -			xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, 0);
> > +			xfs_blockgc_nospace_flush(mp, udqp, gdqp, pdqp, 0,
> > +						error);
> >  			retried = true;
> >  			goto retry;
> >  		}
> > -		if (error)
> > +		if (error) {
> > +			if (error == -EDQUOT && xfs_dquot_hardlimit_exceeded(
> > +					pdqp))
> > +				error = -ENOSPC;
> > +
> >  			goto out_cancel;
> > +		}
> 
> Same again.
> 
> >  	}
> >  
> >  	*tpp = tp;
> > @@ -1419,14 +1435,19 @@ xfs_trans_alloc_dir(
> >  		goto done;
> >  
> >  	error = xfs_trans_reserve_quota_nblks(tp, dp, resblks, 0, false);
> > -	if (error == -EDQUOT || error == -ENOSPC) {
> > +	if (error == -EDQUOT) {
> >  		if (!retried) {
> >  			xfs_trans_cancel(tp);
> > -			xfs_blockgc_free_quota(dp, 0);
> > +			xfs_blockgc_nospace_flush(dp->i_mount, ip->i_udquot,
> > +						ip->i_gdquot, ip->i_pdquot,
> > +						0, error);
> >  			retried = true;
> >  			goto retry;
> >  		}
> >  
> > +		if (xfs_dquot_hardlimit_exceeded(dp->i_pdquot))
> > +			error = -ENOSPC;
> > +
> 
> And again.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
