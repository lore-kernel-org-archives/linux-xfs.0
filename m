Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965101AbeAXSoU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jan 2018 13:44:20 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8E61266C7D
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:20 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A4D05D728
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFCv2 9/9] xfs: add extra log count for transactions that defer agfl frees
Date: Wed, 24 Jan 2018 13:44:18 -0500
Message-Id: <20180124184418.40403-10-bfoster@redhat.com>
In-Reply-To: <20180124184418.40403-1-bfoster@redhat.com>
References: <20180124184418.40403-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that AGFL frees are deferred from particular contexts, the
associated transactions may require an increased number of
transaction rolls during deferred operation processing. Update the
log counts to prevent these additional rolls from blocking on
reservation regrant.

XXX: This patch is currently a no-op as XFS_AGFL_LOG_COUNT is set to
zero. Initially it was 1, but testing has shown a couple issues:

- The increase in number of regrants due to deferred AGFL block frees
appears to be minimal on the workloads examined so far.
- Increasing the logcount of certain larger transactions (e.g.,
tr_rename and some of the other directory ops) can increase the max
transaction reservation and have side effects like increasing the
minimum required log size at mkfs time.

Based on the above and the reasoning that deferred AGFL block frees
are a subset of all AGFL fixup operations (only frees), which in
turn are a subset of allocations (typically those that involve btree
shape changes), I think that it's probably overkill to increase
the logcount of any existing transactions at the moment. That
doesn't preclude from doing so in the future, of course.

I'm including this patch for reference and discussion purposes for
the RFC. I'm open to running more/different tests and/or considering
subsets of transactions, though I would prefer any change be backed
by a test that demonstrates the cost of deferring AGFL frees and
benefit of increasing the logcount of the associated transaction(s)
and workload. I've simply not been able to do that with enough
clarity to justify a change so far.

Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index b7e5357d060a..05fdcef07216 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -82,20 +82,23 @@ struct xfs_trans_resv {
 	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
 
 /*
- * Various log count values.
+ * Various log count values. The AGFL count is a sub-component that covers
+ * additional tx rolls due to AGFL fixups (for transactions that defer AGFL
+ * block frees).
  */
+#define	XFS_AGFL_LOG_COUNT		0 /* for agfl fixups */
 #define	XFS_DEFAULT_LOG_COUNT		1
 #define	XFS_DEFAULT_PERM_LOG_COUNT	2
 #define	XFS_ITRUNCATE_LOG_COUNT		2
 #define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
-#define XFS_INACTIVE_LOG_COUNT		2
-#define	XFS_CREATE_LOG_COUNT		2
+#define	XFS_INACTIVE_LOG_COUNT		(2 + XFS_AGFL_LOG_COUNT)
+#define	XFS_CREATE_LOG_COUNT		(2 + XFS_AGFL_LOG_COUNT)
 #define	XFS_CREATE_TMPFILE_LOG_COUNT	2
-#define	XFS_MKDIR_LOG_COUNT		3
-#define	XFS_SYMLINK_LOG_COUNT		3
-#define	XFS_REMOVE_LOG_COUNT		2
-#define	XFS_LINK_LOG_COUNT		2
-#define	XFS_RENAME_LOG_COUNT		2
+#define	XFS_MKDIR_LOG_COUNT		(3 + XFS_AGFL_LOG_COUNT)
+#define	XFS_SYMLINK_LOG_COUNT		(3 + XFS_AGFL_LOG_COUNT)
+#define	XFS_REMOVE_LOG_COUNT		(2 + XFS_AGFL_LOG_COUNT)
+#define	XFS_LINK_LOG_COUNT		(2 + XFS_AGFL_LOG_COUNT)
+#define	XFS_RENAME_LOG_COUNT		(2 + XFS_AGFL_LOG_COUNT)
 #define	XFS_WRITE_LOG_COUNT		2
 #define	XFS_WRITE_LOG_COUNT_REFLINK	8
 #define	XFS_ADDAFORK_LOG_COUNT		2
-- 
2.13.6

