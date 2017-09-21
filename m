Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34132 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751700AbdIURaL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 13:30:11 -0400
Date: Thu, 21 Sep 2017 10:30:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/27] xfs: query the per-AG reservation counters
Message-ID: <20170921173006.GJ7112@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
 <150595306363.18473.9101441147554650927.stgit@magnolia>
 <20170921143630.GD58956@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921143630.GD58956@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 10:36:31AM -0400, Brian Foster wrote:
> On Wed, Sep 20, 2017 at 05:17:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Establish an ioctl for userspace to query the original and current
> > per-AG reservation counts.  This will be used by xfs_scrub to
> > check that the vfs counters are at least somewhat sane.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> The code seems fine, but I'm wondering how much of this would remain as
> is based on Dave's potential switch of the perag res stuff to be a
> hidden reservation. That itself still needs to be posted/reviewed/etc.,
> so might it be smarter to defer defining an interface to export this
> stuff until the core mechanism is worked out?

I think Dave's vision is that we should permanently steal the AG
reservations from the max fs size:

(device size - static metadata - static per-ag reservations)

In which case the ioctl isn't needed at all, since the statfs counters
would simply never report the per-ag reservations at all.

> That aside, I'm also wondering how/what userspace scrub does with the
> overall total values as opposed to individual AG reservation values.

To a rough approximation, xfs_scrub (phase 7) compares the fs geometry
data (used blocks, used inodes) against what it found via getfsmap and
bulkstat and warns about a potentially insufficient scrub if the counts
are off by more than 10% from what the fs reports.  The per-AG summary
counter ar_current_resv is added to the statvfs.f_bfree counter since
reserved blocks don't show up in getfsmap.

Since per-AG reservations never use more than 9% of the fs space worst
case (1k blocks) and usually 2% (4k blocks) the current 10% tolerance
built into xfs_scrub is probably good enough for now.

Anyway, I plan to withdraw this patch.

> Are the current "ask" values expected to be uniform across each AG..?

scrub doesn't care.

> For example, what happens if one AG has a bogus "current" value for
> whatever reason (perhaps this is more relevant for both values if we
> do actually end up with on-disk reservations)?

If it exceeds scrub's tolerances it'll warn about the discrepancy.
There's probably no way to fix the summary counters without an
xfs_repair run, unless it's acceptable to freeze the whole fs.

Not going to try to do that. :)

--D

> 
> Brian
> 
> >  fs/xfs/libxfs/xfs_fs.h |   12 ++++++++++++
> >  fs/xfs/xfs_fsops.c     |   26 ++++++++++++++++++++++++++
> >  fs/xfs/xfs_fsops.h     |    2 ++
> >  fs/xfs/xfs_ioctl.c     |   24 ++++++++++++++++++++++++
> >  fs/xfs/xfs_ioctl32.c   |    1 +
> >  5 files changed, 65 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 8c61f21..2c26c38 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -469,6 +469,17 @@ typedef struct xfs_swapext
> >  #define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
> >  
> >  /*
> > + * AG reserved block counters
> > + */
> > +struct xfs_fsop_ag_resblks {
> > +	__u32 ar_flags;			/* output flags, none defined now */
> > +	__u32 ar_reserved;		/* zero */
> > +	__u64 ar_current_resv;		/* blocks reserved now */
> > +	__u64 ar_mount_resv;		/* blocks reserved at mount time */
> > +	__u64 ar_reserved2[5];		/* zero */
> > +};
> > +
> > +/*
> >   * ioctl limits
> >   */
> >  #ifdef XATTR_LIST_MAX
> > @@ -543,6 +554,7 @@ typedef struct xfs_swapext
> >  #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
> >  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
> >  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
> > +#define XFS_IOC_GET_AG_RESBLKS	     _IOR ('X', 126, struct xfs_fsop_ag_resblks)
> >  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
> >  
> >  
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 8f22fc5..50fb3a2 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -44,6 +44,7 @@
> >  #include "xfs_filestream.h"
> >  #include "xfs_rmap.h"
> >  #include "xfs_ag_resv.h"
> > +#include "xfs_fs.h"
> >  
> >  /*
> >   * File system operations
> > @@ -1046,3 +1047,28 @@ xfs_fs_unreserve_ag_blocks(
> >  
> >  	return error;
> >  }
> > +
> > +/* Query the per-AG reservations to see how many blocks we have reserved. */
> > +int
> > +xfs_fs_get_ag_reserve_blocks(
> > +	struct xfs_mount		*mp,
> > +	struct xfs_fsop_ag_resblks	*out)
> > +{
> > +	struct xfs_ag_resv		*r;
> > +	struct xfs_perag		*pag;
> > +	xfs_agnumber_t			agno;
> > +
> > +	memset(out, 0, sizeof(struct xfs_fsop_ag_resblks));
> > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > +		pag = xfs_perag_get(mp, agno);
> > +		r = xfs_perag_resv(pag, XFS_AG_RESV_METADATA);
> > +		out->ar_current_resv += r->ar_reserved;
> > +		out->ar_mount_resv += r->ar_asked;
> > +		r = xfs_perag_resv(pag, XFS_AG_RESV_AGFL);
> > +		out->ar_current_resv += r->ar_reserved;
> > +		out->ar_mount_resv += r->ar_asked;
> > +		xfs_perag_put(pag);
> > +	}
> > +
> > +	return 0;
> > +}
> > diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> > index 2954c13..c8f5e26 100644
> > --- a/fs/xfs/xfs_fsops.h
> > +++ b/fs/xfs/xfs_fsops.h
> > @@ -25,6 +25,8 @@ extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
> >  extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
> >  				xfs_fsop_resblks_t *outval);
> >  extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
> > +extern int xfs_fs_get_ag_reserve_blocks(struct xfs_mount *mp,
> > +		struct xfs_fsop_ag_resblks *out);
> >  
> >  extern int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
> >  extern int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 5049e8a..44dc178 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1782,6 +1782,27 @@ xfs_ioc_swapext(
> >  	return error;
> >  }
> >  
> > +static int
> > +xfs_ioc_get_ag_reserve_blocks(
> > +	struct xfs_mount		*mp,
> > +	void __user			*arg)
> > +{
> > +	struct xfs_fsop_ag_resblks	out;
> > +	int				error;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	error = xfs_fs_get_ag_reserve_blocks(mp, &out);
> > +	if (error)
> > +		return error;
> > +
> > +	if (copy_to_user(arg, &out, sizeof(out)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Note: some of the ioctl's return positive numbers as a
> >   * byte count indicating success, such as readlink_by_handle.
> > @@ -1987,6 +2008,9 @@ xfs_file_ioctl(
> >  		return 0;
> >  	}
> >  
> > +	case XFS_IOC_GET_AG_RESBLKS:
> > +		return xfs_ioc_get_ag_reserve_blocks(mp, arg);
> > +
> >  	case XFS_IOC_FSGROWFSDATA: {
> >  		xfs_growfs_data_t in;
> >  
> > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > index fa0bc4d..e8b4de3 100644
> > --- a/fs/xfs/xfs_ioctl32.c
> > +++ b/fs/xfs/xfs_ioctl32.c
> > @@ -556,6 +556,7 @@ xfs_file_compat_ioctl(
> >  	case XFS_IOC_ERROR_INJECTION:
> >  	case XFS_IOC_ERROR_CLEARALL:
> >  	case FS_IOC_GETFSMAP:
> > +	case XFS_IOC_GET_AG_RESBLKS:
> >  		return xfs_file_ioctl(filp, cmd, p);
> >  #ifndef BROKEN_X86_ALIGNMENT
> >  	/* These are handled fine if no alignment issues */
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
