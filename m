Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981AEC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 14:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380916AbiAUOZC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 09:25:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350730AbiAUOZB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 09:25:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642775101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B7hvOprxHiL9qCQhIeqXVlImgIsILi7okCdTn4NbuEw=;
        b=baOhx9jNN1nzVRcXPFcb9x2NU0B2nRA07sVLlSAaFYz5ezsuNTdx80EiOZxunFWh97iS6n
        Sk8pIcI+t+bqZAmVCW0tti+QjtVmY0+hlpmHp1jxNAZi0hGQTB1WeGGuU/n15zxPirW3MP
        x1sPacg8MxhFV/9PEx4Df/Gk+DGZ5Us=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-c3m46r3WP0-xPOtVffF6FA-1; Fri, 21 Jan 2022 09:24:57 -0500
X-MC-Unique: c3m46r3WP0-xPOtVffF6FA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0D2C46864;
        Fri, 21 Jan 2022 14:24:55 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C64E5E49C;
        Fri, 21 Jan 2022 14:24:55 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        rcu@vger.kernel.org
Subject: [PATCH] xfs: require an rcu grace period before inode recycle
Date:   Fri, 21 Jan 2022 09:24:54 -0500
Message-Id: <20220121142454.1994916-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
inactivation mechanism to mitigate the need for an RCU wait in most
cases. Deferred inactivation queues and batches the on-disk freeing
of recently destroyed inodes, and so significantly increases the
likelihood that a grace period has elapsed by the time an inode is
freed and observable by the allocation code as a reuse candidate.
Capture the current RCU grace period cookie at inode destroy time
and refer to it at allocation time to conditionally wait for an RCU
grace period if one hadn't expired in the meantime.  Since only
unlinked inodes are recycle candidates and unlinked inodes always
require inactivation, we only need to poll and assign RCU state in
the inactivation codepath. Slightly adjust struct xfs_inode to fit
the new field into padding holes that conveniently preexist in the
same cacheline as the deferred inactivation list.

Finally, note that the ideal long term solution here is to
rearchitect bits of XFS' internal inode lifecycle management such
that this additional stall point is not required, but this requires
more thought, time and work to address. This approach restores
functional correctness in the meantime.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

Here's the RCU fixup patch for inode reuse that I've been playing with,
re: the vfs patch discussion [1]. I've put it in pretty much the most
basic form, but I think there are a couple aspects worth thinking about:

1. Use and frequency of start_poll_synchronize_rcu() (vs.
get_state_synchronize_rcu()). The former is a bit more active than the
latter in that it triggers the start of a grace period, when necessary.
This currently invokes per inode, which is the ideal frequency in
theory, but could be reduced, associated with the xfs_inogegc thresholds
in some manner, etc., if there is good reason to do that.

2. The rcu cookie lifecycle. This variant updates it on inactivation
queue and nowhere else because the RCU docs imply that counter rollover
is not a significant problem. In practice, I think this means that if an
inode is stamped at least once, and the counter rolls over, future
(non-inactivation, non-unlinked) eviction -> repopulation cycles could
trigger rcu syncs. I think this would require repeated
eviction/reinstantiation cycles within a small window to be noticeable,
so I'm not sure how likely this is to occur. We could be more defensive
by resetting or refreshing the cookie. E.g., refresh (or reset to zero)
at recycle time, unconditionally refresh at destroy time (using
get_state_synchronize_rcu() for non-inactivation), etc.

Otherwise testing is ongoing, but this version at least survives an
fstests regression run.

Brian

[1] https://lore.kernel.org/linux-fsdevel/164180589176.86426.501271559065590169.stgit@mickey.themaw.net/

 fs/xfs/xfs_icache.c | 11 +++++++++++
 fs/xfs/xfs_inode.h  |  3 ++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d019c98eb839..4931daa45ca4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -349,6 +349,16 @@ xfs_iget_recycle(
 	spin_unlock(&ip->i_flags_lock);
 	rcu_read_unlock();
 
+	/*
+	 * VFS RCU pathwalk lookups dictate the same lifecycle rules for an
+	 * inode recycle as for freeing an inode. I.e., we cannot repurpose the
+	 * inode until a grace period has elapsed from the time the previous
+	 * version of the inode was destroyed. In most cases a grace period has
+	 * already elapsed if the inode was (deferred) inactivated, but
+	 * synchronize here as a last resort to guarantee correctness.
+	 */
+	cond_synchronize_rcu(ip->i_destroy_gp);
+
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	error = xfs_reinit_inode(mp, inode);
 	if (error) {
@@ -2019,6 +2029,7 @@ xfs_inodegc_queue(
 	trace_xfs_inode_set_need_inactive(ip);
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags |= XFS_NEED_INACTIVE;
+	ip->i_destroy_gp = start_poll_synchronize_rcu();
 	spin_unlock(&ip->i_flags_lock);
 
 	gc = get_cpu_ptr(mp->m_inodegc);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c447bf04205a..2153e3edbb86 100644
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
-- 
2.31.1

