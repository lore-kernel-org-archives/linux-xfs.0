Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F7117CB2
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 13:33:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3D6F304032
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 11:33:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n0s0knXB7q2efGF5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2016 11:33:54 -0700 (PDT)
Date: Fri, 15 Jul 2016 14:33:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 043/119] xfs: enable the xfs_defer mechanism to process
	rmaps to update
Message-ID: <20160715183351.GC55338@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612654775.12839.16417290544621580173.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612654775.12839.16417290544621580173.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:22:27PM -0700, Darrick J. Wong wrote:
> Connect the xfs_defer mechanism with the pieces that we'll need to
> handle deferred rmap updates.  We'll wire up the existing code to
> our new deferred mechanism later.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks sane, same general comment here as for the bmap stuff way back
when it was hooked up to the defer bits (i.e., tightening up the
interface a bit and pushing stuff down into xfs_trans_extfree.c iirc).

Brian

>  fs/xfs/libxfs/xfs_defer.h |    1 
>  fs/xfs/xfs_defer_item.c   |  124 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 125 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 743fc32..920642e62 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -51,6 +51,7 @@ struct xfs_defer_pending {
>   * find all the space it needs.
>   */
>  enum xfs_defer_ops_type {
> +	XFS_DEFER_OPS_TYPE_RMAP,
>  	XFS_DEFER_OPS_TYPE_FREE,
>  	XFS_DEFER_OPS_TYPE_MAX,
>  };
> diff --git a/fs/xfs/xfs_defer_item.c b/fs/xfs/xfs_defer_item.c
> index 1c2d556..dbd10fc 100644
> --- a/fs/xfs/xfs_defer_item.c
> +++ b/fs/xfs/xfs_defer_item.c
> @@ -31,6 +31,8 @@
>  #include "xfs_trace.h"
>  #include "xfs_bmap.h"
>  #include "xfs_extfree_item.h"
> +#include "xfs_rmap_btree.h"
> +#include "xfs_rmap_item.h"
>  
>  /* Extent Freeing */
>  
> @@ -136,11 +138,133 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
>  	.cancel_item	= xfs_bmap_free_cancel_item,
>  };
>  
> +/* Reverse Mapping */
> +
> +/* Sort rmap intents by AG. */
> +static int
> +xfs_rmap_update_diff_items(
> +	void				*priv,
> +	struct list_head		*a,
> +	struct list_head		*b)
> +{
> +	struct xfs_mount		*mp = priv;
> +	struct xfs_rmap_intent		*ra;
> +	struct xfs_rmap_intent		*rb;
> +
> +	ra = container_of(a, struct xfs_rmap_intent, ri_list);
> +	rb = container_of(b, struct xfs_rmap_intent, ri_list);
> +	return  XFS_FSB_TO_AGNO(mp, ra->ri_bmap.br_startblock) -
> +		XFS_FSB_TO_AGNO(mp, rb->ri_bmap.br_startblock);
> +}
> +
> +/* Get an RUI. */
> +STATIC void *
> +xfs_rmap_update_create_intent(
> +	struct xfs_trans		*tp,
> +	unsigned int			count)
> +{
> +	return xfs_trans_get_rui(tp, count);
> +}
> +
> +/* Log rmap updates in the intent item. */
> +STATIC void
> +xfs_rmap_update_log_item(
> +	struct xfs_trans		*tp,
> +	void				*intent,
> +	struct list_head		*item)
> +{
> +	struct xfs_rmap_intent		*rmap;
> +
> +	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
> +	xfs_trans_log_start_rmap_update(tp, intent, rmap->ri_type,
> +			rmap->ri_owner, rmap->ri_whichfork,
> +			rmap->ri_bmap.br_startoff,
> +			rmap->ri_bmap.br_startblock,
> +			rmap->ri_bmap.br_blockcount,
> +			rmap->ri_bmap.br_state);
> +}
> +
> +/* Get an RUD so we can process all the deferred rmap updates. */
> +STATIC void *
> +xfs_rmap_update_create_done(
> +	struct xfs_trans		*tp,
> +	void				*intent,
> +	unsigned int			count)
> +{
> +	return xfs_trans_get_rud(tp, intent, count);
> +}
> +
> +/* Process a deferred rmap update. */
> +STATIC int
> +xfs_rmap_update_finish_item(
> +	struct xfs_trans		*tp,
> +	struct xfs_defer_ops		*dop,
> +	struct list_head		*item,
> +	void				*done_item,
> +	void				**state)
> +{
> +	struct xfs_rmap_intent		*rmap;
> +	int				error;
> +
> +	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
> +	error = xfs_trans_log_finish_rmap_update(tp, done_item,
> +			rmap->ri_type,
> +			rmap->ri_owner, rmap->ri_whichfork,
> +			rmap->ri_bmap.br_startoff,
> +			rmap->ri_bmap.br_startblock,
> +			rmap->ri_bmap.br_blockcount,
> +			rmap->ri_bmap.br_state);
> +	kmem_free(rmap);
> +	return error;
> +}
> +
> +/* Clean up after processing deferred rmaps. */
> +STATIC void
> +xfs_rmap_update_finish_cleanup(
> +	struct xfs_trans	*tp,
> +	void			*state,
> +	int			error)
> +{
> +}
> +
> +/* Abort all pending RUIs. */
> +STATIC void
> +xfs_rmap_update_abort_intent(
> +	void				*intent)
> +{
> +	xfs_rui_release(intent);
> +}
> +
> +/* Cancel a deferred rmap update. */
> +STATIC void
> +xfs_rmap_update_cancel_item(
> +	struct list_head		*item)
> +{
> +	struct xfs_rmap_intent		*rmap;
> +
> +	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
> +	kmem_free(rmap);
> +}
> +
> +const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
> +	.type		= XFS_DEFER_OPS_TYPE_RMAP,
> +	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
> +	.diff_items	= xfs_rmap_update_diff_items,
> +	.create_intent	= xfs_rmap_update_create_intent,
> +	.abort_intent	= xfs_rmap_update_abort_intent,
> +	.log_item	= xfs_rmap_update_log_item,
> +	.create_done	= xfs_rmap_update_create_done,
> +	.finish_item	= xfs_rmap_update_finish_item,
> +	.finish_cleanup = xfs_rmap_update_finish_cleanup,
> +	.cancel_item	= xfs_rmap_update_cancel_item,
> +};
> +
>  /* Deferred Item Initialization */
>  
>  /* Initialize the deferred operation types. */
>  void
>  xfs_defer_init_types(void)
>  {
> +	xfs_defer_init_op_type(&xfs_rmap_update_defer_type);
>  	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
>  }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
