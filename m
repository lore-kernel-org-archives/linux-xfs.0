Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6764E7CA0
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2016 16:41:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5A93AC005
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2016 14:41:54 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id A1EHOdPosIoDjEQ6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 27 Jun 2016 14:41:52 -0700 (PDT)
Date: Mon, 27 Jun 2016 14:41:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 018/119] xfs: enable the xfs_defer mechanism to process
	extents to free
Message-ID: <20160627214145.GC4921@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612638717.12839.11007379793448761871.stgit@birch.djwong.org>
	<20160627131508.GC23076@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160627131508.GC23076@bfoster.bfoster>
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

On Mon, Jun 27, 2016 at 09:15:08AM -0400, Brian Foster wrote:
> On Thu, Jun 16, 2016 at 06:19:47PM -0700, Darrick J. Wong wrote:
> > Connect the xfs_defer mechanism with the pieces that we'll need to
> > handle deferred extent freeing.  We'll wire up the existing code to
> > our new deferred mechanism later.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Could we merge this with the xfs_trans_*efi/efd* bits? We'd need to
> preserve some calls for recovery, but it looks like other parts are only
> used by the deferred ops infrastructure at this point.

Yes, we could replace xfs_bmap_free_create_{intent,done} with
xfs_trans_get_ef[id] and lose the silly functions.  I'll go take
care of all of them.

--D

> 
> Brian
> 
> >  fs/xfs/libxfs/xfs_defer.h |    1 
> >  fs/xfs/xfs_defer_item.c   |  108 +++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 109 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > index 85c7a3a..743fc32 100644
> > --- a/fs/xfs/libxfs/xfs_defer.h
> > +++ b/fs/xfs/libxfs/xfs_defer.h
> > @@ -51,6 +51,7 @@ struct xfs_defer_pending {
> >   * find all the space it needs.
> >   */
> >  enum xfs_defer_ops_type {
> > +	XFS_DEFER_OPS_TYPE_FREE,
> >  	XFS_DEFER_OPS_TYPE_MAX,
> >  };
> >  
> > diff --git a/fs/xfs/xfs_defer_item.c b/fs/xfs/xfs_defer_item.c
> > index 4c2ba28..127a54e 100644
> > --- a/fs/xfs/xfs_defer_item.c
> > +++ b/fs/xfs/xfs_defer_item.c
> > @@ -29,9 +29,117 @@
> >  #include "xfs_defer.h"
> >  #include "xfs_trans.h"
> >  #include "xfs_trace.h"
> > +#include "xfs_bmap.h"
> > +#include "xfs_extfree_item.h"
> > +
> > +/* Extent Freeing */
> > +
> > +/* Sort bmap items by AG. */
> > +static int
> > +xfs_bmap_free_diff_items(
> > +	void				*priv,
> > +	struct list_head		*a,
> > +	struct list_head		*b)
> > +{
> > +	struct xfs_mount		*mp = priv;
> > +	struct xfs_bmap_free_item	*ra;
> > +	struct xfs_bmap_free_item	*rb;
> > +
> > +	ra = container_of(a, struct xfs_bmap_free_item, xbfi_list);
> > +	rb = container_of(b, struct xfs_bmap_free_item, xbfi_list);
> > +	return  XFS_FSB_TO_AGNO(mp, ra->xbfi_startblock) -
> > +		XFS_FSB_TO_AGNO(mp, rb->xbfi_startblock);
> > +}
> > +
> > +/* Get an EFI. */
> > +STATIC void *
> > +xfs_bmap_free_create_intent(
> > +	struct xfs_trans		*tp,
> > +	unsigned int			count)
> > +{
> > +	return xfs_trans_get_efi(tp, count);
> > +}
> > +
> > +/* Log a free extent to the intent item. */
> > +STATIC void
> > +xfs_bmap_free_log_item(
> > +	struct xfs_trans		*tp,
> > +	void				*intent,
> > +	struct list_head		*item)
> > +{
> > +	struct xfs_bmap_free_item	*free;
> > +
> > +	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
> > +	xfs_trans_log_efi_extent(tp, intent, free->xbfi_startblock,
> > +			free->xbfi_blockcount);
> > +}
> > +
> > +/* Get an EFD so we can process all the free extents. */
> > +STATIC void *
> > +xfs_bmap_free_create_done(
> > +	struct xfs_trans		*tp,
> > +	void				*intent,
> > +	unsigned int			count)
> > +{
> > +	return xfs_trans_get_efd(tp, intent, count);
> > +}
> > +
> > +/* Process a free extent. */
> > +STATIC int
> > +xfs_bmap_free_finish_item(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_defer_ops		*dop,
> > +	struct list_head		*item,
> > +	void				*done_item,
> > +	void				**state)
> > +{
> > +	struct xfs_bmap_free_item	*free;
> > +	int				error;
> > +
> > +	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
> > +	error = xfs_trans_free_extent(tp, done_item,
> > +			free->xbfi_startblock,
> > +			free->xbfi_blockcount);
> > +	kmem_free(free);
> > +	return error;
> > +}
> > +
> > +/* Abort all pending EFIs. */
> > +STATIC void
> > +xfs_bmap_free_abort_intent(
> > +	void				*intent)
> > +{
> > +	xfs_efi_release(intent);
> > +}
> > +
> > +/* Cancel a free extent. */
> > +STATIC void
> > +xfs_bmap_free_cancel_item(
> > +	struct list_head		*item)
> > +{
> > +	struct xfs_bmap_free_item	*free;
> > +
> > +	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
> > +	kmem_free(free);
> > +}
> > +
> > +const struct xfs_defer_op_type xfs_extent_free_defer_type = {
> > +	.type		= XFS_DEFER_OPS_TYPE_FREE,
> > +	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
> > +	.diff_items	= xfs_bmap_free_diff_items,
> > +	.create_intent	= xfs_bmap_free_create_intent,
> > +	.abort_intent	= xfs_bmap_free_abort_intent,
> > +	.log_item	= xfs_bmap_free_log_item,
> > +	.create_done	= xfs_bmap_free_create_done,
> > +	.finish_item	= xfs_bmap_free_finish_item,
> > +	.cancel_item	= xfs_bmap_free_cancel_item,
> > +};
> > +
> > +/* Deferred Item Initialization */
> >  
> >  /* Initialize the deferred operation types. */
> >  void
> >  xfs_defer_init_types(void)
> >  {
> > +	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
> >  }
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
