Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbeJFKRq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 06:17:46 -0400
Date: Fri, 5 Oct 2018 20:15:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: always assign buffer verifiers when one is
 provided
Message-ID: <20181006031555.GD28243@magnolia>
References: <153870045847.29695.10286947858219936840.stgit@magnolia>
 <153870047100.29695.14645106534029933489.stgit@magnolia>
 <20181005115712.GB54400@bfoster>
 <20181005170251.GS19324@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005170251.GS19324@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Oct 05, 2018 at 10:02:51AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 05, 2018 at 07:57:13AM -0400, Brian Foster wrote:
> > On Thu, Oct 04, 2018 at 05:47:51PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > If a caller supplies buffer ops when trying to read a buffer and the
> > > buffer doesn't already have buf ops assigned, ensure that the ops are
> > > assigned to the buffer and the verifier is run on that buffer.
> > > 
> > > Note that current XFS code is careful to assign buffer ops after a
> > > xfs_{trans_,}buf_read call in which ops were not supplied.  However, we
> > > should apply ops defensively in case there is ever a coding mistake; and
> > > an upcoming repair patch will need to be able to read a buffer without
> > > assigning buf ops.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > Just a few nits..
> > 
> > >  fs/xfs/xfs_buf.c       |   64 +++++++++++++++++++++++++++++++++++-------------
> > >  fs/xfs/xfs_buf.h       |    3 ++
> > >  fs/xfs/xfs_trans_buf.c |   28 +++++++++++++++++++++
> > >  3 files changed, 78 insertions(+), 17 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index e839907e8492..3adfa139dcfe 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -749,6 +749,29 @@ _xfs_buf_read(
> > >  	return xfs_buf_submit(bp);
> > >  }
> > >  
> > > +/*
> > > + * If the caller passed in an ops structure and the buffer doesn't have ops
> > > + * assigned, set the ops and use them to verify the contents.  If the contents
> > > + * cannot be verified, we'll clear XBF_DONE.
> > > + */
> > > +int
> > > +xfs_buf_ensure_ops(
> > > +	struct xfs_buf		*bp,
> > > +	const struct xfs_buf_ops *ops)
> > > +{
> > > +	ASSERT(bp->b_flags & XBF_DONE);
> > > +
> > > +	if (!ops || bp->b_ops)
> > > +		return 0;
> > > +
> > > +	bp->b_error = 0;
> > 
> > If we only call this for XBF_DONE buffers, does that mean that ->b_error
> > should also be zero already? Is it worth adding that to the assert above
> > instead of resetting it?
> 
> Hmm, yes, I think b_error ought to be zero on the way into this
> function.
> 
> > > +	bp->b_ops = ops;
> > > +	bp->b_ops->verify_read(bp);
> > > +	if (bp->b_error)
> > > +		bp->b_flags &= ~XBF_DONE;
> > > +	return bp->b_error;
> > > +}
> > > +
> > >  xfs_buf_t *
> > >  xfs_buf_read_map(
> > >  	struct xfs_buftarg	*target,
> > > @@ -762,26 +785,33 @@ xfs_buf_read_map(
> > >  	flags |= XBF_READ;
> > >  
> > >  	bp = xfs_buf_get_map(target, map, nmaps, flags);
> > > -	if (bp) {
> > > -		trace_xfs_buf_read(bp, flags, _RET_IP_);
> > > +	if (!bp)
> > > +		return NULL;
> > >  
> > > -		if (!(bp->b_flags & XBF_DONE)) {
> > > -			XFS_STATS_INC(target->bt_mount, xb_get_read);
> > > -			bp->b_ops = ops;
> > > -			_xfs_buf_read(bp, flags);
> > > -		} else if (flags & XBF_ASYNC) {
> > > -			/*
> > > -			 * Read ahead call which is already satisfied,
> > > -			 * drop the buffer
> > > -			 */
> > > -			xfs_buf_relse(bp);
> > > -			return NULL;
> > > -		} else {
> > > -			/* We do not want read in the flags */
> > > -			bp->b_flags &= ~XBF_READ;
> > > -		}
> > > +	trace_xfs_buf_read(bp, flags, _RET_IP_);
> > > +
> > > +	if (!(bp->b_flags & XBF_DONE)) {
> > > +		XFS_STATS_INC(target->bt_mount, xb_get_read);
> > > +		bp->b_ops = ops;
> > > +		_xfs_buf_read(bp, flags);
> > > +		ASSERT(bp->b_ops != NULL || ops == NULL);
> > 
> > I like having this assert sprinkled around as well, but I'm wondering if
> > we can (safely) make it a bit stronger:
> > 
> > 		ASSERT(bp->b_ops == ops || !ops);

This doesn't work because xfs_da3_node_buf_ops can change b_ops to the
leaf1 or leafn buffer ops, which means that subsequent re-reads of the
same buffer will blow the assert even though everything's fine.  I'm
going to leave it as it was.

(I tried xfstests and it kablooie with assertion failures everywhere.)

--D

> > 
> > I think the !ops check is necessary to cover the case of reading a
> > verified buffer from scrub context (where we don't know the appropriate
> > verifier), but with the current approach we should never pass in the
> > wrong ops for a verified buffer, right?
> 
> That *particular* ASSERT I think is the pointless result of
> overeagerness on my part. :)
> 
> But yes, the rest of them ought to be as you say.  We never want the
> situation where the read caller passes in bufops A but it really has
> bufops B.
> 
> TBH since ASSERTs disappear in CONFIG_XFS_DEBUG=n mode, maybe we should
> complain a little louder about this sort of misprogramming?  I'll look
> into doing something like...
> 
> void
> xfs_buf_confirm_ops(bp, ops)
> {
> 	bool	wrong_ops = ops && bp->b_ops != ops;
> 
> 	if (!wrong_ops)
> 		return;
> 	WARN_ON(wrong_ops, "Metadata verifier mismatch at %pS",
> 			__return_address;
> 	xfs_force_shutdown(...);
> }

> > 
> > > +		return bp;
> > > +	}
> > > +
> > > +	xfs_buf_ensure_ops(bp, ops);
> > > +
> > > +	if (flags & XBF_ASYNC) {
> > > +		/*
> > > +		 * Read ahead call which is already satisfied,
> > > +		 * drop the buffer
> > > +		 */
> > > +		xfs_buf_relse(bp);
> > > +		return NULL;
> > >  	}
> > >  
> > > +	/* We do not want read in the flags */
> > > +	bp->b_flags &= ~XBF_READ;
> > > +	ASSERT(bp->b_ops != NULL || ops == NULL);
> > >  	return bp;
> > >  }
> > >  
> > > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > > index 4e3171acd0f8..526bc7e9e7fc 100644
> > > --- a/fs/xfs/xfs_buf.h
> > > +++ b/fs/xfs/xfs_buf.h
> > > @@ -385,4 +385,7 @@ extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
> > >  #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
> > >  #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
> > >  
> > > +extern int xfs_buf_ensure_ops(struct xfs_buf *bp,
> > > +		const struct xfs_buf_ops *ops);
> > > +
> > >  #endif	/* __XFS_BUF_H__ */
> > > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > > index 15919f67a88f..b0ba2ca9cca3 100644
> > > --- a/fs/xfs/xfs_trans_buf.c
> > > +++ b/fs/xfs/xfs_trans_buf.c
> > > @@ -264,11 +264,38 @@ xfs_trans_read_buf_map(
> > >  			return -EIO;
> > >  		}
> > >  
> > > +		/*
> > > +		 * The caller is trying to read a buffer that is already
> > 
> > "Check if the caller is trying ..." ?
> > 
> > Nits aside:
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Will fix, thanks for the review!
> 
> --D
> 
> > > +		 * attached to the transaction yet has no buffer ops assigned.
> > > +		 * Ops are usually attached when the buffer is attached to the
> > > +		 * transaction, or by the read caller in special circumstances.
> > > +		 * That didn't happen, which is not how this is supposed to go.
> > > +		 *
> > > +		 * If the buffer passes verification we'll let this go, but if
> > > +		 * not we have to shut down.  Let the transaction cleanup code
> > > +		 * release this buffer when it kills the tranaction.
> > > +		 */
> > > +		ASSERT(bp->b_ops != NULL);
> > > +		error = xfs_buf_ensure_ops(bp, ops);
> > > +		if (error) {
> > > +			xfs_buf_ioerror_alert(bp, __func__);
> > > +
> > > +			if (tp->t_flags & XFS_TRANS_DIRTY)
> > > +				xfs_force_shutdown(tp->t_mountp,
> > > +						SHUTDOWN_META_IO_ERROR);
> > > +
> > > +			/* bad CRC means corrupted metadata */
> > > +			if (error == -EFSBADCRC)
> > > +				error = -EFSCORRUPTED;
> > > +			return error;
> > > +		}
> > > +
> > >  		bip = bp->b_log_item;
> > >  		bip->bli_recur++;
> > >  
> > >  		ASSERT(atomic_read(&bip->bli_refcount) > 0);
> > >  		trace_xfs_trans_read_buf_recur(bip);
> > > +		ASSERT(bp->b_ops != NULL || ops == NULL);
> > >  		*bpp = bp;
> > >  		return 0;
> > >  	}
> > > @@ -316,6 +343,7 @@ xfs_trans_read_buf_map(
> > >  		_xfs_trans_bjoin(tp, bp, 1);
> > >  		trace_xfs_trans_read_buf(bp->b_log_item);
> > >  	}
> > > +	ASSERT(bp->b_ops != NULL || ops == NULL);
> > >  	*bpp = bp;
> > >  	return 0;
> > >  
> > > 
