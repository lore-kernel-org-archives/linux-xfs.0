Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56860 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752640AbeDSR0H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Apr 2018 13:26:07 -0400
Date: Thu, 19 Apr 2018 10:25:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/11] xfs: superblock scrub should use uncached buffers
Message-ID: <20180419172548.GY24738@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401922015.11465.14941366292853283272.stgit@magnolia>
 <20180419125546.GA25844@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419125546.GA25844@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 19, 2018 at 08:55:47AM -0400, Brian Foster wrote:
> On Tue, Apr 17, 2018 at 07:40:20PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > We've never cached buffers when reading or writing superblocks, so we
> > need to change scrub to do likewise or risk screwing up the uncached sb
> > buffer usage everywhere else.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Hmm, so this goes back to this[1] thread, right?

Yep.

> IIRC, we wanted to end up with an lru-bypassing uncached buffer lookup
> mechanism to provide uncached behavior for resource-saving purposes
> but without introducing serialization issues between multiple users of
> uncached buffers.

Right.

> On a quick look back, growfs currently uses cached buffers for secondary
> superblocks and the associated patch was looking to change that to
> something like the above. Don't we have the same requirement here (since
> growfs currently still uses cached buffers)?

Correct, this patch is contingent on landing Dave's "tableise growfs"
series that converts growfs to use uncached buffers for writing out the
new secondary supers.  If I manage to land Dave's growfs thing before
repair then I'll keep this; if repair goes first I'll defer it to that
series.

I've never done a contingent-patch in the middle of a series, so I'm not
sure exactly how to present such a {monstr,bog}osity.

--D

> Brian
> 
> [1] https://marc.info/?l=linux-xfs&m=151746733326282&w=2
> 
> >  fs/xfs/scrub/agheader.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index 018aabbd..aacbc3f 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -157,7 +157,7 @@ xfs_scrub_superblock(
> >  	if (agno == 0)
> >  		return 0;
> >  
> > -	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > +	error = xfs_buf_read_uncached(mp->m_ddev_targp,
> >  		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> >  		  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> >  	/*
> > @@ -421,6 +421,7 @@ xfs_scrub_superblock(
> >  		xfs_scrub_block_set_corrupt(sc, bp);
> >  
> >  	xfs_scrub_superblock_xref(sc, bp);
> > +	xfs_buf_relse(bp);
> >  
> >  	return error;
> >  }
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
