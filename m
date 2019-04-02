Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36658 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbfDBSXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 14:23:16 -0400
Date: Tue, 2 Apr 2019 11:23:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/10] xfs: report fs and rt health via geometry structure
Message-ID: <20190402182310.GF5147@magnolia>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413864658.4966.5585966135005160342.stgit@magnolia>
 <20190402173503.GJ2899@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402173503.GJ2899@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 02, 2019 at 01:35:04PM -0400, Brian Foster wrote:
> On Mon, Apr 01, 2019 at 10:10:46AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use our newly expanded geometry structure to report the overall fs and
> > realtime health status.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> I kind of wonder whether it's possible (or makes sense) to make the core
> sickness bits exportable to userspace and thus avoid some of the
> translation code, but that aside this looks fine to me:

Not sure -- for now I went with having separate bits and mapping
functions so that the internal implementation doesn't get fused to the
userspace interface, but seeing as the defines are the same we really
could just copy straight from the incore structure and have a bunch of
BUILD_BUG_ON(internal bit == ioctl bit) until they diverge more.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  fs/xfs/libxfs/xfs_fs.h     |   11 ++++++++++-
> >  fs/xfs/libxfs/xfs_health.h |    3 +++
> >  fs/xfs/xfs_health.c        |   27 +++++++++++++++++++++++++++
> >  fs/xfs/xfs_ioctl.c         |    3 +++
> >  4 files changed, 43 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 87226e00e7bd..ddbfde7ff79d 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -199,9 +199,18 @@ typedef struct xfs_fsop_geom {
> >  	__u32		rtsectsize;	/* realtime sector size, bytes	*/
> >  	__u32		dirblocksize;	/* directory block size, bytes	*/
> >  	__u32		logsunit;	/* log stripe unit, bytes */
> > -	__u64		reserved[18];	/* reserved space */
> > +	__u32		health;		/* o: unhealthy fs & rt metadata */
> > +	__u32		reserved32;	/* reserved space */
> > +	__u64		reserved[17];	/* reserved space */
> >  } xfs_fsop_geom_t;
> >  
> > +#define XFS_FSOP_GEOM_HEALTH_FS_COUNTERS (1 << 0) /* summary counters */
> > +#define XFS_FSOP_GEOM_HEALTH_FS_UQUOTA	(1 << 1)  /* user quota */
> > +#define XFS_FSOP_GEOM_HEALTH_FS_GQUOTA	(1 << 2)  /* group quota */
> > +#define XFS_FSOP_GEOM_HEALTH_FS_PQUOTA	(1 << 3)  /* project quota */
> > +#define XFS_FSOP_GEOM_HEALTH_RT_BITMAP	(1 << 4)  /* realtime bitmap */
> > +#define XFS_FSOP_GEOM_HEALTH_RT_SUMMARY	(1 << 5)  /* realtime summary */
> > +
> >  /* Output for XFS_FS_COUNTS */
> >  typedef struct xfs_fsop_counts {
> >  	__u64	freedata;	/* free data section blocks */
> > diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> > index 269b124dc1d7..36736d54a3e3 100644
> > --- a/fs/xfs/libxfs/xfs_health.h
> > +++ b/fs/xfs/libxfs/xfs_health.h
> > @@ -39,6 +39,7 @@
> >  struct xfs_mount;
> >  struct xfs_perag;
> >  struct xfs_inode;
> > +struct xfs_fsop_geom;
> >  
> >  /* Observable health issues for metadata spanning the entire filesystem. */
> >  #define XFS_HEALTH_FS_COUNTERS	(1 << 0)  /* summary counters */
> > @@ -200,4 +201,6 @@ xfs_inode_healthy(struct xfs_inode *ip)
> >  	return xfs_inode_measure_sickness(ip) == 0;
> >  }
> >  
> > +void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
> > +
> >  #endif	/* __XFS_HEALTH_H__ */
> > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > index 6e2da858c356..151c98693bef 100644
> > --- a/fs/xfs/xfs_health.c
> > +++ b/fs/xfs/xfs_health.c
> > @@ -249,3 +249,30 @@ xfs_inode_measure_sickness(
> >  	spin_unlock(&ip->i_flags_lock);
> >  	return ret;
> >  }
> > +
> > +/* Fill out fs geometry health info. */
> > +void
> > +xfs_fsop_geom_health(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_fsop_geom	*geo)
> > +{
> > +	unsigned int		sick;
> > +
> > +	geo->health = 0;
> > +
> > +	sick = xfs_fs_measure_sickness(mp);
> > +	if (sick & XFS_HEALTH_FS_COUNTERS)
> > +		geo->health |= XFS_FSOP_GEOM_HEALTH_FS_COUNTERS;
> > +	if (sick & XFS_HEALTH_FS_UQUOTA)
> > +		geo->health |= XFS_FSOP_GEOM_HEALTH_FS_UQUOTA;
> > +	if (sick & XFS_HEALTH_FS_GQUOTA)
> > +		geo->health |= XFS_FSOP_GEOM_HEALTH_FS_GQUOTA;
> > +	if (sick & XFS_HEALTH_FS_PQUOTA)
> > +		geo->health |= XFS_FSOP_GEOM_HEALTH_FS_PQUOTA;
> > +
> > +	sick = xfs_rt_measure_sickness(mp);
> > +	if (sick & XFS_HEALTH_RT_BITMAP)
> > +		geo->health |= XFS_FSOP_GEOM_HEALTH_RT_BITMAP;
> > +	if (sick & XFS_HEALTH_RT_SUMMARY)
> > +		geo->health |= XFS_FSOP_GEOM_HEALTH_RT_SUMMARY;
> > +}
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index b5918ce656bd..f9bf11b6a055 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -34,6 +34,7 @@
> >  #include "scrub/xfs_scrub.h"
> >  #include "xfs_sb.h"
> >  #include "xfs_ag.h"
> > +#include "xfs_health.h"
> >  
> >  #include <linux/capability.h>
> >  #include <linux/cred.h>
> > @@ -830,6 +831,8 @@ xfs_ioc_fsgeometry(
> >  	if (error)
> >  		return error;
> >  
> > +	xfs_fsop_geom_health(mp, &fsgeo);
> > +
> >  	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
> >  		return -EFAULT;
> >  	return 0;
> > 
