Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030692AbdD0Ijy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Apr 2017 04:39:54 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA664A08F3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2017 08:39:53 +0000 (UTC)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfs: Allow user to kill fstrim process
Date: Thu, 27 Apr 2017 10:39:28 +0200
Message-Id: <1493282368-32422-1-git-send-email-lczerner@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>

fstrim can take really long time on big, slow device or on file system
with a lots of allocation groups. Currently there is no way for the user
to cancell the operation. This patch makes it possible for the user to
kill fstrim pocess by adding the check for fatal_signal_pending() in
xfs_trim_extents().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 fs/xfs/xfs_discard.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index d796ffa..6a05d27 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -132,6 +132,11 @@ xfs_trim_extents(
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			goto out_del_cursor;
+
+		if (fatal_signal_pending(current)) {
+			error = -ERESTARTSYS;
+			goto out_del_cursor;
+		}
 	}
 
 out_del_cursor:
@@ -196,8 +201,11 @@ xfs_ioc_trim(
 	for (agno = start_agno; agno <= end_agno; agno++) {
 		error = xfs_trim_extents(mp, agno, start, end, minlen,
 					  &blocks_trimmed);
-		if (error)
+		if (error) {
 			last_error = error;
+			if (error == -ERESTARTSYS)
+				break;
+		}
 	}
 
 	if (last_error)
-- 
2.7.4

