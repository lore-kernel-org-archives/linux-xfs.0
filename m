Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfDZMGd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Apr 2019 08:06:33 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BAABC308B475
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2019 12:06:33 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78B086660B
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2019 12:06:33 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: add missing error check in xfs_prepare_shift()
Date: Fri, 26 Apr 2019 08:06:33 -0400
Message-Id: <20190426120633.36420-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_prepare_shift() fails to check the error return from
xfs_flush_unmap_range(). If the latter fails, that could lead to an
insert/collapse range operation over a delalloc range, which is not
supported.

Add an error check and return appropriately. This is reproduced
rarely by generic/475.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2db43ff4f8b5..06d07f1e310b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1193,6 +1193,8 @@ xfs_prepare_shift(
 	 * about to shift down every extent from offset to EOF.
 	 */
 	error = xfs_flush_unmap_range(ip, offset, XFS_ISIZE(ip));
+	if (error)
+		return error;
 
 	/*
 	 * Clean out anything hanging around in the cow fork now that
-- 
2.17.2
