Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:55313 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbeICHi7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Sep 2018 03:38:59 -0400
Date: Mon, 3 Sep 2018 13:20:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 23/28] xfs: Add parent pointers to rename
Message-ID: <20180903032031.GO5631@dastard>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
 <1535484161-11059-24-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535484161-11059-24-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 28, 2018 at 12:22:36PM -0700, Allison Henderson wrote:
> This patch removes the old parent pointer attribute during the
> rename operation, and re-adds the updated parent pointer
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

renameat operations in generic/023 trigger an ASSERT failure in the
error handling path.

 XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/xfs_inode_item.c, line: 576
 ------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:102!
 invalid opcode: 0000 [#1] PREEMPT SMP
 CPU: 0 PID: 10568 Comm: renameat2 Not tainted 4.19.0-rc2-dgc+ #652
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/01/2014
 RIP: 0010:assfail+0x28/0x30
 Code: c3 90 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 c8 52 2e 82 48 89 fa 31 ff e8 64 f9 ff ff 80 3d 05 95 0a 01 00 75 03 0f 0b c3 <0f> 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 48 63 f6 49 8a
 RSP: 0018:ffffc90000b7bc18 EFLAGS: 00010202
 RAX: 0000000000000000 RBX: ffff88002d20a840 RCX: 0000000000000000
 RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff8227a7dc
 RBP: ffff88002b4fb480 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000200 R11: f000000000000000 R12: ffff880034495fc8
 R13: ffffffffffffffff R14: 0000000000000000 R15: ffffffff822e6858
 FS:  00007f5fc4d4b740(0000) GS:ffff88003ec00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f5fc3d01170 CR3: 0000000034534000 CR4: 00000000000006f0
 Call Trace:
  xfs_inode_item_unlock+0x63/0x80
  xfs_trans_free_items+0x71/0xf0
  xfs_trans_cancel+0xaf/0x1f0
  xfs_rename+0x435/0xc50
  xfs_vn_rename+0xd5/0x140
  vfs_rename+0x384/0x9b0
  ? lookup_dcache+0x17/0x60
  do_renameat2+0x49b/0x550
  __x64_sys_renameat2+0x20/0x30
  do_syscall_64+0x5a/0x180
  entry_SYSCALL_64_after_hwframe+0x49/0xbe


> @@ -2985,14 +2987,14 @@ xfs_rename(
>  	 * we can rely on either trans_commit or trans_cancel to unlock
>  	 * them.
>  	 */
> -	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, src_dp, 0);
>  	if (new_parent)
> -		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, target_dp, 0);
> +	xfs_trans_ijoin(tp, src_ip, 0);
>  	if (target_ip)
> -		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, target_ip, 0);
>  	if (wip)
> -		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, wip, 0);

So we change the locking such that failure requires use to unlock
the inodes after the transaction commit or cancel....

>  
>  	/*
>  	 * If we are using project inheritance, we only allow renames
> @@ -3002,15 +3004,16 @@ xfs_rename(
>  	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
>  		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
>  		error = -EXDEV;
> -		goto out_trans_cancel;
> +		goto out_unlock;

This smells wrong - we need to cancel the transaction, then unlock
the items, not the other way around, so we should still be jumping
to a transaction cancel action.

>  	}
>  
>  	/* RENAME_EXCHANGE is unique from here on. */
> -	if (flags & RENAME_EXCHANGE)
> -		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
> +	if (flags & RENAME_EXCHANGE) {
> +		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
>  					target_dp, target_name, target_ip,
>  					spaceres);
> -
> +		goto out;
> +	}

This looks problematic, too. i.e.  On error, xfs_cross_rename() will
have already called xfs_trans_cancel(), but it hasn't unlocked any
of the inodes. If it succeeds, it commits the transaction. Either
way, the transaction has been finished and freed. However, the
code we jump to expects that the transaction is open and still
running.

Also "out" typically means "goto end of function and return". This
is jumping to parent pointer addition, not the function return
processing. Hence the label needs to be changed to
"parent_pointer"....

[....]

> @@ -3175,16 +3178,51 @@ xfs_rename(
>  		VFS_I(wip)->i_state &= ~I_LINKABLE;
>  	}
>  
> +out:
> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> +		error = xfs_parent_add_deferred(target_dp, tp, src_ip, target_name,
> +				new_diroffset);

And so when we try to add the a parent pointers, we haven't checked
if the cross rename failed and aborted the transaction. Or if it
succeeded, it expects to continue using the transaction which
xfs_cross_rename() committed.

> +		if (error)
> +			goto out_bmap_cancel;
> +
> +		error = xfs_parent_remove_deferred(src_dp, tp, src_ip,
> +						   old_diroffset);
> +		if (error)
> +			goto out_bmap_cancel;
> +	}

We don't have "bmaps" in these functions any more. We just need to
cancel the trasaction now, right?

> +
>  	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
>  	if (new_parent)
>  		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
>  
>  	error = xfs_finish_rename(tp);
> +
>  	if (wip)
>  		xfs_irele(wip);
> +	if (wip)
> +		xfs_iunlock(wip, XFS_ILOCK_EXCL);
> +	if (target_ip)
> +		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
> +	if (new_parent)
> +		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
> +	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);
> +

OK, so this unlocks after the final commit. That's fine, but the
rest of the error stack looks wrong.

>  	return error;
>  
> +out_bmap_cancel:
> +	xfs_defer_cancel(tp);

xfs_trans_cancel() calls xfs_defer_cancel() now, so it's not needed
anymore.

> +out_unlock:
> +	if (wip)
> +		xfs_iunlock(wip, XFS_ILOCK_EXCL);
> +	if (target_ip)
> +		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
> +	if (new_parent)
> +		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
> +	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);

And I think this has to happen after calling xfs_trans_cancel().
> +
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  out_release_wip:

So the return stacking needs work here. I think it should look
something like:

	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
	if (new_parent)
		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
	error = xfs_finish_rename(tp);

out_unlock:
	if (wip)
		xfs_irele(wip);
	if (wip)
		xfs_iunlock(wip, XFS_ILOCK_EXCL);
	if (target_ip)
		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
	if (new_parent)
		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);

	return error;

out_trans_cancel:
	xfs_trans_cancel(tp);
out_release_wip:
	if (wip)
		xfs_irele(wip);
	goto out_unlock;
}

This means almost all the error goto's remain unchanged,
"out_bmap_cancel" should be "out_trans_cancel", xfs_cross_rename()
needs to roll the transaction, not commit it, and it if fails it
needs to jump to out_trans_cancel().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
