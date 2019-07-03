Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60590 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfGCOzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jul 2019 10:55:15 -0400
Date: Wed, 3 Jul 2019 07:52:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/9] xfs: wire up the new v5 bulkstat_single ioctl
Message-ID: <20190703145256.GU1404256@magnolia>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158197298.495715.10824532259700709632.stgit@magnolia>
 <20190703132441.GF26057@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703132441.GF26057@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

On Wed, Jul 03, 2019 at 09:24:41AM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:46:13PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Wire up the V5 BULKSTAT_SINGLE ioctl and rename the old one V1.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_fs.h |   16 ++++++++++
> >  fs/xfs/xfs_ioctl.c     |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_ioctl32.c   |    1 +
> >  fs/xfs/xfs_ondisk.h    |    1 +
> >  4 files changed, 97 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 960f3542e207..95d0411dae9b 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -468,6 +468,16 @@ struct xfs_bulk_ireq {
> >  
> >  #define XFS_BULK_IREQ_FLAGS_ALL	(0)
> >  
> > +/* Header for a single inode request. */
> > +struct xfs_ireq {
> > +	uint64_t	ino;		/* I/O: start with this inode	*/
> > +	uint32_t	flags;		/* I/O: operation flags		*/
> > +	uint32_t	reserved32;	/* must be zero			*/
> > +	uint64_t	reserved[2];	/* must be zero			*/
> > +};
> > +
> > +#define XFS_IREQ_FLAGS_ALL	(0)
> > +
> >  /*
> >   * ioctl structures for v5 bulkstat and inumbers requests
> >   */
> > @@ -478,6 +488,11 @@ struct xfs_bulkstat_req {
> >  #define XFS_BULKSTAT_REQ_SIZE(nr)	(sizeof(struct xfs_bulkstat_req) + \
> >  					 (nr) * sizeof(struct xfs_bulkstat))
> >  
> > +struct xfs_bulkstat_single_req {
> > +	struct xfs_ireq		hdr;
> > +	struct xfs_bulkstat	bulkstat;
> > +};
> > +
> 
> What's the reasoning for separate data structures when the single
> command is basically a subset of standard bulkstat (similar to the older
> interface)?

I split them up to avoid having irrelevant bulk_req fields (specifically
icount and ocount) cluttering up the single_req header.  In patch 9 the
bulkstat single command grows the ability to request the root inode to
fix xfsdump's inability to correctly guess the root directory.

--D

> Brian
> 
> >  /*
> >   * Error injection.
> >   */
> > @@ -780,6 +795,7 @@ struct xfs_scrub_metadata {
> >  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
> >  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
> >  #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
> > +#define XFS_IOC_BULKSTAT_SINGLE	     _IOR ('X', 128, struct xfs_bulkstat_single_req)
> >  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
> >  
> >  
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index cf6a38c2a3ed..2c821fa601a4 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -922,6 +922,83 @@ xfs_ioc_bulkstat(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Check the incoming singleton request @hdr from userspace and initialize the
> > + * internal @breq bulk request appropriately.  Returns 0 if the bulk request
> > + * should proceed; or the usual negative error code.
> > + */
> > +static int
> > +xfs_ireq_setup(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_ireq		*hdr,
> > +	struct xfs_ibulk	*breq,
> > +	void __user		*ubuffer)
> > +{
> > +	if ((hdr->flags & ~XFS_IREQ_FLAGS_ALL) ||
> > +	    hdr->reserved32 ||
> > +	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
> > +		return -EINVAL;
> > +
> > +	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
> > +		return -EINVAL;
> > +
> > +	breq->ubuffer = ubuffer;
> > +	breq->icount = 1;
> > +	breq->startino = hdr->ino;
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Update the userspace singleton request @hdr to reflect the end state of the
> > + * internal bulk request @breq.  If @error is negative then we return just
> > + * that; otherwise we copy the state so that userspace can discover what
> > + * happened.
> > + */
> > +static void
> > +xfs_ireq_teardown(
> > +	struct xfs_ireq		*hdr,
> > +	struct xfs_ibulk	*breq)
> > +{
> > +	hdr->ino = breq->startino;
> > +}
> > +
> > +/* Handle the v5 bulkstat_single ioctl. */
> > +STATIC int
> > +xfs_ioc_bulkstat_single(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		cmd,
> > +	struct xfs_bulkstat_single_req __user *arg)
> > +{
> > +	struct xfs_ireq		hdr;
> > +	struct xfs_ibulk	breq = {
> > +		.mp		= mp,
> > +	};
> > +	int			error;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	if (XFS_FORCED_SHUTDOWN(mp))
> > +		return -EIO;
> > +
> > +	if (copy_from_user(&hdr, &arg->hdr, sizeof(hdr)))
> > +		return -EFAULT;
> > +
> > +	error = xfs_ireq_setup(mp, &hdr, &breq, &arg->bulkstat);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfs_bulkstat_one(&breq, xfs_bulkstat_fmt);
> > +	if (error)
> > +		return error;
> > +
> > +	xfs_ireq_teardown(&hdr, &breq);
> > +	if (copy_to_user(&arg->hdr, &hdr, sizeof(hdr)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> >  STATIC int
> >  xfs_ioc_fsgeometry(
> >  	struct xfs_mount	*mp,
> > @@ -2088,6 +2165,8 @@ xfs_file_ioctl(
> >  
> >  	case XFS_IOC_BULKSTAT:
> >  		return xfs_ioc_bulkstat(mp, cmd, arg);
> > +	case XFS_IOC_BULKSTAT_SINGLE:
> > +		return xfs_ioc_bulkstat_single(mp, cmd, arg);
> >  
> >  	case XFS_IOC_FSGEOMETRY_V1:
> >  		return xfs_ioc_fsgeometry(mp, arg, 3);
> > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > index df107adbdbf3..6fa0f41dbae5 100644
> > --- a/fs/xfs/xfs_ioctl32.c
> > +++ b/fs/xfs/xfs_ioctl32.c
> > @@ -581,6 +581,7 @@ xfs_file_compat_ioctl(
> >  	case FS_IOC_GETFSMAP:
> >  	case XFS_IOC_SCRUB_METADATA:
> >  	case XFS_IOC_BULKSTAT:
> > +	case XFS_IOC_BULKSTAT_SINGLE:
> >  		return xfs_file_ioctl(filp, cmd, p);
> >  #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
> >  	/*
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index 954484c6eb96..fa1252657b08 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -150,6 +150,7 @@ xfs_check_ondisk_structs(void)
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_single_req,	224);
> >  }
> >  
> >  #endif /* __XFS_ONDISK_H */
> > 
