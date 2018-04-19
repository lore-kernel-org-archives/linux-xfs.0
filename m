Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751695AbeDSLUn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Apr 2018 07:20:43 -0400
Date: Thu, 19 Apr 2018 07:20:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/11] xfs: quota scrub should use bmapbtd scrubber
Message-ID: <20180419112042.GA25447@bfoster.bfoster>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401921403.11465.9618173695298878026.stgit@magnolia>
 <20180418183447.GE22375@bfoster.bfoster>
 <20180418200036.GT24738@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418200036.GT24738@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 18, 2018 at 01:00:36PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 18, 2018 at 02:34:47PM -0400, Brian Foster wrote:
> > On Tue, Apr 17, 2018 at 07:40:14PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Replace the quota scrubber's open-coded data fork scrubber with a
> > > redirected call to the bmapbtd scrubber.  This strengthens the quota
> > > scrub to include all the cross-referencing that it does.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/scrub/quota.c |   95 ++++++++++++++++++++++++++++----------------------
> > >  1 file changed, 54 insertions(+), 41 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> > > index 1068a91..67f94c4 100644
> > > --- a/fs/xfs/scrub/quota.c
> > > +++ b/fs/xfs/scrub/quota.c
...
> > > +	if (error)
> > > +		return error;
> > > +	sc->sm->sm_flags |= (fake_sm.sm_flags & XFS_SCRUB_FLAGS_OUT);
> > > +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > > +		return error;
> > > +
> > > +	/* Check for data fork problems that apply only to quota files. */
> > >  	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
> > > -	while (1) {
> > > +	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
> > > +	for_each_xfs_iext(ifp, &icur, &irec) {
> > >  		if (xfs_scrub_should_terminate(sc, &error))
> > >  			break;
> > > -
> > > -		off = irec.br_startoff + irec.br_blockcount;
> > > -		nimaps = 1;
> > > -		error = xfs_bmapi_read(sc->ip, off, -1, &irec, &nimaps,
> > > -				XFS_BMAPI_ENTIRE);
> > > -		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, off,
> > > -				&error))
> > > -			goto out;
> > > -		if (!nimaps)
> > > -			break;
> > > -		if (irec.br_startblock == HOLESTARTBLOCK)
> > > -			continue;
> > > -
> > > -		/* Check the extent record doesn't point to crap. */
> > > -		if (irec.br_startblock + irec.br_blockcount <=
> > > -		    irec.br_startblock)
> > > -			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
> > > -					irec.br_startoff);
> > > -		if (!xfs_verify_fsbno(mp, irec.br_startblock) ||
> > > -		    !xfs_verify_fsbno(mp, irec.br_startblock +
> > > -					irec.br_blockcount - 1))
> > > -			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
> > > -					irec.br_startoff);
> > > -
> > >  		/*
> > > -		 * Unwritten extents or blocks mapped above the highest
> > > +		 * delalloc extents or blocks mapped above the highest
> > >  		 * quota id shouldn't happen.
> > >  		 */
> > >  		if (isnullstartblock(irec.br_startblock) ||
> > >  		    irec.br_startoff > max_dqid_off ||
> > > -		    irec.br_startoff + irec.br_blockcount > max_dqid_off + 1)
> > > -			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
> > > +		    irec.br_startoff + irec.br_blockcount > max_dqid_off + 1) {
> > 
> > Not introduced by this patch, but what's with the +1 to max_dqid_off
> > here?
> 
> max_dquid_off is the file block offset of the dquot for the highest
> quota id (0xFFFFFFFF), so this is checking that the next block after the
> extent doesn't map an unreachable offset.  The logic is a bit twisted;
> maybe (irec.br_startoff + irec.br_blockcount - 1 > max_dqid_off) would
> be clearer?
> 

Ah, I see. The calculated offset is exclusive and the max_dqid_off value
is inclusive. Yeah... not a big deal obviously but the tweak you propose
does seem a bit more clear to me. Thanks.

Brian

> --D
> 
> > 
> > Brian
> > 
> > > +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
> > > +					irec.br_startoff);
> > > +			break;
> > > +		}
> > >  	}
> > > +
> > > +	return error;
> > > +}
> > > +
> > > +/* Scrub all of a quota type's items. */
> > > +int
> > > +xfs_scrub_quota(
> > > +	struct xfs_scrub_context	*sc)
> > > +{
> > > +	struct xfs_scrub_quota_info	sqi;
> > > +	struct xfs_mount		*mp = sc->mp;
> > > +	struct xfs_quotainfo		*qi = mp->m_quotainfo;
> > > +	uint				dqtype;
> > > +	int				error = 0;
> > > +
> > > +	dqtype = xfs_scrub_quota_to_dqtype(sc);
> > > +
> > > +	/* Look for problem extents. */
> > > +	error = xfs_scrub_quota_data_fork(sc);
> > > +	if (error)
> > > +		goto out;
> > >  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > >  		goto out;
> > >  
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
