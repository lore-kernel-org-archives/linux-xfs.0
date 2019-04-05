Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45484 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfDEUda (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Apr 2019 16:33:30 -0400
Date: Fri, 5 Apr 2019 13:33:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/10] xfs: report AG health via AG geometry ioctl
Message-ID: <20190405203319.GA5147@magnolia>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413865266.4966.1015973371094452528.stgit@magnolia>
 <20190403143002.GA25805@bfoster>
 <20190403161106.GK5147@magnolia>
 <20190404114854.GA37737@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404114854.GA37737@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 04, 2019 at 07:48:57AM -0400, Brian Foster wrote:
> On Wed, Apr 03, 2019 at 09:11:06AM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 03, 2019 at 10:30:05AM -0400, Brian Foster wrote:
> > > On Mon, Apr 01, 2019 at 10:10:52AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Use the AG geometry info ioctl to report health status too.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_fs.h     |   12 +++++++++++-
> > > >  fs/xfs/libxfs/xfs_health.h |    2 ++
> > > >  fs/xfs/xfs_health.c        |   40 ++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_ioctl.c         |    2 ++
> > > >  4 files changed, 55 insertions(+), 1 deletion(-)
> > > > 
> > > > 
> > > ...
> > > > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > > > index 151c98693bef..5ca471bd41ad 100644
> > > > --- a/fs/xfs/xfs_health.c
> > > > +++ b/fs/xfs/xfs_health.c
> > > > @@ -276,3 +276,43 @@ xfs_fsop_geom_health(
> > > >  	if (sick & XFS_HEALTH_RT_SUMMARY)
> > > >  		geo->health |= XFS_FSOP_GEOM_HEALTH_RT_SUMMARY;
> > > >  }
> > > > +
> > > > +/* Fill out ag geometry health info. */
> > > > +void
> > > > +xfs_ag_geom_health(
> > > > +	struct xfs_mount	*mp,
> > > > +	xfs_agnumber_t		agno,
> > > > +	struct xfs_ag_geometry	*ageo)
> > > > +{
> > > > +	struct xfs_perag	*pag;
> > > > +	unsigned int		sick;
> > > > +
> > > > +	if (agno >= mp->m_sb.sb_agcount)
> > > > +		return;
> > > 
> > > The call to xfs_ag_get_geometry() would have already returned an error
> > > in the ioctl path for the above scenario. It might still make sense to
> > > check here, but perhaps we could let this function also return an int
> > > and return an error for consistency?
> > 
> > Or maybe just ASSERT on the agno and add a note that the caller is
> > required to pass in a valid ag number.
> > 
> > > > +
> > > > +	ageo->ag_health = 0;
> > > > +
> > > > +	pag = xfs_perag_get(mp, agno);
> > > > +	sick = xfs_ag_measure_sickness(pag);
> > > > +	if (sick & XFS_HEALTH_AG_SB)
> > > > +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_SB;
> > > 
> > > I'm starting to wonder whether "health" is the best term to use for the
> > > interface bits just because it reads a little weird to measure
> > > "sickness" and then apply all the sick state to something called
> > > "health." I don't have a better suggestion off the top of my head,
> > > though. Just something to think about a bit more from an API
> > > standpoint..
> > 
> > I had the same conundrum.  I guess we could start the bitset with -1 and
> > clear bits when scrub says they've gone bad?  That would be much clearer
> > with regards to the names, but technically we don't know the health of a
> > structure until we scan it, so I wouldn't want to represent the fs as
> > being "healthy" having not actually looked for problems.
> > 
> > What we /really/ need is a tri-state bitset[1]:
> > 
> > enum Bool
> > {
> >     True,
> >     False,
> >     FileNotFound
> > };
> > 
> > But maybe I will try renaming all this to "sick" again.
> > 
> > if (sick & XFS_SICK_AG_AGF)
> > 	ageo->ag_sick |= XFS_AG_GEOM_SICK_AG_AGF;
> > 
> > Gosh.  That second name is gross.  XFS_AG_GEOM_SICK_AGF.
> > 
> > Sick sick sick sick sick.  Ok, I've convinced myself of the name change. :P
> > 
> 
> Heh. I suppose we could either invert the logic or perhaps try to come
> up with a better keyword than "health" for the exported bits (at least).
> If I see ag_health in a data structure, for example, I'm assuming it's
> telling me what is healthy. Of course we'll have documentation and
> whatnot to clear that up..
> 
> Another term that came to mind is "fault" or "faulted" as it has
> precedent in storage contexts wrt to raid. I.e., ag_faults and
> XFS_AG_GEOM_FAULT_AGF, etc. etc. To me it also kind of covers the angle
> that we aren't necessarily stating a subset of the filesystem is healthy
> due to lack of faults if we just haven't scrubbed/found anything. Hm? I
> guess it could be confused with reporting underlying storage problems. I
> dunno... it's more clear to me, but maybe others have ideas..

I have a (not very strong) preference for 'sick' over 'fault' because
there are other parts of xfs where we deal with (page) faults and I
don't really want to get "file metadata faults" and "file page faults"
confused.

(I'm not sure anyone is really going to confuse them, though...)

--D

> Brian
> 
> > --D
> > 
> > [1] https://thedailywtf.com/articles/What_Is_Truth_0x3f_
> > 
> > > Brian
> > > 
> > > > +	if (sick & XFS_HEALTH_AG_AGF)
> > > > +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_AGF;
> > > > +	if (sick & XFS_HEALTH_AG_AGFL)
> > > > +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_AGFL;
> > > > +	if (sick & XFS_HEALTH_AG_AGI)
> > > > +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_AGI;
> > > > +	if (sick & XFS_HEALTH_AG_BNOBT)
> > > > +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_BNOBT;
> > > > +	if (sick & XFS_HEALTH_AG_CNTBT)
> > > > +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_CNTBT;
> > > > +	if (sick & XFS_HEALTH_AG_INOBT)
> > > > +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_INOBT;
> > > > +	if (sick & XFS_HEALTH_AG_FINOBT)
> > > > +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_FINOBT;
> > > > +	if (sick & XFS_HEALTH_AG_RMAPBT)
> > > > +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_RMAPBT;
> > > > +	if (sick & XFS_HEALTH_AG_REFCNTBT)
> > > > +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_REFCNTBT;
> > > > +	xfs_perag_put(pag);
> > > > +}
> > > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > > index f9bf11b6a055..f1fc5e53cfc1 100644
> > > > --- a/fs/xfs/xfs_ioctl.c
> > > > +++ b/fs/xfs/xfs_ioctl.c
> > > > @@ -853,6 +853,8 @@ xfs_ioc_ag_geometry(
> > > >  	if (error)
> > > >  		return error;
> > > >  
> > > > +	xfs_ag_geom_health(mp, ageo.ag_number, &ageo);
> > > > +
> > > >  	if (copy_to_user(arg, &ageo, sizeof(ageo)))
> > > >  		return -EFAULT;
> > > >  	return 0;
> > > > 
