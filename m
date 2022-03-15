Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528AFC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 20:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351522AbiCOUEj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 16:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351472AbiCOUEi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 16:04:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C78286FE
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 13:03:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1019FB817C9
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 20:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8CFC340E8;
        Tue, 15 Mar 2022 20:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647374601;
        bh=JzWOeO1TN+T1a0zmKhM0gpjAx7f03bBgrTypVMGnrRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mBBAOWw3sFaYd0kviPYi9NmeTHgQhyHOuCUcmdDWEN7JtEtHMCN0y19WbroDyJsNC
         bPToek9oQ0M1HugHsy0msqrJk9TGOzeiZCsnslXLhqD2rLsq0MIUlJcDF2vTAf1Kj6
         rGWI4z+pmbegTctsiDPJ97R0shNvLZLENCODXG3v8NsaGqTsNkpmLnWKwiueqR3mW7
         A2hjjvzb90InFHeCUwkQ+rinLg8wYlbcjOAucEvG0OfJbp+L7F+JSwT8MjZQ6P6KZW
         N1TIiSolv7F68FdBYU3QFr3FWAVwxRsrDExFORCaPYShS0MNRU7Fu7pY4qewyzLbI4
         D4V3d55czTjzA==
Date:   Tue, 15 Mar 2022 13:03:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: xfs_is_shutdown vs xlog_is_shutdown cage fight
Message-ID: <20220315200321.GR8224@magnolia>
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315064241.3133751-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 05:42:41PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> I've been chasing a recent resurgence in generic/388 recovery
> failure and/or corruption events. The events have largely been

recoveryloop, the gift that keeps on giving...

> uninitialised inode chunks being tripped over in log recovery
> such as:
> 
>  XFS (pmem1): User initiated shutdown received.
>  pmem1: writeback error on inode 12621949, offset 1019904, sector 12968096
>  XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xa3/0xf0 (fs/xfs/xfs_fsops.c:500).  Shutting down filesystem.
>  XFS (pmem1): Please unmount the filesystem and rectify the problem(s)
>  XFS (pmem1): Unmounting Filesystem
>  XFS (pmem1): Mounting V5 Filesystem
>  XFS (pmem1): Starting recovery (logdev: internal)
>  XFS (pmem1): bad inode magic/vsn daddr 8723584 #0 (magic=1818)
>  XFS (pmem1): Metadata corruption detected at xfs_inode_buf_verify+0x180/0x190, xfs_inode block 0x851c80 xfs_inode_buf_verify
>  XFS (pmem1): Unmount and run xfs_repair
>  XFS (pmem1): First 128 bytes of corrupted metadata buffer:
>  00000000: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000010: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000020: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000030: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000040: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000050: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000060: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  00000070: 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18  ................
>  XFS (pmem1): metadata I/O error in "xlog_recover_items_pass2+0x52/0xc0" at daddr 0x851c80 len 32 error 117
>  XFS (pmem1): log mount/recovery failed: error -117
>  XFS (pmem1): log mount failed
> 
> There have been isolated random other issues, too - xfs_repair fails
> because it finds some corruption in symlink blocks, rmap
> inconsistencies, etc - but they are nowhere near as common as the
> uninitialised inode chunk failure.
> 
> The problem has clearly happened at runtime before recovery has run;
> I can see the ICREATE log item in the log shortly before the
> actively recovered range of the log. This means the ICREATE was
> definitely created and written to the log, but for some reason the
> tail of the log has been moved past the ordered buffer log item that
> tracks INODE_ALLOC buffers and, supposedly, prevents the tail of the
> log moving past the ICREATE log item before the inode chunk buffer
> is written to disk.
> 
> Tracing the fsstress processes that are running when the filesystem
> shut down immediately pin-pointed the problem:
> 
> user shutdown marks xfs_mount as shutdown
> 
>          godown-213341 [008]  6398.022871: console:              [ 6397.915392] XFS (pmem1): User initiated shutdown received.
> .....
> 
> aild tries to push ordered inode cluster buffer
> 
>   xfsaild/pmem1-213314 [001]  6398.022974: xfs_buf_trylock:      dev 259:1 daddr 0x851c80 bbcount 0x20 hold 16 pincount 0 lock 0 flags DONE|INODES|PAGES caller xfs_inode_item_push+0x8e
>   xfsaild/pmem1-213314 [001]  6398.022976: xfs_ilock_nowait:     dev 259:1 ino 0x851c80 flags ILOCK_SHARED caller xfs_iflush_cluster+0xae
> 
> xfs_iflush_cluster() checks xfs_is_shutdown(), returns true,
> calls xfs_iflush_abort() to kill writeback of the inode.
> Inode is removed from AIL, drops cluster buffer reference.
> 
>   xfsaild/pmem1-213314 [001]  6398.022977: xfs_ail_delete:       dev 259:1 lip 0xffff88880247ed80 old lsn 7/20344 new lsn 7/21000 type XFS_LI_INODE flags IN_AIL
>   xfsaild/pmem1-213314 [001]  6398.022978: xfs_buf_rele:         dev 259:1 daddr 0x851c80 bbcount 0x20 hold 17 pincount 0 lock 0 flags DONE|INODES|PAGES caller xfs_iflush_abort+0xd7
> 
> .....
> 
> All inodes on cluster buffer are aborted, then the cluster buffer
> itself is aborted and removed from the AIL *without writeback*:
> 
> xfsaild/pmem1-213314 [001]  6398.023011: xfs_buf_error_relse:  dev 259:1 daddr 0x851c80 bbcount 0x20 hold 2 pincount 0 lock 0 flags ASYNC|DONE|STALE|INODES|PAGES caller xfs_buf_ioend_fail+0x33
>    xfsaild/pmem1-213314 [001]  6398.023012: xfs_ail_delete:       dev 259:1 lip 0xffff8888053efde8 old lsn 7/20344 new lsn 7/20344 type XFS_LI_BUF flags IN_AIL
> 
> The inode buffer was at 7/20344 when it was removed from the AIL.
> 
>    xfsaild/pmem1-213314 [001]  6398.023012: xfs_buf_item_relse:   dev 259:1 daddr 0x851c80 bbcount 0x20 hold 2 pincount 0 lock 0 flags ASYNC|DONE|STALE|INODES|PAGES caller xfs_buf_item_done+0x31
>    xfsaild/pmem1-213314 [001]  6398.023012: xfs_buf_rele:         dev 259:1 daddr 0x851c80 bbcount 0x20 hold 2 pincount 0 lock 0 flags ASYNC|DONE|STALE|INODES|PAGES caller xfs_buf_item_relse+0x39
> 
> .....
> 
> Userspace is still running, doing stuff. an fsstress process runs
> syncfs() or sync() and we end up in sync_fs_one_sb() which issues
> a log force. This pushes on the CIL:
> 
>         fsstress-213322 [001]  6398.024430: xfs_fs_sync_fs:       dev 259:1 m_features 0x20000000019ff6e9 opstate (clean|shutdown|inodegc|blockgc) s_flags 0x70810000 caller sync_fs_one_sb+0x26
>         fsstress-213322 [001]  6398.024430: xfs_log_force:        dev 259:1 lsn 0x0 caller xfs_fs_sync_fs+0x82
>         fsstress-213322 [001]  6398.024430: xfs_log_force:        dev 259:1 lsn 0x5f caller xfs_log_force+0x7c
>            <...>-194402 [001]  6398.024467: kmem_alloc:           size 176 flags 0x14 caller xlog_cil_push_work+0x9f
> 
> And the CIL fills up iclogs with pending changes. This picks up
> the current tail from the AIL:
> 
>            <...>-194402 [001]  6398.024497: xlog_iclog_get_space: dev 259:1 state XLOG_STATE_ACTIVE refcnt 1 offset 0 lsn 0x0 flags  caller xlog_write+0x149
>            <...>-194402 [001]  6398.024498: xlog_iclog_switch:    dev 259:1 state XLOG_STATE_ACTIVE refcnt 1 offset 0 lsn 0x700005408 flags  caller xlog_state_get_iclog_space+0x37e
>            <...>-194402 [001]  6398.024521: xlog_iclog_release:   dev 259:1 state XLOG_STATE_WANT_SYNC refcnt 1 offset 32256 lsn 0x700005408 flags  caller xlog_write+0x5f9
>            <...>-194402 [001]  6398.024522: xfs_log_assign_tail_lsn: dev 259:1 new tail lsn 7/21000, old lsn 7/20344, last sync 7/21448
> 
> And it moves the tail of the log to 7/21000 from 7/20344. This
> *moves the tail of the log beyond the ICREATE transaction* that was
> at 7/20344 and pinned by the inode cluster buffer that was cancelled
> above.
> 
> ....
> 
>          godown-213341 [008]  6398.027005: xfs_force_shutdown:   dev 259:1 tag logerror flags log_io|force_umount file fs/xfs/xfs_fsops.c line_num 500
>           godown-213341 [008]  6398.027022: console:              [ 6397.915406] pmem1: writeback error on inode 12621949, offset 1019904, sector 12968096
>           godown-213341 [008]  6398.030551: console:              [ 6397.919546] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xa3/0xf0 (fs/
> 
> And finally the log itself is now shutdown, stopping all further
> writes to the log. But this is too late to prevent the corruption
> that moving the tail of the log forwards after we start cancelling
> writeback causes.
> 
> The fundamental problem here is that we are using the wrong shutdown
> checks for log items. We've long conflated mount shutdown with log
> shutdown state, and I started separating that recently with the
> atomic shutdown state changes in commit b36d4651e165 ("xfs: make
> forced shutdown processing atomic"). The changes in that commit
> series are directly responsible for being able to diagnose this
> issue because it clearly separated mount shutdown from log shutdown.
> 
> Essentially, once we start cancelling writeback of log items and
> removing them from the AIL because the filesystem is shut down, we
> *cannot* update the journal because we may have cancelled the items
> that pin the tail of the log. That moves the tail of the log
> forwards without having written the metadata back, hence we have
> corrupt in memory state and writing to the journal propagates that
> to the on-disk state.
> 
> What commit b36d4651e165 makes clear is that log item state needs to
> change relative to log shutdown, not mount shutdown. IOWs, anything
> that aborts metadata writeback needs to check log shutdown state
> because log items directly affect log consistency. Having them check
> mount shutdown state introduces the above race condition where we
> cancel metadata writeback before the log shuts down.
> 
> To fix this, this patch works through all log items and converts
> shutdown checks to use xlog_is_shutdown() rather than
> xfs_is_shutdown(), so that we don't start aborting metadata
> writeback before we shut off journal writes.

Once the log has shut down, is there any reason we shouldn't consider
the filesystem shut down too?

IOWs, should xfs_is_shutdown be doing something like this:

bool
xfs_is_shutdown(struct xfs_mount *mp)
{
	return test_bit(XFS_OPSTATE_SHUTDOWN, &mp->m_opstate) ||
		xlog_is_shutdown(mp->m_log);
}

I could very easily envision myself reintroducing bugs w.r.t.
{xfs,xlog}_is_shutdown because it's not immediately obvious to me
(particularly in xfs_buf.c) which one I ought to use.

Another way to put this is: what needs to succeed between the point
where we set OPSTATE_SHUTDOWN and XLOG_IO_ERROR?  Is the answer to that
"any log IO that was initiated right up until we actually set
XLOG_IO_ERROR"?  Which means random parts of the buffer cache, and the
inode/dquot flush code?

IOWs the log flush and any AIL writeback that was in progress?

> AFAICT, this race condition is a zero day IO error handling bug in
> XFS that dates back to the introduction of XLOG_IO_ERROR,
> XLOG_STATE_IOERROR and XFS_FORCED_SHUTDOWN back in January 1997.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c        | 30 +++++++++++++++++++++++-------
>  fs/xfs/xfs_icache.c     |  3 ++-
>  fs/xfs/xfs_inode.c      | 15 +++++++++++++--
>  fs/xfs/xfs_inode_item.c | 12 ++++++++++++
>  fs/xfs/xfs_qm.c         |  8 ++++----
>  5 files changed, 54 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8867f143598e..b6073b5a990a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -14,6 +14,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
>  #include "xfs_log_recover.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_errortag.h"
> @@ -813,7 +814,7 @@ xfs_buf_read_map(
>  	 * buffer.
>  	 */
>  	if (error) {
> -		if (!xfs_is_shutdown(target->bt_mount))
> +		if (!xlog_is_shutdown(target->bt_mount->m_log))
>  			xfs_buf_ioerror_alert(bp, fa);
>  
>  		bp->b_flags &= ~XBF_DONE;
> @@ -1177,10 +1178,10 @@ xfs_buf_ioend_handle_error(
>  	struct xfs_error_cfg	*cfg;
>  
>  	/*
> -	 * If we've already decided to shutdown the filesystem because of I/O
> +	 * If we've already decided to shutdown the journal because of I/O
>  	 * errors, there's no point in giving this a retry.
>  	 */
> -	if (xfs_is_shutdown(mp))
> +	if (xlog_is_shutdown(mp->m_log))
>  		goto out_stale;
>  
>  	xfs_buf_ioerror_alert_ratelimited(bp);
> @@ -1593,8 +1594,23 @@ __xfs_buf_submit(
>  
>  	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
>  
> -	/* on shutdown we stale and complete the buffer immediately */
> -	if (xfs_is_shutdown(bp->b_mount)) {
> +	/*
> +	 * On log shutdown we stale and complete the buffer immediately. We can
> +	 * be called to read the superblock before the log has been set up, so
> +	 * be careful checking the log state.
> +	 *
> +	 * Checking the mount shutdown state here can result in the log tail
> +	 * moving inappropriately on disk as the log may not yet be shut down.
> +	 * Hence failing this buffer on mount shutdown can remove it from the
> +	 * AIL and move the tail of the log forwards without having written
> +	 * this buffer to disk. This corrupts the log tail state in memory, and
> +	 * because the log isn't yet shut down, it can then be propagated to
> +	 * disk before the log is shutdown. Hence we check log shutdown state
> +	 * here rather than mount state to avoid corrupting the log tail on
> +	 * shutdown.
> +	 */
> +	if (bp->b_mount->m_log &&
> +	    xlog_is_shutdown(bp->b_mount->m_log)) {
>  		xfs_buf_ioend_fail(bp);
>  		return -EIO;
>  	}
> @@ -1808,10 +1824,10 @@ xfs_buftarg_drain(
>  	 * If one or more failed buffers were freed, that means dirty metadata
>  	 * was thrown away. This should only ever happen after I/O completion
>  	 * handling has elevated I/O error(s) to permanent failures and shuts
> -	 * down the fs.
> +	 * down the journal.
>  	 */
>  	if (write_fail) {
> -		ASSERT(xfs_is_shutdown(btp->bt_mount));
> +		ASSERT(xlog_is_shutdown(btp->bt_mount->m_log));
>  		xfs_alert(btp->bt_mount,
>  	      "Please run xfs_repair to determine the extent of the problem.");
>  	}
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 9644f938990c..57ebf6ceef30 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -23,6 +23,7 @@
>  #include "xfs_reflink.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_ag.h"
> +#include "xfs_log_priv.h"
>  
>  #include <linux/iversion.h>
>  
> @@ -873,7 +874,7 @@ xfs_reclaim_inode(
>  	if (xfs_iflags_test_and_set(ip, XFS_IFLUSHING))
>  		goto out_iunlock;
>  
> -	if (xfs_is_shutdown(ip->i_mount)) {
> +	if (xlog_is_shutdown(ip->i_mount->m_log)) {
>  		xfs_iunpin_wait(ip);
>  		xfs_iflush_abort(ip);
>  		goto reclaim;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 04bf467b1090..aab55a06ece7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -35,6 +35,7 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
>  #include "xfs_ag.h"
> +#include "xfs_log_priv.h"
>  
>  struct kmem_cache *xfs_inode_cache;
>  
> @@ -3659,7 +3660,7 @@ xfs_iflush_cluster(
>  		 * AIL, leaving a dirty/unpinned inode attached to the buffer
>  		 * that otherwise looks like it should be flushed.
>  		 */
> -		if (xfs_is_shutdown(mp)) {
> +		if (xlog_is_shutdown(mp->m_log)) {
>  			xfs_iunpin_wait(ip);
>  			xfs_iflush_abort(ip);
>  			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> @@ -3685,9 +3686,19 @@ xfs_iflush_cluster(
>  	}
>  
>  	if (error) {
> +		/*
> +		 * Shutdown first so we kill the log before we release this
> +		 * buffer. If it is an INODE_ALLOC buffer and pins the tail

Does inode flush failure leading to immediate shutdown need to happen
with the dquot code too?  I /think/ we don't?  Because all we do is
remove the dirty flag on the dquot and kill the log?

Ok, lunch time, I'm going to push send so you can see the progress I've
made so far.

--D

> +		 * of the log, failing it before the _log_ is shut down can
> +		 * result in the log tail being moved forward in the journal
> +		 * on disk because log writes can still be taking place. Hence
> +		 * unpinning the tail will allow the ICREATE intent to be
> +		 * removed from the log an recovery will fail with uninitialised
> +		 * inode cluster buffers.
> +		 */
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  		bp->b_flags |= XBF_ASYNC;
>  		xfs_buf_ioend_fail(bp);
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  		return error;
>  	}
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 19dc3e37bb4d..308b30f35a71 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -17,6 +17,7 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_error.h"
>  
>  #include <linux/iversion.h>
> @@ -709,6 +710,17 @@ xfs_iflush_ail_updates(
>  		if (INODE_ITEM(lip)->ili_flush_lsn != lip->li_lsn)
>  			continue;
>  
> +		/*
> +		 * dgc: Not sure how this happens, but it happens very
> +		 * occassionaly via generic/388.  xfs_iflush_abort() also
> +		 * silently handles this same "under writeback but not in AIL at
> +		 * shutdown" condition via xfs_trans_ail_delete().
> +		 */
> +		if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> +			ASSERT(xlog_is_shutdown(lip->li_log));
> +			continue;
> +		}
> +
>  		lsn = xfs_ail_delete_one(ailp, lip);
>  		if (!tail_lsn && lsn)
>  			tail_lsn = lsn;
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 32ac8d9c8940..f165d1a3de1d 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -25,6 +25,7 @@
>  #include "xfs_error.h"
>  #include "xfs_ag.h"
>  #include "xfs_ialloc.h"
> +#include "xfs_log_priv.h"
>  
>  /*
>   * The global quota manager. There is only one of these for the entire
> @@ -121,8 +122,7 @@ xfs_qm_dqpurge(
>  	struct xfs_dquot	*dqp,
>  	void			*data)
>  {
> -	struct xfs_mount	*mp = dqp->q_mount;
> -	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> +	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
>  	int			error = -EAGAIN;
>  
>  	xfs_dqlock(dqp);
> @@ -157,7 +157,7 @@ xfs_qm_dqpurge(
>  	}
>  
>  	ASSERT(atomic_read(&dqp->q_pincount) == 0);
> -	ASSERT(xfs_is_shutdown(mp) ||
> +	ASSERT(xlog_is_shutdown(dqp->q_logitem.qli_item.li_log) ||
>  		!test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags));
>  
>  	xfs_dqfunlock(dqp);
> @@ -172,7 +172,7 @@ xfs_qm_dqpurge(
>  	 */
>  	ASSERT(!list_empty(&dqp->q_lru));
>  	list_lru_del(&qi->qi_lru, &dqp->q_lru);
> -	XFS_STATS_DEC(mp, xs_qm_dquot_unused);
> +	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot_unused);
>  
>  	xfs_qm_dqdestroy(dqp);
>  	return 0;
> -- 
> 2.35.1
> 
