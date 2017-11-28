Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753155AbdK1NaD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Nov 2017 08:30:03 -0500
Date: Tue, 28 Nov 2017 08:30:02 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: include inobt buffers in ifree tx log
 reservation
Message-ID: <20171128133001.GB45759@bfoster.bfoster>
References: <20171127202434.43125-1-bfoster@redhat.com>
 <20171127202434.43125-3-bfoster@redhat.com>
 <20171127222857.GA5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127222857.GA5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 09:28:57AM +1100, Dave Chinner wrote:
> On Mon, Nov 27, 2017 at 03:24:32PM -0500, Brian Foster wrote:
> > The tr_ifree transaction handles inode unlinks and inode chunk
> > frees. The current transaction calculation does not accurately
> > reflect worst case changes to the inode btree, however. The inobt
> > portion of the current transaction reservation only covers
> > modification of a single inobt buffer (for the particular inode
> > record). This is a historical artifact from the days before XFS
> > supported full inode chunk removal.
> > 
> > When support for inode chunk removal was added in commit
> > 254f6311ed1b ("Implement deletion of inode clusters in XFS."), the
> > additional log reservation required for chunk removal was not added
> > correctly. The new reservation only considered the header overhead
> > of associated buffers rather than the full contents of the btrees
> > and AGF and AGFL buffers affected by the transaction. The
> > reservation for the free space btrees was subsequently fixed up in
> > commit 5fe6abb82f76 ("Add space for inode and allocation btrees to
> > ITRUNCATE log reservation"), but the res. for full inobt joins has
> > never been added.
> > 
> > Update xfs_calc_ifree_reservation() to include a full inobt join in
> > the reservation calculation. Refactor the undocumented +2 blocks for
> > the AGF and AGFL buffers into the appropriate place so they are
> > accounted as sectors (not FSBs) and update the associated comments.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_trans_resv.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index 6bd916bd35e2..4cd7cd1e60da 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -490,10 +490,10 @@ xfs_calc_symlink_reservation(
> >  /*
> >   * In freeing an inode we can modify:
> >   *    the inode being freed: inode size
> > - *    the super block free inode counter: sector size
> > + *    the super block free inode counter, AGF and AGFL: sector size
> >   *    the agi hash list and counters: sector size
> > - *    the inode btree entry: block size
> >   *    the on disk inode before ours in the agi hash list: inode cluster size
> > + *    the inode chunk is marked stale (headers only)
> >   *    the inode btree: max depth * blocksize
> >   *    the allocation btrees: 2 trees * (max depth - 1) * block size
> >   *    the finobt (record insertion, removal or modification)
> > @@ -504,12 +504,11 @@ xfs_calc_ifree_reservation(
> >  {
> >  	return XFS_DQUOT_LOGRES(mp) +
> >  		xfs_calc_inode_res(mp, 1) +
> 
>  *    the inode being freed: inode size
> 
> > -		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> > -		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
> > +		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> 
>  *    the super block free inode counter, AGF and AGFL: sector size
> 
> 		[missing, hidden in calc_iunlink_remove]
> 
>  *    the agi hash list and counters: sector size
> 
> >  		xfs_calc_iunlink_remove_reservation(mp) +
> 
>  *    the on disk inode before ours in the agi hash list: inode cluster size
> 
> 		[missing]
> 
>  *    on-disk inode to log the di_next_unlinked: inode cluster size
> 
> Yes, check the xfs_iunlink_remove() code - we can log two inode
> cluster buffers there: the one prior to us in the unlinked list,
> and ours to reset the di_next_unlinked pointer to
> null. IOWs, xfs_calc_iunlink_remove_reservation() needs to take into
> account /2/ inode cluster buffers, not one.
> 

I was wondering why this wouldn't be covered by the inode size included
above, but looking at the code, I guess we log the agi unlinked changes
directly in the cluster buffer. That means we have separate log items
with independent reservation consumption between the unlinked list
fixups and core inode.

I'll update xfs_calc_iunlink_remove_reservation() to include another
cluster and add a comment.

> >  		xfs_calc_buf_res(1, 0) +
> 
> No idea what this is.
> 

Same, I didn't want to remove it unless we could identify what it was
originally intended for.

> > -		xfs_calc_buf_res(2 + mp->m_ialloc_blks +
> > -				 mp->m_in_maxlevels, 0) +
> > +		xfs_calc_buf_res(mp->m_ialloc_blks, 0) +
> 
>  *    the inode chunk is marked stale (headers only)
> 
> > +		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
> 
>   *    the inode btree: max depth * blocksize
> 
> >  		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> >  				 XFS_FSB_TO_B(mp, 1)) +
>   *    the allocation btrees: 2 trees * (max depth - 1) * block size
> 
> >  		xfs_calc_finobt_res(mp, 0, 1);
> 
>   *    the finobt (record insertion, removal or modification)
> 
> The rest look fine.
> 

Thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
