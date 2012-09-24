Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8OI7qwB194118 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 13:07:52 -0500
Date: Mon, 24 Sep 2012 13:09:04 -0500 (CDT)
From: Mark Tinguely <tinguely@eagdhcp-232-125.americas.sgi.com>
Message-Id: <201209241809.q8OI94s3003323@eagdhcp-232-125.americas.sgi.com>
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
	hang
In-Reply-To: <20120924171159.GG1140@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: bpm@sgi.com, tinguely@sgi.com
Cc: xfs@oss.sgi.com

> From bpm@sgi.com Mon Sep 24 12:11:59 2012
> Date: Mon, 24 Sep 2012 12:11:59 -0500
> From: Ben Myers <bpm@sgi.com>
> To: <tinguely@sgi.com>
> Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
> 	hang
> Cc: <xfs@oss.sgi.com>
>
> Hi Mark,
>
> On Wed, Sep 19, 2012 at 11:31:33AM -0500, tinguely@sgi.com wrote:
> ...
> > I traced the callers of xfs_alloc_vextent(), noting transaction creation,
> > commits and cancels; I noted loops in the callers and which were marked
> > as metadata/userdata. I can send this document to reviewers.
>
> I'd like to see the doc of xfs_alloc_vextent callers and which of them loop.
> Can you post your doc to the list?
>
> Regards,
> 	Ben


Here are the Linux 3.6.x callers of xfs_alloc_vextent() stopping at the
transaction commit/cancel level.

XFS_BMAPI_METADATA *not* being set implies user data.

Userdata being set is the community designated indication that an allocate
worker is needed to prevent the overflow of the kernel stack.

Calling xfs_alloc_vextent() several times with the same transaction can cause
a dead lock if a new allocation worker can not be allocated. I noted where the
loops occur. xfs_alloc_vextent() can call itself, those calls must be in the
same allocation worker. 

As a bonus, consolidating the loops into one worker actually gives a slight
performance advantage.

Sorry this is wider than 80 characters wide.
		---
xfs_bmap_btalloc(xfs_bmalloca_t)
! xfs_bmap_alloc(xfs_bmalloca_t)
! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
! ! ! xfs_bmapi_write(xfs_trans_t ...)  loops over above
! ! ! ! xfs_attr_rmtval_set(xfs_da_args_t) loops over bmapi_write (xfs_attr_set_int) **XFS_BMAPI_METADATA**
! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! xfs_da_grow_inode_int(xfs_da_args_t) loops over bmapi_write **XFS_BMAPI_METADATA**
! ! ! ! ! xfs_dir2_grow_inode(struct xfs_da_args)
! ! ! ! ! ! xfs_dir2_sf_to_block(xfs_da_args_t)
! ! ! ! ! ! ! xfs_bmap_add_attrfork_local(xfs_trans_t ..)
! ! ! ! ! ! ! ! xfs_bmap_add_attrfork(...) trans alloc, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! xfs_dir2_sf_addname((xfs_da_args_t)
! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! xfs_dir2_leaf_addname(xfs_da_args_t)
! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! xfs_dir2_block_addname(xfs_da_args_t)
! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! xfs_dir2_sf_addname((xfs_da_args_t)
! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! xfs_dir2_leaf_to_node(xfs_da_args_t)
! ! ! ! ! ! ! xfs_dir2_leaf_addname(xfs_da_args_t) <also above>
! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_dir2_block_addname(xfs_da_args_t)
! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_dir2_sf_addname((xfs_da_args_t)
! ! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! xfs_dir2_node_addname_int(xfs_da_args_t ...)
! ! ! ! ! ! ! xfs_dir2_node_addname(xfs_da_args_t)
! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_dir2_leaf_addname(xfs_da_args_t)
! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t)
! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! xfs_da_grow_inode(xfs_da_args)
! ! ! ! ! ! xfs_attr_shortform_to_leaf(xfs_da_args_t)
! ! ! ! ! ! ! xfs_attr_set_int(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! xfs_attr_leaf_to_node(xfs_da_args_t)
! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! xfs_attr_leaf_split(xfs_da_state_t ...)
! ! ! ! ! ! ! xfs_da_split(xfs_da_state_t) loops over xfs_attr_leaf_split
! ! ! ! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) trans_roll
! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! ! xfs_dir2_node_addname(xfs_da_args_t)
! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_dir2_leaf_addname(xfs_da_args_t)
! ! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t)
! ! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! xfs_da_root_split(xfs_da_state_t ...) <above>
! ! ! ! ! ! ! xfs_da_split(xfs_da_state_t) loops over xfs_attr_leaf_split
! ! ! ! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) trans_roll
! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! xfs_da_node_split(xfs_da_state_t ...)
! ! ! ! ! ! ! ! xfs_da_split(xfs_da_state_t) loops over xfs_attr_leaf_split
! ! ! ! ! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) trans_roll
! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! xfs_dir2_block_to_leaf(xfs_da_args_t ...)
! ! ! ! ! ! ! xfs_dir2_block_addname(xfs_da_args_t)
! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! xfs_dir2_sf_addname((xfs_da_args_t)
! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! xfs_dir2_leafn_split(xfs_da_state_t...)
! ! ! ! ! ! ! xfs_da_split(xfs_da_state_t) loops over xfs_attr_leaf_split
! ! ! ! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) trans_roll
! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! xfs_qm_dqalloc(xfs_trans_t ...) does a xfs_bmap_finish/cancel **XFS_BMAPI_METADATA**
! ! ! ! ! xfs_qm_dqtobp(xfs_trans_t ...)
! ! ! ! ! ! xfs_qm_dqread(...) does the trans_alloc/commit/cancel
! ! ! ! xfs_iomap_write_direct(...) alloc trans, xfs_trans_commit/cancel
! ! ! ! xfs_iomap_write_allocate(...) alloc trans, xfs_trans_commit/cancel safe loop
! ! ! ! xfs_iomap_write_unwritten(..) alloc trans, xfs_trans_commit/cancel safe loop
! ! ! ! xfs_growfs_rt_alloc(..) alloc trans, xfs_trans_commit/cancel safe loop
! ! ! ! xfs_symlink(...) allocates trans does a xfs_trans_commit/cancel
! ! ! ! xfs_alloc_file_space(...) alloc trans, xfs_trans_commit/cancel safe loop

xfs_bmap_extents_to_btree(xfs_trans_t ...) <- set userdata to 0 (patch 3)
! xfs_bmap_add_attrfork_extents(xfs_trans_t ...)
! ! xfs_bmap_add_attrfork(...) allocates trans does a xfs_trans_commit/cancel
! xfs_bmap_add_extent_delay_real(fs_bmalloca)
! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
! ! ! <see above>
! xfs_bmap_add_extent_unwritten_real(xfs_trans_t ...)
! ! xfs_bmapi_convert_unwritten(xfs_bmalloca ...)
! ! ! xfs_bmapi_write(xfs_trans ...) calls xfs_bmapi_convert_unwritten in loop XFS_BMAPI_METADATA
! ! ! ! ... <see above>
! ! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
! ! ! xfs_attr_rmtval_remove(xfs_da_args_t) loops calling xfs_bunmapi **XFS_BMAPI_METADATA**
! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! xfs_attr_node_addname(xfs_da_args_t) trans_roll
! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
! ! ! ! xfs_attr_node_removename(xfs_da_args_t)
! ! ! ! ! xfs_attr_remove_int(...) allocates trans does a xfs_trans_commit/cancel
! ! ! xfs_dir2_shrink_inode(xfs_da_args_t) **XFS_BMAPI_METADATA**
! ! ! ! xfs_dir2_leaf_trim_data(xfs_da_args_t)
! ! ! ! ! xfs_dir2_leaf_to_block(xfs_da_args_t ...)
! ! ! ! ! ! xfs_dir2_leaf_removename(xfs_da_args_t)
! ! ! ! ! ! ! xfs_dir_removename(xfs_trans ...)
! ! ! ! ! ! ! ! xfs_remove(...) allocates trans does a xfs_trans_commit/cancel
! ! ! ! xfs_dir2_leaf_trim_data(xfs_da_args_t)
! ! ! ! ! xfs_dir2_leaf_to_block(xfs_da_args_t ...)
! ! ! ! ! ! xfs_dir2_leaf_removename(xfs_da_args_t)
! ! ! ! ! ! ! xfs_dir_removename(xfs_trans ...)
! ! ! ! ! ! ! ! xfs_remove(...) allocates trans does a xfs_trans_commit/cancel
! ! ! ! ! ! xfs_dir2_node_to_leaf(xfs_da_state_t)
! ! ! ! ! ! ! xfs_dir2_node_removename(xfs_da_args_t)
! ! ! ! ! ! ! ! xfs_dir_removename(xfs_trans_t ...) creates the xfs_da_args_t
! ! ! ! ! ! ! ! ! xfs_remove(...) allocates trans does a xfs_trans_commit/cancel
! ! ! ! xfs_dir2_node_to_leaf(xfs_da_state_t)
! ! ! ! ! xfs_dir2_node_removename(xfs_da_args_t)
! ! ! ! ! ! xfs_dir_removename(xfs_trans_t ...) creates the xfs_da_args_t
! ! ! ! ! ! ! xfs_remove(...) allocates trans does a xfs_trans_commit/cancel
! ! ! xfs_bmap_punch_delalloc_range(...) loops calling xfs_bunmapi with NULL tp
! ! ! xfs_da_shrink_inode(xfs_da_args_t) loops calling xfs_bunmapi **XFS_BMAPI_METADATA**
! ! ! ! xfs_dir2_leaf_to_block(xfs_da_args_t ...)
! ! ! ! ! xfs_dir2_leaf_removename(xfs_da_args_t)
! ! ! ! ! ! xfs_dir_removename(xfs_trans ...)
! ! ! ! ! ! ! xfs_remove(...) allocates trans does a xfs_trans_commit/cancel
! ! ! xfs_itruncate_extents(xfs_trans ...) loops calling xfs_bunmapi with new tp
! ! ! xfs_inactive_symlink_rmt(..., xfs_trans_t) does a trans_commit and trans_dup
! ! ! xfs_free_file_space(...) loops calling xfs_bmapi with new tp
! xfs_bmap_add_extent_hole_real(xfs_bmalloca ...)
! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
! ! ! ... <see above>
! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
! ! ... <see above>

xfs_bmap_local_to_extents(xfs_trans_t ...)     <- set userdata to 0 (patch 3)
! xfs_bmap_add_attrfork_local(xfs_trans_t ..)
! ! xfs_bmap_add_attrfork(...) trans alloc, bmap_finish trans_commit/cancel
! xfs_bmapi_write(xfs_trans_t ...) XFS_BMAPI_METADATA
! ! ... <see above>

xfs_ialloc_ag_alloc(xfs_trans_t ...) userdata == 0
! xfs_dialloc(xfs_trans ...) loops over the above
! ! xfs_ialloc(xfs_trans ...)
! ! ! xfs_dir_ialloc(xfs_trans ...)
! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel

xfs_bmbt_alloc_block(xfs_btree_cur, ...) userdata == 0
! xfs_btree_split(xfs_btree_cur, ...)
! ! xfs_btree_make_block_unfull
! ! ! xfs_btree_insrec(xfs_btree_cur, ...)
! ! ! ! xfs_btree_insert(xfs_btree_cur, ...)
! ! ! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
! ! ! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! xfs_free_ag_extent(xfs_trans ...)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! xfs_bmap_add_extent_delay_real(xfs_bmalloca)
! ! ! ! ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
! ! ! ! ! ! ! ! ... <see above>
! ! ! ! ! xfs_bmap_add_extent_hole_real(xfs_bmalloca)
! ! ! ! ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
! ! ! ! ! ! ! ! ... <see above>
! ! ! ! ! xfs_bmap_add_extent_unwritten_real(xfs_trans, ...)
! ! ! ! ! ! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
! ! ! ! ! ! ! ... <see above>
! ! ! ! ! ! xfs_bmapi_convert_unwritten(xfs_bmalloca, ...)
! ! ! ! ! ! ! xfs_bmapi_write(xfs_trans_t ...) loop over the above
! ! ! ! ! ! ! ! ... <see above>
! ! ! ! ! xfs_bmap_del_extent(xfs_trans, ...) 
! ! ! ! ! ! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
! ! ! ! ! ! ! ... <see above>
! ! ! ! ! xfs_ialloc_ag_alloc(xfs_trans, ...) loops over the above
! ! ! ! ! ! xfs_dialloc(xfs_trans ...) loops over the above
! ! ! ! ! ! ! xfs_ialloc(xfs_trans ...)
! ! ! ! ! ! ! ! xfs_dir_ialloc(xfs_trans ...)
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! xfs_btree_new_iroot(xfs_btree_cur, ...)
! ! xfs_btree_make_block_unfull(xfs_btree_cur, ...)
! ! ! xfs_btree_insrec(xfs_btree_cur, ...)
! ! ! ! xfs_btree_insert(xfs_btree_cur, ...)
! ! ! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
! ! ! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! xfs_bmap_add_attrfork_btree(xfs_trans_t ...)
! ! ! xfs_bmap_add_attrfork(...) allocates trans does a xfs_trans_commit/cancel
! xfs_btree_new_root(xfs_btree_cur, ...)
! ! xfs_btree_insrec(xfs_btree_cur, ...)
! ! ! xfs_btree_insert(xfs_btree_cur, ...)
! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)

xfs_inobt_alloc_block(xfs_btree_cur, ...) userdata == 0
! xfs_btree_split(xfs_btree_cur, ...)
! ! xfs_btree_make_block_unfull
! ! ! xfs_btree_insrec(xfs_btree_cur, ...)
! ! ! ! xfs_btree_insert(xfs_btree_cur, ...)
! ! ! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
! ! ! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! xfs_free_ag_extent(xfs_trans ...)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! xfs_bmap_add_extent_delay_real(xfs_bmalloca)
! ! ! ! ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
! ! ! ! ! ! ! ! ... <see above>
! ! ! ! ! xfs_bmap_add_extent_hole_real(xfs_bmalloca)
! ! ! ! ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
! ! ! ! ! ! ! ! ... <see above>
! ! ! ! ! xfs_bmap_add_extent_unwritten_real(xfs_trans, ...)
! ! ! ! ! ! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
! ! ! ! ! ! ! ... <see above>
! ! ! ! ! ! xfs_bmapi_convert_unwritten(xfs_bmalloca, ...)
! ! ! ! ! ! ! xfs_bmapi_write(xfs_trans_t ...) loop over the above
! ! ! ! ! ! ! ! ... <see above>
! ! ! ! ! xfs_bmap_del_extent(xfs_trans, ...) 
! ! ! ! ! ! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
! ! ! ! ! ! ! ... <see above>
! ! ! ! ! xfs_ialloc_ag_alloc(xfs_trans, ...) loops over the above
! ! ! ! ! ! xfs_dialloc(xfs_trans ...) loops over the above
! ! ! ! ! ! ! xfs_ialloc(xfs_trans ...)
! ! ! ! ! ! ! ! xfs_dir_ialloc(xfs_trans ...)
! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
! xfs_btree_new_iroot(xfs_btree_cur, ...)
! ! xfs_btree_make_block_unfull(xfs_btree_cur, ...)
! ! ! xfs_btree_insrec(xfs_btree_cur, ...)
! ! ! ! xfs_btree_insert(xfs_btree_cur, ...)
! ! ! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
! ! ! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! xfs_bmap_add_attrfork_btree(xfs_trans_t ...)
! ! ! xfs_bmap_add_attrfork(...) allocates trans does a xfs_trans_commit/cancel
! xfs_btree_new_root(xfs_btree_cur, ...)
! ! xfs_btree_insrec(xfs_btree_cur, ...)
! ! ! xfs_btree_insert(xfs_btree_cur, ...)
! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
