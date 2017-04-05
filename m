Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753996AbdDEVDY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 17:03:24 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E65B2E6050
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2017 21:03:19 +0000 (UTC)
Received: from Liberator.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF1685C895
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2017 21:03:18 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: simplify xfs_calc_dquots_per_chunk
Message-ID: <b99b73b5-9525-bf50-ecd4-ccb361545b12@redhat.com>
Date: Wed, 5 Apr 2017 16:03:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

ndquots is a 32-bit value, and we don't care
about the remainder; there is no reason to use do_div
here, it seems to be the result of a decade+ historical
accident.

Worse, the do_div implementation in userspace breaks
when fed a 32-bit dividend, so we commented it out there
in any case.

Change to simple division, and then we can change
userspace to match, and mandate a 64-bit dividend in
the do_div() in userspace as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--- 

tested w/ ./check -g quota

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index ac9a003..747085b 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -35,13 +35,8 @@
 xfs_calc_dquots_per_chunk(
 	unsigned int		nbblks)	/* basic block units */
 {
-	unsigned int	ndquots;
-
 	ASSERT(nbblks > 0);
-	ndquots = BBTOB(nbblks);
-	do_div(ndquots, sizeof(xfs_dqblk_t));
-
-	return ndquots;
+	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
 }
 
 /*

