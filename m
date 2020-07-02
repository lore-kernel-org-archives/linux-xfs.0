Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A3BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 11:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DD3A207CD
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 11:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgGBLwC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 07:52:02 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:40577 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726475AbgGBLwB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 07:52:01 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 4E096D59421;
        Thu,  2 Jul 2020 21:51:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqxkm-0005N2-Gb; Thu, 02 Jul 2020 21:51:44 +1000
Date:   Thu, 2 Jul 2020 21:51:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/10] xfs: automatic relogging
Message-ID: <20200702115144.GH2005@dread.disaster.area>
References: <20200701165116.47344-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701165116.47344-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=WjuL8whnHV-ND36bcxAA:9 a=P6Vn_4uck0kdZqOM:21 a=X2Zx2kfS6nRPC8vd:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 12:51:06PM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's a v1 (non-RFC) version of the automatic relogging functionality.
> Note that the buffer relogging bits (patches 8-10) are still RFC as I've
> had to hack around some things to utilize it for testing. I include them
> here mostly for reference/discussion. Most of the effort from the last
> rfc post has gone into testing and solidifying the functionality. This
> now survives a traditional fstests regression run as well as a test run
> with random buffer relogging enabled on every test/scratch device mount
> that occurs throughout the fstests cycle. The quotaoff use case is
> additionally tested independently by artificially delaying completion of
> the quotaoff in parallel with many fsstress worker threads.
> 
> The hacks/workarounds to support the random buffer relogging enabled
> fstests run are not included here because they are not associated with
> core functionality, but rather are side effects of randomly relogging
> arbitrary buffers, etc. I can work them into the buffer relogging
> patches if desired, but I'd like to get the core functionality and use
> case worked out before getting too far into the testing code. I also
> know Darrick was interested in the ->iop_relog() callback for some form
> of generic feedback into active dfops processing, so it might be worth
> exploring that further.
> 
> Thoughts, reviews, flames appreciated.

Ok I've looked through the code again, and again I've had to pause,
stop and think hard about it because the feeling I've had right from
the start about the automatic relogging concept is stronger than
ever.

I think the most constructive way to say what I'm feeling is that I
think this is the wrong approach to solve the quota off problem.
However, I've never been able to come up with an alternative that
also solved the quotaoff problem so I've tried to help make this
relogging concept work.

It's a very interesting experiment, but I've always had a nagging
doubt about putting transaction reservations both above and below
the AIL. In reading this version, I'm having trouble following and
understanding the transaction reservation juggling and
recalculation complexity that's been introduced to facilitate
the stealing that is being done. Yes, I know that I suggested the
dynamic stealing approach - it's certainly better than past
versions, but it hasn't really addressed my underlying doubt about
the relogging concept in general...

I have been spending some time recently in the quota code, so I have
a better grip on what it is doing now than I did last time I looked
at this relogging code. I never really questioned why the quota code
needed two transactions for quota-off, and I'm guessing that nobody
else has either. So I spent some time this morning understanding
what problem it was actually solving and trying to find an alternate
solution to that problem.

The reason we have the two quota-off transactions is that active
dquot modifications at the time quotaoff is started leak past the
first quota off transaction that hits the journal. Hence to avoid
incorrect replay of those modifications in the journal if we crash
after the quota-off item passes out of the journal, we pin the
quota-off item in the journal. It gets unpinned by the commit of the
second quota-off transaction at completion time, hence defining the
window in journal where quota-off is being processed and dquot
modifications should be ignored. i.e. there is no window where
recovery will replay dquot modifications incorrectly.

However, if the second transaction is left too long, the reservation
will fail to find journal space because of the pinned quota-off item.

The relogging infrastructure is designed to allow the inital
quota-off intent to keep moving forward in the log so it never pins
the tail of the log before the second quota-off transaction is run.
This tries to avoid the recovery issue because there's always an
active quota off item in the log, but I think there may be a flaw
here.  When the quotaoff item gets relogged, it jumps all the dquots
in the log that were modified after the quota-off started. Hence if
we crash after the relogging but while the dquots are still in the
log before the relogged quotaoff item, then they will be replayed,
possibly incorrectly. i.e. the relogged quota-off item no longer
prevents replay of those items.

So while relogging prevents the tail pinning deadlock, I think it
may actually result in incorrect recovery behaviour in that items
that should be cancelled and not replayed can end up getting
replayed.  I'm not sure that this matters for dquots, but for a
general mechanism I think the transactional ordering violations it
can result in reduce it's usefulness significantly.

But back to quota-off: What I've realised is that the only dquot
modifications we need to protect against being recovered are the
ones that are running at the time the first quota-off is committed
to the journal. That is, once the DQACTIVE flags are clear,
transactions will not modify those dquots anymore. Hence by the time
that the quota off item pins the tail of the log, the transactions
that were actively dirtying inodes when it was committed have also
committed and are in the journal and there are no actively modified
dquots left in memory.

IOWs, we don't actually need to wait until we've released and purged
all the dquots from memory before we log the second quota off item;
all we need to wait for is for all the transactions with dirty
dquots to have committed. These transactions already have log
reservations, so completing them will free unused reservation space
for the second quota off transaction. Once they are committed, then
we can log the second item. i.e. we don't have to wait until we've
cleaned up the dquots to close out the quota-off transaction in the
journal.

To make it even more robust, if we stop all the transactions that
may dirty dquots and drain the active ones before we log the first
quota-off item, we can log the second item immediately afterwards
because it is known that there are no dquot modifications in flight
when the first item is logged. We can probably even log both items
in the same transaction.

Recovery will behave correctly on all kernels, old and new, because
we've prevented dquots from landing in the journal after the first
quota-off item. Hence it looks to recovery simply like the fs was
idle when the quota-off was run...

So, putting my money where my mouth is, the patch below does this.
It's survived 100 cycles of xfs/305 (qoff vs fsstress) and 10 cycles
of -g quota with all quotas enabled and is currently running a full
auto cycle with all quotas enabled. It hasn't let the smoke out
after about 4 hours of testing now....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com


[RFC] xfs: rework quota off process to avoid deadlocks

From: Dave Chinner <dchinner@redhat.com>

The quotaoff operation has a rare but longstanding deadlock vector
in terms of how the operation is logged. A quotaoff start intent is
logged (synchronously) at the onset to ensure recovery can handle
the operation if interrupted before in-core changes are made. This
quotaoff intent pins the log tail while the quotaoff sequence scans
and purges dquots from all in-core inodes. While this operation
generally doesn't generate much log traffic on its own, it can be
time consuming. If unrelated, concurrent filesystem activity
consumes remaining log space before quotaoff is able to acquire log
reservation for the quotaoff end intent, the filesystem locks up
indefinitely.

The problem that the quota-off intent/done logging setup is designed
to deal with is that when the quota-off intent is first logged,
there can be active transactions with modified dquots in them. These
cannot be aborted, and the result is that modified dquots end up in
the journal after the quota-off item has been recorded. Hence the
proposal to automatically relog the quota off intent so it doesn't
fall out of the log before the done intent can be written.

We can fix this another way: all we need to do is prevent dquots
from being logged to the journal after we log the quota off intent.
If we do this, then we can just log the quota off intent and the
intent done items in the same transaction and then tear down the
in memory dquots.

The current code prevents new dquots from being logged once the
quota-off has been logged simply by clearing the DQ_ACTIVE flags for
the quota being logged. Removing this flag means all future
transactions will see that the specific quota type is no longer
active and skip over it completely. This, however, requires
co-ordination with inode locks for it to behave correctly, and
hence this mechanism cannot be used to block transactions while we
wait for other transactions to drain out.

Hence add a new "quota off running" flag to the mount quota flags.
This bit can be set atomically, and we can use bit ops to wait on it
being cleared. ANd when we clear the bit we can issue a wakeups on
it. Hence adding a new bit gives us the mechanism to block
operations while quota-off is running.

To acheive this draining, we need to keep a count of the number of
active transactions that are modifying dquots. To do that, let's tag
transaction reservation structures for transactions that may modify
dquots with a new flag. We can look at that flag in
xfs_trans_alloc() - where it is safe to block - and do
all our quota-off run checks, blocking and accounting here.
We can use a single per-cpu counter to track dquot modifying
transactions in flight, so after setting the "quota off running"
flag all we need to do is wait for the counter to run to zero.

At this point, we can log the quota off items, then clear the
mount quota flags, and then detatch and reap all the dquots that
remain in memory that will no longer be used. This can be done after
the quota-off end item is logged because nothing is going to be
modifying the dquots we need to reap at this point.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |   3 ++
 fs/xfs/libxfs/xfs_shared.h     |   2 +
 fs/xfs/libxfs/xfs_trans_resv.c |  28 +++++------
 fs/xfs/xfs_mount.h             |   2 +-
 fs/xfs/xfs_qm.c                |  24 ++++-----
 fs/xfs/xfs_qm.h                |   4 ++
 fs/xfs/xfs_qm_syscalls.c       |  95 ++++++++++++++++++------------------
 fs/xfs/xfs_trans.c             |  18 ++++++-
 fs/xfs/xfs_trans_dquot.c       | 108 ++++++++++++++++++++++++++++++-----------
 9 files changed, 180 insertions(+), 104 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 56d9dd787e7b..84e5d568cf1f 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -79,6 +79,9 @@ typedef uint16_t	xfs_qwarncnt_t;
 #define XFS_ALL_QUOTA_ACTIVE	\
 	(XFS_UQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE)
 
+#define XFS_QUOTA_OFF_RUNNING_BIT 15  /* Quotas are being turned off */
+#define XFS_QUOTA_OFF_RUNNING	(1 << XFS_QUOTA_OFF_RUNNING_BIT)
+
 /*
  * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
  * quota will be not be switched off as long as that inode lock is held.
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c45acbd3add9..d4a6156dba31 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -65,6 +65,8 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
+#define XFS_TRANS_QUOTA		0x80	/* xact manipulates dquot info */
+
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d1a0848cb52e..2310d1634898 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -846,7 +846,7 @@ xfs_trans_resv_calc(
 		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
 	else
 		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
-	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
@@ -854,56 +854,56 @@ xfs_trans_resv_calc(
 				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
 	else
 		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
-	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
 	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
-	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
 	resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
-	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
 	resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
-	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
 	resp->tr_symlink.tr_logcount = XFS_SYMLINK_LOG_COUNT;
-	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp);
 	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
-	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_create_tmpfile.tr_logres =
 			xfs_calc_create_tmpfile_reservation(mp);
 	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
-	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
 	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
-	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
 	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
-	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_addafork.tr_logres = xfs_calc_addafork_reservation(mp);
 	resp->tr_addafork.tr_logcount = XFS_ADDAFORK_LOG_COUNT;
-	resp->tr_addafork.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_addafork.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_attrinval.tr_logres = xfs_calc_attrinval_reservation(mp);
 	resp->tr_attrinval.tr_logcount = XFS_ATTRINVAL_LOG_COUNT;
-	resp->tr_attrinval.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_attrinval.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_attrsetm.tr_logres = xfs_calc_attrsetm_reservation(mp);
 	resp->tr_attrsetm.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-	resp->tr_attrsetm.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_attrsetm.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_attrrm.tr_logres = xfs_calc_attrrm_reservation(mp);
 	resp->tr_attrrm.tr_logcount = XFS_ATTRRM_LOG_COUNT;
-	resp->tr_attrrm.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_attrrm.tr_logflags |= XFS_TRANS_PERM_LOG_RES | XFS_TRANS_QUOTA;
 
 	resp->tr_growrtalloc.tr_logres = xfs_calc_growrtalloc_reservation(mp);
 	resp->tr_growrtalloc.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6d3e78c35883..5eabc555a532 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -129,7 +129,7 @@ typedef struct xfs_mount {
 	uint			m_rsumlevels;	/* rt summary levels */
 	uint			m_rsumsize;	/* size of rt summary, bytes */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
-	uint			m_qflags;	/* quota status flags */
+	unsigned long		m_qflags;	/* quota status flags */
 	uint64_t		m_flags;	/* global mount flags */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 938023dd8ce5..3f59291d7fbc 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -299,9 +299,7 @@ xfs_qm_need_dqattach(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return false;
-	if (!XFS_IS_QUOTA_ON(mp))
+	if (!xfs_trans_quota_running(ip->i_mount))
 		return false;
 	if (!XFS_NOT_DQATTACHED(mp, ip))
 		return false;
@@ -648,13 +646,16 @@ xfs_qm_init_quotainfo(
 	if (error)
 		goto out_free_qinf;
 
+	error = percpu_counter_init(&qinf->qi_active_trans, 0, GFP_NOFS);
+	if (error)
+		goto out_free_lru;
 	/*
 	 * See if quotainodes are setup, and if not, allocate them,
 	 * and change the superblock accordingly.
 	 */
 	error = xfs_qm_init_quotainos(mp);
 	if (error)
-		goto out_free_lru;
+		goto out_free_counter;
 
 	INIT_RADIX_TREE(&qinf->qi_uquota_tree, GFP_NOFS);
 	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
@@ -696,6 +697,8 @@ xfs_qm_init_quotainfo(
 	mutex_destroy(&qinf->qi_quotaofflock);
 	mutex_destroy(&qinf->qi_tree_lock);
 	xfs_qm_destroy_quotainos(qinf);
+out_free_counter:
+	percpu_counter_destroy(&qinf->qi_active_trans);
 out_free_lru:
 	list_lru_destroy(&qinf->qi_lru);
 out_free_qinf:
@@ -713,18 +716,17 @@ void
 xfs_qm_destroy_quotainfo(
 	struct xfs_mount	*mp)
 {
-	struct xfs_quotainfo	*qi;
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
-	qi = mp->m_quotainfo;
-	ASSERT(qi != NULL);
+	mp->m_quotainfo = NULL;
 
 	unregister_shrinker(&qi->qi_shrinker);
 	list_lru_destroy(&qi->qi_lru);
+	percpu_counter_destroy(&qi->qi_active_trans);
 	xfs_qm_destroy_quotainos(qi);
 	mutex_destroy(&qi->qi_tree_lock);
 	mutex_destroy(&qi->qi_quotaofflock);
 	kmem_free(qi);
-	mp->m_quotainfo = NULL;
 }
 
 /*
@@ -1640,7 +1642,7 @@ xfs_qm_vop_dqalloc(
 	int			error;
 	uint			lockflags;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+	if (!xfs_trans_quota_running(mp))
 		return 0;
 
 	lockflags = XFS_ILOCK_EXCL;
@@ -1891,7 +1893,7 @@ xfs_qm_vop_rename_dqattach(
 	struct xfs_mount	*mp = i_tab[0]->i_mount;
 	int			i;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+	if (!xfs_trans_quota_running(mp))
 		return 0;
 
 	for (i = 0; (i < 4 && i_tab[i]); i++) {
@@ -1922,7 +1924,7 @@ xfs_qm_vop_create_dqattach(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+	if (!xfs_trans_quota_running(mp))
 		return;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 7b0e771fcbce..754b05024cf1 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -78,6 +78,7 @@ struct xfs_quotainfo {
 	struct xfs_def_quota	qi_grp_default;
 	struct xfs_def_quota	qi_prj_default;
 	struct shrinker		qi_shrinker;
+	struct percpu_counter	qi_active_trans;
 };
 
 static inline struct radix_tree_root *
@@ -125,6 +126,9 @@ xfs_dquot_type(struct xfs_dquot *dqp)
 	return XFS_DQ_PROJ;
 }
 
+bool xfs_trans_quota_running(struct xfs_mount *mp);
+bool xfs_trans_quota_enabled(struct xfs_mount *mp);
+
 extern void	xfs_trans_mod_dquot(struct xfs_trans *tp, struct xfs_dquot *dqp,
 				    uint field, int64_t delta);
 extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 7effd7a28136..bc08d7127ef3 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -18,6 +18,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_icache.h"
+#include "xfs_log.h"
 
 STATIC int
 xfs_qm_log_quotaoff(
@@ -169,6 +170,27 @@ xfs_qm_scall_quotaoff(
 	if ((mp->m_qflags & flags) == 0)
 		goto out_unlock;
 
+	/*
+	 * We are about to start the quota off operation. At this point we stop
+	 * new transactions from making quota modifications, but we want
+	 * currently running transactions to drain out. Setting the
+	 * XFS_QUOTA_OFF_RUNNING_BIT will place a new modification barrier in
+	 * the dquot code, and then we need to wait until the active quota
+	 * transaction counter falls to zero.
+	 */
+	set_bit(XFS_QUOTA_OFF_RUNNING_BIT, &mp->m_qflags);
+	while (percpu_counter_sum(&q->qi_active_trans) > 0) {
+		/* sleep for a short while before checking again */
+		msleep(250);
+	}
+
+	/*
+	 * Now there are no quota modifications taking place, force the log to
+	 * get all quota modifications into the log before we log the quota off
+	 * items to indicate quota has been turned off.
+	 */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
 	/*
 	 * Write the LI_QUOTAOFF log record, and do SB changes atomically,
 	 * and synchronously. If we fail to write, we should abort the
@@ -179,61 +201,38 @@ xfs_qm_scall_quotaoff(
 		goto out_unlock;
 
 	/*
-	 * Next we clear the XFS_MOUNT_*DQ_ACTIVE bit(s) in the mount struct
-	 * to take care of the race between dqget and quotaoff. We don't take
-	 * any special locks to reset these bits. All processes need to check
-	 * these bits *after* taking inode lock(s) to see if the particular
-	 * quota type is in the process of being turned off. If *ACTIVE, it is
-	 * guaranteed that all dquot structures and all quotainode ptrs will all
-	 * stay valid as long as that inode is kept locked.
-	 *
-	 * There is no turning back after this.
-	 */
-	mp->m_qflags &= ~inactivate_flags;
-
-	/*
-	 * Give back all the dquot reference(s) held by inodes.
-	 * Here we go thru every single incore inode in this file system, and
-	 * do a dqrele on the i_udquot/i_gdquot that it may have.
-	 * Essentially, as long as somebody has an inode locked, this guarantees
-	 * that quotas will not be turned off. This is handy because in a
-	 * transaction once we lock the inode(s) and check for quotaon, we can
-	 * depend on the quota inodes (and other things) being valid as long as
-	 * we keep the lock(s).
+	 * Clear all the quota flags now that we've logged the initial quota-off
+	 * intent. Once these flags are cleared, we can log the quota-off end
+	 * intent knowing that no further modifications to the type of dquots
+	 * we just turned off will occur.
 	 */
-	xfs_qm_dqrele_all_inodes(mp, flags);
+	mp->m_qflags &= ~(inactivate_flags | flags);
+	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
+	if (error) {
+		/*
+		 * We're screwed now. Shutdown is the only option, but we
+		 * continue the quotaoff dquot cleanup as that has to
+		 * be done regardless of whether we shutdown or not.
+		 */
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	}
 
 	/*
-	 * Next we make the changes in the quota flag in the mount struct.
-	 * This isn't protected by a particular lock directly, because we
-	 * don't want to take a mrlock every time we depend on quotas being on.
+	 * The quota-off transactions are now on stable storage and quotas are
+	 * turned off in memory. We still have dquots that we need to reclaim,
+	 * but they will no longer be a part of ongoing modifications so we
+	 * can do that after we release all the transactions on the quota-off
+	 * barrier.
 	 */
-	mp->m_qflags &= ~flags;
+	clear_and_wake_up_bit(XFS_QUOTA_OFF_RUNNING_BIT, &mp->m_qflags);
 
 	/*
-	 * Go through all the dquots of this file system and purge them,
-	 * according to what was turned off.
+	 * Give back all the dquot references held by inodes and purge the
+	 * dquots from memory.
 	 */
+	xfs_qm_dqrele_all_inodes(mp, flags);
 	xfs_qm_dqpurge_all(mp, dqtype);
 
-	/*
-	 * Transactions that had started before ACTIVE state bit was cleared
-	 * could have logged many dquots, so they'd have higher LSNs than
-	 * the first QUOTAOFF log record does. If we happen to crash when
-	 * the tail of the log has gone past the QUOTAOFF record, but
-	 * before the last dquot modification, those dquots __will__
-	 * recover, and that's not good.
-	 *
-	 * So, we have QUOTAOFF start and end logitems; the start
-	 * logitem won't get overwritten until the end logitem appears...
-	 */
-	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
-	if (error) {
-		/* We're screwed now. Shutdown is the only option. */
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		goto out_unlock;
-	}
-
 	/*
 	 * If all quotas are completely turned off, close shop.
 	 */
@@ -323,7 +322,7 @@ xfs_qm_scall_trunc_qfiles(
 
 	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0 ||
 	    (flags & ~XFS_DQ_ALLTYPES)) {
-		xfs_debug(mp, "%s: flags=%x m_qflags=%x",
+		xfs_debug(mp, "%s: flags=%x m_qflags=%lx",
 			__func__, flags, mp->m_qflags);
 		return -EINVAL;
 	}
@@ -364,7 +363,7 @@ xfs_qm_scall_quotaon(
 	flags &= XFS_ALL_QUOTA_ENFD;
 
 	if (flags == 0) {
-		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
+		xfs_debug(mp, "%s: zero flags, m_qflags=%lx",
 			__func__, mp->m_qflags);
 		return -EINVAL;
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 6f350490f84b..abeddaed4cd6 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -20,6 +20,8 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_qm.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -266,6 +268,20 @@ xfs_trans_alloc(
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
 
+	/*
+	 * If we might be manipulating quota, we need to block here if quotas
+	 * are being turned off. This allows active transactions to drain so
+	 * that we aren't modifying dquots after the quota has been turned
+	 * off. We do this here because we aren't holding any locks that
+	 * the transaction draining could block on. If quotas are enabled
+	 * while the transaction runs, track that in the transaction flags
+	 * so that we can tell the quota subsystem when the transaction is done.
+	 */
+	if (resp->tr_logflags & XFS_TRANS_QUOTA) {
+		if (xfs_trans_quota_enabled(mp))
+			tp->t_flags |= XFS_TRANS_QUOTA;
+	}
+
 	/*
 	 * Zero-reservation ("empty") transactions can't modify anything, so
 	 * they're allowed to run while we're frozen.
@@ -274,7 +290,7 @@ xfs_trans_alloc(
 		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 
 	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
-	tp->t_flags = flags;
+	tp->t_flags |= flags;
 	tp->t_mountp = mp;
 	INIT_LIST_HEAD(&tp->t_items);
 	INIT_LIST_HEAD(&tp->t_busy);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c0f73b82c055..6d8d5543eb94 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -16,7 +16,66 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 
-STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
+static void
+xfs_trans_alloc_dqinfo(
+	struct xfs_trans	*tp)
+{
+	if (!tp || tp->t_dqinfo)
+		return;
+	tp->t_dqinfo = kmem_zone_zalloc(xfs_qm_dqtrxzone, 0);
+}
+
+void
+xfs_trans_free_dqinfo(
+	struct xfs_trans	*tp)
+{
+	if (tp->t_flags & XFS_TRANS_QUOTA)
+		percpu_counter_dec(&tp->t_mountp->m_quotainfo->qi_active_trans);
+
+	if (!tp->t_dqinfo)
+		return;
+
+	kmem_cache_free(xfs_qm_dqtrxzone, tp->t_dqinfo);
+	tp->t_dqinfo = NULL;
+}
+
+bool
+xfs_trans_quota_running(
+	struct xfs_mount	*mp)
+{
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return false;
+	if (!XFS_IS_QUOTA_ON(mp))
+		return false;
+	return true;
+}
+
+bool
+xfs_trans_quota_enabled(
+	struct xfs_mount	*mp)
+{
+	bool			waited;
+
+	do {
+		if (!xfs_trans_quota_running(mp))
+			return false;
+
+		/*
+		 * Don't start new quota modifications while quota off is
+		 * running. If we waited on a quota off, we need to recheck
+		 * if quota is enabled.
+		 */
+		waited = false;
+		while (test_bit(XFS_QUOTA_OFF_RUNNING_BIT, &mp->m_qflags)) {
+			wait_on_bit(&mp->m_qflags, XFS_QUOTA_OFF_RUNNING_BIT,
+						TASK_UNINTERRUPTIBLE);
+			waited = true;
+		}
+	} while (waited == true);
+
+	percpu_counter_inc(&mp->m_quotainfo->qi_active_trans);
+	return true;
+}
 
 /*
  * Add the locked dquot to the transaction.
@@ -67,11 +126,17 @@ xfs_trans_dup_dqinfo(
 	struct xfs_trans	*otp,
 	struct xfs_trans	*ntp)
 {
+	struct xfs_mount	*mp = otp->t_mountp;
 	struct xfs_dqtrx	*oq, *nq;
 	int			i, j;
 	struct xfs_dqtrx	*oqa, *nqa;
 	uint64_t		blk_res_used;
 
+	if (otp->t_flags & XFS_TRANS_QUOTA) {
+		ntp->t_flags |= XFS_TRANS_QUOTA;
+		percpu_counter_inc(&mp->m_quotainfo->qi_active_trans);
+	}
+
 	if (!otp->t_dqinfo)
 		return;
 
@@ -131,13 +196,12 @@ xfs_trans_mod_dquot_byino(
 {
 	xfs_mount_t	*mp = tp->t_mountp;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) ||
-	    !XFS_IS_QUOTA_ON(mp) ||
-	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
+	if (!xfs_trans_quota_running(mp))
+		return;
+	if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return;
 
-	if (tp->t_dqinfo == NULL)
-		xfs_trans_alloc_dqinfo(tp);
+	xfs_trans_alloc_dqinfo(tp);
 
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
 		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
@@ -192,8 +256,11 @@ xfs_trans_mod_dquot(
 	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
 	qtrx = NULL;
 
-	if (tp->t_dqinfo == NULL)
-		xfs_trans_alloc_dqinfo(tp);
+	if (!xfs_trans_quota_running(tp->t_mountp))
+		return;
+
+	xfs_trans_alloc_dqinfo(tp);
+
 	/*
 	 * Find either the first free slot or the slot that belongs
 	 * to this dquot.
@@ -742,11 +809,9 @@ xfs_trans_reserve_quota_bydquots(
 {
 	int		error;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+	if (!xfs_trans_quota_running(mp))
 		return 0;
-
-	if (tp && tp->t_dqinfo == NULL)
-		xfs_trans_alloc_dqinfo(tp);
+	xfs_trans_alloc_dqinfo(tp);
 
 	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 
@@ -800,8 +865,9 @@ xfs_trans_reserve_quota_nblks(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+	if (!xfs_trans_quota_running(mp))
 		return 0;
+	xfs_trans_alloc_dqinfo(tp);
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
 
@@ -856,19 +922,3 @@ xfs_trans_log_quotaoff_item(
 	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
 }
 
-STATIC void
-xfs_trans_alloc_dqinfo(
-	xfs_trans_t	*tp)
-{
-	tp->t_dqinfo = kmem_zone_zalloc(xfs_qm_dqtrxzone, 0);
-}
-
-void
-xfs_trans_free_dqinfo(
-	xfs_trans_t	*tp)
-{
-	if (!tp->t_dqinfo)
-		return;
-	kmem_cache_free(xfs_qm_dqtrxzone, tp->t_dqinfo);
-	tp->t_dqinfo = NULL;
-}
