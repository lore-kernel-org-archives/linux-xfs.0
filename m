Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54062 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfDDPsn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Apr 2019 11:48:43 -0400
Date: Thu, 4 Apr 2019 08:48:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/10] xfs: update health status if we get a clean bill
 of health
Message-ID: <20190404154836.GP5147@magnolia>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413867884.4966.3786317285199498710.stgit@magnolia>
 <20190404115140.GC37737@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190404115140.GC37737@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 04, 2019 at 07:51:43AM -0400, Brian Foster wrote:
> On Mon, Apr 01, 2019 at 10:11:18AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If scrub finds that everything is ok with the filesystem, we need a way
> > to tell the health tracking that it can let go of indirect health flags,
> > since indirect flags only mean that at some point in the past we lost
> > some context.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> FYI this one doesn't compile for me:
> 
> ...
> fs/xfs/scrub/common.c: In function ‘xchk_set_corrupt’:
> fs/xfs/scrub/common.c:217:2: error: implicit declaration of function ‘xfs_scrub_whine’; did you mean ‘xfs_bmapi_write’? [-Werror=implicit-function-declaration]
>   xfs_scrub_whine(sc->mp, "type %d ret_ip %pS",

Uhh... April Fools! :)

> ...
> 
> >  fs/xfs/libxfs/xfs_fs.h |    3 ++
> >  fs/xfs/scrub/common.c  |   12 ++++++++++
> >  fs/xfs/scrub/common.h  |    1 +
> >  fs/xfs/scrub/health.c  |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/health.h  |    1 +
> >  fs/xfs/scrub/repair.c  |    1 +
> >  fs/xfs/scrub/scrub.c   |    6 +++++
> >  fs/xfs/scrub/trace.h   |    4 ++-
> >  8 files changed, 84 insertions(+), 2 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
> > index dd9986500801..049e802b9418 100644
> > --- a/fs/xfs/scrub/health.c
> > +++ b/fs/xfs/scrub/health.c
> ...
> > @@ -54,6 +55,60 @@ xchk_health_mask_for_scrub_type(
> ...
> > +/*
> > + * Scrub gave the filesystem a clean bill of health, so clear all the indirect
> > + * markers of past problems (at least for the fs and ags) so that we can be
> > + * healthy again.
> > + */
> > +STATIC void
> > +xchk_mark_all_healthy(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_perag	*pag;
> > +	xfs_agnumber_t		agno;
> > +	int			error = 0;
> > +
> > +	xfs_fs_mark_healthy(mp, XFS_HEALTH_FS_INDIRECT);
> > +	xfs_rt_mark_healthy(mp, XFS_HEALTH_RT_INDIRECT);
> > +	for (agno = 0; error == 0 && agno < mp->m_sb.sb_agcount; agno++) {
> > +		pag = xfs_perag_get(mp, agno);
> > +		xfs_ag_mark_healthy(pag, XFS_HEALTH_AG_INDIRECT);
> > +		xfs_perag_put(pag);
> > +	}
> > +}
> >  /* Mark metadata unhealthy. */
> >  static void
> >  xchk_mark_sick(
> > @@ -149,6 +204,9 @@ xchk_mark_healthy(
> >  	case XFS_SCRUB_TYPE_RTSUM:
> >  		xfs_rt_mark_healthy(sc->mp, mask);
> >  		break;
> > +	case XFS_SCRUB_TYPE_HEALTHY:
> > +		xchk_mark_all_healthy(sc->mp);
> > +		break;
> 
> Should this scrub type have a corresponding health flag? It kind of
> looks like it being zeroed could prevent us from getting here because of
> the 'if (!mask)' check in xchk_update_health(), but it's a bit twisty
> from there to here.. :P

Oops, no, that's just a bug. :(

SCRUB_TYPE_HEALTHY is a convenience method for xfs_scrub to ask the
kernel to clear all the indirect sick flags if it saw no errors and
nothing else got marked sick since xfs_scrub started running.  It's not
collecting primary evidence, so there's no health flag associated with
it and *_mask should be zero.

The top of xchk_mark_healthy should have been:

if (sc->sm->sm_type == XFS_SCRUB_TYPE_HEALTHY) {
	xchk_mark_all_healthy(sc->mp);
	return;
}

if (!mask)
	return;

switch (sc->sm->sm_type) {
<etc>

--D

> Brian
> 
> >  	default:
> >  		break;
> >  	}
> > diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
> > index e795f4c9a23c..001e5a93273d 100644
> > --- a/fs/xfs/scrub/health.h
> > +++ b/fs/xfs/scrub/health.h
> > @@ -8,5 +8,6 @@
> >  
> >  unsigned int xchk_health_mask_for_scrub_type(__u32 scrub_type);
> >  void xchk_update_health(struct xfs_scrub *sc, bool already_fixed);
> > +int xchk_health_record(struct xfs_scrub *sc);
> >  
> >  #endif /* __XFS_SCRUB_HEALTH_H__ */
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index f28f4bad317b..5df67fe5d8ac 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> > @@ -31,6 +31,7 @@
> >  #include "xfs_quota.h"
> >  #include "xfs_attr.h"
> >  #include "xfs_reflink.h"
> > +#include "xfs_health.h"
> >  #include "scrub/xfs_scrub.h"
> >  #include "scrub/scrub.h"
> >  #include "scrub/common.h"
> > diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> > index b1519dfc5811..f446ab57d7b0 100644
> > --- a/fs/xfs/scrub/scrub.c
> > +++ b/fs/xfs/scrub/scrub.c
> > @@ -348,6 +348,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
> >  		.scrub	= xchk_quota,
> >  		.repair	= xrep_notsupported,
> >  	},
> > +	[XFS_SCRUB_TYPE_HEALTHY] = {	/* fs healthy; clean all reminders */
> > +		.type	= ST_FS,
> > +		.setup	= xchk_setup_fs,
> > +		.scrub	= xchk_health_record,
> > +		.repair = xrep_notsupported,
> > +	},
> >  };
> >  
> >  /* This isn't a stable feature, warn once per day. */
> > diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> > index 3c83e8b3b39c..7c25a38c6f81 100644
> > --- a/fs/xfs/scrub/trace.h
> > +++ b/fs/xfs/scrub/trace.h
> > @@ -75,7 +75,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
> >  	{ XFS_SCRUB_TYPE_RTSUM,		"rtsummary" }, \
> >  	{ XFS_SCRUB_TYPE_UQUOTA,	"usrquota" }, \
> >  	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
> > -	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }
> > +	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
> > +	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }
> >  
> >  DECLARE_EVENT_CLASS(xchk_class,
> >  	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
> > @@ -223,6 +224,7 @@ DEFINE_EVENT(xchk_block_error_class, name, \
> >  		 void *ret_ip), \
> >  	TP_ARGS(sc, daddr, ret_ip))
> >  
> > +DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_fs_error);
> >  DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_error);
> >  DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_preen);
> >  
> > 
