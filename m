Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A7307CF2
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 01:44:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BE891304053
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 23:44:23 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5ibAIuQ3ayRiXPQR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jul 2016 23:44:20 -0700 (PDT)
Date: Tue, 5 Jul 2016 23:44:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 026/119] xfs: add owner field to extent allocation and
	freeing
Message-ID: <20160706064410.GC18951@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612643914.12839.17925699349002137545.stgit@birch.djwong.org>
	<20160706040120.GA12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160706040120.GA12670@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Wed, Jul 06, 2016 at 02:01:20PM +1000, Dave Chinner wrote:
> On Thu, Jun 16, 2016 at 06:20:39PM -0700, Darrick J. Wong wrote:
> > For the rmap btree to work, we have to feed the extent owner
> > information to the the allocation and freeing functions. This
> > information is what will end up in the rmap btree that tracks
> > allocated extents. While we technically don't need the owner
> > information when freeing extents, passing it allows us to validate
> > that the extent we are removing from the rmap btree actually
> > belonged to the owner we expected it to belong to.
> ....
> 
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -1318,6 +1318,71 @@ typedef __be32 xfs_inobt_ptr_t;
> >   */
> >  #define	XFS_RMAP_CRC_MAGIC	0x524d4233	/* 'RMB3' */
> >  
> > +/*
> > + * Ownership info for an extent.  This is used to create reverse-mapping
> > + * entries.
> > + */
> > +#define XFS_OWNER_INFO_ATTR_FORK	(1 << 0)
> > +#define XFS_OWNER_INFO_BMBT_BLOCK	(1 << 1)
> > +struct xfs_owner_info {
> > +	uint64_t		oi_owner;
> > +	xfs_fileoff_t		oi_offset;
> > +	unsigned int		oi_flags;
> > +};
> > +
> > +static inline void
> > +xfs_rmap_ag_owner(
> > +	struct xfs_owner_info	*oi,
> > +	uint64_t		owner)
> > +{
> > +	oi->oi_owner = owner;
> > +	oi->oi_offset = 0;
> > +	oi->oi_flags = 0;
> > +}
> > +
> > +static inline void
> > +xfs_rmap_ino_bmbt_owner(
> > +	struct xfs_owner_info	*oi,
> > +	xfs_ino_t		ino,
> > +	int			whichfork)
> > +{
> > +	oi->oi_owner = ino;
> > +	oi->oi_offset = 0;
> > +	oi->oi_flags = XFS_OWNER_INFO_BMBT_BLOCK;
> > +	if (whichfork == XFS_ATTR_FORK)
> > +		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
> > +}
> > +
> > +static inline void
> > +xfs_rmap_ino_owner(
> > +	struct xfs_owner_info	*oi,
> > +	xfs_ino_t		ino,
> > +	int			whichfork,
> > +	xfs_fileoff_t		offset)
> > +{
> > +	oi->oi_owner = ino;
> > +	oi->oi_offset = offset;
> > +	oi->oi_flags = 0;
> > +	if (whichfork == XFS_ATTR_FORK)
> > +		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
> > +}
> 
> One of the things we've avaoided doing so far is putting functions
> like this into xfs_format.h. xfs_format.h is really just for the
> on disk format definitions, not the code to access/pack/unpack it.
> Hence I think think these sorts of functions need to be moved to
> xfs_rmap.h....

Yes.

I've already split xfs_rmap_btree.h into xfs_rmap.h (high level rmap
functions) and xfs_rmap_btree.h (low level btree functions) for the
realtime rmapbt code split.  Won't be difficult to move these over
from xfs_format.h.

Speaking of which, I've pushed that along to the point that the
kernel-side implementation is at pre-alpha eatmydata stage, check
works well enough that xfstests doesn't explode, and we can collect
rt rmaps for checking and rebuilding of the tree.  I'll try to finish
that tomorrow.

--D

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
