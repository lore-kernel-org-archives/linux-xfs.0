Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 52BBC7F3F
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 23:28:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D86F304039
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 21:28:13 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NNyp8HM6TI6iZ4zT for <xfs@oss.sgi.com>;
	Sun, 25 May 2014 21:28:11 -0700 (PDT)
Date: Mon, 26 May 2014 14:28:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/16] xfs: introduce directory geometry structure
Message-ID: <20140526042807.GW8554@dastard>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-2-git-send-email-david@fromorbit.com>
	<20140523190459.GB8343@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140523190459.GB8343@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, May 23, 2014 at 03:04:59PM -0400, Brian Foster wrote:
> On Fri, May 23, 2014 at 10:03:37AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The directory code has a dependency on the struct xfs_mount to
> > supply the directory block geometry. Block size, block log size,
> > and other parameters are pre-caclulated in the struct xfs_mount or
> > access directly from the superblock embedded in the struct
> > xfs_mount.
> > 
> > Extract all of this geometry information out of the struct xfs_mount
> > and superblock and place it into a new struct xfs_da_geometry
> > defined by the directory code. Allocate and initialise it at mount
> > time, and attach it to the struct xfs_mount so it canbe passed back
> > into the directory code appropriately rather than using the struct
> > xfs_mount.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> > @@ -99,24 +100,56 @@ xfs_dir_mount(
> >  	mp->m_dir_inode_ops = xfs_dir_get_ops(mp, NULL);
> >  	mp->m_nondir_inode_ops = xfs_nondir_get_ops(mp, NULL);
> >  
> > -	mp->m_dirblksize = 1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog);
> > -	mp->m_dirblkfsbs = 1 << mp->m_sb.sb_dirblklog;
> > -	mp->m_dirdatablk = xfs_dir2_db_to_da(mp, XFS_DIR2_DATA_FIRSTDB(mp));
> > -	mp->m_dirleafblk = xfs_dir2_db_to_da(mp, XFS_DIR2_LEAF_FIRSTDB(mp));
> > -	mp->m_dirfreeblk = xfs_dir2_db_to_da(mp, XFS_DIR2_FREE_FIRSTDB(mp));
> > -
> >  	nodehdr_size = mp->m_dir_inode_ops->node_hdr_size;
> > -	mp->m_attr_node_ents = (mp->m_sb.sb_blocksize - nodehdr_size) /
> > +	mp->m_dir_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
> > +				    KM_SLEEP | KM_MAYFAIL);
> > +	mp->m_attr_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
> > +				     KM_SLEEP | KM_MAYFAIL);
> > +	if (!mp->m_dir_geo || !mp->m_attr_geo) {
> > +		kmem_free(mp->m_dir_geo);
> > +		kmem_free(mp->m_attr_geo);
> > +		return ENOMEM;
> > +	}
> 
> While it looks like everything is handled correctly here, I think this
> would be much cleaner if we just created a set of xfs_mount_alloc/free()
> helpers that did all of the allocations at once. Then we wouldn't have a
> situation where the caller has non-obvious memory allocations to clean
> up should it fail sometime after calling xfs_da_mount().

I think that each subsystem needs to have it's own init/teardown
functions, and that the rest of the code needs to call them
appropriately. Yes, error handling can be non-trivial, but the idea
that we do unconditional allocation for subsystems/configs that we
may not use (eg. due to mkfs options) seems a little wrong to me.

And aggregating all the allocations doesn't remove the need for most
subsystems to be able to return initialisation errors, so int he
long run it doesn't really change the fact that we have to
initialise and then tear down on subsequent subsystem init
failures...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
