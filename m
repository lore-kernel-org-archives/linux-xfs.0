Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B091C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Feb 2022 17:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbiBQRZi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Feb 2022 12:25:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243687AbiBQRZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Feb 2022 12:25:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F1FC2B04A8
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 09:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645118722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HwpYCDiD1IIcuqN7MBHegrlGMOHnc0ndhLkAkKMCYFc=;
        b=HXwTfzWREpFKGIPmybESMXgne4mtD6fXsNiOiW+LeXgZatW+FbPZr8XWdU5Tv1FCWoizsa
        0wR96S2oKpxSDHFOFiSrq6awTkTjZups+bsV9ZPRN+NzDNc71UYh1raFYdCFfqMi87ryhi
        UYKqMNaGCY3d2qcvCpovQ3HVrXPm/Q8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-Q0V5eNC7ObCaUgMQJVPMEg-1; Thu, 17 Feb 2022 12:25:20 -0500
X-MC-Unique: Q0V5eNC7ObCaUgMQJVPMEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFBCA18B613F
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 17:25:19 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8702F2DE6F
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 17:25:19 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 1/4] xfs: require an rcu grace period before inode recycle
Date:   Thu, 17 Feb 2022 12:25:15 -0500
Message-Id: <20220217172518.3842951-2-bfoster@redhat.com>
In-Reply-To: <20220217172518.3842951-1-bfoster@redhat.com>
References: <20220217172518.3842951-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The XFS inode allocation algorithm aggressively reuses recently
freed inodes. This is historical behavior that has been in place for
quite some time, since XFS was imported to mainline Linux. Once the
VFS adopted RCUwalk path lookups (also some time ago), this behavior
became slightly incompatible because the inode recycle path doesn't
isolate concurrent access to the inode from the VFS.

This has recently manifested as problems in the VFS when XFS happens
to change the type or properties of a recently unlinked inode while
still involved in an RCU lookup. For example, if the VFS refers to a
previous incarnation of a symlink inode, obtains the ->get_link()
callback from inode_operations, and the latter happens to change to
a non-symlink type via a recycle event, the ->get_link() callback
pointer is reset to NULL and the lookup results in a crash.

To avoid this class of problem, isolate in-core inodes for recycling
with an RCU grace period. This is the same level of protection the
VFS expects for inactivated inodes that are never reused, and so
guarantees no further concurrent access before the type or
properties of the inode change. We don't want an unconditional
synchronize_rcu() event here because that would result in a
significant performance impact to mixed inode allocation workloads.

Fortunately, we can take advantage of the recently added deferred
inactivation mechanism to mitigate the need for an RCU wait in some
cases. Deferred inactivation queues and batches the on-disk freeing
of recently destroyed inodes, and so for non-sustained inactivation
workloads increases the likelihood that a grace period has elapsed
by the time an inode is freed and observable by the allocation code
as a recycle candidate. We have to respect the lifecycle rules
regardless of whether an inode was inactivated or not because of the
fields modified by inode reinit. Therefore, capture the current RCU
grace period cookie as early as possible at destroy time and use it
at lookup time to conditionally sync an RCU grace period if one
hadn't elapsed before the recycle attempt. Slightly adjust struct
xfs_inode to fit the new field into padding holes that conveniently
preexist in the same cacheline as the deferred inactivation list.

Note that this patch alone introduces a significant negative impact
to mixed file allocation and removal workloads because the
allocation algorithm aggressively attempts to reuse recently freed
inodes. This results in frequent RCU grace period synchronization
stalls in the allocation path. This problem is mitigated by
forthcoming patches to track and avoid recycling of inodes with
pending RCU grace periods.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icache.c | 37 ++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_inode.h  |  3 ++-
 fs/xfs/xfs_trace.h  |  8 ++++++--
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9644f938990c..693896bc690f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -351,6 +351,19 @@ xfs_iget_recycle(
 	spin_unlock(&ip->i_flags_lock);
 	rcu_read_unlock();
 
+	/*
+	 * VFS RCU pathwalk lookups dictate the same lifecycle rules for an
+	 * inode recycle as for freeing an inode. I.e., we cannot reinit the
+	 * inode structure until a grace period has elapsed from the last
+	 * ->destroy_inode() call. In most cases a grace period has already
+	 * elapsed if the inode was inactivated, but synchronize here as a
+	 * last resort to guarantee correctness.
+	 */
+	if (!poll_state_synchronize_rcu(ip->i_destroy_gp)) {
+		cond_synchronize_rcu(ip->i_destroy_gp);
+		trace_xfs_iget_recycle_stall(ip);
+	}
+
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	error = xfs_reinit_inode(mp, inode);
 	if (error) {
@@ -1789,7 +1802,8 @@ xfs_check_delalloc(
 /* Schedule the inode for reclaim. */
 static void
 xfs_inodegc_set_reclaimable(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	unsigned long		destroy_gp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
@@ -1805,6 +1819,8 @@ xfs_inodegc_set_reclaimable(
 	spin_lock(&ip->i_flags_lock);
 
 	trace_xfs_inode_set_reclaimable(ip);
+	if (destroy_gp)
+		ip->i_destroy_gp = destroy_gp;
 	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
 	ip->i_flags |= XFS_IRECLAIMABLE;
 	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
@@ -1826,7 +1842,8 @@ xfs_inodegc_inactivate(
 {
 	trace_xfs_inode_inactivating(ip);
 	xfs_inactive(ip);
-	xfs_inodegc_set_reclaimable(ip);
+	/* inactive inodes are assigned rcu state when first queued */
+	xfs_inodegc_set_reclaimable(ip, 0);
 }
 
 void
@@ -1997,7 +2014,8 @@ xfs_inodegc_want_flush_work(
  */
 static void
 xfs_inodegc_queue(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	unsigned long		destroy_gp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_inodegc	*gc;
@@ -2007,6 +2025,7 @@ xfs_inodegc_queue(
 	trace_xfs_inode_set_need_inactive(ip);
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags |= XFS_NEED_INACTIVE;
+	ip->i_destroy_gp = destroy_gp;
 	spin_unlock(&ip->i_flags_lock);
 
 	gc = get_cpu_ptr(mp->m_inodegc);
@@ -2086,6 +2105,7 @@ xfs_inode_mark_reclaimable(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	bool			need_inactive;
+	unsigned long		destroy_gp;
 
 	XFS_STATS_INC(mp, vn_reclaim);
 
@@ -2094,15 +2114,22 @@ xfs_inode_mark_reclaimable(
 	 */
 	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_ALL_IRECLAIM_FLAGS));
 
+	/*
+	 * Poll the RCU subsystem as early as possible and pass the grace
+	 * period cookie along to assign to the inode. This grace period must
+	 * expire before the struct inode can be recycled.
+	 */
+	destroy_gp = start_poll_synchronize_rcu();
+
 	need_inactive = xfs_inode_needs_inactive(ip);
 	if (need_inactive) {
-		xfs_inodegc_queue(ip);
+		xfs_inodegc_queue(ip, destroy_gp);
 		return;
 	}
 
 	/* Going straight to reclaim, so drop the dquots. */
 	xfs_qm_dqdetach(ip);
-	xfs_inodegc_set_reclaimable(ip);
+	xfs_inodegc_set_reclaimable(ip, destroy_gp);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b7e8f14d9fca..6ca60373ff58 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -40,8 +40,9 @@ typedef struct xfs_inode {
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	mrlock_t		i_lock;		/* inode lock */
-	atomic_t		i_pincount;	/* inode pin count */
 	struct llist_node	i_gclist;	/* deferred inactivation list */
+	unsigned long		i_destroy_gp;	/* destroy rcugp cookie */
+	atomic_t		i_pincount;	/* inode pin count */
 
 	/*
 	 * Bitsets of inode metadata that have been checked and/or are sick.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a8076ef8cb4..28ac861c3565 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -727,16 +727,19 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(unsigned long, iflags)
+		__field(unsigned long, destroy_gp)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->iflags = ip->i_flags;
+		__entry->destroy_gp = ip->i_destroy_gp;
 	),
-	TP_printk("dev %d:%d ino 0x%llx iflags 0x%lx",
+	TP_printk("dev %d:%d ino 0x%llx iflags 0x%lx destroy_gp 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __entry->iflags)
+		  __entry->iflags,
+		  __entry->destroy_gp)
 )
 
 #define DEFINE_INODE_EVENT(name) \
@@ -746,6 +749,7 @@ DEFINE_EVENT(xfs_inode_class, name, \
 DEFINE_INODE_EVENT(xfs_iget_skip);
 DEFINE_INODE_EVENT(xfs_iget_recycle);
 DEFINE_INODE_EVENT(xfs_iget_recycle_fail);
+DEFINE_INODE_EVENT(xfs_iget_recycle_stall);
 DEFINE_INODE_EVENT(xfs_iget_hit);
 DEFINE_INODE_EVENT(xfs_iget_miss);
 
-- 
2.31.1

