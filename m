Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752734AbdACRyY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jan 2017 12:54:24 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A4A37883B1
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jan 2017 17:53:38 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (dhcp-27-38.brq.redhat.com [10.34.27.38])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v03Hrbnl027898
        for <linux-xfs@vger.kernel.org>; Tue, 3 Jan 2017 12:53:38 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Fix max_retries _show and _store functions
Date: Tue,  3 Jan 2017 18:53:31 +0100
Message-Id: <20170103175331.8089-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

max_retries _show and _store functions should test against cfg->max_retries,
not cfg->retry_timeout

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 276d302..de6195e 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -396,7 +396,7 @@ max_retries_show(
 	int		retries;
 	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
 
-	if (cfg->retry_timeout == XFS_ERR_RETRY_FOREVER)
+	if (cfg->max_retries == XFS_ERR_RETRY_FOREVER)
 		retries = -1;
 	else
 		retries = cfg->max_retries;
@@ -422,7 +422,7 @@ max_retries_store(
 		return -EINVAL;
 
 	if (val == -1)
-		cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
+		cfg->max_retries = XFS_ERR_RETRY_FOREVER;
 	else
 		cfg->max_retries = val;
 	return count;
-- 
2.9.3

