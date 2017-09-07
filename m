Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753134AbdIGDpT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 23:45:19 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 93D67C04B32C
        for <linux-xfs@vger.kernel.org>; Thu,  7 Sep 2017 03:45:19 +0000 (UTC)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/2] xfs: kill meaningless variable 'zero'
Date: Thu,  7 Sep 2017 11:42:54 +0800
Message-Id: <20170907034254.7180-2-eguan@redhat.com>
In-Reply-To: <20170907034254.7180-1-eguan@redhat.com>
References: <20170907034254.7180-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>

In xfs_file_aio_write_checks(), variable 'zero' is there only to
satisfy xfs_zero_eof(), the result of it is ignored. Now, with
iomap_zero_range() based xfs_zero_eof(), we can safely pass NULL as
the last param of it and kill 'zero'.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 fs/xfs/xfs_file.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 812cd17b331f..e7dbeed0f0cb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -373,8 +373,6 @@ xfs_file_aio_write_checks(
 	 */
 	spin_lock(&ip->i_flags_lock);
 	if (iocb->ki_pos > i_size_read(inode)) {
-		bool	zero = false;
-
 		spin_unlock(&ip->i_flags_lock);
 		if (!drained_dio) {
 			if (*iolock == XFS_IOLOCK_SHARED) {
@@ -395,7 +393,7 @@ xfs_file_aio_write_checks(
 			drained_dio = true;
 			goto restart;
 		}
-		error = xfs_zero_eof(ip, iocb->ki_pos, i_size_read(inode), &zero);
+		error = xfs_zero_eof(ip, iocb->ki_pos, i_size_read(inode), NULL);
 		if (error)
 			return error;
 	} else
-- 
2.13.5

