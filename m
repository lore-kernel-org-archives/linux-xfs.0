Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60163 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753596AbeDRNbV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Apr 2018 09:31:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 05465326227B
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 13:31:21 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D85A47F64A
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 13:31:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 3/6] xfs: defer agfl block frees from deferred ops processing context
Date: Wed, 18 Apr 2018 09:31:16 -0400
Message-Id: <20180418133119.21775-4-bfoster@redhat.com>
In-Reply-To: <20180418133119.21775-1-bfoster@redhat.com>
References: <20180418133119.21775-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that AGFL block frees are deferred when dfops is set in the
transaction, start deferring AGFL block frees from contexts that are
known to push the limits of existing log reservations.

The first such context is deferred operation processing itself. This
primarily targets deferred extent frees (such as file extents and
inode chunks), but in doing so covers all allocation operations that
occur in deferred operation processing context.

Update xfs_defer_finish() to set and reset ->t_agfl_dfops across the
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
index 087fea02c389..4d87d9661907 100644
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
+	ASSERT(!(*tp)->t_agfl_dfops || ((*tp)->t_agfl_dfops == dop));
+	orig_dop = (*tp)->t_agfl_dfops;
+	(*tp)->t_agfl_dfops = dop;
+
 	/* Until we run out of pending work to finish... */
 	while (xfs_defer_has_unfinished_work(dop)) {
 		/* Log intents for work items sitting in the intake. */
@@ -428,6 +439,7 @@ xfs_defer_finish(
 	}
 
 out:
+	(*tp)->t_agfl_dfops = orig_dop;
 	if (error)
 		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
 	else
-- 
2.13.6

