Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753526AbdGXPCb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jul 2017 11:02:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 53C2520B15
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2017 15:02:31 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35FBC871FE
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2017 15:02:31 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix quotacheck dquot id overflow infinite loop
Date: Mon, 24 Jul 2017 11:02:29 -0400
Message-Id: <20170724150229.12549-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

If a dquot has an id of U32_MAX, the next lookup index increment
overflows the uint32_t back to 0. This starts the lookup sequence
over from the beginning, repeats indefinitely and results in a
livelock.

Update xfs_qm_dquot_walk() to explicitly check for the lookup
overflow and exit the loop.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_qm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6ce948c..15751dc 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -111,6 +111,9 @@ xfs_qm_dquot_walk(
 			skipped = 0;
 			break;
 		}
+		/* we're done if id overflows back to zero */
+		if (!next_index)
+			break;
 	}
 
 	if (skipped) {
-- 
2.9.4

