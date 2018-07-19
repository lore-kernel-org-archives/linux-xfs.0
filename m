Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731113AbeGSRCW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 13:02:22 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8BCB640363A8
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 16:18:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BCEF1C640
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 16:18:27 +0000 (UTC)
Date: Thu, 19 Jul 2018 12:18:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/14] xfs: support embedded dfops in transaction
Message-ID: <20180719161825.GE29404@bfoster>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719134919.29939-9-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 09:49:13AM -0400, Brian Foster wrote:
> The dfops structure used by multi-transaction operations is
> typically stored on the stack and carried around by the associated
> transaction. The lifecycle of dfops does not quite match that of the
> transaction, but they are tightly related in that the former depends
> on the latter.
> 
> The relationship of these objects is tight enough that we can avoid
> the cumbersome boilerplate code required in most cases to manage
> them separately by just embedding an xfs_defer_ops in the
> transaction itself. This means that a transaction allocation returns
> with an initialized dfops, a transaction commit finishes pending
> deferred items before the tx commit, a transaction cancel cancels
> the dfops before the transaction and a transaction dup operation
> transfers the current dfops state to the new transaction.
> 
> The dup operation is slightly complicated by the fact that we can no
> longer just copy a dfops pointer from the old transaction to the new
> transaction. This is solved through a dfops move helper that
> transfers the pending items and other dfops state across the
> transactions. This also requires that transaction rolling code
> always refer to the transaction for the current dfops reference.
> 
> Finally, to facilitate incremental conversion to the internal dfops
> and continue to support the current external dfops mode of
> operation, create the new ->t_dfops_internal field with a layer of
> indirection. On allocation, ->t_dfops points to the internal dfops.
> This state is overridden by callers who re-init a local dfops on the
> transaction. Once ->t_dfops is overridden, the external dfops
> reference is maintained as the transaction rolls.
> 
> This patch adds the fundamental ability to support an internal
> dfops. All codepaths that perform deferred processing continue to
> override the internal dfops until they are converted over in
> subsequent patches.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---

FYI, this accidentally leaves off libxfs/xfs_rtbitmap.c, which also
requires the xfs_defer.h include treatment.

Brian

>  fs/xfs/libxfs/xfs_alloc_btree.c    |  1 +
>  fs/xfs/libxfs/xfs_attr_leaf.c      |  1 +
>  fs/xfs/libxfs/xfs_da_btree.c       |  1 +
>  fs/xfs/libxfs/xfs_defer.c          | 33 ++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_defer.h          |  1 +
>  fs/xfs/libxfs/xfs_dir2_block.c     |  1 +
>  fs/xfs/libxfs/xfs_dir2_data.c      |  1 +
>  fs/xfs/libxfs/xfs_dir2_leaf.c      |  1 +
>  fs/xfs/libxfs/xfs_dir2_node.c      |  1 +
>  fs/xfs/libxfs/xfs_dir2_sf.c        |  1 +
>  fs/xfs/libxfs/xfs_dquot_buf.c      |  1 +
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |  1 +
>  fs/xfs/libxfs/xfs_inode_fork.c     |  1 +
>  fs/xfs/libxfs/xfs_refcount_btree.c |  1 +
>  fs/xfs/libxfs/xfs_symlink_remote.c |  1 +
>  fs/xfs/libxfs/xfs_trans_resv.c     |  1 +
>  fs/xfs/xfs_aops.c                  |  1 +
>  fs/xfs/xfs_attr_inactive.c         |  2 +-
>  fs/xfs/xfs_attr_list.c             |  1 +
>  fs/xfs/xfs_buf_item.c              |  1 +
>  fs/xfs/xfs_dir2_readdir.c          |  1 +
>  fs/xfs/xfs_dquot_item.c            |  1 +
>  fs/xfs/xfs_export.c                |  1 +
>  fs/xfs/xfs_extent_busy.c           |  1 +
>  fs/xfs/xfs_extfree_item.c          |  1 +
>  fs/xfs/xfs_file.c                  |  1 +
>  fs/xfs/xfs_icache.c                |  1 +
>  fs/xfs/xfs_icreate_item.c          |  1 +
>  fs/xfs/xfs_inode_item.c            |  1 +
>  fs/xfs/xfs_ioctl.c                 |  1 +
>  fs/xfs/xfs_iops.c                  |  2 +-
>  fs/xfs/xfs_log.c                   |  1 +
>  fs/xfs/xfs_log_cil.c               |  1 +
>  fs/xfs/xfs_pnfs.c                  |  1 +
>  fs/xfs/xfs_qm.c                    |  1 +
>  fs/xfs/xfs_qm_bhv.c                |  1 +
>  fs/xfs/xfs_qm_syscalls.c           |  2 +-
>  fs/xfs/xfs_quotaops.c              |  1 +
>  fs/xfs/xfs_super.c                 |  1 +
>  fs/xfs/xfs_trans.c                 | 32 ++++++++++++++++++++++++-----
>  fs/xfs/xfs_trans.h                 |  2 +-
>  fs/xfs/xfs_trans_ail.c             |  1 +
>  fs/xfs/xfs_trans_buf.c             |  1 +
>  fs/xfs/xfs_trans_dquot.c           |  1 +
>  fs/xfs/xfs_trans_inode.c           |  1 +
>  45 files changed, 103 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 4e59cc8a2802..a2ecb6e94cfe 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -18,6 +18,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_cksum.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 251304f3bc5d..56156c985e4d 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -16,6 +16,7 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_bmap_btree.h"
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 9efbd2038ffb..b5c8dbf5c037 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -17,6 +17,7 @@
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_alloc.h"
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index e6baa27a690b..415fcf720cc9 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -557,3 +557,36 @@ xfs_defer_init(
>  	}
>  	trace_xfs_defer_init(mp, dop, _RET_IP_);
>  }
> +
> +/*
> + * Move state from one xfs_defer_ops to another and reset the source to initial
> + * state. This is primarily used to carry state forward across transaction rolls
> + * with internal dfops.
> + */
> +void
> +xfs_defer_move(
> +	struct xfs_defer_ops	*dst,
> +	struct xfs_defer_ops	*src)
> +{
> +	int			i;
> +
> +	ASSERT(dst != src);
> +
> +	list_splice_init(&src->dop_intake, &dst->dop_intake);
> +	list_splice_init(&src->dop_pending, &dst->dop_pending);
> +
> +	for (i = 0; i < XFS_DEFER_OPS_NR_INODES; i++) {
> +		if (!src->dop_inodes[i])
> +			break;
> +		dst->dop_inodes[i] = src->dop_inodes[i];
> +	}
> +	for (i = 0; i< XFS_DEFER_OPS_NR_BUFS; i++) {
> +		if (!src->dop_bufs[i])
> +			break;
> +		dst->dop_bufs[i] = src->dop_bufs[i];
> +	}
> +
> +	dst->dop_low = src->dop_low;
> +
> +	xfs_defer_reset(src);
> +}
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 8f58f217fdff..349b4d906fb2 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -67,6 +67,7 @@ void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
>  bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
>  int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
>  int xfs_defer_bjoin(struct xfs_defer_ops *dop, struct xfs_buf *bp);
> +void xfs_defer_move(struct xfs_defer_ops *dst, struct xfs_defer_ops *src);
>  
>  /* Description of a deferred type. */
>  struct xfs_defer_op_type {
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 30ed5919da72..76b45a309a23 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -13,6 +13,7 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 01162c62ec8f..d4e2318cf235 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -16,6 +16,7 @@
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
>  #include "xfs_error.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_cksum.h"
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 1728a3e6f5cf..c514f116812e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -18,6 +18,7 @@
>  #include "xfs_dir2_priv.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_cksum.h"
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 2daf874969ab..1a904d2d130e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -18,6 +18,7 @@
>  #include "xfs_dir2_priv.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_cksum.h"
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 585dfdb7b6b6..26ae3e0a257f 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -12,6 +12,7 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_error.h"
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index d293f371dd54..1ddd5860fbf8 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -13,6 +13,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_quota.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_qm.h"
>  #include "xfs_error.h"
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index a5237afec5ab..e91919764cad 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -19,6 +19,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_cksum.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_rmap.h"
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 183ec0cb8921..4c1f4a2af811 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -12,6 +12,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_btree.h"
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 26d2300ed865..3e3e7509a518 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -18,6 +18,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_cksum.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_bit.h"
>  #include "xfs_rmap.h"
> diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> index 95374ab2dee7..f231dd836cd5 100644
> --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> @@ -17,6 +17,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_symlink.h"
>  #include "xfs_cksum.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index f99a7aefe418..db356294707b 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -17,6 +17,7 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_quota.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_qm.h"
>  #include "xfs_trans_space.h"
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f4d3252236c1..9c121168dd9b 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -11,6 +11,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_alloc.h"
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index d3055972d3a6..cb0ad9b6678e 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -17,6 +17,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_alloc.h"
>  #include "xfs_attr_remote.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
> @@ -26,7 +27,6 @@
>  #include "xfs_quota.h"
>  #include "xfs_trace.h"
>  #include "xfs_dir2.h"
> -#include "xfs_defer.h"
>  
>  /*
>   * Look at all the extents for this logical region,
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index f9ca80154c9c..8c6acc994419 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -14,6 +14,7 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 1c9d1398980b..335d05b5d1e7 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -11,6 +11,7 @@
>  #include "xfs_bit.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_trans_priv.h"
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 5142e64e2345..a4b38c94effe 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -19,6 +19,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_bmap.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  
>  /*
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 7dedd17c4813..8fb101ad8b91 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -12,6 +12,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_quota.h"
>  #include "xfs_error.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_trans_priv.h"
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index 3cf4682e2510..ef5b7959b18b 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -13,6 +13,7 @@
>  #include "xfs_dir2.h"
>  #include "xfs_export.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_trace.h"
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 0ed68379e551..3558a832f483 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -16,6 +16,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_extent_busy.h"
>  #include "xfs_trace.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_log.h"
>  
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index d9da66c718bb..55cc4f4fae36 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -10,6 +10,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_buf_item.h"
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 6b31f41eafa2..8e06b19ce8c0 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -13,6 +13,7 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 47f417d20a30..873113913d4a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -12,6 +12,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_error.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_inode_item.h"
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 8381d34cb102..04f86ede18c7 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -11,6 +11,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_error.h"
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 2389c34c172d..423c2183a383 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -10,6 +10,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_error.h"
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0ef5ece5634c..d816eaec685d 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -26,6 +26,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_symlink.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_acl.h"
>  #include "xfs_btree.h"
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 704b57a8b99e..32bbd5001b9f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -18,6 +18,7 @@
>  #include "xfs_quota.h"
>  #include "xfs_error.h"
>  #include "xfs_attr.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> @@ -26,7 +27,6 @@
>  #include "xfs_dir2.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_iomap.h"
> -#include "xfs_defer.h"
>  
>  #include <linux/capability.h>
>  #include <linux/xattr.h>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5e56f3b93d4b..b6a89e4ff847 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -12,6 +12,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index d3884e08b43c..92050c99c430 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -14,6 +14,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_extent_busy.h"
>  #include "xfs_discard.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index f44c3599527d..f3fe6ed2da96 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -10,6 +10,7 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_log.h"
>  #include "xfs_bmap.h"
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 9ceb85cce33a..166ca6054179 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -20,6 +20,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_bmap_util.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_qm.h"
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 73a1d77ec187..1ebcb9e9418f 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -12,6 +12,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_error.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_qm.h"
>  
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index df0783303887..94ca3bff8d07 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -16,13 +16,13 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_error.h"
>  #include "xfs_quota.h"
>  #include "xfs_qm.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> -#include "xfs_defer.h"
>  
>  STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
>  STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 205fbb2a77e4..a698b964d13a 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -10,6 +10,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_quota.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f9f8dc490d3d..25a6d227d1fe 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -18,6 +18,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_error.h"
>  #include "xfs_fsops.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index de00f79ff698..142410632a36 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -14,12 +14,12 @@
>  #include "xfs_inode.h"
>  #include "xfs_extent_busy.h"
>  #include "xfs_quota.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
> -#include "xfs_defer.h"
>  
>  kmem_zone_t	*xfs_trans_zone;
>  
> @@ -119,7 +119,13 @@ xfs_trans_dup(
>  	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
>  	tp->t_rtx_res = tp->t_rtx_res_used;
>  	ntp->t_pflags = tp->t_pflags;
> -	ntp->t_dfops = tp->t_dfops;
> +
> +	/* copy the dfops pointer if it's external, otherwise move it */
> +	xfs_defer_init(ntp, &ntp->t_dfops_internal);
> +	if (tp->t_dfops != &tp->t_dfops_internal)
> +		ntp->t_dfops = tp->t_dfops;
> +	else
> +		xfs_defer_move(ntp->t_dfops, tp->t_dfops);
>  
>  	xfs_trans_dup_dqinfo(tp, ntp);
>  
> @@ -275,6 +281,13 @@ xfs_trans_alloc(
>  	INIT_LIST_HEAD(&tp->t_items);
>  	INIT_LIST_HEAD(&tp->t_busy);
>  	tp->t_firstblock = NULLFSBLOCK;
> +	/*
> +	 * We only roll transactions with permanent log reservation. Don't init
> +	 * ->t_dfops to skip attempts to finish or cancel an empty dfops with a
> +	 * non-permanent res.
> +	 */
> +	if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES)
> +		xfs_defer_init(tp, &tp->t_dfops_internal);
>  
>  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
>  	if (error) {
> @@ -916,11 +929,17 @@ __xfs_trans_commit(
>  	int			error = 0;
>  	int			sync = tp->t_flags & XFS_TRANS_SYNC;
>  
> -	ASSERT(!tp->t_dfops ||
> -	       !xfs_defer_has_unfinished_work(tp->t_dfops) || regrant);
> -
>  	trace_xfs_trans_commit(tp, _RET_IP_);
>  
> +	/* finish deferred items on final commit */
> +	if (!regrant && tp->t_dfops) {
> +		error = xfs_defer_finish(&tp, tp->t_dfops);
> +		if (error) {
> +			xfs_defer_cancel(tp->t_dfops);
> +			goto out_unreserve;
> +		}
> +	}
> +
>  	/*
>  	 * If there is nothing to be logged by the transaction,
>  	 * then unlock all of the items associated with the
> @@ -1010,6 +1029,9 @@ xfs_trans_cancel(
>  
>  	trace_xfs_trans_cancel(tp, _RET_IP_);
>  
> +	if (tp->t_dfops)
> +		xfs_defer_cancel(tp->t_dfops);
> +
>  	/*
>  	 * See if the caller is relying on us to shut down the
>  	 * filesystem.  This happens in paths where we detect
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 6f857af61455..bab857c36d3a 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -24,7 +24,6 @@ struct xfs_rui_log_item;
>  struct xfs_btree_cur;
>  struct xfs_cui_log_item;
>  struct xfs_cud_log_item;
> -struct xfs_defer_ops;
>  struct xfs_bui_log_item;
>  struct xfs_bud_log_item;
>  
> @@ -130,6 +129,7 @@ typedef struct xfs_trans {
>  	struct list_head	t_items;	/* log item descriptors */
>  	struct list_head	t_busy;		/* list of busy extents */
>  	unsigned long		t_pflags;	/* saved process flags state */
> +	struct xfs_defer_ops	t_dfops_internal;
>  } xfs_trans_t;
>  
>  /*
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 55326f971cb3..91aa25a753fc 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -10,6 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_trace.h"
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 15919f67a88f..165044d7b6c3 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -11,6 +11,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_trans_priv.h"
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index c23257a26c2b..d737a5c00148 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -12,6 +12,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_error.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_quota.h"
> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index 542927321a61..7848911f5e98 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -11,6 +11,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_inode_item.h"
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
