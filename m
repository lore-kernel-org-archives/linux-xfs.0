Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34685 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbcKEAAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:00:50 -0400
Date: Fri, 4 Nov 2016 17:00:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] libxfs: clean up _dir2_data_freescan
Message-ID: <20161105000041.GB2786@birch.djwong.org>
References: <147828429514.31793.3070284385118900515.stgit@birch.djwong.org>
 <147828432807.31793.11613248965488442086.stgit@birch.djwong.org>
 <b7044544-ebd4-b62c-4873-bcd04b1241ab@sandeen.net>
 <20161104230952.GH32036@birch.djwong.org>
 <37b43c54-ae10-a1b6-2136-e3a3f9e96a2d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37b43c54-ae10-a1b6-2136-e3a3f9e96a2d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 04, 2016 at 06:20:22PM -0500, Eric Sandeen wrote:
> On 11/4/16 6:09 PM, Darrick J. Wong wrote:
> > On Fri, Nov 04, 2016 at 05:58:57PM -0500, Eric Sandeen wrote:
> >> On 11/4/16 1:32 PM, Darrick J. Wong wrote:
> >>> Refactor the implementations of xfs_dir2_data_freescan into a
> >>> routine that takes the raw directory block parameters and
> >>> a second function that figures out the raw parameters from the
> >>> directory inode.  This enables us to use the exact same code
> >>> for both userspace and the kernel, since repair knows exactly
> >>> which directory block geometry parameters it needs.
> >>>
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> seems fine tho I can't say I like the new function name; what
> >> does "_hdr" mean?  They both take a *hdr ...
> >>
> >> maybe _xfs_dir2_data_freescan or xfs_dir2_data_freescan_int?
> > 
> > I'll change it to xfs_dir2_data_freescan_geo().
> 
> it gets both geo and ops, both derived from dp ...
> 
> see i.e. xfs_btree_init_block, xfs_rtmodify_summary etc for
> examples of a simple args translation calling an "*_int()"
> (internal?) function.  That's pretty common in the xfs code.

Ok I'll change it.

--D

> 
> -Eric
> 
> > --D
> > 
> >>
> >> *shrug*
> >>
> >> -Eric
> >>
> >>> ---
> >>>  fs/xfs/libxfs/xfs_dir2.h      |    3 +++
> >>>  fs/xfs/libxfs/xfs_dir2_data.c |   24 +++++++++++++++++-------
> >>>  2 files changed, 20 insertions(+), 7 deletions(-)
> >>>
> >>>
> >>> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> >>> index becc926..42456de 100644
> >>> --- a/fs/xfs/libxfs/xfs_dir2.h
> >>> +++ b/fs/xfs/libxfs/xfs_dir2.h
> >>> @@ -157,6 +157,9 @@ extern int xfs_dir2_isleaf(struct xfs_da_args *args, int *r);
> >>>  extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
> >>>  				struct xfs_buf *bp);
> >>>  
> >>> +extern void xfs_dir2_data_freescan_hdr(struct xfs_da_geometry *geo,
> >>> +		const struct xfs_dir_ops *ops,
> >>> +		struct xfs_dir2_data_hdr *hdr, int *loghead);
> >>>  extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
> >>>  		struct xfs_dir2_data_hdr *hdr, int *loghead);
> >>>  extern void xfs_dir2_data_log_entry(struct xfs_da_args *args,
> >>> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> >>> index 725fc78..1729eb2 100644
> >>> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> >>> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> >>> @@ -505,8 +505,9 @@ xfs_dir2_data_freeremove(
> >>>   * Given a data block, reconstruct its bestfree map.
> >>>   */
> >>>  void
> >>> -xfs_dir2_data_freescan(
> >>> -	struct xfs_inode	*dp,
> >>> +xfs_dir2_data_freescan_hdr(
> >>> +	struct xfs_da_geometry	*geo,
> >>> +	const struct xfs_dir_ops *ops,
> >>>  	struct xfs_dir2_data_hdr *hdr,
> >>>  	int			*loghead)
> >>>  {
> >>> @@ -516,7 +517,6 @@ xfs_dir2_data_freescan(
> >>>  	struct xfs_dir2_data_free *bf;
> >>>  	char			*endp;		/* end of block's data */
> >>>  	char			*p;		/* current entry pointer */
> >>> -	struct xfs_da_geometry	*geo = dp->i_mount->m_dir_geo;
> >>>  
> >>>  	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
> >>>  	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
> >>> @@ -526,13 +526,13 @@ xfs_dir2_data_freescan(
> >>>  	/*
> >>>  	 * Start by clearing the table.
> >>>  	 */
> >>> -	bf = dp->d_ops->data_bestfree_p(hdr);
> >>> +	bf = ops->data_bestfree_p(hdr);
> >>>  	memset(bf, 0, sizeof(*bf) * XFS_DIR2_DATA_FD_COUNT);
> >>>  	*loghead = 1;
> >>>  	/*
> >>>  	 * Set up pointers.
> >>>  	 */
> >>> -	p = (char *)dp->d_ops->data_entry_p(hdr);
> >>> +	p = (char *)ops->data_entry_p(hdr);
> >>>  	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
> >>>  	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
> >>>  		btp = xfs_dir2_block_tail_p(geo, hdr);
> >>> @@ -559,12 +559,22 @@ xfs_dir2_data_freescan(
> >>>  		else {
> >>>  			dep = (xfs_dir2_data_entry_t *)p;
> >>>  			ASSERT((char *)dep - (char *)hdr ==
> >>> -			       be16_to_cpu(*dp->d_ops->data_entry_tag_p(dep)));
> >>> -			p += dp->d_ops->data_entsize(dep->namelen);
> >>> +			       be16_to_cpu(*ops->data_entry_tag_p(dep)));
> >>> +			p += ops->data_entsize(dep->namelen);
> >>>  		}
> >>>  	}
> >>>  }
> >>>  
> >>> +void
> >>> +xfs_dir2_data_freescan(
> >>> +	struct xfs_inode	*dp,
> >>> +	struct xfs_dir2_data_hdr *hdr,
> >>> +	int			*loghead)
> >>> +{
> >>> +	return xfs_dir2_data_freescan_hdr(dp->i_mount->m_dir_geo, dp->d_ops,
> >>> +			hdr, loghead);
> >>> +}
> >>> +
> >>>  /*
> >>>   * Initialize a data block at the given block number in the directory.
> >>>   * Give back the buffer for the created block.
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
