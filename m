Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752146AbdIGDpR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 23:45:17 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 63C733DE3D
        for <linux-xfs@vger.kernel.org>; Thu,  7 Sep 2017 03:45:17 +0000 (UTC)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/2] xfs: report zeroed or not correctly in xfs_zero_range()
Date: Thu,  7 Sep 2017 11:42:53 +0800
Message-Id: <20170907034254.7180-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>

The 'did_zero' param of xfs_zero_range() was not passed to
iomap_zero_range() correctly. This was introduced by commit
7bb41db3ea16 ("xfs: handle 64-bit length in xfs_iozero"), and found
by code inspection.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c4893e226fd8..812cd17b331f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -58,7 +58,7 @@ xfs_zero_range(
 	xfs_off_t		count,
 	bool			*did_zero)
 {
-	return iomap_zero_range(VFS_I(ip), pos, count, NULL, &xfs_iomap_ops);
+	return iomap_zero_range(VFS_I(ip), pos, count, did_zero, &xfs_iomap_ops);
 }
 
 int
-- 
2.13.5

