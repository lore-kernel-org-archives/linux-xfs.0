Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36684 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfDKPae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Apr 2019 11:30:34 -0400
Date: Thu, 11 Apr 2019 08:30:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/8] xfs: report fs and rt health via geometry structure
Message-ID: <20190411153016.GE1019523@magnolia>
References: <155494712442.1090518.2784809287026447547.stgit@magnolia>
 <155494716446.1090518.6511378096384851735.stgit@magnolia>
 <20190411130910.GF2888@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411130910.GF2888@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 11, 2019 at 09:09:10AM -0400, Brian Foster wrote:
> On Wed, Apr 10, 2019 at 06:46:04PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use our newly expanded geometry structure to report the overall fs and
> > realtime health status.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_fs.h     |   11 ++++++++
> >  fs/xfs/libxfs/xfs_health.h |    3 ++
> >  fs/xfs/xfs_health.c        |   57 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_ioctl.c         |    2 ++
> >  4 files changed, 72 insertions(+), 1 deletion(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > index 21728228e08b..eb8dbc3a952a 100644
> > --- a/fs/xfs/xfs_health.c
> > +++ b/fs/xfs/xfs_health.c
> > @@ -264,3 +264,60 @@ xfs_inode_measure_sickness(
> >  	*checked = ip->i_checked;
> >  	spin_unlock(&ip->i_flags_lock);
> >  }
> ...
> > +
> > +static inline void
> > +xfgeo_health_tick(
> > +	struct xfs_fsop_geom	*geo,
> > +	unsigned int		sick,
> > +	unsigned int		checked,
> > +	unsigned int		sick_mask,
> > +	unsigned int		fsop_mask)
> > +{
> 
> Could we just pass the struct ioctl_sick_map to this helper? IMO, that
> makes the mapping logic a bit more explicit and also doesn't introduce
> an unnecessary field name change between ->ioctl_mask and fsop_mask.

Ok.

> FWIW, I might also rename ->ioctl_mask to ->geom_mask since it's
> specific to that structure.

> > +	if (checked & sick_mask)
> > +		geo->checked |= fsop_mask;
> > +	if (sick & sick_mask)
> > +		geo->sick |= fsop_mask;
> > +}
> > +
> ...
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 0aaf4f88524d..3e3ee197bd0f 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> ...
> > @@ -792,6 +793,7 @@ xfs_ioc_fsgeometry(
> >  	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
> >  	if (error)
> >  		return error;
> > +	xfs_fsop_geom_health(mp, &fsgeo);
> >  
> 
> Not really a problem, but it might make sense to not bother with this
> unless struct_version >= 5 (via the already existing check below).

Ok.

--D

> Brian
> 
> >  	if (struct_version <= 3)
> >  		len = sizeof(struct xfs_fsop_geom_v1);
> > 
