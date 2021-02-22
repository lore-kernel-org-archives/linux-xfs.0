Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B975C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 22:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 446E864E4B
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 22:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhBVWyf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 17:54:35 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:49757 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232088AbhBVWy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 17:54:29 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id A75891ADB73;
        Tue, 23 Feb 2021 09:53:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEK5I-00HK0K-Kv; Tue, 23 Feb 2021 09:53:44 +1100
Date:   Tue, 23 Feb 2021 09:53:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: lockdep recursive locking warning on for-next
Message-ID: <20210222225344.GQ4662@dread.disaster.area>
References: <20210218181450.GA705507@bfoster>
 <20210218184926.GN7190@magnolia>
 <20210218191252.GA709084@bfoster>
 <20210218193154.GO7190@magnolia>
 <20210219041427.GE4662@dread.disaster.area>
 <20210219042833.GA7193@magnolia>
 <20210219054820.GG4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219054820.GG4662@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=KlgsIpSAAvnNWTS01oAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 19, 2021 at 04:48:20PM +1100, Dave Chinner wrote:
> On Thu, Feb 18, 2021 at 08:28:33PM -0800, Darrick J. Wong wrote:
> > On Fri, Feb 19, 2021 at 03:14:27PM +1100, Dave Chinner wrote:
> > > > What if we implemented a XFS_TRANS_TRYRESERVE flag that would skip the
> > > > scanning loops?  Then it would be at least a little more obvious when
> > > > xfs_free_eofblocks and xfs_reflink_cancel_cow_range kick on.
> > > 
> > > Isn't detecting transaction reentry exactly what PF_FSTRANS is for?
> > > 
> > > Or have we dropped that regression fix on the ground *again*?
> > 
> > That series isn't making progress.
> 
> Ok, I just went back and looked at v15 from a month ago and noticed
> multiple new bugs that weren't in v14. I'm so done with that slow
> motion merry-go-round, so here's patch I wrote from scratch 10
> minutes ago....

And, yes, this patch assert fails when the GC code re-enters
xfs_trans_alloc()....

[56063.434910] kernel BUG at fs/xfs/xfs_message.c:110!
[56063.434929] invalid opcode: 0000 [#8] PREEMPT SMP
[56063.434932] CPU: 8 PID: 436700 Comm: fsstress Tainted: G      D           5.11.0-dgc+ #2897
[56063.436666] kernel BUG at fs/xfs/xfs_message.c:110!
[56063.439129] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
[56063.439134] RIP: 0010:assfail+0x27/0x2d
[56063.439142] Code: 0b 5d c3 66 66 66 66 90 55 41 89 c8 48 89 d1 48 89 f2 48 89 e5 48 c7 c6 50 47 58 82 e8 79 f9 ff ff 80 3d 49 51 86 02 00 74 02 <0f> 0b 0f 0b 5d 9
[56063.439145] RSP: 0018:ffffc9000a91f968 EFLAGS: 00010202
[56063.439149] RAX: 0000000000000000 RBX: ffff8885cffbe200 RCX: 0000000000000000
[56063.439151] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffff82511561
[56063.439154] RBP: ffffc9000a91f968 R08: 0000000000000000 R09: 000000000000000a
[56064.187006] R10: 000000000000000a R11: f000000000000000 R12: ffff888258a5e000
[56064.188957] R13: ffff888258a5e2fc R14: 0000000000000000 R15: 0000000000000000
[56064.190909] FS:  00007f498012b040(0000) GS:ffff8885fec00000(0000) knlGS:0000000000000000
[56064.193109] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[56064.194701] CR2: 00007f498033b000 CR3: 0000000240fab001 CR4: 0000000000060ee0
[56064.196648] Call Trace:
[56064.197333]  xfs_trans_alloc+0x28c/0x2c0
[56064.198423]  xfs_free_eofblocks+0x12b/0x200
[56064.199603]  xfs_inode_free_eofblocks.constprop.0+0xd7/0x120
[56064.201161]  xfs_blockgc_scan_inode+0x36/0x80
[56064.202358]  xfs_inode_walk_ag+0x1bc/0x450
[56064.203493]  ? xfs_inode_free_cowblocks+0xf0/0xf0
[56064.204795]  xfs_inode_walk+0x69/0xc0
[56064.205836]  ? xfs_inode_free_cowblocks+0xf0/0xf0
[56064.207128]  xfs_blockgc_free_space+0x36/0x90
[56064.208323]  xfs_trans_alloc+0x19b/0x2c0
[56064.209421]  xfs_trans_alloc_inode+0x6f/0x170
[56064.210633]  xfs_alloc_file_space+0x101/0x2c0
[56064.211828]  ? __might_sleep+0x4b/0x80
[56064.212874]  xfs_file_fallocate+0x2e1/0x480
[56064.214030]  ? __do_sys_newfstat+0x55/0x60
[56064.215171]  vfs_fallocate+0x152/0x330
[56064.216220]  __x64_sys_fallocate+0x44/0x70
[56064.217383]  do_syscall_64+0x32/0x50
[56064.218372]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

So this patch does detect this as transaction recursion....

Cheers,

Dave.

> xfs: use current->journal_info for detecting transaction recursion
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because the iomap code using PF_MEMALLOC_NOFS to detect transaction
> recursion in XFS is just wrong. Remove it from the iomap code and
> replace it with XFS specific internal checks using
> current->journal_info instead.
> 
> Fixes: 9070733b4efa ("xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/iomap/buffered-io.c    |  7 -------
>  fs/xfs/libxfs/xfs_btree.c |  4 +++-
>  fs/xfs/xfs_aops.c         | 17 +++++++++++++++--
>  fs/xfs/xfs_trans.c        | 21 +++++----------------
>  fs/xfs/xfs_trans.h        | 30 ++++++++++++++++++++++++++++++
>  5 files changed, 53 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 16a1e82e3aeb..fcd4a0d71fc1 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1458,13 +1458,6 @@ iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
>  			PF_MEMALLOC))
>  		goto redirty;
>  
> -	/*
> -	 * Given that we do not allow direct reclaim to call us, we should
> -	 * never be called in a recursive filesystem reclaim context.
> -	 */
> -	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
> -		goto redirty;
> -
>  	/*
>  	 * Is this page beyond the end of the file?
>  	 *
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index b56ff451adce..e6a15b920034 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -2805,7 +2805,7 @@ xfs_btree_split_worker(
>  	struct xfs_btree_split_args	*args = container_of(work,
>  						struct xfs_btree_split_args, work);
>  	unsigned long		pflags;
> -	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
> +	unsigned long		new_pflags = 0;
>  
>  	/*
>  	 * we are in a transaction context here, but may also be doing work
> @@ -2817,11 +2817,13 @@ xfs_btree_split_worker(
>  		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
>  
>  	current_set_flags_nested(&pflags, new_pflags);
> +	xfs_trans_set_context(args->cur->bc_tp);
>  
>  	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
>  					 args->key, args->curp, args->stat);
>  	complete(args->done);
>  
> +	xfs_trans_clear_context(args->cur->bc_tp);
>  	current_restore_flags_nested(&pflags, new_pflags);
>  }
>  
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 4304c6416fbb..b4186d666157 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -62,7 +62,7 @@ xfs_setfilesize_trans_alloc(
>  	 * We hand off the transaction to the completion thread now, so
>  	 * clear the flag here.
>  	 */
> -	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> +	xfs_trans_clear_context(tp);
>  	return 0;
>  }
>  
> @@ -125,7 +125,7 @@ xfs_setfilesize_ioend(
>  	 * thus we need to mark ourselves as being in a transaction manually.
>  	 * Similarly for freeze protection.
>  	 */
> -	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> +	xfs_trans_set_context(tp);
>  	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
>  
>  	/* we abort the update if there was an IO error */
> @@ -568,6 +568,12 @@ xfs_vm_writepage(
>  {
>  	struct xfs_writepage_ctx wpc = { };
>  
> +	if (WARN_ON_ONCE(current->journal_info)) {
> +		redirty_page_for_writepage(wbc, page);
> +		unlock_page(page);
> +		return 0;
> +	}
> +
>  	return iomap_writepage(page, wbc, &wpc.ctx, &xfs_writeback_ops);
>  }
>  
> @@ -578,6 +584,13 @@ xfs_vm_writepages(
>  {
>  	struct xfs_writepage_ctx wpc = { };
>  
> +	/*
> +	 * Writing back data in a transaction context can result in recursive
> +	 * transactions. This is bad, so issue a warning and get out of here.
> +	 */
> +	if (WARN_ON_ONCE(current->journal_info))
> +		return 0;
> +
>  	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
>  	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
>  }
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 7d05694681e3..28c87eff11c0 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -72,6 +72,7 @@ xfs_trans_free(
>  	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
>  
>  	trace_xfs_trans_free(tp, _RET_IP_);
> +	xfs_trans_clear_context(tp);
>  	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_end_intwrite(tp->t_mountp->m_super);
>  	xfs_trans_free_dqinfo(tp);
> @@ -123,7 +124,8 @@ xfs_trans_dup(
>  
>  	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
>  	tp->t_rtx_res = tp->t_rtx_res_used;
> -	ntp->t_pflags = tp->t_pflags;
> +
> +	xfs_trans_switch_context(tp, ntp);
>  
>  	/* move deferred ops over to the new tp */
>  	xfs_defer_move(ntp, tp);
> @@ -157,9 +159,6 @@ xfs_trans_reserve(
>  	int			error = 0;
>  	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
>  
> -	/* Mark this thread as being in a transaction */
> -	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> -
>  	/*
>  	 * Attempt to reserve the needed disk blocks by decrementing
>  	 * the number needed from the number available.  This will
> @@ -167,10 +166,8 @@ xfs_trans_reserve(
>  	 */
>  	if (blocks > 0) {
>  		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
> -		if (error != 0) {
> -			current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> +		if (error != 0)
>  			return -ENOSPC;
> -		}
>  		tp->t_blk_res += blocks;
>  	}
>  
> @@ -244,9 +241,6 @@ xfs_trans_reserve(
>  		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
>  		tp->t_blk_res = 0;
>  	}
> -
> -	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> -
>  	return error;
>  }
>  
> @@ -270,6 +264,7 @@ xfs_trans_alloc(
>  	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_start_intwrite(mp->m_super);
> +	xfs_trans_set_context(tp);
>  
>  	/*
>  	 * Zero-reservation ("empty") transactions can't modify anything, so
> @@ -892,8 +887,6 @@ __xfs_trans_commit(
>  	xfs_trans_apply_dquot_deltas(tp);
>  
>  	xlog_cil_commit(mp->m_log, tp, &commit_seq, regrant);
> -
> -	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>  	xfs_trans_free(tp);
>  
>  	/*
> @@ -925,7 +918,6 @@ __xfs_trans_commit(
>  			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
>  		tp->t_ticket = NULL;
>  	}
> -	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>  	xfs_trans_free_items(tp, !!error);
>  	xfs_trans_free(tp);
>  
> @@ -985,9 +977,6 @@ xfs_trans_cancel(
>  		tp->t_ticket = NULL;
>  	}
>  
> -	/* mark this thread as no longer being in a transaction */
> -	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> -
>  	xfs_trans_free_items(tp, dirty);
>  	xfs_trans_free(tp);
>  }
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index d223d4f4e429..f7b0fc24027f 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -281,4 +281,34 @@ int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
>  		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, bool force,
>  		struct xfs_trans **tpp);
>  
> +static inline void
> +xfs_trans_set_context(
> +	struct xfs_trans	*tp)
> +{
> +	ASSERT(current->journal_info == NULL);
> +	tp->t_pflags = memalloc_nofs_save();
> +	current->journal_info = tp;
> +}
> +
> +static inline void
> +xfs_trans_clear_context(
> +	struct xfs_trans	*tp)
> +{
> +	if (current->journal_info == tp) {
> +		memalloc_nofs_restore(tp->t_pflags);
> +		current->journal_info = NULL;
> +	}
> +}
> +
> +static inline void
> +xfs_trans_switch_context(
> +	struct xfs_trans	*old_tp,
> +	struct xfs_trans	*new_tp)
> +{
> +	ASSERT(current->journal_info == old_tp);
> +	new_tp->t_pflags = old_tp->t_pflags;
> +	old_tp->t_pflags = 0;
> +	current->journal_info = new_tp;
> +}
> +
>  #endif	/* __XFS_TRANS_H__ */
> 

-- 
Dave Chinner
david@fromorbit.com
