Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59078 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732639AbeHGRlm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Aug 2018 13:41:42 -0400
Date: Tue, 7 Aug 2018 08:26:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs: cancel dfops on xfs_defer_finish() error
Message-ID: <20180807152644.GC30972@magnolia>
References: <18f3296d-e5d4-4d76-51f8-a40d0ceaa20e@canonical.com>
 <20180807143720.GA55416@bfoster>
 <20180807151029.GA30972@magnolia>
 <20180807151836.GB55416@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180807151836.GB55416@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Colin Ian King <colin.king@canonical.com>, linux-xfs@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, Aug 07, 2018 at 11:18:36AM -0400, Brian Foster wrote:
> On Tue, Aug 07, 2018 at 08:10:29AM -0700, Darrick J. Wong wrote:
> > On Tue, Aug 07, 2018 at 10:37:21AM -0400, Brian Foster wrote:
> > > On Tue, Aug 07, 2018 at 03:14:07PM +0100, Colin Ian King wrote:
> > > > Hi,
> > > > 
> > > > Recent commit 82ff27bc52a88cb5cc400bfa64e210d3ec8dfebd ("xfs: automatic
> > > > dfops buffer relogging") removed the assignment of variable error:
> > > > 
> > > > -       error = xfs_defer_bjoin(tp->t_dfops, bp);
> > > >         if (error) {
> > > >                 xfs_trans_bhold_release(tp, bp);
> > > >                 xfs_trans_brelse(tp, bp);
> > > > 
> > > 
> > > Hmm, I _think_ we can just drop these error checks now that this
> > > pre-finish error state is non-existent, something like the appended diff
> > > (with additional cleanups). E.g., if the buffer is held in the
> > > transaction then the bjoin is implicit. If the finish fails, then the
> > > state is essentially unchanged by the relogging patch.
> > > 
> > > That said, the error handling is a bit tricky here. Darrick, I think you
> > > reworked this recently.. thoughts?
> > > 
> > > Brian
> > > 
> > > --- 8< ---
> > > 
> > > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > > index 70a76ac41f01..2106c4142ecd 100644
> > > --- a/fs/xfs/xfs_dquot.c
> > > +++ b/fs/xfs/xfs_dquot.c
> > > @@ -311,7 +311,7 @@ xfs_dquot_disk_alloc(
> > >  			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
> > >  			XFS_QM_DQALLOC_SPACE_RES(mp), &map, &nmaps);
> > >  	if (error)
> > > -		goto error0;
> > > +		return error;
> > >  	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
> > >  	ASSERT(nmaps == 1);
> > >  	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> > > @@ -326,8 +326,8 @@ xfs_dquot_disk_alloc(
> > >  	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, dqp->q_blkno,
> > >  			mp->m_quotainfo->qi_dqchunklen, 0);
> > >  	if (!bp) {
> > > -		error = -ENOMEM;
> > > -		goto error1;
> > > +		xfs_defer_cancel(tp);
> > > +		return -ENOMEM;
> > 
> > The only caller of xfs_dquot_disk_alloc checks the return value and
> > xfs_trans_cancels the transaction, which should take care of calling
> > xfs_defer_cancel, right?
> > 
> 
> Yeah. IIRC I originally left the defer_cancel() alone in this function
> just to be consistent, since it calls xfs_defer_finish() as well on the
> caller's transaction. Technically I don't think it matters either way,
> so I don't have much preference on if it stays or goes (assuming the
> other changes are correct)...

I can't think of a good reason for anything (except xfs_trans_cancel) to
call xfs_defer_cancel.  It's never correct to kill all the deferred ops
attached to a transaction and then continue logging things to the
transaction, which means that the only thing you can really do after
cancelling the dfops is to cancel the transaction.  I'd have to look
more carefully but I think all the remaining callers can all go away.

xfs_defer_finish is a different story -- it can be used (by online
repair for example) to process the deferred operations so they don't sit
around pinning memory and log, even if there's a lot more work to be
done before _trans_commit.  But I don't think we need to _defer_cancel
if things go awry.

--D

> Brian
> 
> > --D
> > 
> > >  	}
> > >  	bp->b_ops = &xfs_dquot_buf_ops;
> > >  
> > > @@ -349,10 +349,8 @@ xfs_dquot_disk_alloc(
> > >  	 * the buffer locked across the _defer_finish call.  We can now do
> > >  	 * this correctly with xfs_defer_bjoin.
> > >  	 *
> > > -	 * Above, we allocated a disk block for the dquot information and
> > > -	 * used get_buf to initialize the dquot.  If the _defer_bjoin fails,
> > > -	 * the buffer is still locked to *tpp, so we must _bhold_release and
> > > -	 * then _trans_brelse the buffer.  If the _defer_finish fails, the old
> > > +	 * Above, we allocated a disk block for the dquot information and used
> > > +	 * get_buf to initialize the dquot. If the _defer_finish fails, the old
> > >  	 * transaction is gone but the new buffer is not joined or held to any
> > >  	 * transaction, so we must _buf_relse it.
> > >  	 *
> > > @@ -362,24 +360,14 @@ xfs_dquot_disk_alloc(
> > >  	 * manually or by committing the transaction.
> > >  	 */
> > >  	xfs_trans_bhold(tp, bp);
> > > -	if (error) {
> > > -		xfs_trans_bhold_release(tp, bp);
> > > -		xfs_trans_brelse(tp, bp);
> > > -		goto error1;
> > > -	}
> > >  	error = xfs_defer_finish(tpp);
> > >  	tp = *tpp;
> > >  	if (error) {
> > >  		xfs_buf_relse(bp);
> > > -		goto error0;
> > > +		return error;
> > >  	}
> > >  	*bpp = bp;
> > >  	return 0;
> > > -
> > > -error1:
> > > -	xfs_defer_cancel(tp);
> > > -error0:
> > > -	return error;
> > >  }
> > >  
> > >  /*
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
