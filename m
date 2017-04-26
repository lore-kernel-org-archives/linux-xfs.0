Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16443 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030444AbdDZVXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 17:23:42 -0400
Date: Wed, 26 Apr 2017 14:23:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] xfs: allocate quotaoff transactions up front to
 avoid log deadlock
Message-ID: <20170426212333.GB23371@birch.djwong.org>
References: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
 <1487173247-5965-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487173247-5965-3-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, Dave Chinner <david@fromorbit.com>

On Wed, Feb 15, 2017 at 10:40:44AM -0500, Brian Foster wrote:
> The quotaoff operation commits two explicitly synchronous
> transactions to correctly handle log recovery of dquots being
> modified at the time the quotaoff occurs. The first quotaoff
> transaction pins the tail of the log with a qoff logitem in the AIL
> to ensure further logged dquots stay ahead of the quotaoff operation
> in the log. The second quotaoff_end transaction is committed after
> the quotaoff operation completes, releases the original log item and
> thus unpins the log.
> 
> Since the first transaction pins the tail of the log, this means a
> finite amount of space in the log is available between the time a
> quotaoff starts and completes before transaction reservations have
> to block on the log. While the quotaoff operation itself consumes no
> further log space, it is possible for other operations in the
> filesystem to consume the remaining log space before the quotaoff
> completes. If this occurs, the quotaoff_end transaction also blocks
> on the log which prevents the release of the log item and the
> filesystem deadlocks. This has been reproduced via repeated xfs/305
> iterations on a vm with fairly limited resources.
> 
> To avoid a deadlock due to a particularly slow quotaoff operation,
> allocate the quotaoff_end transaction immediately after the initial
> quotaoff transaction is committed. Carry a reference to the
> transaction through xfs_qm_scall_quotaoff() rather than the qoff log
> item and commit it once the quotaoff completes.

Hmm... so instead of holding a pinned log item for however long it takes
to finish quotaoff, we instead hold a transaction.  That does fix the
problem where we pin the log tail and the head crashes into it, but also
comes with its own problems, doesn't it?

In xfs_qm_scall_quotaoff, we call xfs_qm_dqrele_all_inodes, which
calls xfs_dqrele_inode to call xfs_qm_dqrele on all the inodes in the
system.  However, if any of those inodes are unlinked and inactive, the
iput -> xfs_fs_destroy_inode -> xfs_inactive path truncates the inode,
which itself requires a transaction, so now we're running with nested
transactions.

I'm not sure that's necessarily a problem because the outer transaction
contains only a single qoffend item.  AFAICT I haven't encountered any
other places in XFS where a single thread runs nested transactions, but
it still seems suspect to me.

Heh, lockdep just spat this at me:

[19767.048839] =============================================
[19767.049699] [ INFO: possible recursive locking detected ]
[19767.050511] 4.11.0-rc4-djw #3 Not tainted
[19767.051122] ---------------------------------------------
[19767.051907] xfs_quota/4152 is trying to acquire lock:
[19767.052617]  (sb_internal){.+.+.+}, at: [<ffffffffa015ee13>] xfs_trans_alloc+0xe3/0x130 [xfs]
[19767.054151] 
[19767.054151] but task is already holding lock:
[19767.055246]  (sb_internal){.+.+.+}, at: [<ffffffffa015ee13>] xfs_trans_alloc+0xe3/0x130 [xfs]
[19767.056897] 
[19767.056897] other info that might help us debug this:
[19767.057980]  Possible unsafe locking scenario:
[19767.057980] 
[19767.058967]        CPU0
[19767.059385]        ----
[19767.060339]   lock(sb_internal);
[19767.061187]   lock(sb_internal);
[19767.061771] 
[19767.061771]  *** DEADLOCK ***
[19767.061771] 
[19767.062818]  May be due to missing lock nesting notation
[19767.062818] 
[19767.063967] 3 locks held by xfs_quota/4152:
[19767.064521]  #0:  (&type->s_umount_key#34){++++++}, at: [<ffffffff812287f0>] __get_super.part.18+0xc0/0xe0
[19767.065805]  #1:  (&qinf->qi_quotaofflock){+.+.+.}, at: [<ffffffffa0182a53>] xfs_qm_scall_quotaoff+0x53/0x6c0 [xfs]
[19767.067226]  #2:  (sb_internal){.+.+.+}, at: [<ffffffffa015ee13>] xfs_trans_alloc+0xe3/0x130 [xfs]
[19767.068543] 
[19767.068543] stack backtrace:
[19767.069191] CPU: 2 PID: 4152 Comm: xfs_quota Not tainted 4.11.0-rc4-djw #3
[19767.070124] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[19767.071405] Call Trace:
[19767.071798]  dump_stack+0x85/0xc2
[19767.072298]  __lock_acquire+0x164e/0x16a0
[19767.072866]  ? kvm_sched_clock_read+0x9/0x20
[19767.073460]  ? sched_clock+0x9/0x10
[19767.073979]  lock_acquire+0xbf/0x210
[19767.074532]  ? xfs_trans_alloc+0xe3/0x130 [xfs]
[19767.075166]  __sb_start_write+0xc0/0x220
[19767.075782]  ? xfs_trans_alloc+0xe3/0x130 [xfs]
[19767.076475]  xfs_trans_alloc+0xe3/0x130 [xfs]
[19767.077138]  xfs_inactive_truncate+0x31/0x130 [xfs]
[19767.077862]  ? xfs_qm_dqattach+0x16/0x50 [xfs]
[19767.078524]  xfs_inactive+0x17d/0x270 [xfs]
[19767.079141]  xfs_fs_destroy_inode+0xb3/0x350 [xfs]
[19767.079964]  destroy_inode+0x3b/0x60
[19767.080679]  evict+0x132/0x190
[19767.081301]  iput+0x243/0x320
[19767.081961]  xfs_inode_ag_walk+0x2a8/0x690 [xfs]
[19767.082757]  ? xfs_inode_ag_walk+0x92/0x690 [xfs]
[19767.083545]  ? xfs_trans_free_dqinfo+0x30/0x30 [xfs]
[19767.084279]  ? xfs_perag_get+0xa8/0x2b0 [xfs]
[19767.084753]  ? xfs_perag_get+0xa8/0x2b0 [xfs]
[19767.085234]  xfs_inode_ag_iterator_flags+0x69/0xa0 [xfs]
[19767.086251]  ? xfs_trans_free_dqinfo+0x30/0x30 [xfs]
[19767.087219]  xfs_qm_dqrele_all_inodes+0x36/0x60 [xfs]
[19767.088431]  xfs_qm_scall_quotaoff+0x100/0x6c0 [xfs]
[19767.089285]  xfs_quota_disable+0x3d/0x50 [xfs]
[19767.090138]  SyS_quotactl+0x3ff/0x820
[19767.090853]  ? SYSC_newstat+0x3b/0x50
[19767.091501]  ? trace_hardirqs_on_caller+0x129/0x1b0
[19767.092398]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[19767.093238]  entry_SYSCALL_64_fastpath+0x1f/0xc2
[19767.094150] RIP: 0033:0x7f43530a70ca
[19767.094851] RSP: 002b:00007ffe7570fbe8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b3
[19767.096078] RAX: ffffffffffffffda RBX: 00007ffe7570fde8 RCX: 00007f43530a70ca
[19767.097242] RDX: 0000000000000000 RSI: 00000000012d26f0 RDI: 0000000000580202
[19767.098402] RBP: 0000000000000005 R08: 00007ffe7570fbfc R09: 0000000000005802
[19767.099645] R10: 00007ffe7570fbfc R11: 0000000000000206 R12: 0000000000401e50
[19767.100841] R13: 00007ffe7570fde0 R14: 0000000000000000 R15: 0000000000000000

--D

> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c | 42 ++++++++++++++++++++++++------------------
>  1 file changed, 24 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 475a388..dbb6802 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -35,9 +35,11 @@
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  
> -STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
> -STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
> -					uint);
> +STATIC int	xfs_qm_log_quotaoff(struct xfs_mount *, struct xfs_trans **,
> +				    uint);
> +STATIC int	xfs_qm_log_quotaoff_end(struct xfs_mount *,
> +					struct xfs_qoff_logitem *,
> +					struct xfs_trans **, uint);
>  
>  /*
>   * Turn off quota accounting and/or enforcement for all udquots and/or
> @@ -56,7 +58,7 @@ xfs_qm_scall_quotaoff(
>  	uint			dqtype;
>  	int			error;
>  	uint			inactivate_flags;
> -	xfs_qoff_logitem_t	*qoffstart;
> +	struct xfs_trans	*qend_tp;
>  
>  	/*
>  	 * No file system can have quotas enabled on disk but not in core.
> @@ -128,7 +130,7 @@ xfs_qm_scall_quotaoff(
>  	 * and synchronously. If we fail to write, we should abort the
>  	 * operation as it cannot be recovered safely if we crash.
>  	 */
> -	error = xfs_qm_log_quotaoff(mp, &qoffstart, flags);
> +	error = xfs_qm_log_quotaoff(mp, &qend_tp, flags);
>  	if (error)
>  		goto out_unlock;
>  
> @@ -181,7 +183,7 @@ xfs_qm_scall_quotaoff(
>  	 * So, we have QUOTAOFF start and end logitems; the start
>  	 * logitem won't get overwritten until the end logitem appears...
>  	 */
> -	error = xfs_qm_log_quotaoff_end(mp, qoffstart, flags);
> +	error = xfs_trans_commit(qend_tp);
>  	if (error) {
>  		/* We're screwed now. Shutdown is the only option. */
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> @@ -556,13 +558,14 @@ xfs_qm_scall_setqlim(
>  
>  STATIC int
>  xfs_qm_log_quotaoff_end(
> -	xfs_mount_t		*mp,
> -	xfs_qoff_logitem_t	*startqoff,
> +	struct xfs_mount	*mp,
> +	struct xfs_qoff_logitem	*startqoff,
> +	struct xfs_trans	**tpp,
>  	uint			flags)
>  {
> -	xfs_trans_t		*tp;
> +	struct xfs_trans	*tp;
>  	int			error;
> -	xfs_qoff_logitem_t	*qoffi;
> +	struct xfs_qoff_logitem	*qoffi;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
>  	if (error)
> @@ -578,21 +581,22 @@ xfs_qm_log_quotaoff_end(
>  	 * We don't care about quotoff's performance.
>  	 */
>  	xfs_trans_set_sync(tp);
> -	return xfs_trans_commit(tp);
> +	*tpp = tp;
> +	return 0;
>  }
>  
>  
>  STATIC int
>  xfs_qm_log_quotaoff(
> -	xfs_mount_t	       *mp,
> -	xfs_qoff_logitem_t     **qoffstartp,
> -	uint		       flags)
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	**end_tp,
> +	uint			flags)
>  {
> -	xfs_trans_t	       *tp;
> +	struct xfs_trans	*tp;
>  	int			error;
> -	xfs_qoff_logitem_t     *qoffi;
> +	struct xfs_qoff_logitem	*qoffi;
>  
> -	*qoffstartp = NULL;
> +	*end_tp = NULL;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
>  	if (error)
> @@ -617,7 +621,9 @@ xfs_qm_log_quotaoff(
>  	if (error)
>  		goto out;
>  
> -	*qoffstartp = qoffi;
> +	error = xfs_qm_log_quotaoff_end(mp, qoffi, end_tp, flags);
> +	if (error)
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  out:
>  	return error;
>  }
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
