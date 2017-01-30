Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751454AbdA3V7y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jan 2017 16:59:54 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DA0D66198D
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jan 2017 21:59:54 +0000 (UTC)
Date: Mon, 30 Jan 2017 16:59:52 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [BUG] xfs/305 hangs 4.10-rc4 kernel
Message-ID: <20170130215952.GA11230@bfoster.bfoster>
References: <20170125063943.GF1859@eguan.usersys.redhat.com>
 <20170125145215.GC28388@bfoster.bfoster>
 <20170126032950.GM1859@eguan.usersys.redhat.com>
 <20170126184427.GA39683@bfoster.bfoster>
 <20170127025219.GR1859@eguan.usersys.redhat.com>
 <20170130181224.GC8737@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170130181224.GC8737@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 30, 2017 at 01:12:24PM -0500, Brian Foster wrote:
> On Fri, Jan 27, 2017 at 10:52:19AM +0800, Eryu Guan wrote:
> > On Thu, Jan 26, 2017 at 01:44:28PM -0500, Brian Foster wrote:
> > > On Thu, Jan 26, 2017 at 11:29:50AM +0800, Eryu Guan wrote:
> > > > On Wed, Jan 25, 2017 at 09:52:16AM -0500, Brian Foster wrote:
> > > > > On Wed, Jan 25, 2017 at 02:39:43PM +0800, Eryu Guan wrote:
> > > > > > Hi all,
> > > > > > 
> > > > > > I hit another test hang triggered by running xfs/305 in a loop, it
> > > > > > usually reproduces within 50 iterations. It also involves disabling
> > > > > > quota, which looks similar to the generic/232 hang[1]. Perhaps they
> > > > > > share the same root cause?
> > > > > > 
> > > > > > [333853.198159] xfs_quota       D    0 13880  13441 0x00000080
> > > > > > [333853.227479] Call Trace:
> > > > > > [333853.239429]  __schedule+0x21c/0x6b0
> > > > > > [333853.255410]  schedule+0x36/0x80
> > > > > > [333853.269932]  schedule_timeout+0x1d1/0x3a0
> > > > > > [333853.288354]  ? lock_timer_base+0xa0/0xa0
> > > > > > [333853.306296]  ? xfs_qm_need_dqattach+0x80/0x80 [xfs]
> > > > > > [333853.329015]  schedule_timeout_uninterruptible+0x1f/0x30
> > > > > > [333853.353344]  xfs_qm_dquot_walk.isra.10+0x172/0x190 [xfs]
> > > > > > [333853.377747]  xfs_qm_dqpurge_all+0x5c/0x80 [xfs]
> > > > > > [333853.398433]  xfs_qm_scall_quotaoff+0x127/0x380 [xfs]
> > > > > > [333853.421062]  xfs_quota_disable+0x3d/0x50 [xfs]
> > > > > > [333853.441319]  SyS_quotactl+0x391/0x850
> > > > > > [333853.458143]  ? __audit_syscall_entry+0xaf/0x100
> > > > > > [333853.478903]  ? syscall_trace_enter+0x1d0/0x2b0
> > > > > > [333853.499262]  ? __audit_syscall_exit+0x209/0x290
> > > > > > [333853.519938]  do_syscall_64+0x67/0x180
> > > > > > [333853.536771]  entry_SYSCALL64_slow_path+0x25/0x25
> > > > > > [333853.558105] RIP: 0033:0x7f95be064fea
> > > > > > [333853.574521] RSP: 002b:00007ffc988b6348 EFLAGS: 00000206 ORIG_RAX: 00000000000000b3
> > > > > > [333853.608922] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f95be064fea
> > > > > > [333853.641478] RDX: 0000000000000000 RSI: 00000000027bb2f0 RDI: 0000000000580201
> > > > > > [333853.674091] RBP: 00000000027bb320 R08: 00007ffc988b635c R09: 0000000000000001
> > > > > > [333853.706913] R10: 00007ffc988b635c R11: 0000000000000206 R12: 00000000027bb2d0
> > > > > > [333853.744953] R13: 00000000027ba0a0 R14: 0000000000000000 R15: 00000000027ba080
> > > > > > 
> > > > > > I've seen this hang on multiple test hosts with different test configs,
> > > > > > e.g. xfs_2k_crc xfs_4k_reflink. I also tried with 4.9 kernel, but I kept
> > > > > > hitting the BUG_ON that this kernel commit[2] fixed in 4.10-rc kernel.
> > > > > > 
> > > > > 
> > > > > Interesting... I'm not sure this is necessarily locked up given the call
> > > > > to schedule_timeout(). That suggests we could be in the
> > > > > xfs_qm_dquot_walk()->delay() call and possibly spinning on skipped
> > > > > entries. It looks like the only way we skip an entry is if it is already
> > > > > being freed or has a reference count. The only other dquot free path
> > > > > looks like the shrinker, but that doesn't appear in the blocked task
> > > > > list at all. We do have a dqread call, but that path hasn't even added
> > > > > the dquot to the radix tree yet.
> > > > > 
> > > > > > I attached full sysrq-w output. If you need more info please let me
> > > > > > know.
> > > > > >
> > > > > 
> > > > > It looks like pretty much everything is hung up on log reservation,
> > > > > including writeback, which is more indicative of a potential log
> > > > > reservation problem. xfsaild appears to be alive, however (a
> > > > > schedule_timeout() in that path suggests the thread is working to push
> > > > > log items and free up log space), so maybe something else is going on.
> > > > > It might be interesting to see if we can tell if we're spinning
> > > > > somewhere by enabling tracepoints once in this state. Also, have you
> > > > > checked for any unexpected syslog messages when this occurs?
> > > > 
> > > > There's nothing interesting in dmesg with stock 4.10-rc4 kernel, but if
> > > > I test with Darrick's xfs-linux tree for-next branch (which has a few
> > > > patches on top of 4.10-rc4), I can see this message:
> > > > 
> > > > XFS (dm-5): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
> > > > 
> > > > But I can see this message in every xfs/305 iteration, and other tests
> > > > too. I attached dmesg log prior to sysrq-w output, gathered from
> > > > "for-next" kernel.
> > > > 
> > > > I also attached trace log while we're in this state (also from
> > > > "for-next" kernel):
> > > > 
> > > > cd /mnt/ext4
> > > > trace-cmd record -e xfs_*
> > > > sleep 10
> > > > trace-cmd report > log
> > > > 
> > > 
> > > Thanks Eryu. The only thing in the AIL is the XFS_LI_QUOTAOFF log item.
> > > This item is hardcoded to the locked state because it does not really
> > > exist on disk (i.e., it cannot be pushed). Rather, it looks like it is
> > > released upon commit of an accompanying quotaoff_end log item that is
> > > committed after most of the quotaoff work is completed, including the
> > > purge that you're actually stuck on. The purpose of this appears to be
> > > to allow log recovery to deal with the possibility of dquots being
> > > logged after the initial quotaoff transaction. This mechanism
> > > effectively pins the tail of the log with the quotaoff start log item to
> > > ensure log recovery sees it before any subsequent dquot modifications if
> > > we happen to crash at some point in the middle of those operations.
> > > 
> > > What this means is that there is only a fixed amount of physical log
> > > space between the time the quotaoff start is logged and until the
> > > quotaoff completes. If we consume the log space before the quotaoff
> > > completes, we basically deadlock the fs. Indeed, while I haven't been
> > > able to reproduce via xfs/305 alone, I can manufacture this problem by
> > > inserting a long enough sleep after the qutoaoff start item is logged.
> > > The parallel fsstress' then chew up the log and the fs ends up stuck.
> > > 
> > > So I think this is the state you get into, but the root cause is still
> > > not totally clear. It could just be the workload, but it seems a little
> > > crazy to wrap the log before the purge completes since it doesn't log
> > > anything itself. Then again, it looks like the xfs/305 workload can chew
> > > up the log in 30-45s on my 10g scratch dev, so probably not out of the
> > > realm of possibility.
> > > 
> > > I am wondering about the possibility of something else getting stuck
> > > that stalls the dqpurge and then causes the fs-wide deadlock via domino
> > > effect. Could you provide the xfs_info of your scratch device? Also, if
> > 
> > # xfs_info /mnt/testarea/scratch/
> > meta-data=/dev/mapper/systemvg-testlv2 isize=512    agcount=16, agsize=245696 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1 spinodes=0 rmapbt=1
> >          =                       reflink=1
> > data     =                       bsize=4096   blocks=3931136, imaxpct=25
> >          =                       sunit=64     swidth=192 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal               bsize=4096   blocks=7680, version=2
> >          =                       sectsz=512   sunit=64 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > > you could make a system available that is able to reproduce this
> > > reliably enough, that might make it easier to analyze what's going on...
> > 
> > I do have a system that could reproduce the hang reliably, but not so
> > efficiently, it usually reproduces around 30 minutes by running xfs/305
> > in a loop. It's a RH internal test host, I can provide you the address
> > and password if you think it's useful.
> > 
> 
> Thanks for the system info. I could reproduce fairly quickly. I adopted
> some of the characteristics of your scratch dev on my local machine and
> was able to reproduce there as well. What is of note is that in both
> cases I reproduce with xfs_quota stuck at a different point from your
> original report. Instead of being stuck in xfs_qm_dquot_walk(), I
> reproduce the following stack:
> 
> [190961.556198] xfs_quota       D    0  9394   8970 0x00000080
> [190961.581188] Call Trace:
> [190961.592501]  __schedule+0x21c/0x6b0
> [190961.608704]  ? radix_tree_gang_lookup+0xc8/0x110
> [190961.629892]  schedule+0x36/0x80
> [190961.644336]  xlog_grant_head_wait+0xd2/0x210 [xfs]
> [190961.666212]  xlog_grant_head_check+0xaf/0x160 [xfs]
> [190961.688687]  xfs_log_reserve+0xed/0x270 [xfs]
> [190961.708753]  ? kmem_cache_alloc+0x194/0x1a0
> [190961.727905]  xfs_trans_reserve+0x1d6/0x2c0 [xfs]
> [190961.748958]  xfs_trans_alloc+0xc1/0x140 [xfs]
> [190961.768899]  xfs_qm_log_quotaoff_end+0x3c/0x90 [xfs]
> [190961.793068]  xfs_qm_scall_quotaoff+0x128/0x3b0 [xfs]
> [190961.819012]  xfs_quota_disable+0x3d/0x50 [xfs]
> [190961.839279]  SyS_quotactl+0x391/0x850
> [190961.856210]  ? __audit_syscall_entry+0xaf/0x100
> [190961.876958]  ? syscall_trace_enter+0x1d0/0x2b0
> [190961.897212]  ? __audit_syscall_exit+0x209/0x290
> [190961.917889]  do_syscall_64+0x67/0x180
> [190961.934687]  entry_SYSCALL64_slow_path+0x25/0x25
> 
> ... which suggests that we probably need to allocate the quotaoff_end
> transaction right when we allocate the quotaoff start transaction and
> stash it for use once we've released/purged all of the dquots.
> 
> There may be multiple issues here so I'll give something like that a
> shot and see if I can still reproduce a hang.
> 

I reproduced an xfs_wait_buftarg() unmount hang once that looks like a
separate issue (occurs after the test, long after quotaoff has
completed). I haven't reproduced that one again nor the original hang in
100+ iterations so far. Care to give the following a whirl in your
environment? Thanks.

Brian

--8<--

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 475a388..9eccfc1 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -35,9 +35,11 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 
-STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
-STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
-					uint);
+STATIC int	xfs_qm_log_quotaoff(struct xfs_mount *, struct xfs_trans **,
+				    uint);
+STATIC int	xfs_qm_log_quotaoff_end(struct xfs_mount *,
+					struct xfs_qoff_logitem *,
+					struct xfs_trans **, uint);
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -56,7 +58,7 @@ xfs_qm_scall_quotaoff(
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
-	xfs_qoff_logitem_t	*qoffstart;
+	struct xfs_trans	*qend_tp;
 
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -128,7 +130,7 @@ xfs_qm_scall_quotaoff(
 	 * and synchronously. If we fail to write, we should abort the
 	 * operation as it cannot be recovered safely if we crash.
 	 */
-	error = xfs_qm_log_quotaoff(mp, &qoffstart, flags);
+	error = xfs_qm_log_quotaoff(mp, &qend_tp, flags);
 	if (error)
 		goto out_unlock;
 
@@ -181,7 +183,7 @@ xfs_qm_scall_quotaoff(
 	 * So, we have QUOTAOFF start and end logitems; the start
 	 * logitem won't get overwritten until the end logitem appears...
 	 */
-	error = xfs_qm_log_quotaoff_end(mp, qoffstart, flags);
+	error = xfs_trans_commit(qend_tp);
 	if (error) {
 		/* We're screwed now. Shutdown is the only option. */
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
@@ -556,13 +558,14 @@ xfs_qm_scall_setqlim(
 
 STATIC int
 xfs_qm_log_quotaoff_end(
-	xfs_mount_t		*mp,
-	xfs_qoff_logitem_t	*startqoff,
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	*startqoff,
+	struct xfs_trans	**tpp,
 	uint			flags)
 {
-	xfs_trans_t		*tp;
+	struct xfs_trans	*tp;
 	int			error;
-	xfs_qoff_logitem_t	*qoffi;
+	struct xfs_qoff_logitem	*qoffi;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
 	if (error)
@@ -578,21 +581,22 @@ xfs_qm_log_quotaoff_end(
 	 * We don't care about quotoff's performance.
 	 */
 	xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp);
+	*tpp = tp;
+	return 0;
 }
 
 
 STATIC int
 xfs_qm_log_quotaoff(
-	xfs_mount_t	       *mp,
-	xfs_qoff_logitem_t     **qoffstartp,
-	uint		       flags)
+	struct xfs_mount	*mp,
+	struct xfs_trans	**end_tp,
+	uint			flags)
 {
-	xfs_trans_t	       *tp;
+	struct xfs_trans	*tp;
 	int			error;
-	xfs_qoff_logitem_t     *qoffi;
+	struct xfs_qoff_logitem	*qoffi;
 
-	*qoffstartp = NULL;
+	*end_tp = NULL;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
 	if (error)
@@ -617,7 +621,8 @@ xfs_qm_log_quotaoff(
 	if (error)
 		goto out;
 
-	*qoffstartp = qoffi;
+	error = xfs_qm_log_quotaoff_end(mp, qoffi, end_tp, flags);
+	/* TODO: shutdown on error */
 out:
 	return error;
 }
