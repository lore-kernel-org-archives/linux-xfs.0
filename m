Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbeACAJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 19:09:24 -0500
Date: Tue, 2 Jan 2018 16:09:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/20] xfs: refactor verifier callers to print address of
 failing check
Message-ID: <20180103000917.GI4857@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399126849.23543.12256432171396478044.stgit@magnolia>
 <20180102234423.GB5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180102234423.GB5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 03, 2018 at 10:44:23AM +1100, Dave Chinner wrote:
> On Fri, Dec 22, 2017 at 05:07:48PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor the callers of verifiers to print the instruction address of a
> > failing check.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> .....
> > @@ -2455,13 +2461,16 @@ xfs_agf_read_verify(
> >  	struct xfs_buf	*bp)
> >  {
> >  	struct xfs_mount *mp = bp->b_target->bt_mount;
> > +	xfs_failaddr_t	fa;
> >  
> >  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> >  	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
> > -		xfs_verifier_error(bp, -EFSBADCRC);
> > -	else if (XFS_TEST_ERROR(xfs_agf_verify(mp, bp), mp,
> > -				XFS_ERRTAG_ALLOC_READ_AGF))
> > -		xfs_verifier_error(bp, -EFSCORRUPTED);
> > +		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
> > +	else {
> > +		fa = xfs_agf_verify(mp, bp);
> > +		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_ALLOC_READ_AGF))
> > +			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
> > +	}
> >  }
> 
> That's much nicer than the last iteration :)
> 
> .....
> 
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index c0a98c4..7e58a99 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -348,15 +348,18 @@ xfs_corruption_error(
> >  void
> >  xfs_verifier_error(
> >  	struct xfs_buf		*bp,
> > -	int			error)
> > +	int			error,
> > +	xfs_failaddr_t		failaddr)
> >  {
> >  	struct xfs_mount *mp = bp->b_target->bt_mount;
> > +	xfs_failaddr_t		fa;
> >  
> > -	__xfs_buf_ioerror(bp, error, __return_address);
> > +	fa = failaddr ? failaddr : __return_address;
> > +	__xfs_buf_ioerror(bp, error, failaddr);
> 
> I'm a little unsure of this. Why pass failaddr to
> __xfs_buf_ioerror() rather than fa?

Oops.  Yeah, that should be fa, not failaddr.

--D

> Otherwise, everything looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
