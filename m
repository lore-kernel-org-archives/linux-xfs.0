Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:61178 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751539AbdLSUxm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 15:53:42 -0500
Date: Wed, 20 Dec 2017 07:53:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/13] xfs: create a new buf_ops pointer to verify
 structure metadata
Message-ID: <20171219205339.GB4094@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320956591.30654.3796756077270484760.stgit@magnolia>
 <20171219062205.GV4094@dastard>
 <20171219181529.GB11969@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219181529.GB11969@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 19, 2017 at 10:15:29AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 19, 2017 at 05:22:05PM +1100, Dave Chinner wrote:
> > On Wed, Dec 13, 2017 at 03:59:25PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Expose all metadata structure buffer verifier functions via buf_ops.
> > > These will be used by the online scrub mechanism to look for problems
> > > with buffers that are already sitting around in memory.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > ....
> > > @@ -2468,7 +2478,7 @@ xfs_agf_read_verify(
> > >  	.verify_write = xfs_attr3_leaf_write_verify,
> > > +	.verify_struct = xfs_attr3_leaf_verify,
> > >  };
> > >  
> > >  int
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > > index d4d2902..1be995b 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > > @@ -204,10 +204,42 @@ xfs_attr3_rmt_write_verify(
> > >  	ASSERT(len == 0);
> > >  }
> > >  
> > > +static xfs_failaddr_t
> > > +xfs_attr3_rmt_verify_struct(
> > > +	struct xfs_buf	*bp)
> > > +{
> > > +	struct xfs_mount *mp = bp->b_target->bt_mount;
> > > +	char		*ptr;
> > > +	void		*failed_at;
> > > +	int		len;
> > > +	xfs_daddr_t	bno;
> > > +	int		blksize = mp->m_attr_geo->blksize;
> > > +
> > > +	/* no verification of non-crc buffers */
> > > +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> > > +		return NULL;
> > > +
> > > +	ptr = bp->b_addr;
> > > +	bno = bp->b_bn;
> > > +	len = BBTOB(bp->b_length);
> > > +	ASSERT(len >= blksize);
> > > +
> > > +	while (len > 0) {
> > > +		if ((failed_at = xfs_attr3_rmt_verify(mp, ptr, blksize, bno)))
> > > +			return failed_at;
> > > +		len -= blksize;
> > > +		ptr += blksize;
> > > +		bno += BTOBB(blksize);
> > > +	}
> > > +
> > > +	return NULL;
> > > +}
> > 
> > I'd much prefer to see this combined with
> > xfs_attr3_rmt_read_verify() rather than having another copy of this
> > iteration code. They really only vary by whether the CRC is checked
> > in the loop....
> > 
> > ....
> > 
> > > +static xfs_failaddr_t
> > > +xfs_dquot_buf_verify_struct(
> > > +	struct xfs_buf	*bp)
> > > +{
> > > +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > > +
> > > +	if (!xfs_dquot_buf_verify(mp, bp, 0))
> > > +		return __this_address;
> > > +	return NULL;
> > > +}
> > 
> > I can't remember what happened exactly with dquot buffers earlire in
> > the patchset, but why isn't it returning a failaddr like all the
> > other structure verifiers?
> 
> The dquot verifiers are sufficiently different from everything else
> (verbose error reporting, some ability to zap garbage data) that I was
> going to send that as a separate cleanup series.
> 
> I /think/ the solution is to disentangle xfs_dqcheck into a separate
> check routine that returns xfs_failaddr_t like everything else (at a
> cost of the removal of all the xfs_alert calls) so that the error
> reports become "xfs: quota buffer XXX error at xfs_dqcheck+0x74" like
> everything else.  The caller becomes directly responsible for printing a
> warning message (instead of XFS_QMOPT_DOWARN).
> 
> Then, the quota repair piece becomes a separate function which the
> XFS_QMOPT_DQREPAIR callers can call directly.
> 
> Sound good?

Yes, seems like a reasonable cleanup to make. Making the dquot code
have fewer special snowflakes is always a good idea :P

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
