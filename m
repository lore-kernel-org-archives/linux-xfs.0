Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D6BC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 13:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbiAMNhG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 08:37:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23756 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235283AbiAMNhG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jan 2022 08:37:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642081025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AdPd0e33YzcG3BRC4eVqk+x2t1n+Z3Cpxw5JOnhSk2g=;
        b=er/2G4C2RmN748ivyxTGSUHjdFtdpMTn0Gg8sXXaMlB0LBJCXww6WPyGLBRQLmg8z/fDNQ
        oggKxTBemop7qNHL/6PG0wecN44I+J8wpSloXEoAk0Tpaw9uKUgDay9gboTxEC+tI0rWeu
        oqevfWIWoZvdtduUfuJ3u0WifdmG26Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-YffKfdoAPna8L5uDK3wbLg-1; Thu, 13 Jan 2022 08:37:04 -0500
X-MC-Unique: YffKfdoAPna8L5uDK3wbLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 714F219251A0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 13:37:03 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FAA284A26
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 13:37:03 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls after reclaim
Date:   Thu, 13 Jan 2022 08:37:01 -0500
Message-Id: <20220113133701.629593-3-bfoster@redhat.com>
In-Reply-To: <20220113133701.629593-1-bfoster@redhat.com>
References: <20220113133701.629593-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We've had reports on distro (pre-deferred inactivation) kernels that
inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
lock when invoked on a frozen XFS fs. This occurs because
drop_caches acquires the lock and then blocks in xfs_inactive() on
transaction alloc for an inode that requires an eofb trim. unfreeze
then blocks on the same lock and the fs is deadlocked.

With deferred inactivation, the deadlock problem is no longer
present because ->destroy_inode() no longer blocks whether the fs is
frozen or not. There is still unfortunate behavior in that lookups
of a pending inactive inode spin loop waiting for the pending
inactive state to clear, which won't happen until the fs is
unfrozen. This was always possible to some degree, but is
potentially amplified by the fact that reclaim no longer blocks on
the first inode that requires inactivation work. Instead, we
populate the inactivation queues indefinitely. The side effect can
be observed easily by invoking drop_caches on a frozen fs previously
populated with eofb and/or cowblocks inodes and then running
anything that relies on inode lookup (i.e., ls).

To mitigate this behavior, invoke internal blockgc reclaim during
the freeze sequence to guarantee that inode eviction doesn't lead to
this state due to eofb or cowblocks inodes. This is similar to
current behavior on read-only remount. Since the deadlock issue was
present for such a long time, also document the subtle
->destroy_inode() constraint to avoid unintentional reintroduction
of the deadlock problem in the future.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c7ac486ca5d3..1d0f87e47fa4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -623,8 +623,13 @@ xfs_fs_alloc_inode(
 }
 
 /*
- * Now that the generic code is guaranteed not to be accessing
- * the linux inode, we can inactivate and reclaim the inode.
+ * Now that the generic code is guaranteed not to be accessing the inode, we can
+ * inactivate and reclaim it.
+ *
+ * NOTE: ->destroy_inode() can be called (with ->s_umount held) while the
+ * filesystem is frozen. Therefore it is generally unsafe to attempt transaction
+ * allocation in this context. A transaction alloc that blocks on frozen state
+ * from a context with ->s_umount held will deadlock with unfreeze.
  */
 STATIC void
 xfs_fs_destroy_inode(
@@ -764,6 +769,16 @@ xfs_fs_sync_fs(
 	 * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
 	 */
 	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
+		struct xfs_icwalk	icw = {0};
+
+		/*
+		 * Clear out eofb and cowblocks inodes so eviction while frozen
+		 * doesn't leave them sitting in the inactivation queue where
+		 * they cannot be processed.
+		 */
+		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
+		xfs_blockgc_free_space(mp, &icw);
+
 		xfs_inodegc_stop(mp);
 		xfs_blockgc_stop(mp);
 	}
-- 
2.31.1

