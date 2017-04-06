Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50863 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935207AbdDFOeZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 10:34:25 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0945861E74
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2017 14:34:25 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] mkfs: rtinherit minval should be 0
Date: Thu,  6 Apr 2017 16:34:26 +0200
Message-Id: <20170406143426.19727-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

As with any other option, rtinherit=[0|1], but minval was incorrectly
set to 1, so it was not possible to disable this option.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6fedc05c..5aac4d1b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -290,7 +290,7 @@ struct opt_params dopts = {
 		},
 		{ .index = D_RTINHERIT,
 		  .conflicts = { LAST_CONFLICT },
-		  .minval = 1,
+		  .minval = 0,
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
-- 
2.12.1

