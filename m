Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RNG5Jw151830 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 18:16:05 -0500
Message-ID: <5064DE7A.6000608@sgi.com>
Date: Thu, 27 Sep 2012 18:17:14 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
	hang
References: <20120924171159.GG1140@sgi.com>
	<201209241809.q8OI94s3003323@eagdhcp-232-125.americas.sgi.com>
	<20120927224852.GJ13214@sgi.com>
In-Reply-To: <20120927224852.GJ13214@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 09/27/12 17:48, Ben Myers wrote:
> Hey Mark,
>
> On Mon, Sep 24, 2012 at 01:09:04PM -0500, Mark Tinguely wrote:
>>>  From bpm@sgi.com Mon Sep 24 12:11:59 2012
>>> Date: Mon, 24 Sep 2012 12:11:59 -0500
>>> From: Ben Myers<bpm@sgi.com>
>>> To:<tinguely@sgi.com>
>>> Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
>>> 	hang
>>> Cc:<xfs@oss.sgi.com>
>>>
>>> Hi Mark,
>>>
>>> On Wed, Sep 19, 2012 at 11:31:33AM -0500, tinguely@sgi.com wrote:
>>> ...
>>>> I traced the callers of xfs_alloc_vextent(), noting transaction creation,
>>>> commits and cancels; I noted loops in the callers and which were marked
>>>> as metadata/userdata. I can send this document to reviewers.
>>>
>>> I'd like to see the doc of xfs_alloc_vextent callers and which of them loop.
>>> Can you post your doc to the list?
>>>
>>> Regards,
>>> 	Ben
>>
>>
>> Here are the Linux 3.6.x callers of xfs_alloc_vextent() stopping at the
>> transaction commit/cancel level.
>
> Thanks.  Here I am going to make some notes to help me to understand the
> deadlock as you have described.  I'm going to make some idiotic, redundant, and
> obvious commentary for my own understanding and benefit, and then go and spam
> the list with it.
>
>> XFS_BMAPI_METADATA *not* being set implies user data.
>>
>> Userdata being set is the community designated indication that an allocate
>> worker is needed to prevent the overflow of the kernel stack.
>
> Even when XFS_BMAPI_METADATA is set, this doesn't necessarily translate into
> userdata being clear in struct xfs_alloc_arg.  This is due to declaring that
> structure on the stack and then forgetting to zero it.  You have fixed all
> occurances of that in patch 3 of this series.  They are:
>
> xfs_alloc_fix_freelist,
> xfs_bmap_btalloc,	*
> xfs_bmap_extents_to_btree,
> xfs_bmap_local_to_extents,
> xfs_ialloc_ag_alloc
>
> In each of those five stacks we could have intended not to use a worker thread
> for the allocation, but we used one anyway due to having forgotten to zero the
> structure.
>
> * In xfs_bmap_btalloc, args.userdata is set from ap->userdata before the first
> call to xfs_alloc_vextent.  As long as ap->userdata is initialized properly
> this one is ok.
>
>> Calling xfs_alloc_vextent() several times with the same transaction can cause
>> a dead lock if a new allocation worker can not be allocated. I noted where the
>> loops occur. xfs_alloc_vextent() can call itself, those calls must be in the
>> same allocation worker.
>
> This deadlock is characterized by a thread having taken the agf buffer lock in
> this code path:
>
> __xfs_alloc_vextent
>    xfs_alloc_fix_freelist
>      xfs_alloc_read_agf
>        xfs_read_agf
>
> The agf buffer gets logged during allocation and stays locked until transaction
> commit or cancel.
>
> The deadlock comes when the transaction which holds the agf lock blocks waiting
> for a worker, and all of the workers are blocked on the agf lock.
>
> So... because the work being done in __xfs_alloc_vextent will always have need
> of the agf buffer lock, we must never hold the agf lock and then go after a
> worker thread for allocation.  The availability of a worker thread cannot be
> guaranteed.
>
> It's not just a problem with loops.  We risk deadlock on every call to
> xfs_alloc_vextent in the same transaction while the agf lock is held.  e.g.
> multiple tries in xfs_bmap_btalloc.
>
>> As a bonus, consolidating the loops into one worker actually gives a slight
>> performance advantage.
>>
>> Sorry this is wider than 80 characters wide.
>> 		---
>> xfs_bmap_btalloc(xfs_bmalloca_t)
>
> args.userdata = ap->userdata;	* not worried about patch 3 here
>
>> ! xfs_bmap_alloc(xfs_bmalloca_t)
>> ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
>> ! ! ! xfs_bmapi_write(xfs_trans_t ...)  loops over above
>
> Here we risk deadlock in the loop on xfs_bmapi_allocate.  That appears to be
> limited by the number of maps requested.
>
>> ! ! ! ! xfs_attr_rmtval_set(xfs_da_args_t) loops over bmapi_write (xfs_attr_set_int) **XFS_BMAPI_METADATA**
>> ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>
> xfs_attr_rmtval_set calls xfs_bmapi_write in a loop.  XFS_BMAPI_METADATA flag
> was set, so this cannot be using a worker.  No risk of this deadlock here.
>
>> ! ! ! ! xfs_da_grow_inode_int(xfs_da_args_t) loops over bmapi_write **XFS_BMAPI_METADATA**
>> ! ! ! ! ! xfs_dir2_grow_inode(struct xfs_da_args)
>> ! ! ! ! ! ! xfs_dir2_sf_to_block(xfs_da_args_t)
>> ! ! ! ! ! ! ! xfs_bmap_add_attrfork_local(xfs_trans_t ..)
>> ! ! ! ! ! ! ! ! xfs_bmap_add_attrfork(...) trans alloc, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! xfs_dir2_sf_addname((xfs_da_args_t)
>> ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! xfs_dir2_leaf_addname(xfs_da_args_t)
>> ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! xfs_dir2_block_addname(xfs_da_args_t)
>> ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
>> ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! xfs_dir2_sf_addname((xfs_da_args_t)
>> ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! xfs_dir2_leaf_to_node(xfs_da_args_t)
>> ! ! ! ! ! ! ! xfs_dir2_leaf_addname(xfs_da_args_t)<also above>
>> ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_dir2_block_addname(xfs_da_args_t)
>> ! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
>> ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_dir2_sf_addname((xfs_da_args_t)
>> ! ! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
>> ! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! xfs_dir2_node_addname_int(xfs_da_args_t ...)
>> ! ! ! ! ! ! ! xfs_dir2_node_addname(xfs_da_args_t)
>> ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_dir2_leaf_addname(xfs_da_args_t)
>> ! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! xfs_da_grow_inode(xfs_da_args)
>> ! ! ! ! ! ! xfs_attr_shortform_to_leaf(xfs_da_args_t)
>> ! ! ! ! ! ! ! xfs_attr_set_int(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! xfs_attr_leaf_to_node(xfs_da_args_t)
>> ! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! xfs_attr_leaf_split(xfs_da_state_t ...)
>> ! ! ! ! ! ! ! xfs_da_split(xfs_da_state_t) loops over xfs_attr_leaf_split
>> ! ! ! ! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) trans_roll
>> ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! ! xfs_dir2_node_addname(xfs_da_args_t)
>> ! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
>> ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_dir2_leaf_addname(xfs_da_args_t)
>> ! ! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! xfs_da_root_split(xfs_da_state_t ...)<above>
>> ! ! ! ! ! ! ! xfs_da_split(xfs_da_state_t) loops over xfs_attr_leaf_split
>> ! ! ! ! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) trans_roll
>> ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! xfs_da_node_split(xfs_da_state_t ...)
>> ! ! ! ! ! ! ! ! xfs_da_split(xfs_da_state_t) loops over xfs_attr_leaf_split
>> ! ! ! ! ! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) trans_roll
>> ! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! xfs_dir2_block_to_leaf(xfs_da_args_t ...)
>> ! ! ! ! ! ! ! xfs_dir2_block_addname(xfs_da_args_t)
>> ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
>> ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! xfs_dir2_sf_addname((xfs_da_args_t)
>> ! ! ! ! ! ! ! ! ! xfs_dir_createname(xfs_trans_t)
>> ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_dir_canenter(xfs_trans_t ...)
>> ! ! ! ! ! ! ! ! ! ! xfs_rename(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_link(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! xfs_dir2_leafn_split(xfs_da_state_t...)
>> ! ! ! ! ! ! ! xfs_da_split(xfs_da_state_t) loops over xfs_attr_leaf_split
>> ! ! ! ! ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) trans_roll
>> ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>
> No risk of deadlock here due to XFS_BMAPI_METADATA flag.
>
>> ! ! ! ! xfs_qm_dqalloc(xfs_trans_t ...) does a xfs_bmap_finish/cancel **XFS_BMAPI_METADATA**
>> ! ! ! ! ! xfs_qm_dqtobp(xfs_trans_t ...)
>> ! ! ! ! ! ! xfs_qm_dqread(...) does the trans_alloc/commit/cancel
>
> No risk of deadlock here due to XFS_BMAPI_METADATA flag.
>
>> ! ! ! ! xfs_iomap_write_direct(...) alloc trans, xfs_trans_commit/cancel
>
> This allocates it's own transaction and will use a worker since it isn't
> metadata.  Hmm.
>
>> ! ! ! ! xfs_iomap_write_allocate(...) alloc trans, xfs_trans_commit/cancel safe loop
>
> So this is a safe loop because the transaction alloc/commit is within the
> loop... and nmap = 1.
>
> Pfff.  This is in the stack you posted for this series.  So I'm a little confused.
>
> I haven't got through the full list yet.  I'll send this today to keep things
> moving and pick up again tomorrow.
>
> Regards,
> 	Ben
>
>> ! ! ! ! xfs_iomap_write_unwritten(..) alloc trans, xfs_trans_commit/cancel safe loop
>> ! ! ! ! xfs_growfs_rt_alloc(..) alloc trans, xfs_trans_commit/cancel safe loop
>> ! ! ! ! xfs_symlink(...) allocates trans does a xfs_trans_commit/cancel
>> ! ! ! ! xfs_alloc_file_space(...) alloc trans, xfs_trans_commit/cancel safe loop
>>
>> xfs_bmap_extents_to_btree(xfs_trans_t ...)<- set userdata to 0 (patch 3)
>> ! xfs_bmap_add_attrfork_extents(xfs_trans_t ...)
>> ! ! xfs_bmap_add_attrfork(...) allocates trans does a xfs_trans_commit/cancel
>> ! xfs_bmap_add_extent_delay_real(fs_bmalloca)
>> ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
>> ! ! !<see above>
>> ! xfs_bmap_add_extent_unwritten_real(xfs_trans_t ...)
>> ! ! xfs_bmapi_convert_unwritten(xfs_bmalloca ...)
>> ! ! ! xfs_bmapi_write(xfs_trans ...) calls xfs_bmapi_convert_unwritten in loop XFS_BMAPI_METADATA
>> ! ! ! ! ...<see above>
>> ! ! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
>> ! ! ! xfs_attr_rmtval_remove(xfs_da_args_t) loops calling xfs_bunmapi **XFS_BMAPI_METADATA**
>> ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! xfs_attr_node_addname(xfs_da_args_t) trans_roll
>> ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! xfs_attr_leaf_addname(xfs_da_args_t) may do a trans_roll
>> ! ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! ! xfs_attr_set_int(..) does the trans_alloc/commit/cancel
>> ! ! ! ! xfs_attr_node_removename(xfs_da_args_t)
>> ! ! ! ! ! xfs_attr_remove_int(...) allocates trans does a xfs_trans_commit/cancel
>> ! ! ! xfs_dir2_shrink_inode(xfs_da_args_t) **XFS_BMAPI_METADATA**
>> ! ! ! ! xfs_dir2_leaf_trim_data(xfs_da_args_t)
>> ! ! ! ! ! xfs_dir2_leaf_to_block(xfs_da_args_t ...)
>> ! ! ! ! ! ! xfs_dir2_leaf_removename(xfs_da_args_t)
>> ! ! ! ! ! ! ! xfs_dir_removename(xfs_trans ...)
>> ! ! ! ! ! ! ! ! xfs_remove(...) allocates trans does a xfs_trans_commit/cancel
>> ! ! ! ! xfs_dir2_leaf_trim_data(xfs_da_args_t)
>> ! ! ! ! ! xfs_dir2_leaf_to_block(xfs_da_args_t ...)
>> ! ! ! ! ! ! xfs_dir2_leaf_removename(xfs_da_args_t)
>> ! ! ! ! ! ! ! xfs_dir_removename(xfs_trans ...)
>> ! ! ! ! ! ! ! ! xfs_remove(...) allocates trans does a xfs_trans_commit/cancel
>> ! ! ! ! ! ! xfs_dir2_node_to_leaf(xfs_da_state_t)
>> ! ! ! ! ! ! ! xfs_dir2_node_removename(xfs_da_args_t)
>> ! ! ! ! ! ! ! ! xfs_dir_removename(xfs_trans_t ...) creates the xfs_da_args_t
>> ! ! ! ! ! ! ! ! ! xfs_remove(...) allocates trans does a xfs_trans_commit/cancel
>> ! ! ! ! xfs_dir2_node_to_leaf(xfs_da_state_t)
>> ! ! ! ! ! xfs_dir2_node_removename(xfs_da_args_t)
>> ! ! ! ! ! ! xfs_dir_removename(xfs_trans_t ...) creates the xfs_da_args_t
>> ! ! ! ! ! ! ! xfs_remove(...) allocates trans does a xfs_trans_commit/cancel
>> ! ! ! xfs_bmap_punch_delalloc_range(...) loops calling xfs_bunmapi with NULL tp
>> ! ! ! xfs_da_shrink_inode(xfs_da_args_t) loops calling xfs_bunmapi **XFS_BMAPI_METADATA**
>> ! ! ! ! xfs_dir2_leaf_to_block(xfs_da_args_t ...)
>> ! ! ! ! ! xfs_dir2_leaf_removename(xfs_da_args_t)
>> ! ! ! ! ! ! xfs_dir_removename(xfs_trans ...)
>> ! ! ! ! ! ! ! xfs_remove(...) allocates trans does a xfs_trans_commit/cancel
>> ! ! ! xfs_itruncate_extents(xfs_trans ...) loops calling xfs_bunmapi with new tp
>> ! ! ! xfs_inactive_symlink_rmt(..., xfs_trans_t) does a trans_commit and trans_dup
>> ! ! ! xfs_free_file_space(...) loops calling xfs_bmapi with new tp
>> ! xfs_bmap_add_extent_hole_real(xfs_bmalloca ...)
>> ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
>> ! ! ! ...<see above>
>> ! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
>> ! ! ...<see above>
>>
>> xfs_bmap_local_to_extents(xfs_trans_t ...)<- set userdata to 0 (patch 3)
>> ! xfs_bmap_add_attrfork_local(xfs_trans_t ..)
>> ! ! xfs_bmap_add_attrfork(...) trans alloc, bmap_finish trans_commit/cancel
>> ! xfs_bmapi_write(xfs_trans_t ...) XFS_BMAPI_METADATA
>> ! ! ...<see above>
>>
>> xfs_ialloc_ag_alloc(xfs_trans_t ...) userdata == 0
>> ! xfs_dialloc(xfs_trans ...) loops over the above
>> ! ! xfs_ialloc(xfs_trans ...)
>> ! ! ! xfs_dir_ialloc(xfs_trans ...)
>> ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>>
>> xfs_bmbt_alloc_block(xfs_btree_cur, ...) userdata == 0
>> ! xfs_btree_split(xfs_btree_cur, ...)
>> ! ! xfs_btree_make_block_unfull
>> ! ! ! xfs_btree_insrec(xfs_btree_cur, ...)
>> ! ! ! ! xfs_btree_insert(xfs_btree_cur, ...)
>> ! ! ! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! xfs_free_ag_extent(xfs_trans ...)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! xfs_bmap_add_extent_delay_real(xfs_bmalloca)
>> ! ! ! ! ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
>> ! ! ! ! ! ! ! ! ...<see above>
>> ! ! ! ! ! xfs_bmap_add_extent_hole_real(xfs_bmalloca)
>> ! ! ! ! ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
>> ! ! ! ! ! ! ! ! ...<see above>
>> ! ! ! ! ! xfs_bmap_add_extent_unwritten_real(xfs_trans, ...)
>> ! ! ! ! ! ! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
>> ! ! ! ! ! ! ! ...<see above>
>> ! ! ! ! ! ! xfs_bmapi_convert_unwritten(xfs_bmalloca, ...)
>> ! ! ! ! ! ! ! xfs_bmapi_write(xfs_trans_t ...) loop over the above
>> ! ! ! ! ! ! ! ! ...<see above>
>> ! ! ! ! ! xfs_bmap_del_extent(xfs_trans, ...)
>> ! ! ! ! ! ! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
>> ! ! ! ! ! ! ! ...<see above>
>> ! ! ! ! ! xfs_ialloc_ag_alloc(xfs_trans, ...) loops over the above
>> ! ! ! ! ! ! xfs_dialloc(xfs_trans ...) loops over the above
>> ! ! ! ! ! ! ! xfs_ialloc(xfs_trans ...)
>> ! ! ! ! ! ! ! ! xfs_dir_ialloc(xfs_trans ...)
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! xfs_btree_new_iroot(xfs_btree_cur, ...)
>> ! ! xfs_btree_make_block_unfull(xfs_btree_cur, ...)
>> ! ! ! xfs_btree_insrec(xfs_btree_cur, ...)
>> ! ! ! ! xfs_btree_insert(xfs_btree_cur, ...)
>> ! ! ! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! xfs_bmap_add_attrfork_btree(xfs_trans_t ...)
>> ! ! ! xfs_bmap_add_attrfork(...) allocates trans does a xfs_trans_commit/cancel
>> ! xfs_btree_new_root(xfs_btree_cur, ...)
>> ! ! xfs_btree_insrec(xfs_btree_cur, ...)
>> ! ! ! xfs_btree_insert(xfs_btree_cur, ...)
>> ! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
>> ! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
>> ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
>> ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
>> ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>>
>> xfs_inobt_alloc_block(xfs_btree_cur, ...) userdata == 0
>> ! xfs_btree_split(xfs_btree_cur, ...)
>> ! ! xfs_btree_make_block_unfull
>> ! ! ! xfs_btree_insrec(xfs_btree_cur, ...)
>> ! ! ! ! xfs_btree_insert(xfs_btree_cur, ...)
>> ! ! ! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! xfs_free_ag_extent(xfs_trans ...)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! xfs_bmap_add_extent_delay_real(xfs_bmalloca)
>> ! ! ! ! ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
>> ! ! ! ! ! ! ! ! ...<see above>
>> ! ! ! ! ! xfs_bmap_add_extent_hole_real(xfs_bmalloca)
>> ! ! ! ! ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
>> ! ! ! ! ! ! ! ! ...<see above>
>> ! ! ! ! ! xfs_bmap_add_extent_unwritten_real(xfs_trans, ...)
>> ! ! ! ! ! ! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
>> ! ! ! ! ! ! ! ...<see above>
>> ! ! ! ! ! ! xfs_bmapi_convert_unwritten(xfs_bmalloca, ...)
>> ! ! ! ! ! ! ! xfs_bmapi_write(xfs_trans_t ...) loop over the above
>> ! ! ! ! ! ! ! ! ...<see above>
>> ! ! ! ! ! xfs_bmap_del_extent(xfs_trans, ...)
>> ! ! ! ! ! ! xfs_bunmapi(xfs_trans_t ...) XFS_BMAPI_METADATA
>> ! ! ! ! ! ! ! ...<see above>
>> ! ! ! ! ! xfs_ialloc_ag_alloc(xfs_trans, ...) loops over the above
>> ! ! ! ! ! ! xfs_dialloc(xfs_trans ...) loops over the above
>> ! ! ! ! ! ! ! xfs_ialloc(xfs_trans ...)
>> ! ! ! ! ! ! ! ! xfs_dir_ialloc(xfs_trans ...)
>> ! ! ! ! ! ! ! ! ! xfs_create(...) trans allocated, bmap_finish trans_commit/cancel
>> ! ! ! ! ! ! ! ! ! xfs_symlink(...) trans allocated, bmap_finish trans_commit/cancel
>> ! xfs_btree_new_iroot(xfs_btree_cur, ...)
>> ! ! xfs_btree_make_block_unfull(xfs_btree_cur, ...)
>> ! ! ! xfs_btree_insrec(xfs_btree_cur, ...)
>> ! ! ! ! xfs_btree_insert(xfs_btree_cur, ...)
>> ! ! ! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
>> ! ! ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! xfs_bmap_add_attrfork_btree(xfs_trans_t ...)
>> ! ! ! xfs_bmap_add_attrfork(...) allocates trans does a xfs_trans_commit/cancel
>> ! xfs_btree_new_root(xfs_btree_cur, ...)
>> ! ! xfs_btree_insrec(xfs_btree_cur, ...)
>> ! ! ! xfs_btree_insert(xfs_btree_cur, ...)
>> ! ! ! xfs_alloc_fixup_trees(xfs_btree_cur, ...)
>> ! ! ! ! xfs_alloc_ag_vextent_exact(xfs_alloc_arg)
>> ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! xfs_alloc_ag_vextent_near(xfs_alloc_arg)
>> ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>> ! ! ! ! xfs_alloc_ag_vextent_size(xfs_alloc_arg)
>> ! ! ! ! ! xfs_alloc_ag_vextent(xfs_alloc_arg)
>> ! ! ! ! ! ! __xfs_alloc_vextent(xfs_alloc_arg)
>>
>> --Mark.
>>


Adding just the 3 patch does not prevent the hang.

penguin9:~/xfstests-dev # cat /proc/11432/stack
[<e0d8e688>] xfs_alloc_vextent+0x58/0x80 [xfs]
[<e0d99319>] xfs_bmap_btalloc+0x319/0x9b0 [xfs]
[<e0d999ca>] xfs_bmap_alloc+0x1a/0x30 [xfs]
[<e0da61be>] xfs_bmapi_allocate+0xce/0x390 [xfs]
[<e0da6a38>] xfs_bmapi_write+0x5b8/0xb90 [xfs]
[<e0d7d5f8>] xfs_iomap_write_allocate+0x1b8/0x420 [xfs]
[<e0d6d962>] xfs_map_blocks+0x282/0x410 [xfs]
[<e0d6e8de>] xfs_vm_writepage+0x27e/0x660 [xfs]
[<c02e676b>] __writepage+0xb/0x30
[<c02e6f8f>] write_cache_pages+0x18f/0x3e0
[<c02e7217>] generic_writepages+0x37/0x50
[<e0d6cc5f>] xfs_vm_writepages+0x2f/0x40 [xfs]
[<c02e7f4c>] do_writepages+0x1c/0x30
[<c02e046f>] __filemap_fdatawrite_range+0x4f/0x60
[<c02e0fb6>] filemap_fdatawrite_range+0x26/0x30
[<e0d78a4e>] xfs_flush_pages+0x6e/0xe0 [xfs]
[<e0d75e1b>] xfs_file_buffered_aio_write+0x11b/0x1c0 [xfs]
[<e0d75fab>] xfs_file_aio_write+0xeb/0x170 [xfs]
[<c031e884>] do_sync_write+0x94/0xd0
[<c031f26a>] vfs_write+0x8a/0x160
[<c031f67b>] sys_pwrite64+0x7b/0x80
[<c068bb65>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff

penguin9:~/xfstests-dev # cat /proc/11434/stack
[<e0d8e688>] xfs_alloc_vextent+0x58/0x80 [xfs]
[<e0d99319>] xfs_bmap_btalloc+0x319/0x9b0 [xfs]
[<e0d999ca>] xfs_bmap_alloc+0x1a/0x30 [xfs]
[<e0da61be>] xfs_bmapi_allocate+0xce/0x390 [xfs]
[<e0da6a38>] xfs_bmapi_write+0x5b8/0xb90 [xfs]
[<e0d7d5f8>] xfs_iomap_write_allocate+0x1b8/0x420 [xfs]
[<e0d6d962>] xfs_map_blocks+0x282/0x410 [xfs]
[<e0d6e8de>] xfs_vm_writepage+0x27e/0x660 [xfs]
[<c02e676b>] __writepage+0xb/0x30
[<c02e6f8f>] write_cache_pages+0x18f/0x3e0
[<c02e7217>] generic_writepages+0x37/0x50
[<e0d6cc5f>] xfs_vm_writepages+0x2f/0x40 [xfs]
[<c02e7f4c>] do_writepages+0x1c/0x30
[<c02e046f>] __filemap_fdatawrite_range+0x4f/0x60
[<c02e0fb6>] filemap_fdatawrite_range+0x26/0x30
[<e0d78a4e>] xfs_flush_pages+0x6e/0xe0 [xfs]
[<e0d75e1b>] xfs_file_buffered_aio_write+0x11b/0x1c0 [xfs]
[<e0d75fab>] xfs_file_aio_write+0xeb/0x170 [xfs]
[<c031e884>] do_sync_write+0x94/0xd0
[<c031f26a>] vfs_write+0x8a/0x160
[<c031f67b>] sys_pwrite64+0x7b/0x80
[<c068bb65>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff

penguin9:~/xfstests-dev # cat /proc/11440/stack
[<e0d8e688>] xfs_alloc_vextent+0x58/0x80 [xfs]
[<e0d99ba8>] xfs_bmap_extents_to_btree+0x198/0x5d0 [xfs]
[<e0da5a47>] xfs_bmap_add_extent_delay_real+0x2057/0x2700 [xfs]
[<e0da6357>] xfs_bmapi_allocate+0x267/0x390 [xfs]
[<e0da6a38>] xfs_bmapi_write+0x5b8/0xb90 [xfs]
[<e0d7d5f8>] xfs_iomap_write_allocate+0x1b8/0x420 [xfs]
[<e0d6d962>] xfs_map_blocks+0x282/0x410 [xfs]
[<e0d6e8de>] xfs_vm_writepage+0x27e/0x660 [xfs]
[<c02e676b>] __writepage+0xb/0x30
[<c02e6f8f>] write_cache_pages+0x18f/0x3e0
[<c02e7217>] generic_writepages+0x37/0x50
[<e0d6cc5f>] xfs_vm_writepages+0x2f/0x40 [xfs]
[<c02e7f4c>] do_writepages+0x1c/0x30
[<c02e046f>] __filemap_fdatawrite_range+0x4f/0x60
[<c02e0fb6>] filemap_fdatawrite_range+0x26/0x30
[<e0d78a4e>] xfs_flush_pages+0x6e/0xe0 [xfs]
[<e0d75e1b>] xfs_file_buffered_aio_write+0x11b/0x1c0 [xfs]
[<e0d75fab>] xfs_file_aio_write+0xeb/0x170 [xfs]
[<c031e884>] do_sync_write+0x94/0xd0
[<c031f26a>] vfs_write+0x8a/0x160
[<c031f67b>] sys_pwrite64+0x7b/0x80
[<c068bb65>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff

penguin9:~/xfstests-dev # cat /proc/11443/stack
[<e0d8e688>] xfs_alloc_vextent+0x58/0x80 [xfs]
[<e0d99319>] xfs_bmap_btalloc+0x319/0x9b0 [xfs]
[<e0d999ca>] xfs_bmap_alloc+0x1a/0x30 [xfs]
[<e0da61be>] xfs_bmapi_allocate+0xce/0x390 [xfs]
[<e0da6a38>] xfs_bmapi_write+0x5b8/0xb90 [xfs]
[<e0d7d5f8>] xfs_iomap_write_allocate+0x1b8/0x420 [xfs]
[<e0d6d962>] xfs_map_blocks+0x282/0x410 [xfs]
[<e0d6e8de>] xfs_vm_writepage+0x27e/0x660 [xfs]
[<c02e676b>] __writepage+0xb/0x30
[<c02e6f8f>] write_cache_pages+0x18f/0x3e0
[<c02e7217>] generic_writepages+0x37/0x50
[<e0d6cc5f>] xfs_vm_writepages+0x2f/0x40 [xfs]
[<c02e7f4c>] do_writepages+0x1c/0x30
[<c02e046f>] __filemap_fdatawrite_range+0x4f/0x60
[<c02e0fb6>] filemap_fdatawrite_range+0x26/0x30
[<e0d78a4e>] xfs_flush_pages+0x6e/0xe0 [xfs]
[<e0d75e1b>] xfs_file_buffered_aio_write+0x11b/0x1c0 [xfs]
[<e0d75fab>] xfs_file_aio_write+0xeb/0x170 [xfs]
[<c031e884>] do_sync_write+0x94/0xd0
[<c031f26a>] vfs_write+0x8a/0x160
[<c031f67b>] sys_pwrite64+0x7b/0x80
[<c068bb65>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff

I will run a x86_64 machine overnight to see if I can get a hang
on that box too.

We are dealing with multiple AGs here, so analysing this one may take
more time.

Rarely but sometimes, this machine will save core upon receiving a NMI.
I will try to get as much information before trying that.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
