Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965096AbeAXSoU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jan 2018 13:44:20 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 16C678B104
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:20 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED5085D728
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFCv2 4/9] xfs: defer agfl block frees from deferred ops processing context
Date: Wed, 24 Jan 2018 13:44:13 -0500
Message-Id: <20180124184418.40403-5-bfoster@redhat.com>
In-Reply-To: <20180124184418.40403-1-bfoster@redhat.com>
References: <20180124184418.40403-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that AGFL block frees can be deferred when dfops is carried
through to the allocator via the transaction, we want to start
deferring AGFL block frees from the contexts that are known to
stress existing log reservations.

The first such context is deferred operation processing itself. This
primarily targets deferred extent frees (such as file extents and
inode chunks), but in doing so covers all allocation operations that
occur in deferred operation processing context.

Update xfs_defer_finish() to set and reset ->t_dfops across the
finish sequence. This means that any AGFL block frees due to
allocation events result in the addition of new EFIs to the dfops
rather than being processed immediately. xfs_defer_finish() rolls
the transaction at least once more to process the frees of the AGFL
blocks back to the allocation btrees and returns once the AGFL is
rectified.

XXX: cache/reset old_dfops rather than NULL?

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 087fea02c389..de71d292b9f3 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -357,6 +357,14 @@ xfs_defer_finish(
 
 	trace_xfs_defer_finish((*tp)->t_mountp, dop);
 
+	/*
+	 * Attach dfops to the transaction during deferred ops processing. This
+	 * causes calls into the allocator to defer AGFL block frees. The
+	 * pointer is set to NULL before we return.
+	 */
+	ASSERT(!(*tp)->t_dfops || ((*tp)->t_dfops == dop));
+	(*tp)->t_dfops = dop;
+
 	/* Until we run out of pending work to finish... */
 	while (xfs_defer_has_unfinished_work(dop)) {
 		/* Log intents for work items sitting in the intake. */
@@ -428,6 +436,7 @@ xfs_defer_finish(
 	}
 
 out:
+	(*tp)->t_dfops = NULL;
 	if (error)
 		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
 	else
-- 
2.13.6

