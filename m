Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752706AbdK0W5i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 17:57:38 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E44696014F
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 22:57:37 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB6525C888
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 22:57:37 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: fix uninitialized variable in xfs_scrub_quota
Message-ID: <8ac42102-7147-a373-5e2c-a984e1bdbe00@redhat.com>
Date: Mon, 27 Nov 2017 16:57:36 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

On the first pass through the while(1) loop, we get to
xfs_scrub_should_terminate() which can test the uninitialized 
error variable.

Fixes-coverity-id: 1423737
Fixes: c2fc338c ("xfs: scrub quota information")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

compile-tested only

diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 8e58ba8..613def9 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -207,7 +207,7 @@
 	xfs_dqid_t			id = 0;
 	uint				dqtype;
 	int				nimaps;
-	int				error;
+	int				error = 0;
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return -ENOENT;

