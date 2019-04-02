Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36866 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfDBVli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 17:41:38 -0400
Date: Tue, 2 Apr 2019 14:35:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/10] xfs: add a new ioctl to describe allocation group
 geometry
Message-ID: <20190402213528.GG5147@magnolia>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413864032.4966.11238815153270272807.stgit@magnolia>
 <20190402173446.GI2899@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402173446.GI2899@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 02, 2019 at 01:34:46PM -0400, Brian Foster wrote:
> On Mon, Apr 01, 2019 at 10:10:40AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a new ioctl to describe an allocation group's geometry.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Just a couple nits...
> 
> >  fs/xfs/libxfs/xfs_ag.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_ag.h |    2 ++
> >  fs/xfs/libxfs/xfs_fs.h |   14 ++++++++++++++
> >  fs/xfs/xfs_ioctl.c     |   24 ++++++++++++++++++++++++
> >  fs/xfs/xfs_ioctl32.c   |    1 +
> >  5 files changed, 89 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index 1ef8acf35e7d..1679e37fe28d 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -19,6 +19,7 @@
> >  #include "xfs_ialloc.h"
> >  #include "xfs_rmap.h"
> >  #include "xfs_ag.h"
> > +#include "xfs_ag_resv.h"
> >  
> >  static struct xfs_buf *
> >  xfs_get_aghdr_buf(
> > @@ -461,3 +462,50 @@ xfs_ag_extend_space(
> >  				len, &XFS_RMAP_OINFO_SKIP_UPDATE,
> >  				XFS_AG_RESV_NONE);
> >  }
> > +
> > +/* Retrieve AG geometry. */
> > +int
> > +xfs_ag_get_geometry(
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno,
> > +	struct xfs_ag_geometry	*ageo)
> > +{
> > +	struct xfs_buf		*bp;
> > +	struct xfs_agi		*agi;
> > +	struct xfs_agf		*agf;
> > +	struct xfs_perag	*pag;
> > +	unsigned int		freeblks;
> > +	int			error;
> > +
> > +	memset(ageo, 0, sizeof(*ageo));
> > +
> > +	if (agno >= mp->m_sb.sb_agcount)
> > +		return -EINVAL;
> > +
> 
> I'd probably error check prior to the memset().

Ok.

> > +	error = xfs_ialloc_read_agi(mp, NULL, agno, &bp);
> > +	if (error)
> > +		return error;
> > +
> > +	agi = XFS_BUF_TO_AGI(bp);
> > +	ageo->ag_icount = be32_to_cpu(agi->agi_count);
> > +	ageo->ag_ifree = be32_to_cpu(agi->agi_freecount);
> > +	xfs_buf_relse(bp);
> > +
> > +	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &bp);
> > +	if (error)
> > +		return error;
> > +
> > +	agf = XFS_BUF_TO_AGF(bp);
> > +	pag = xfs_perag_get(mp, agno);
> > +	ageo->ag_length = be32_to_cpu(agf->agf_length);
> > +	freeblks = pag->pagf_freeblks +
> > +		   pag->pagf_flcount +
> > +		   pag->pagf_btreeblks -
> > +		   xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE);
> > +	ageo->ag_freeblks = freeblks;
> > +	xfs_perag_put(pag);
> > +	xfs_buf_relse(bp);
> > +
> 
> I wonder if we should lock down the agi and agf together to prevent any
> potential incoherent reporting between them..? For example, suppose we
> collect the agi values, release the agi and lose a race to the agf by an
> inode allocator who consumes more free blocks before we ultimately read
> the agf values and return.

Good point, will fix.

--D

> Brian
> 
> > +	ageo->ag_number = agno;
> > +	return 0;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > index 412702e23f61..5166322807e7 100644
> > --- a/fs/xfs/libxfs/xfs_ag.h
> > +++ b/fs/xfs/libxfs/xfs_ag.h
> > @@ -26,5 +26,7 @@ struct aghdr_init_data {
> >  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> >  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
> >  			struct aghdr_init_data *id, xfs_extlen_t len);
> > +int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
> > +			struct xfs_ag_geometry *ageo);
> >  
> >  #endif /* __LIBXFS_AG_H */
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 1dba751cde60..87226e00e7bd 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -266,6 +266,19 @@ typedef struct xfs_fsop_resblks {
> >  #define XFS_MIN_DBLOCKS(s) ((xfs_rfsblock_t)((s)->sb_agcount - 1) *	\
> >  			 (s)->sb_agblocks + XFS_MIN_AG_BLOCKS)
> >  
> > +/*
> > + * Output for XFS_IOC_AG_GEOMETRY
> > + */
> > +struct xfs_ag_geometry {
> > +	__u32		ag_number;	/* i/o: AG number */
> > +	__u32		ag_length;	/* o: length in blocks */
> > +	__u32		ag_freeblks;	/* o: free space */
> > +	__u32		ag_icount;	/* o: inodes allocated */
> > +	__u32		ag_ifree;	/* o: inodes free */
> > +	__u32		ag_reserved32;	/* o: zero */
> > +	__u64		ag_reserved[5];	/* o: zero */
> > +};
> > +
> >  /*
> >   * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
> >   */
> > @@ -619,6 +632,7 @@ struct xfs_scrub_metadata {
> >  #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
> >  /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
> >  #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
> > +#define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
> >  
> >  /*
> >   * ioctl commands that replace IRIX syssgi()'s
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 7fd8815633dc..b5918ce656bd 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -33,6 +33,7 @@
> >  #include "xfs_fsmap.h"
> >  #include "scrub/xfs_scrub.h"
> >  #include "xfs_sb.h"
> > +#include "xfs_ag.h"
> >  
> >  #include <linux/capability.h>
> >  #include <linux/cred.h>
> > @@ -834,6 +835,26 @@ xfs_ioc_fsgeometry(
> >  	return 0;
> >  }
> >  
> > +STATIC int
> > +xfs_ioc_ag_geometry(
> > +	struct xfs_mount	*mp,
> > +	void			__user *arg)
> > +{
> > +	struct xfs_ag_geometry	ageo;
> > +	int			error;
> > +
> > +	if (copy_from_user(&ageo, arg, sizeof(ageo)))
> > +		return -EFAULT;
> > +
> > +	error = xfs_ag_get_geometry(mp, ageo.ag_number, &ageo);
> > +	if (error)
> > +		return error;
> > +
> > +	if (copy_to_user(arg, &ageo, sizeof(ageo)))
> > +		return -EFAULT;
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Linux extended inode flags interface.
> >   */
> > @@ -1960,6 +1981,9 @@ xfs_file_ioctl(
> >  	case XFS_IOC_FSGEOMETRY:
> >  		return xfs_ioc_fsgeometry(mp, arg);
> >  
> > +	case XFS_IOC_AG_GEOMETRY:
> > +		return xfs_ioc_ag_geometry(mp, arg);
> > +
> >  	case XFS_IOC_GETVERSION:
> >  		return put_user(inode->i_generation, (int __user *)arg);
> >  
> > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > index 323cfd4b15dc..28d2110dd871 100644
> > --- a/fs/xfs/xfs_ioctl32.c
> > +++ b/fs/xfs/xfs_ioctl32.c
> > @@ -563,6 +563,7 @@ xfs_file_compat_ioctl(
> >  	case XFS_IOC_DIOINFO:
> >  	case XFS_IOC_FSGEOMETRY_V2:
> >  	case XFS_IOC_FSGEOMETRY:
> > +	case XFS_IOC_AG_GEOMETRY:
> >  	case XFS_IOC_FSGETXATTR:
> >  	case XFS_IOC_FSSETXATTR:
> >  	case XFS_IOC_FSGETXATTRA:
> > 
