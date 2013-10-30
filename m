Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B87107F54
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 18:16:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 573D6AC004
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 16:16:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aRs3EXdCfkgH407c for <xfs@oss.sgi.com>;
	Wed, 30 Oct 2013 16:16:04 -0700 (PDT)
Date: Thu, 31 Oct 2013 10:15:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/15] xfs: xfs_remove deadlocks due to inverted AGF vs
	AGI lock ordering
Message-ID: <20131030231557.GJ6188@dastard>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
	<1383045118-31107-2-git-send-email-david@fromorbit.com>
	<20131030223904.GM1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131030223904.GM1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 30, 2013 at 05:39:04PM -0500, Ben Myers wrote:
> On Tue, Oct 29, 2013 at 10:11:44PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Removing an inode from the namespace involves removing the directory
> > entry and dropping the link count on the inode. Removing the
> > directory entry can result in locking an AGF (directory blocks were
> > freed) and removing a link count can result in placing the inode on
> > an unlinked list which results in locking an AGI.
> > 
> > The big problem here is that we have an ordering constraint on AGF
> > and AGI locking - inode allocation locks the AGI, then can allocate
> > a new extent for new inodes, locking the AGF after the AGI.
> > Similarly, freeing the inode removes the inode from the unlinked
> > list, requiring that we lock the AGI first, and then freeing the
> > inode can result in an inode chunk being freed and hence freeing
> > disk space requiring that we lock an AGF.
> > 
> > Hence the ordering that is imposed by other parts of the code is AGI
> > before AGF. This means we cannot remove the directory entry before
> > we drop the inode reference count and put it on the unlinked list as
> > this results in a lock order of AGF then AGI, and this can deadlock
> > against inode allocation and freeing. Therefore we must drop the
> > link counts before we remove the directory entry.
> > 
> > This is still safe from a transactional point of view - it is not
> > until we get to xfs_bmap_finish() that we have the possibility of
> > multiple transactions in this operation. Hence as long as we remove
> > the directory entry and drop the link count in the first transaction
> > of the remove operation, there are no transactional constraints on
> > the ordering here.
> > 
> > Change the ordering of the operations in the xfs_remove() function
> > to align the ordering of AGI and AGF locking to match that of the
> > rest of the code.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> These two codepaths look plausible for the deadlock you described:
> 
> inode allocation locking:
> xfs_create
>   xfs_dir_ialloc
>     xfs_ialloc
>       xfs_dialloc
>         xfs_ialloc_read_agi              * takes agi
>         xfs_ialloc_ag_alloc
>           xfs_alloc_vextent
>             xfs_alloc_fix_freelist
>               xfs_alloc_read_agf         * takes agf
> 
> vs
> 
> xfs_remove
>   xfs_dir_removename
>     xfs_dir2_node_removename
>       xfs_dir2_leafn_remove
>         xfs_dir2_shrink_inode
>           xfs_bunmapi
>           . xfs_bmap_del_extent
>           .   xfs_btree_delete
>           .     xfs_btree_delrec
>           .       .free_block
>           .         xfs_bmbt_free_block
>           .           xfs_bmap_add_free  * adds to free list, doesn't take agf
>             xfs_bmap_extents_to_btree
>               xfs_alloc_vextent          * takes agf

Yeah, that's not the obvious or common path, but it has the same
cause of allocation - it's a bmbt block that gets allocated. i.e.
removing a block from the middle of a contiguous extent can result
in the extent tree growing, and hence needing allocation of block
for the new entry. This is the path I was hitting:

....
        xfs_dir2_shrink_inode
          xfs_bunmapi
            xfs_bmap_del_extent
	      case 0: /* delete middle of extent */
	      xfs_btree_update
	      xfs_btree_increment
	      xfs_btree_insert
	        xfs_btree_insrec
		  xfs_btree_make_block_unfull
		    xfs_btree_split
		      .alloc_block
		        xfs_bmbt_alloc_block
		          xfs_alloc_vextent	* takes agf


> I was thinking I'd find something in .free_block, but I didn't.

Right, data extents are added to the free list that is later walked
and freed via xfs_bmap_finish() after it adds an EFI to match the
free list to the current transaction the free list belongs to and
commits it.

> But it does
> look like we'll take the agf if we have to convert between directory formats in
> xfs_dir2_leafn_remove, and it looks like there are a few more opportunities to
> take the agf in xfs_bunmapi...

Yup, but with the above call chain, any random block removal can
cause a bmbt allocation to occur, so we don't really need to look
any further. Indeed, you should just assume that any call to
xfs_bunmapi() to free an extent will require block allocation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
