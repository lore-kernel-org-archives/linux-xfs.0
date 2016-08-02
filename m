Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85A177CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 15:48:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5644D304048
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 13:48:05 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 9wTcXeebTHHCNdwf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 13:48:02 -0700 (PDT)
Date: Tue, 2 Aug 2016 13:47:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/47] xfs: change xfs_bmap_{finish, cancel, init, free}
	-> xfs_defer_*
Message-ID: <20160802204746.GM8590@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907707014.25461.326080392148826094.stgit@birch.djwong.org>
	<20160802173033.GD54148@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160802173033.GD54148@bfoster.bfoster>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Tue, Aug 02, 2016 at 01:30:33PM -0400, Brian Foster wrote:
> On Wed, Jul 20, 2016 at 09:57:50PM -0700, Darrick J. Wong wrote:
> > Drop the compatibility shims that we were using to integrate the new
> > deferred operation mechanism into the existing code.  No new code.
> > 
> > v2: Also change xfs_bmap_free_item -> xfs_extent_free_item.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c        |   58 ++++++++++++++++++------------------
> >  fs/xfs/libxfs/xfs_attr_remote.c |   14 ++++-----
> >  fs/xfs/libxfs/xfs_bmap.c        |   46 ++++++++++++++---------------
> >  fs/xfs/libxfs/xfs_bmap.h        |   18 ++++++-----
> >  fs/xfs/libxfs/xfs_btree.h       |    5 ++-
> >  fs/xfs/libxfs/xfs_da_btree.h    |    4 +--
> >  fs/xfs/libxfs/xfs_defer.h       |    7 ----
> >  fs/xfs/libxfs/xfs_dir2.c        |    6 ++--
> >  fs/xfs/libxfs/xfs_dir2.h        |    8 +++--
> >  fs/xfs/libxfs/xfs_ialloc.c      |    6 ++--
> >  fs/xfs/libxfs/xfs_ialloc.h      |    2 +
> >  fs/xfs/libxfs/xfs_trans_resv.c  |    4 +--
> >  fs/xfs/xfs_bmap_util.c          |   28 +++++++++---------
> >  fs/xfs/xfs_bmap_util.h          |    2 +
> >  fs/xfs/xfs_dquot.c              |   10 +++---
> >  fs/xfs/xfs_inode.c              |   62 ++++++++++++++++++++-------------------
> >  fs/xfs/xfs_inode.h              |    4 +--
> >  fs/xfs/xfs_iomap.c              |   24 ++++++++-------
> >  fs/xfs/xfs_rtalloc.c            |    8 +++--
> >  fs/xfs/xfs_super.c              |    2 +
> >  fs/xfs/xfs_symlink.c            |   16 +++++-----
> >  fs/xfs/xfs_trans.h              |    5 ---
> >  fs/xfs/xfs_trans_extfree.c      |   36 +++++++++++------------
> >  23 files changed, 182 insertions(+), 193 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> > index a9f34ee..b484902 100644
> > --- a/fs/xfs/xfs_trans_extfree.c
> > +++ b/fs/xfs/xfs_trans_extfree.c
> > @@ -35,7 +35,7 @@
> >   * caller must use all nextents extents, because we are not
> >   * flexible about this at all.
> >   */
> > -struct xfs_efi_log_item *
> > +STATIC struct xfs_efi_log_item *
> >  xfs_trans_get_efi(struct xfs_trans	*tp,
> 
> I think we should just fold this into the one caller below.
> 
> >  		  uint			nextents)
> >  {
> > @@ -59,7 +59,7 @@ xfs_trans_get_efi(struct xfs_trans	*tp,
> >   * extent is to be logged as needing to be freed.  It should
> >   * be called once for each extent to be freed.
> >   */
> > -void
> > +STATIC void
> >  xfs_trans_log_efi_extent(struct xfs_trans		*tp,
> >  			 struct xfs_efi_log_item	*efip,
> >  			 xfs_fsblock_t			start_block,
> 
> Same here. Otherwise looks good:

Ok, will do.

--D
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > @@ -156,13 +156,13 @@ xfs_extent_free_diff_items(
> >  	struct list_head		*b)
> >  {
> >  	struct xfs_mount		*mp = priv;
> > -	struct xfs_bmap_free_item	*ra;
> > -	struct xfs_bmap_free_item	*rb;
> > +	struct xfs_extent_free_item	*ra;
> > +	struct xfs_extent_free_item	*rb;
> >  
> > -	ra = container_of(a, struct xfs_bmap_free_item, xbfi_list);
> > -	rb = container_of(b, struct xfs_bmap_free_item, xbfi_list);
> > -	return  XFS_FSB_TO_AGNO(mp, ra->xbfi_startblock) -
> > -		XFS_FSB_TO_AGNO(mp, rb->xbfi_startblock);
> > +	ra = container_of(a, struct xfs_extent_free_item, xefi_list);
> > +	rb = container_of(b, struct xfs_extent_free_item, xefi_list);
> > +	return  XFS_FSB_TO_AGNO(mp, ra->xefi_startblock) -
> > +		XFS_FSB_TO_AGNO(mp, rb->xefi_startblock);
> >  }
> >  
> >  /* Get an EFI. */
> > @@ -181,11 +181,11 @@ xfs_extent_free_log_item(
> >  	void				*intent,
> >  	struct list_head		*item)
> >  {
> > -	struct xfs_bmap_free_item	*free;
> > +	struct xfs_extent_free_item	*free;
> >  
> > -	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
> > -	xfs_trans_log_efi_extent(tp, intent, free->xbfi_startblock,
> > -			free->xbfi_blockcount);
> > +	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> > +	xfs_trans_log_efi_extent(tp, intent, free->xefi_startblock,
> > +			free->xefi_blockcount);
> >  }
> >  
> >  /* Get an EFD so we can process all the free extents. */
> > @@ -207,13 +207,13 @@ xfs_extent_free_finish_item(
> >  	void				*done_item,
> >  	void				**state)
> >  {
> > -	struct xfs_bmap_free_item	*free;
> > +	struct xfs_extent_free_item	*free;
> >  	int				error;
> >  
> > -	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
> > +	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> >  	error = xfs_trans_free_extent(tp, done_item,
> > -			free->xbfi_startblock,
> > -			free->xbfi_blockcount);
> > +			free->xefi_startblock,
> > +			free->xefi_blockcount);
> >  	kmem_free(free);
> >  	return error;
> >  }
> > @@ -231,9 +231,9 @@ STATIC void
> >  xfs_extent_free_cancel_item(
> >  	struct list_head		*item)
> >  {
> > -	struct xfs_bmap_free_item	*free;
> > +	struct xfs_extent_free_item	*free;
> >  
> > -	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
> > +	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> >  	kmem_free(free);
> >  }
> >  
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
