Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C84C4727C
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 15:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5F852145D
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 15:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PhCIcl8/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732513AbgJAPD3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 11:03:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732096AbgJAPD1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 11:03:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZqRIYOvUZ8Aecixy3koxFjGZsX4WqLNYeS9RnsOjnck=;
        b=PhCIcl8/VGrpnwW4bgFcRLzP4woYtouA7eQxe0VejzS9kOEyXEdj/fVgAa1DACp6mHbGfn
        Pn1YnEqP7KOsILLJJkQZueCsKn20TM/Jk1OJYEZXM6N8CUyIVDvxqLzwCRW1AFYPv4Y3Ts
        dPLlY2Jler/Yqb36olTZ5/D7ww3wbCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-m3v0pFOiOtmOK8Hbf-wgUw-1; Thu, 01 Oct 2020 11:03:23 -0400
X-MC-Unique: m3v0pFOiOtmOK8Hbf-wgUw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70DDD640AD
        for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2020 15:03:12 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C78E10013BD
        for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2020 15:03:12 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: transaction subsystem quiesce mechanism
Date:   Thu,  1 Oct 2020 11:03:09 -0400
Message-Id: <20201001150310.141467-3-bfoster@redhat.com>
In-Reply-To: <20201001150310.141467-1-bfoster@redhat.com>
References: <20201001150310.141467-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The updated quotaoff logging algorithm depends on a runtime quiesce
of the transaction subsystem to guarantee all transactions after a
certain point detect quota subsystem changes. Implement this
mechanism using an internal lock, similar to the external filesystem
freeze mechanism. This is also somewhat analogous to the old percpu
transaction counter mechanism, but we don't actually need a counter.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c  |  2 ++
 fs/xfs/xfs_mount.h |  3 +++
 fs/xfs/xfs_super.c |  8 ++++++++
 fs/xfs/xfs_trans.c |  4 ++--
 fs/xfs/xfs_trans.h | 20 ++++++++++++++++++++
 5 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b35611882ff9..214310c94de5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -58,6 +58,7 @@ xfs_setfilesize_trans_alloc(
 	 * we released it.
 	 */
 	__sb_writers_release(ioend->io_inode->i_sb, SB_FREEZE_FS);
+	percpu_rwsem_release(&mp->m_trans_rwsem, true, _THIS_IP_);
 	/*
 	 * We hand off the transaction to the completion thread now, so
 	 * clear the flag here.
@@ -127,6 +128,7 @@ xfs_setfilesize_ioend(
 	 */
 	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
+	percpu_rwsem_acquire(&ip->i_mount->m_trans_rwsem, true, _THIS_IP_);
 
 	/* we abort the update if there was an IO error */
 	if (error) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dfa429b77ee2..f1083a9ce1f8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -171,6 +171,9 @@ typedef struct xfs_mount {
 	 */
 	struct percpu_counter	m_delalloc_blks;
 
+	/* lock for transaction quiesce (used by quotaoff) */
+	struct percpu_rw_semaphore	m_trans_rwsem;
+
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	uint64_t		m_resblks;	/* total reserved blocks */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index baf5de30eebb..ff3ad5392e21 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1029,8 +1029,15 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_fdblocks;
 
+	/* not a counter, but close enough... */
+	error = percpu_init_rwsem(&mp->m_trans_rwsem);
+	if (error)
+		goto free_delalloc;
+
 	return 0;
 
+free_delalloc:
+	percpu_counter_destroy(&mp->m_delalloc_blks);
 free_fdblocks:
 	percpu_counter_destroy(&mp->m_fdblocks);
 free_ifree:
@@ -1053,6 +1060,7 @@ static void
 xfs_destroy_percpu_counters(
 	struct xfs_mount	*mp)
 {
+	percpu_free_rwsem(&mp->m_trans_rwsem);
 	percpu_counter_destroy(&mp->m_icount);
 	percpu_counter_destroy(&mp->m_ifree);
 	percpu_counter_destroy(&mp->m_fdblocks);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index ca18a040336a..c07fa036549a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -69,7 +69,7 @@ xfs_trans_free(
 
 	trace_xfs_trans_free(tp, _RET_IP_);
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
-		sb_end_intwrite(tp->t_mountp->m_super);
+		xfs_trans_end(tp->t_mountp);
 	xfs_trans_free_dqinfo(tp);
 	kmem_cache_free(xfs_trans_zone, tp);
 }
@@ -265,7 +265,7 @@ xfs_trans_alloc(
 	 */
 	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
-		sb_start_intwrite(mp->m_super);
+		xfs_trans_start(mp);
 
 	/*
 	 * Zero-reservation ("empty") transactions can't modify anything, so
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f46534b75236..af54c17a22c0 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -209,6 +209,26 @@ xfs_trans_read_buf(
 				      flags, bpp, ops);
 }
 
+/*
+ * Context tracking helpers for external (i.e. fs freeze) and internal
+ * transaction quiesce.
+ */
+static inline void
+xfs_trans_start(
+	struct xfs_mount	*mp)
+{
+	sb_start_intwrite(mp->m_super);
+	percpu_down_read(&mp->m_trans_rwsem);
+}
+
+static inline void
+xfs_trans_end(
+	struct xfs_mount	*mp)
+{
+	percpu_up_read(&mp->m_trans_rwsem);
+	sb_end_intwrite(mp->m_super);
+}
+
 struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
-- 
2.25.4

