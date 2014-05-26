Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBE707F51
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 16:39:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC945304032
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 14:39:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8CU4TBxlloNpxvFX for <xfs@oss.sgi.com>;
	Mon, 26 May 2014 14:39:44 -0700 (PDT)
Date: Tue, 27 May 2014 07:39:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/16] xfs: introduce directory geometry structure
Message-ID: <20140526213929.GO18954@dastard>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-2-git-send-email-david@fromorbit.com>
	<20140523190459.GB8343@laptop.bfoster>
	<20140526042807.GW8554@dastard>
	<20140526132954.GA61135@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140526132954.GA61135@bfoster.bfoster>
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

On Mon, May 26, 2014 at 09:29:55AM -0400, Brian Foster wrote:
> On Mon, May 26, 2014 at 02:28:07PM +1000, Dave Chinner wrote:
> > On Fri, May 23, 2014 at 03:04:59PM -0400, Brian Foster wrote:
> > > On Fri, May 23, 2014 at 10:03:37AM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > The directory code has a dependency on the struct xfs_mount to
> > > > supply the directory block geometry. Block size, block log size,
> > > > and other parameters are pre-caclulated in the struct xfs_mount or
> > > > access directly from the superblock embedded in the struct
> > > > xfs_mount.
> > > > 
> > > > Extract all of this geometry information out of the struct xfs_mount
> > > > and superblock and place it into a new struct xfs_da_geometry
> > > > defined by the directory code. Allocate and initialise it at mount
> > > > time, and attach it to the struct xfs_mount so it canbe passed back
> > > > into the directory code appropriately rather than using the struct
> > > > xfs_mount.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ....
> > > > @@ -99,24 +100,56 @@ xfs_dir_mount(
> > > >  	mp->m_dir_inode_ops = xfs_dir_get_ops(mp, NULL);
> > > >  	mp->m_nondir_inode_ops = xfs_nondir_get_ops(mp, NULL);
> > > >  
> > > > -	mp->m_dirblksize = 1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog);
> > > > -	mp->m_dirblkfsbs = 1 << mp->m_sb.sb_dirblklog;
> > > > -	mp->m_dirdatablk = xfs_dir2_db_to_da(mp, XFS_DIR2_DATA_FIRSTDB(mp));
> > > > -	mp->m_dirleafblk = xfs_dir2_db_to_da(mp, XFS_DIR2_LEAF_FIRSTDB(mp));
> > > > -	mp->m_dirfreeblk = xfs_dir2_db_to_da(mp, XFS_DIR2_FREE_FIRSTDB(mp));
> > > > -
> > > >  	nodehdr_size = mp->m_dir_inode_ops->node_hdr_size;
> > > > -	mp->m_attr_node_ents = (mp->m_sb.sb_blocksize - nodehdr_size) /
> > > > +	mp->m_dir_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
> > > > +				    KM_SLEEP | KM_MAYFAIL);
> > > > +	mp->m_attr_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
> > > > +				     KM_SLEEP | KM_MAYFAIL);
> > > > +	if (!mp->m_dir_geo || !mp->m_attr_geo) {
> > > > +		kmem_free(mp->m_dir_geo);
> > > > +		kmem_free(mp->m_attr_geo);
> > > > +		return ENOMEM;
> > > > +	}
> > > 
> > > While it looks like everything is handled correctly here, I think this
> > > would be much cleaner if we just created a set of xfs_mount_alloc/free()
> > > helpers that did all of the allocations at once. Then we wouldn't have a
> > > situation where the caller has non-obvious memory allocations to clean
> > > up should it fail sometime after calling xfs_da_mount().
> > 
> > I think that each subsystem needs to have it's own init/teardown
> > functions, and that the rest of the code needs to call them
> > appropriately. Yes, error handling can be non-trivial, but the idea
> > that we do unconditional allocation for subsystems/configs that we
> > may not use (eg. due to mkfs options) seems a little wrong to me.
> > 
> > And aggregating all the allocations doesn't remove the need for most
> > subsystems to be able to return initialisation errors, so int he
> > long run it doesn't really change the fact that we have to
> > initialise and then tear down on subsequent subsystem init
> > failures...
> > 
> 
> Part of the reason I suggested that approach was that the allocation
> appeared unconditional. Now that I think about it, a related question is
> why not embed the structers into the mount?

The exact reason I wrote the patchset in the first place -
dependencies. If it gets embedded into the struct xfs_mount, there's
now a dependency between the header files, and a circular one at
that (xfs_mount requires xfs_da_btree.h, xfs_da_btree.h requires
xfs_mount.h). By using allocations and forward declarations of the
structure we remove dependencies between the header files...

> No matter, perhaps there is good reason for that. If we do want to keep
> it localized to the subsystem, creating an xfs_da_unmount() (perhaps
> just an inline) would be cleaner and more consistent IMO.

*nod*

I can add that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
