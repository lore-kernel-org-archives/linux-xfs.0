Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 56A417CB1
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 12:30:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 295B38F8037
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:30:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MQs44ovCKlKirLfV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 10:30:16 -0700 (PDT)
Date: Tue, 2 Aug 2016 13:30:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/47] xfs: move deferred operations into a separate file
Message-ID: <20160802173013.GA54148@bfoster.bfoster>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907703710.25461.16650495404061662831.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907703710.25461.16650495404061662831.stgit@birch.djwong.org>
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

On Wed, Jul 20, 2016 at 09:57:17PM -0700, Darrick J. Wong wrote:
> All the code around struct xfs_bmap_free basically implements a
> deferred operation framework through which we can roll transactions
> (to unlock buffers and avoid violating lock order rules) while
> managing all the necessary log redo items.  Previously we only used
> this code to free extents after some sort of mapping operation, but
> with the advent of rmap and reflink, we suddenly need to do more than
> that.
> 
> With that in mind, xfs_bmap_free really becomes a deferred ops control
> structure.  Rename the structure and move the deferred ops into their
> own file to avoid further bloating of the bmap code.
> 
> v2: actually sort the work items by AG to avoid deadlocks.
> 
> v3: split out the -EAGAIN continuation handling into a separate patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Fixes up my comments from the previous version and punts off the EAGAIN
stuff. hch's comments aside, this looks Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/Makefile           |    1 
>  fs/xfs/libxfs/xfs_defer.c |  444 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_defer.h |   95 ++++++++++
>  3 files changed, 540 insertions(+)
>  create mode 100644 fs/xfs/libxfs/xfs_defer.c
>  create mode 100644 fs/xfs/libxfs/xfs_defer.h
> 
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 3542d94..01857b0 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -39,6 +39,7 @@ xfs-y				+= $(addprefix libxfs/, \
>  				   xfs_btree.o \
>  				   xfs_da_btree.o \
>  				   xfs_da_format.o \
> +				   xfs_defer.o \
>  				   xfs_dir2.o \
>  				   xfs_dir2_block.o \
>  				   xfs_dir2_data.o \
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> new file mode 100644
> index 0000000..2809db7
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -0,0 +1,444 @@
> +/*
> + * Copyright (C) 2016 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
> +#include "xfs_sb.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_trans.h"
> +#include "xfs_trace.h"
> +
> +/*
> + * Deferred Operations in XFS
> + *
> + * Due to the way locking rules work in XFS, certain transactions (block
> + * mapping and unmapping, typically) have permanent reservations so that
> + * we can roll the transaction to adhere to AG locking order rules and
> + * to unlock buffers between metadata updates.  Prior to rmap/reflink,
> + * the mapping code had a mechanism to perform these deferrals for
> + * extents that were going to be freed; this code makes that facility
> + * more generic.
> + *
> + * When adding the reverse mapping and reflink features, it became
> + * necessary to perform complex remapping multi-transactions to comply
> + * with AG locking order rules, and to be able to spread a single
> + * refcount update operation (an operation on an n-block extent can
> + * update as many as n records!) among multiple transactions.  XFS can
> + * roll a transaction to facilitate this, but using this facility
> + * requires us to log "intent" items in case log recovery needs to
> + * redo the operation, and to log "done" items to indicate that redo
> + * is not necessary.
> + *
> + * Deferred work is tracked in xfs_defer_pending items.  Each pending
> + * item tracks one type of deferred work.  Incoming work items (which
> + * have not yet had an intent logged) are attached to a pending item
> + * on the dop_intake list, where they wait for the caller to finish
> + * the deferred operations.
> + *
> + * Finishing a set of deferred operations is an involved process.  To
> + * start, we define "rolling a deferred-op transaction" as follows:
> + *
> + * > For each xfs_defer_pending item on the dop_intake list,
> + *   - Sort the work items in AG order.  XFS locking
> + *     order rules require us to lock buffers in AG order.
> + *   - Create a log intent item for that type.
> + *   - Attach it to the pending item.
> + *   - Move the pending item from the dop_intake list to the
> + *     dop_pending list.
> + * > Roll the transaction.
> + *
> + * NOTE: To avoid exceeding the transaction reservation, we limit the
> + * number of items that we attach to a given xfs_defer_pending.
> + *
> + * The actual finishing process looks like this:
> + *
> + * > For each xfs_defer_pending in the dop_pending list,
> + *   - Roll the deferred-op transaction as above.
> + *   - Create a log done item for that type, and attach it to the
> + *     log intent item.
> + *   - For each work item attached to the log intent item,
> + *     * Perform the described action.
> + *     * Attach the work item to the log done item.
> + *
> + * The key here is that we must log an intent item for all pending
> + * work items every time we roll the transaction, and that we must log
> + * a done item as soon as the work is completed.  With this mechanism
> + * we can perform complex remapping operations, chaining intent items
> + * as needed.
> + *
> + * This is an example of remapping the extent (E, E+B) into file X at
> + * offset A and dealing with the extent (C, C+B) already being mapped
> + * there:
> + * +-------------------------------------------------+
> + * | Unmap file X startblock C offset A length B     | t0
> + * | Intent to reduce refcount for extent (C, B)     |
> + * | Intent to remove rmap (X, C, A, B)              |
> + * | Intent to free extent (D, 1) (bmbt block)       |
> + * | Intent to map (X, A, B) at startblock E         |
> + * +-------------------------------------------------+
> + * | Map file X startblock E offset A length B       | t1
> + * | Done mapping (X, E, A, B)                       |
> + * | Intent to increase refcount for extent (E, B)   |
> + * | Intent to add rmap (X, E, A, B)                 |
> + * +-------------------------------------------------+
> + * | Reduce refcount for extent (C, B)               | t2
> + * | Done reducing refcount for extent (C, B)        |
> + * | Increase refcount for extent (E, B)             |
> + * | Done increasing refcount for extent (E, B)      |
> + * | Intent to free extent (C, B)                    |
> + * | Intent to free extent (F, 1) (refcountbt block) |
> + * | Intent to remove rmap (F, 1, REFC)              |
> + * +-------------------------------------------------+
> + * | Remove rmap (X, C, A, B)                        | t3
> + * | Done removing rmap (X, C, A, B)                 |
> + * | Add rmap (X, E, A, B)                           |
> + * | Done adding rmap (X, E, A, B)                   |
> + * | Remove rmap (F, 1, REFC)                        |
> + * | Done removing rmap (F, 1, REFC)                 |
> + * +-------------------------------------------------+
> + * | Free extent (C, B)                              | t4
> + * | Done freeing extent (C, B)                      |
> + * | Free extent (D, 1)                              |
> + * | Done freeing extent (D, 1)                      |
> + * | Free extent (F, 1)                              |
> + * | Done freeing extent (F, 1)                      |
> + * +-------------------------------------------------+
> + *
> + * If we should crash before t2 commits, log recovery replays
> + * the following intent items:
> + *
> + * - Intent to reduce refcount for extent (C, B)
> + * - Intent to remove rmap (X, C, A, B)
> + * - Intent to free extent (D, 1) (bmbt block)
> + * - Intent to increase refcount for extent (E, B)
> + * - Intent to add rmap (X, E, A, B)
> + *
> + * In the process of recovering, it should also generate and take care
> + * of these intent items:
> + *
> + * - Intent to free extent (C, B)
> + * - Intent to free extent (F, 1) (refcountbt block)
> + * - Intent to remove rmap (F, 1, REFC)
> + */
> +
> +static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];
> +
> +/*
> + * For each pending item in the intake list, log its intent item and the
> + * associated extents, then add the entire intake list to the end of
> + * the pending list.
> + */
> +STATIC void
> +xfs_defer_intake_work(
> +	struct xfs_trans		*tp,
> +	struct xfs_defer_ops		*dop)
> +{
> +	struct list_head		*li;
> +	struct xfs_defer_pending	*dfp;
> +
> +	list_for_each_entry(dfp, &dop->dop_intake, dfp_list) {
> +		dfp->dfp_intent = dfp->dfp_type->create_intent(tp,
> +				dfp->dfp_count);
> +		list_sort(tp->t_mountp, &dfp->dfp_work,
> +				dfp->dfp_type->diff_items);
> +		list_for_each(li, &dfp->dfp_work)
> +			dfp->dfp_type->log_item(tp, dfp->dfp_intent, li);
> +	}
> +
> +	list_splice_tail_init(&dop->dop_intake, &dop->dop_pending);
> +}
> +
> +/* Abort all the intents that were committed. */
> +STATIC void
> +xfs_defer_trans_abort(
> +	struct xfs_trans		*tp,
> +	struct xfs_defer_ops		*dop,
> +	int				error)
> +{
> +	struct xfs_defer_pending	*dfp;
> +
> +	/*
> +	 * If the transaction was committed, drop the intent reference
> +	 * since we're bailing out of here. The other reference is
> +	 * dropped when the intent hits the AIL.  If the transaction
> +	 * was not committed, the intent is freed by the intent item
> +	 * unlock handler on abort.
> +	 */
> +	if (!dop->dop_committed)
> +		return;
> +
> +	/* Abort intent items. */
> +	list_for_each_entry(dfp, &dop->dop_pending, dfp_list) {
> +		if (dfp->dfp_committed)
> +			dfp->dfp_type->abort_intent(dfp->dfp_intent);
> +	}
> +
> +	/* Shut down FS. */
> +	xfs_force_shutdown(tp->t_mountp, (error == -EFSCORRUPTED) ?
> +			SHUTDOWN_CORRUPT_INCORE : SHUTDOWN_META_IO_ERROR);
> +}
> +
> +/* Roll a transaction so we can do some deferred op processing. */
> +STATIC int
> +xfs_defer_trans_roll(
> +	struct xfs_trans		**tp,
> +	struct xfs_defer_ops		*dop,
> +	struct xfs_inode		*ip)
> +{
> +	int				i;
> +	int				error;
> +
> +	/* Log all the joined inodes except the one we passed in. */
> +	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++) {
> +		if (dop->dop_inodes[i] == ip)
> +			continue;
> +		xfs_trans_log_inode(*tp, dop->dop_inodes[i], XFS_ILOG_CORE);
> +	}
> +
> +	/* Roll the transaction. */
> +	error = xfs_trans_roll(tp, ip);
> +	if (error) {
> +		xfs_defer_trans_abort(*tp, dop, error);
> +		return error;
> +	}
> +	dop->dop_committed = true;
> +
> +	/* Rejoin the joined inodes except the one we passed in. */
> +	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++) {
> +		if (dop->dop_inodes[i] == ip)
> +			continue;
> +		xfs_trans_ijoin(*tp, dop->dop_inodes[i], 0);
> +	}
> +
> +	return error;
> +}
> +
> +/* Do we have any work items to finish? */
> +bool
> +xfs_defer_has_unfinished_work(
> +	struct xfs_defer_ops		*dop)
> +{
> +	return !list_empty(&dop->dop_pending) || !list_empty(&dop->dop_intake);
> +}
> +
> +/*
> + * Add this inode to the deferred op.  Each joined inode is relogged
> + * each time we roll the transaction, in addition to any inode passed
> + * to xfs_defer_finish().
> + */
> +int
> +xfs_defer_join(
> +	struct xfs_defer_ops		*dop,
> +	struct xfs_inode		*ip)
> +{
> +	int				i;
> +
> +	for (i = 0; i < XFS_DEFER_OPS_NR_INODES; i++) {
> +		if (dop->dop_inodes[i] == ip)
> +			return 0;
> +		else if (dop->dop_inodes[i] == NULL) {
> +			dop->dop_inodes[i] = ip;
> +			return 0;
> +		}
> +	}
> +
> +	return -EFSCORRUPTED;
> +}
> +
> +/*
> + * Finish all the pending work.  This involves logging intent items for
> + * any work items that wandered in since the last transaction roll (if
> + * one has even happened), rolling the transaction, and finishing the
> + * work items in the first item on the logged-and-pending list.
> + *
> + * If an inode is provided, relog it to the new transaction.
> + */
> +int
> +xfs_defer_finish(
> +	struct xfs_trans		**tp,
> +	struct xfs_defer_ops		*dop,
> +	struct xfs_inode		*ip)
> +{
> +	struct xfs_defer_pending	*dfp;
> +	struct list_head		*li;
> +	struct list_head		*n;
> +	void				*done_item = NULL;
> +	void				*state;
> +	int				error = 0;
> +	void				(*cleanup_fn)(struct xfs_trans *, void *, int);
> +
> +	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> +
> +	/* Until we run out of pending work to finish... */
> +	while (xfs_defer_has_unfinished_work(dop)) {
> +		/* Log intents for work items sitting in the intake. */
> +		xfs_defer_intake_work(*tp, dop);
> +
> +		/* Roll the transaction. */
> +		error = xfs_defer_trans_roll(tp, dop, ip);
> +		if (error)
> +			goto out;
> +
> +		/* Mark all pending intents as committed. */
> +		list_for_each_entry_reverse(dfp, &dop->dop_pending, dfp_list) {
> +			if (dfp->dfp_committed)
> +				break;
> +			dfp->dfp_committed = true;
> +		}
> +
> +		/* Log an intent-done item for the first pending item. */
> +		dfp = list_first_entry(&dop->dop_pending,
> +				struct xfs_defer_pending, dfp_list);
> +		done_item = dfp->dfp_type->create_done(*tp, dfp->dfp_intent,
> +				dfp->dfp_count);
> +		cleanup_fn = dfp->dfp_type->finish_cleanup;
> +
> +		/* Finish the work items. */
> +		state = NULL;
> +		list_for_each_safe(li, n, &dfp->dfp_work) {
> +			list_del(li);
> +			dfp->dfp_count--;
> +			error = dfp->dfp_type->finish_item(*tp, dop, li,
> +					done_item, &state);
> +			if (error) {
> +				/*
> +				 * Clean up after ourselves and jump out.
> +				 * xfs_defer_cancel will take care of freeing
> +				 * all these lists and stuff.
> +				 */
> +				if (cleanup_fn)
> +					cleanup_fn(*tp, state, error);
> +				xfs_defer_trans_abort(*tp, dop, error);
> +				goto out;
> +			}
> +		}
> +		/* Done with the dfp, free it. */
> +		list_del(&dfp->dfp_list);
> +		kmem_free(dfp);
> +
> +		if (cleanup_fn)
> +			cleanup_fn(*tp, state, error);
> +	}
> +
> +out:
> +	return error;
> +}
> +
> +/*
> + * Free up any items left in the list.
> + */
> +void
> +xfs_defer_cancel(
> +	struct xfs_defer_ops		*dop)
> +{
> +	struct xfs_defer_pending	*dfp;
> +	struct xfs_defer_pending	*pli;
> +	struct list_head		*pwi;
> +	struct list_head		*n;
> +
> +	/*
> +	 * Free the pending items.  Caller should already have arranged
> +	 * for the intent items to be released.
> +	 */
> +	list_for_each_entry_safe(dfp, pli, &dop->dop_intake, dfp_list) {
> +		list_del(&dfp->dfp_list);
> +		list_for_each_safe(pwi, n, &dfp->dfp_work) {
> +			list_del(pwi);
> +			dfp->dfp_count--;
> +			dfp->dfp_type->cancel_item(pwi);
> +		}
> +		ASSERT(dfp->dfp_count == 0);
> +		kmem_free(dfp);
> +	}
> +	list_for_each_entry_safe(dfp, pli, &dop->dop_pending, dfp_list) {
> +		list_del(&dfp->dfp_list);
> +		list_for_each_safe(pwi, n, &dfp->dfp_work) {
> +			list_del(pwi);
> +			dfp->dfp_count--;
> +			dfp->dfp_type->cancel_item(pwi);
> +		}
> +		ASSERT(dfp->dfp_count == 0);
> +		kmem_free(dfp);
> +	}
> +}
> +
> +/* Add an item for later deferred processing. */
> +void
> +xfs_defer_add(
> +	struct xfs_defer_ops		*dop,
> +	enum xfs_defer_ops_type		type,
> +	struct list_head		*li)
> +{
> +	struct xfs_defer_pending	*dfp = NULL;
> +
> +	/*
> +	 * Add the item to a pending item at the end of the intake list.
> +	 * If the last pending item has the same type, reuse it.  Else,
> +	 * create a new pending item at the end of the intake list.
> +	 */
> +	if (!list_empty(&dop->dop_intake)) {
> +		dfp = list_last_entry(&dop->dop_intake,
> +				struct xfs_defer_pending, dfp_list);
> +		if (dfp->dfp_type->type != type ||
> +		    (dfp->dfp_type->max_items &&
> +		     dfp->dfp_count >= dfp->dfp_type->max_items))
> +			dfp = NULL;
> +	}
> +	if (!dfp) {
> +		dfp = kmem_alloc(sizeof(struct xfs_defer_pending),
> +				KM_SLEEP | KM_NOFS);
> +		dfp->dfp_type = defer_op_types[type];
> +		dfp->dfp_committed = false;
> +		dfp->dfp_intent = NULL;
> +		dfp->dfp_count = 0;
> +		INIT_LIST_HEAD(&dfp->dfp_work);
> +		list_add_tail(&dfp->dfp_list, &dop->dop_intake);
> +	}
> +
> +	list_add_tail(li, &dfp->dfp_work);
> +	dfp->dfp_count++;
> +}
> +
> +/* Initialize a deferred operation list. */
> +void
> +xfs_defer_init_op_type(
> +	const struct xfs_defer_op_type	*type)
> +{
> +	defer_op_types[type->type] = type;
> +}
> +
> +/* Initialize a deferred operation. */
> +void
> +xfs_defer_init(
> +	struct xfs_defer_ops		*dop,
> +	xfs_fsblock_t			*fbp)
> +{
> +	dop->dop_committed = false;
> +	dop->dop_low = false;
> +	memset(&dop->dop_inodes, 0, sizeof(dop->dop_inodes));
> +	*fbp = NULLFSBLOCK;
> +	INIT_LIST_HEAD(&dop->dop_intake);
> +	INIT_LIST_HEAD(&dop->dop_pending);
> +}
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> new file mode 100644
> index 0000000..a227bd2
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -0,0 +1,95 @@
> +/*
> + * Copyright (C) 2016 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#ifndef __XFS_DEFER_H__
> +#define	__XFS_DEFER_H__
> +
> +struct xfs_defer_op_type;
> +
> +/*
> + * Save a log intent item and a list of extents, so that we can replay
> + * whatever action had to happen to the extent list and file the log done
> + * item.
> + */
> +struct xfs_defer_pending {
> +	const struct xfs_defer_op_type	*dfp_type;	/* function pointers */
> +	struct list_head		dfp_list;	/* pending items */
> +	bool				dfp_committed;	/* committed trans? */
> +	void				*dfp_intent;	/* log intent item */
> +	struct list_head		dfp_work;	/* work items */
> +	unsigned int			dfp_count;	/* # extent items */
> +};
> +
> +/*
> + * Header for deferred operation list.
> + *
> + * dop_low is used by the allocator to activate the lowspace algorithm -
> + * when free space is running low the extent allocator may choose to
> + * allocate an extent from an AG without leaving sufficient space for
> + * a btree split when inserting the new extent.  In this case the allocator
> + * will enable the lowspace algorithm which is supposed to allow further
> + * allocations (such as btree splits and newroots) to allocate from
> + * sequential AGs.  In order to avoid locking AGs out of order the lowspace
> + * algorithm will start searching for free space from AG 0.  If the correct
> + * transaction reservations have been made then this algorithm will eventually
> + * find all the space it needs.
> + */
> +enum xfs_defer_ops_type {
> +	XFS_DEFER_OPS_TYPE_MAX,
> +};
> +
> +#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
> +
> +struct xfs_defer_ops {
> +	bool			dop_committed;	/* did any trans commit? */
> +	bool			dop_low;	/* alloc in low mode */
> +	struct list_head	dop_intake;	/* unlogged pending work */
> +	struct list_head	dop_pending;	/* logged pending work */
> +
> +	/* relog these inodes with each roll */
> +	struct xfs_inode	*dop_inodes[XFS_DEFER_OPS_NR_INODES];
> +};
> +
> +void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
> +		struct list_head *h);
> +int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop,
> +		struct xfs_inode *ip);
> +void xfs_defer_cancel(struct xfs_defer_ops *dop);
> +void xfs_defer_init(struct xfs_defer_ops *dop, xfs_fsblock_t *fbp);
> +bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
> +int xfs_defer_join(struct xfs_defer_ops *dop, struct xfs_inode *ip);
> +
> +/* Description of a deferred type. */
> +struct xfs_defer_op_type {
> +	enum xfs_defer_ops_type	type;
> +	unsigned int		max_items;
> +	void (*abort_intent)(void *);
> +	void *(*create_done)(struct xfs_trans *, void *, unsigned int);
> +	int (*finish_item)(struct xfs_trans *, struct xfs_defer_ops *,
> +			struct list_head *, void *, void **);
> +	void (*finish_cleanup)(struct xfs_trans *, void *, int);
> +	void (*cancel_item)(struct list_head *);
> +	int (*diff_items)(void *, struct list_head *, struct list_head *);
> +	void *(*create_intent)(struct xfs_trans *, uint);
> +	void (*log_item)(struct xfs_trans *, void *, struct list_head *);
> +};
> +
> +void xfs_defer_init_op_type(const struct xfs_defer_op_type *type);
> +
> +#endif /* __XFS_DEFER_H__ */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
