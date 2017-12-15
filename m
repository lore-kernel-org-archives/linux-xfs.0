Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:5616 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754706AbdLODJO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 22:09:14 -0500
Date: Fri, 15 Dec 2017 14:09:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/13] xfs: refactor verifier callers to print address of
 failing check
Message-ID: <20171215030909.GK5858@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320951732.30654.12381419566973424218.stgit@magnolia>
 <20171214220326.GI5858@dastard>
 <20171215000409.GM13436@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171215000409.GM13436@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 14, 2017 at 04:04:09PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 15, 2017 at 09:03:26AM +1100, Dave Chinner wrote:
> > On Wed, Dec 13, 2017 at 03:58:37PM -0800, Darrick J. Wong wrote:
> > >   */
> > >  void
> > >  xfs_verifier_error(
> > > -	struct xfs_buf		*bp)
> > > +	struct xfs_buf		*bp,
> > > +	xfs_failaddr_t		fa)
> > >  {
> > >  	struct xfs_mount *mp = bp->b_target->bt_mount;
> > >  
> > >  	xfs_alert(mp, "Metadata %s detected at %pS, %s block 0x%llx",
> > >  		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
> > > -		  __return_address, bp->b_ops->name, bp->b_bn);
> > > +		  fa ? fa : __return_address, bp->b_ops->name,
> > > +		  bp->b_bn);
> > >  
> > >  	xfs_alert(mp, "Unmount and run xfs_repair");
> > 
> > I'm also wondering if we should move the xfs_buf_ioerror() call
> > inside this function, too, rather than coding multiple calls in the
> > verifiers to set bp->b_error in each branch of the verifier that
> > has an error...
> 
> What, something like:
> 
> 	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF)) {
> 		fa = __this_address;
> 		error = -EFSBADCRC;
> 	} else {
> 		fa = xfs_agfl_verify(bp);
> 		if (fa)
> 			error = -EFSCORRUPTED;
> 	}
> 
> 	if (error)
> 		xfs_verifier_error(bp, fa, error);
> 

Yeah, seems like a better approach because we don't have to
put the error on the buffer before calling xfs_verifier_error(). fa
tells us exactly where the error wasdetected, so we don't need
xfs_buf_ioerror() to tell us that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
