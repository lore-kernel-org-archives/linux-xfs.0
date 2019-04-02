Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfDBPol (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Apr 2019 11:44:41 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8DD7D3082B46
        for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2019 15:44:41 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: return correct XFS_IOC_DIOINFO for DAX inode
Message-ID: <b3af182f-a547-9d04-3b29-232857e83fc4@redhat.com>
Date: Tue, 2 Apr 2019 10:44:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>

pmem is byte addressable, and indeed byte-aligned DIO works on
a DAX file.  So, teach XFS_IOC_DIOINFO to return the correct
alignment information if IS_DAX(inode).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6ecdbb3..35eae7d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1919,12 +1919,21 @@ xfs_file_ioctl(
 	}
 	case XFS_IOC_DIOINFO: {
 		struct dioattr	da;
-		xfs_buftarg_t	*target =
-			XFS_IS_REALTIME_INODE(ip) ?
-			mp->m_rtdev_targp : mp->m_ddev_targp;
 
-		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
-		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
+		if (IS_DAX(inode)) {
+			/* pmem is byte addressable */
+			da.d_mem = 1;
+			da.d_miniosz = 1;
+			da.d_maxiosz = INT_MAX;
+		} else {
+			xfs_buftarg_t	*target =
+				XFS_IS_REALTIME_INODE(ip) ?
+				mp->m_rtdev_targp : mp->m_ddev_targp;
+
+			da.d_mem = target->bt_logical_sectorsize;
+			da.d_miniosz = target->bt_logical_sectorsize;
+			da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
+		}
 
 		if (copy_to_user(arg, &da, sizeof(da)))
 			return -EFAULT;
