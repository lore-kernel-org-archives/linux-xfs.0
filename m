Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:55:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LtgXw007361
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:55:44 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E00A84C63AA
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:57:22 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id e3uXYTxS8wBMrHB2 for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:57:22 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKYS-0002BE-8i
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:57:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] XFS: Check for valid transaction headers in recovery
Date: Wed,  8 Oct 2008 08:57:20 +1100
Message-Id: <1223416640-8357-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

When we are about to add a new item to a transaction in recovery, we
need to check that it is valid first. Currently we just assert that
header magic number matches, but in production systems that is
present and we add a corrupted transaction to the list to be
processed. This results in a kernel oops later when processing the
corrupted transaction.

Instead, if we detect a corrupted transaction, abort recovery and
leave the user to clean up the mess that has occurred.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_log_recover.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0280a25..6d961fc 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1417,7 +1417,13 @@ xlog_recover_add_to_trans(
 		return 0;
 	item = trans->r_itemq;
 	if (item == NULL) {
-		ASSERT(*(uint *)dp == XFS_TRANS_HEADER_MAGIC);
+		/* we need to catch log corruptions here */
+		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
+			xlog_warn("XFS: xlog_recover_add_to_trans: "
+				  "bad header magic number");
+			ASSERT(0);
+			return XFS_ERROR(EIO);
+		}
 		if (len == sizeof(xfs_trans_header_t))
 			xlog_recover_add_item(&trans->r_itemq);
 		memcpy(&trans->r_theader, dp, len); /* d, s, l */
-- 
1.5.6.5
