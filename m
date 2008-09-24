Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 18:14:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O1Ejh4022843
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 18:14:45 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BA8F474F90
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 18:16:19 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id BvirAsEHUdBzxtfb for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 18:16:19 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KiIzG-0001Lh-Q2
	for xfs@oss.sgi.com; Wed, 24 Sep 2008 11:16:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] XFS: Check for valid transaction headers in recovery
Date: Wed, 24 Sep 2008 11:16:14 +1000
Message-Id: <1222218974-5161-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

When we are about to add a new item to a transaction in recovery,
we need to check that it is valid first. Current we just assert
that header magic number matches, but in production systems
that is not done add a corrupted transaction to the list to be
processed. This results in a kernel oops later when processing the
corrupted transaction.

Instead, if we detect a corrupted transaction, abort recovery and
leave the user to clean up the mess that has occurred.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_log_recover.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 37c2bf9..1ccc80d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1420,7 +1420,13 @@ xlog_recover_add_to_trans(
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
1.5.6
