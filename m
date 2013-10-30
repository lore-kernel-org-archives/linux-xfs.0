Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D68597F52
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 17:39:04 -0500 (CDT)
Date: Wed, 30 Oct 2013 17:39:04 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 01/15] xfs: xfs_remove deadlocks due to inverted AGF vs
	AGI lock ordering
Message-ID: <20131030223904.GM1935@sgi.com>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
	<1383045118-31107-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383045118-31107-2-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Tue, Oct 29, 2013 at 10:11:44PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Removing an inode from the namespace involves removing the directory
> entry and dropping the link count on the inode. Removing the
> directory entry can result in locking an AGF (directory blocks were
> freed) and removing a link count can result in placing the inode on
> an unlinked list which results in locking an AGI.
> 
> The big problem here is that we have an ordering constraint on AGF
> and AGI locking - inode allocation locks the AGI, then can allocate
> a new extent for new inodes, locking the AGF after the AGI.
> Similarly, freeing the inode removes the inode from the unlinked
> list, requiring that we lock the AGI first, and then freeing the
> inode can result in an inode chunk being freed and hence freeing
> disk space requiring that we lock an AGF.
> 
> Hence the ordering that is imposed by other parts of the code is AGI
> before AGF. This means we cannot remove the directory entry before
> we drop the inode reference count and put it on the unlinked list as
> this results in a lock order of AGF then AGI, and this can deadlock
> against inode allocation and freeing. Therefore we must drop the
> link counts before we remove the directory entry.
> 
> This is still safe from a transactional point of view - it is not
> until we get to xfs_bmap_finish() that we have the possibility of
> multiple transactions in this operation. Hence as long as we remove
> the directory entry and drop the link count in the first transaction
> of the remove operation, there are no transactional constraints on
> the ordering here.
> 
> Change the ordering of the operations in the xfs_remove() function
> to align the ordering of AGI and AGF locking to match that of the
> rest of the code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

These two codepaths look plausible for the deadlock you described:

inode allocation locking:
xfs_create
  xfs_dir_ialloc
    xfs_ialloc
      xfs_dialloc
        xfs_ialloc_read_agi              * takes agi
        xfs_ialloc_ag_alloc
          xfs_alloc_vextent
            xfs_alloc_fix_freelist
              xfs_alloc_read_agf         * takes agf

vs

xfs_remove
  xfs_dir_removename
    xfs_dir2_node_removename
      xfs_dir2_leafn_remove
        xfs_dir2_shrink_inode
          xfs_bunmapi
          . xfs_bmap_del_extent
          .   xfs_btree_delete
          .     xfs_btree_delrec
          .       .free_block
          .         xfs_bmbt_free_block
          .           xfs_bmap_add_free  * adds to free list, doesn't take agf
            xfs_bmap_extents_to_btree
              xfs_alloc_vextent          * takes agf
  xfs_droplink
    xfs_iunlink
      xfs_read_agi       * takes agi

I was thinking I'd find something in .free_block, but I didn't.  But it does
look like we'll take the agf if we have to convert between directory formats in
xfs_dir2_leafn_remove, and it looks like there are a few more opportunities to
take the agf in xfs_bunmapi...

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
