Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D173629DF8
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 10:19:59 -0600 (CST)
Message-ID: <52BEFA2E.5070006@sgi.com>
Date: Sat, 28 Dec 2013 10:19:58 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] xfs: always releasing EFD's reference to EFI in
	xfs_efd_item_committed
References: <52B98295.8050704@oracle.com>
In-Reply-To: <52B98295.8050704@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/24/13 06:48, Jeff Liu wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> With fsstress+godown test I observed an XFS hang up during umount which
> yielding a backtrace like below:
>
> [20876.193635] INFO: task umount:9853 blocked for more than 120 seconds.
> [20876.193641]       Tainted: PF   O 3.13.0-rc2+ #8
> [20876.193643] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [20876.193645] umount          D ffff88026f294440     0  9853   9372
> <snip>
> [20876.193663] Call Trace:
> [20876.193672]  [<ffffffff816f3829>] schedule+0x29/0x70
> [20876.193701]  [<ffffffffa0c4a3e9>] xfs_ail_push_all_sync+0xa9/0xe0 [xfs]
> [20876.193707]  [<ffffffff810a83f0>] ? prepare_to_wait_event+0x100/0x100
> [20876.193726]  [<ffffffffa0be9df1>] xfs_unmountfs+0x61/0x150 [xfs]
> [20876.193746]  [<ffffffffa0becd41>] xfs_fs_put_super+0x21/0x60 [xfs]
> [20876.193751]  [<ffffffff811bbf62>] generic_shutdown_super+0x72/0xf0
> [20876.193754]  [<ffffffff811bc217>] kill_block_super+0x27/0x70
> [20876.193757]  [<ffffffff811bc4fd>] deactivate_locked_super+0x3d/0x60
> [20876.193761]  [<ffffffff811bcab6>] deactivate_super+0x46/0x60
> [20876.193765]  [<ffffffff811d9146>] mntput_no_expire+0xd6/0x170
> [20876.193769]  [<ffffffff811da64e>] SyS_umount+0x8e/0x100
> [20876.193774]  [<ffffffff816ffd6d>] system_call_fastpath+0x1a/0x1f
>
> As per above backtraces, the umount process is already scheduled out
> in xfs_ail_push_all_sync() because it should push out all of pending
> changes in AIL and wait until the AIL is empty.  Then it will wake up
> xfsaild thread to do the actual flushing business.  However, I found
> that the AIL does not became empty in some situations because of some
> EFI are still being on it, but in EFI's iop_push operation, we always
> returning XFS_ITEM_PINNED which leads to the xfsaild thread suffering
> into an infinite loop.
>
> Since EFI items have no locking or pushing, they are pulled from the
> AIL when their corresponding EFDs are committed to disk, and we have
> guaranteed that the EFI should not be freed until it has been unppined
> and the EFD has been committed in commit 666d644cd7, this is done via
> an EFI reference count by initializing it to 2 in xfs_efi_init() -- one
> is it's own count which is not released until it is unpinned, the other
> one is taken by its corresponding EFD which will be released during EFD
> commit operation.
>
> IMHO we should always releasing it's reference to the corresponding EFI
> item once the EFD item is committed to disk regardless of the log item
> is marked with XFS_LI_ABORTED flag or not.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---
>   fs/xfs/xfs_extfree_item.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 3680d04..16c0396 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -437,13 +437,7 @@ xfs_efd_item_committed(
>   {
>   	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
>
> -	/*
> -	 * If we got a log I/O error, it's always the case that the LR with the
> -	 * EFI got unpinned and freed before the EFD got aborted.
> -	 */
> -	if (!(lip->li_flags&  XFS_LI_ABORTED))
> -		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
> -
> +	xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
>   	xfs_efd_item_free(efdp);
>   	return (xfs_lsn_t)-1;
>   }

Hi Jeff.

This would work if the forced shutdown happened after both the EFI and 
EFD transaction were committed and successfully placed on the CIL.

If the sequence went EFI commit, CIL push (EFI is now in the AIL), 
forced shutdown, and then EFD commit. In this sequence, the EFD item 
would not be placed on the CIL and therefore the iop.committed would not 
be called. In this patch only iop_committing and iop_unlock would be run 
on the EFD item.

Thanks,

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
