Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53266 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752630AbeDXOIs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Apr 2018 10:08:48 -0400
Date: Tue, 24 Apr 2018 07:08:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/13] xfs: refactor xfs_qm_dqtobp and xfs_qm_dqalloc
Message-ID: <20180424140822.GG26268@magnolia>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
 <152440960423.29601.4842354354335883165.stgit@magnolia>
 <20180424130731.GA50204@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424130731.GA50204@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Tue, Apr 24, 2018 at 09:07:31AM -0400, Brian Foster wrote:
> On Sun, Apr 22, 2018 at 08:06:44AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Separate the disk dquot read and allocation functionality into
> > two helper functions, then refactor dqread to call them directly.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_dquot.c |  261 ++++++++++++++++++++--------------------------------
> >  1 file changed, 99 insertions(+), 162 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index 7154909..ef4cd56 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> ...
> > @@ -574,74 +532,53 @@ xfs_qm_dqread(
> >  	xfs_dqid_t		id,
> >  	uint			type,
> >  	uint			flags,
> > -	struct xfs_dquot	**O_dqpp)
> > +	struct xfs_dquot	**dqpp)
> >  {
> >  	struct xfs_dquot	*dqp;
> > -	struct xfs_disk_dquot	*ddqp;
> >  	struct xfs_buf		*bp;
> > -	struct xfs_trans	*tp = NULL;
> > +	struct xfs_trans	*tp;
> >  	int			error;
> >  
> >  	dqp = xfs_qm_dqinit_once(mp, id, type);
> >  	trace_xfs_dqread(dqp);
> >  
> > -	if (flags & XFS_QMOPT_DQALLOC) {
> > +	/* Try to read the buffer... */
> > +	error = xfs_qm_dqread_ondisk(mp, dqp, &bp);
> > +	if (error == -ENOENT && (flags & XFS_QMOPT_DQALLOC)) {
> > +		/* ...or allocate a new block and buffer. */
> >  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
> >  				XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
> >  		if (error)
> > -			goto error0;
> > -	}
> > +			goto err;
> >  
> > -	/*
> > -	 * get a pointer to the on-disk dquot and the buffer containing it
> > -	 * dqp already knows its own type (GROUP/USER).
> > -	 */
> > -	error = xfs_qm_dqtobp(&tp, dqp, &ddqp, &bp, flags);
> > -	if (error) {
> > -		/*
> > -		 * This can happen if quotas got turned off (ESRCH),
> > -		 * or if the dquot didn't exist on disk and we ask to
> > -		 * allocate (ENOENT).
> > -		 */
> > -		trace_xfs_dqread_fail(dqp);
> > -		goto error1;
> > -	}
> > +		error = xfs_qm_dqalloc_ondisk(&tp, dqp, &bp);
> > +		if (error)
> > +			goto err_cancel;
> >  
> > -	xfs_qm_dqinit_from_buf(dqp, ddqp);
> > +		error = xfs_trans_commit(tp);
> > +	}
> > +	ASSERT(xfs_buf_islocked(bp));
> 
> Doesn't this fail if the tx commit above fails? Granted we've probably
> shut down...
> 
> Otherwise looks fine modulo Christoph's comments.
> 
> Brian
> 
> P.S., I see that assert was fixed up in the next patch, but then we have
> a couple of the same calls separated by the init call. That probably
> should be fixed up here in any event...

Aha, that's where that fix went, sorry. :(

--D

> 
> > +	if (error)
> > +		goto err;
> >  
> > -	/* Mark the buf so that this will stay incore a little longer */
> > -	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
> > +	xfs_qm_dqinit_from_buf(dqp, bp);
> >  
> >  	/*
> > -	 * We got the buffer with a xfs_trans_read_buf() (in dqtobp())
> > -	 * So we need to release with xfs_trans_brelse().
> > -	 * The strategy here is identical to that of inodes; we lock
> > -	 * the dquot in xfs_qm_dqget() before making it accessible to
> > -	 * others. This is because dquots, like inodes, need a good level of
> > -	 * concurrency, and we don't want to take locks on the entire buffers
> > -	 * for dquot accesses.
> > -	 * Note also that the dquot buffer may even be dirty at this point, if
> > -	 * this particular dquot was repaired. We still aren't afraid to
> > -	 * brelse it because we have the changes incore.
> > +	 * At this point we should have a clean locked buffer.  Release the
> > +	 * buffer since the incore dquot has its own copy and locking
> > +	 * protocol so we needn't tie up the buffer any further.
> >  	 */
> >  	ASSERT(xfs_buf_islocked(bp));
> > -	xfs_trans_brelse(tp, bp);
> > -
> > -	if (tp) {
> > -		error = xfs_trans_commit(tp);
> > -		if (error)
> > -			goto error0;
> > -	}
> > -
> > -	*O_dqpp = dqp;
> > +	xfs_buf_relse(bp);
> > +	*dqpp = dqp;
> >  	return error;
> >  
> > -error1:
> > -	if (tp)
> > -		xfs_trans_cancel(tp);
> > -error0:
> > +err_cancel:
> > +	xfs_trans_cancel(tp);
> > +err:
> > +	trace_xfs_dqread_fail(dqp);
> >  	xfs_qm_dqdestroy(dqp);
> > -	*O_dqpp = NULL;
> > +	*dqpp = NULL;
> >  	return error;
> >  }
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
