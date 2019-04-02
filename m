Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50450 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfDBWbk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 18:31:40 -0400
Date: Tue, 2 Apr 2019 15:31:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/10] xfs: expand xfs_fsop_geom
Message-ID: <20190402223134.GI5147@magnolia>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413863414.4966.13609556795695536711.stgit@magnolia>
 <20190402215346.GW26298@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402215346.GW26298@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 03, 2019 at 08:53:46AM +1100, Dave Chinner wrote:
> On Mon, Apr 01, 2019 at 10:10:34AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Rename the current (v2-v4) geometry ioctl XFS_IOC_FSGEOMETRY_V2 and
> > expand the existing xfs_fsop_geom to reserve empty space for more
> > fields.  This means that newly built binaries will pick up the new
> > format and existing programs will simply end up in the V2 handler.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This looks familiar....
> 
> Thu, 26 Oct 2017 19:33:19 +1100
> [PATCH 11/14] xfs: bump XFS_IOC_FSGEOMETRY to v5 structures
> 
> https://patchwork.kernel.org/patch/10027799/

Heh, yes. :)

> > ---
> >  fs/xfs/libxfs/xfs_fs.h |   32 +++++++++++++++++++++++++++++++-
> >  fs/xfs/libxfs/xfs_sb.c |    5 +++++
> >  fs/xfs/xfs_ioctl.c     |   22 ++++++++++++++++++++--
> >  fs/xfs/xfs_ioctl32.c   |    1 +
> >  4 files changed, 57 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index f3aa59302fef..1dba751cde60 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -148,7 +148,34 @@ typedef struct xfs_fsop_geom_v1 {
> >  } xfs_fsop_geom_v1_t;
> >  
> >  /*
> > - * Output for XFS_IOC_FSGEOMETRY
> > + * Output for XFS_IOC_FSGEOMETRY_V2
> > + */
> > +typedef struct xfs_fsop_geom_v2 {
> > +	__u32		blocksize;	/* filesystem (data) block size */
> > +	__u32		rtextsize;	/* realtime extent size		*/
> > +	__u32		agblocks;	/* fsblocks in an AG		*/
> > +	__u32		agcount;	/* number of allocation groups	*/
> > +	__u32		logblocks;	/* fsblocks in the log		*/
> > +	__u32		sectsize;	/* (data) sector size, bytes	*/
> > +	__u32		inodesize;	/* inode size in bytes		*/
> > +	__u32		imaxpct;	/* max allowed inode space(%)	*/
> > +	__u64		datablocks;	/* fsblocks in data subvolume	*/
> > +	__u64		rtblocks;	/* fsblocks in realtime subvol	*/
> > +	__u64		rtextents;	/* rt extents in realtime subvol*/
> > +	__u64		logstart;	/* starting fsblock of the log	*/
> > +	unsigned char	uuid[16];	/* unique id of the filesystem	*/
> > +	__u32		sunit;		/* stripe unit, fsblocks	*/
> > +	__u32		swidth;		/* stripe width, fsblocks	*/
> > +	__s32		version;	/* structure version		*/
> > +	__u32		flags;		/* superblock version flags	*/
> > +	__u32		logsectsize;	/* log sector size, bytes	*/
> > +	__u32		rtsectsize;	/* realtime sector size, bytes	*/
> > +	__u32		dirblocksize;	/* directory block size, bytes	*/
> > +	__u32		logsunit;	/* log stripe unit, bytes */
> > +} xfs_fsop_geom_v2_t;
> 
> That's actually the v4 structurei, not the v2 structure. fsgeom
> versions 1-3 used the v1 structure, v4 uses this structure, and v5
> uses the current structure. So this (and the renamed ioctl) should
> really be name "v4", not "v2".

Fair enough.  Like Brian, I wasn't 100% sure whether we were on v4 or v2
or vMILLION. :)

> 
> > +/*
> > + * Output for XFS_IOC_FSGEOMETRY (v5)
> >   */
> >  typedef struct xfs_fsop_geom {
> >  	__u32		blocksize;	/* filesystem (data) block size */
> > @@ -172,6 +199,7 @@ typedef struct xfs_fsop_geom {
> >  	__u32		rtsectsize;	/* realtime sector size, bytes	*/
> >  	__u32		dirblocksize;	/* directory block size, bytes	*/
> >  	__u32		logsunit;	/* log stripe unit, bytes */
> > +	__u64		reserved[18];	/* reserved space */
> >  } xfs_fsop_geom_t;
> >  
> >  /* Output for XFS_FS_COUNTS */
> > @@ -189,6 +217,7 @@ typedef struct xfs_fsop_resblks {
> >  } xfs_fsop_resblks_t;
> >  
> >  #define XFS_FSOP_GEOM_VERSION	0
> > +#define XFS_FSOP_GEOM_V5	5
> >  
> >  #define XFS_FSOP_GEOM_FLAGS_ATTR	0x0001	/* attributes in use	*/
> >  #define XFS_FSOP_GEOM_FLAGS_NLINK	0x0002	/* 32-bit nlink values	*/
> > @@ -620,6 +649,7 @@ struct xfs_scrub_metadata {
> >  #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
> >  #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
> >  #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
> > +#define XFS_IOC_FSGEOMETRY_V2	     _IOR ('X', 124, struct xfs_fsop_geom_v2)
> >  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
>                                                 ^^^
> The identifier for the XFS_IOC_FSGEOMETRY ioctl needs to change
> because it's now a new ioctl.

It /is/ different, because the sizeof(third parameter) is encoded in the
ioctl number...

printf("x%lx x%lx\n", XFS_IOC_FSGEOMETRY, XFS_IOC_FSGEOMETRY_V2);

Yields:

x8100587c x8070587c
                 ^^ 124
               ^^ the 'X'
            ^^^ structure size
           ^ ioctl direction

The size went from 0x70 to 0x100, so the number's different, unless
someone wants to make a drastic change to how the ioctl macros work.

Granted, it's a little subtle.

> 
> >  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
> >  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index f0309b74e377..c2ca3a816c41 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -1168,6 +1168,11 @@ xfs_fs_geometry(
> >  
> >  	geo->logsunit = sbp->sb_logsunit;
> >  
> > +	if (struct_version < 5)
> > +		return 0;
> > +
> > +	geo->version = XFS_FSOP_GEOM_V5;
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 6ecdbb3af7de..7fd8815633dc 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -801,7 +801,7 @@ xfs_ioc_fsgeometry_v1(
> >  }
> >  
> >  STATIC int
> > -xfs_ioc_fsgeometry(
> > +xfs_ioc_fsgeometry_v2(
> >  	xfs_mount_t		*mp,
> >  	void			__user *arg)
> >  {
> > @@ -812,6 +812,23 @@ xfs_ioc_fsgeometry(
> >  	if (error)
> >  		return error;
> >  
> > +	if (copy_to_user(arg, &fsgeo, sizeof(struct xfs_fsop_geom_v2)))
> > +		return -EFAULT;
> > +	return 0;
> > +}
> > +
> > +STATIC int
> > +xfs_ioc_fsgeometry(
> > +	struct xfs_mount	*mp,
> > +	void			__user *arg)
> > +{
> > +	struct xfs_fsop_geom	fsgeo;
> > +	int			error;
> > +
> > +	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 5);
> > +	if (error)
> > +		return error;
> > +
> >  	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
> >  		return -EFAULT;
> >  	return 0;
> 
> And I factored all this into a single function, because it's just
> boiler plate that can be done with a version switch passed in from
> the XFS_IOC_FSGEOMETRY* calls themselves. see the patch I referenced
> above....

Yeah, that is a lot less gross.  I'll have a look at your patch from
ages ago.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
