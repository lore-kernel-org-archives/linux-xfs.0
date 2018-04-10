Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3742 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752041AbeDJRqd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 13:46:33 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 45D8B8765D
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26A8682C60
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/7] xfs: defer agfl block frees from deferred ops processing context
Date: Tue, 10 Apr 2018 13:46:28 -0400
Message-Id: <20180410174631.4915-5-bfoster@redhat.com>
In-Reply-To: <20180410174631.4915-1-bfoster@redhat.com>
References: <20180410174631.4915-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that AGFL block frees can be deferred when dfops is carried
through to the allocator via the transaction, we want to start
deferring AGFL block frees from the contexts that are known to push
the limits of existing log reservations.

The first such context is deferred operation processing itself. This
primarily targets deferred extent frees (such as file extents and
inode chunks), but in doing so covers all allocation operations that
occur in deferred operation processing context.

Update xfs_defer_finish() to set and reset ->t_dfops across the
processing sequence. This means that any AGFL block frees due to
allocation events result in the addition of new EFIs to the dfops
rather than being processed immediately. xfs_defer_finish() rolls
the transaction at least once more to process the frees of the AGFL
blocks back to the allocation btrees and returns once the AGFL is
rectified.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index f3aef54257d1..493fdc86f54a 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -352,11 +352,22 @@ xfs_defer_finish(
 	void				*state;
 	int				error = 0;
 	void				(*cleanup_fn)(struct xfs_trans *, void *, int);
+	struct xfs_defer_ops		*orig_dop;
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	trace_xfs_defer_finish((*tp)->t_mountp, dop);
 
+	/*
+	 * Attach dfops to the transaction during deferred ops processing. This
+	 * explicitly causes calls into the allocator to defer AGFL block frees.
+	 * Note that this code can go away once all dfops users attach to the
+	 * associated tp.
+	 */
+	ASSERT(!(*tp)->t_dfops || ((*tp)->t_dfops == dop));
+	orig_dop = (*tp)->t_dfops;
+	(*tp)->t_dfops = dop;
+
 	/* Until we run out of pending work to finish... */
 	while (xfs_defer_has_unfinished_work(dop)) {
 		/* Log intents for work items sitting in the intake. */
@@ -428,6 +439,7 @@ xfs_defer_finish(
 	}
 
 out:
+	(*tp)->t_dfops = orig_dop;
 	if (error)
 		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
 	else
-- 
2.13.6

