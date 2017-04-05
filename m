Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933475AbdDEVzD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 17:55:03 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7FECB61B8D
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2017 21:55:02 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5317E8B179
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2017 21:55:02 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: simplify xfs_calc_dquots_per_chunk
Message-ID: <2112d7f5-60d0-cb07-d186-d95cec3c8975@redhat.com>
Date: Wed, 5 Apr 2017 16:55:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>


The do_div call was commented out because userspace's
do_div is not safe to call with a 32-bit dividend.

Just keep the simple division and remove the other cruft,
we'll change the kernel to match as well; there is no need
for do_div here.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index aae8854..a19a20a 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -29,27 +29,12 @@
 #include "xfs_trace.h"
 #include "xfs_quota_defs.h"
 
-/*
- * XXX: kernel implementation causes ndquots calc to go real
- * bad. Just leaving the existing userspace calc here right now.
- */
 int
 xfs_calc_dquots_per_chunk(
 	unsigned int		nbblks)	/* basic block units */
 {
-
 	ASSERT(nbblks > 0);
 	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
-
-#if 0	/* kernel code that goes wrong in userspace! */
-	unsigned int	ndquots;
-
-	ASSERT(nbblks > 0);
-	ndquots = BBTOB(nbblks);
-	do_div(ndquots, sizeof(xfs_dqblk_t));
-
-	return ndquots;
-#endif
 }
 
 /*

