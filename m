Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43424 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388017AbeGWOFX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 10:05:23 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7CF9D81A4EA0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 685E3111AF23
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 02/15] xfs: use ->t_dfops in log recovery intent processing
Date: Mon, 23 Jul 2018 09:04:01 -0400
Message-Id: <20180723130414.47980-3-bfoster@redhat.com>
In-Reply-To: <20180723130414.47980-1-bfoster@redhat.com>
References: <20180723130414.47980-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xlog_finish_defer_ops() processes the deferred operations collected
over the entire intent recovery sequence. We can't xfs_defer_init()
here because the dfops is already populated. Attach it manually and
eliminate the last caller of xfs_defer_finish() that doesn't pass
->t_dfops.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cbac943896f4..3289811eb076 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4854,6 +4854,8 @@ xlog_finish_defer_ops(
 			0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
+	/* dfops is already populated so assign it manually */
+	tp->t_dfops = dfops;
 
 	error = xfs_defer_finish(&tp, dfops);
 	if (error)
-- 
2.17.1

