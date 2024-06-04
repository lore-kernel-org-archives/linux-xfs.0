Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B36136E26;
	Tue,  4 Jun 2024 07:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717485092; cv=none; b=AAL9o6VBQse4gITez5+VAYQ14NPGV6r+I9zOMS7PZkfvD4Ul6aMBpn9Gto9uXjIANXiNPpozOd4iXkVeDlK0U/B0t22aJHlecnQBxB4S5cRNRl0uCbH/qkaQomQ6pILacfiv42sUYpCw4oBRIzBuWzhliKxxTDD67k9FHFaX2Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717485092; c=relaxed/simple;
	bh=W2c34FCQdVhwAmVoWTiAiA+rMqfuCMI5Bep5ss1y2mk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=taRrRGks027fO6Lf1wOw95whHskDBioyghe0AeuMmIpHtWGKvRRG+XNWIWGvhPEvcgSmnnpX1CF/UWoGQ+ONrXDRXiA8V4C+xArQjndRz/L/keohGduPQPOiC7is9AWYXS11YeDSN4Ky+NIAzDGBiQ2QjICYObwc1kZud9OtQxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VthVl2PX4zwRVR;
	Tue,  4 Jun 2024 15:07:27 +0800 (CST)
Received: from canpemm500010.china.huawei.com (unknown [7.192.105.118])
	by mail.maildlp.com (Postfix) with ESMTPS id 757F1180AA6;
	Tue,  4 Jun 2024 15:11:22 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 4 Jun 2024 15:11:17 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<wozizhi@huawei.com>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>
Subject: [PATCH] xfs: Fix file creation failure
Date: Tue, 4 Jun 2024 15:11:21 +0800
Message-ID: <20240604071121.3981686-1-wozizhi@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)

We have an xfs image that contains only 2 AGs, the first AG is full and
the second AG is empty, then a concurrent file creation and little writing
could unexpectedly return -ENOSPC error since there is a race window that
the allocator could get the wrong agf->agf_longest.

Write file process steps:
1) Find the entry that best meets the conditions, then calculate the start
address and length of the remaining part of the entry after allocation.
2) Delete this entry. Because the second AG is empty, the btree in its agf
has only one record, and agf->agf_longest will be set to 0 after deletion.
3) Insert the remaining unused parts of this entry based on the
calculations in 1), and update the agf->agf_longest.

Create file process steps:
1) Check whether there are free inodes in the inode chunk.
2) If there is no free inode, check whether there has space for creating
inode chunks, perform the no-lock judgment first.
3) If the judgment succeeds, the judgment is performed again with agf lock
held. Otherwire, an error is returned directly.

If the write process is in step 2) but not go to 3) yet, the create file
process goes to 2) at this time, it will be mistaken for no space,
resulting in the file system still has space but the file creation fails.

	Direct write				Create file
xfs_file_write_iter
 ...
 xfs_direct_write_iomap_begin
  xfs_iomap_write_direct
   ...
   xfs_alloc_ag_vextent_near
    xfs_alloc_cur_finish
     xfs_alloc_fixup_trees
      xfs_btree_delete
       xfs_btree_delrec
	xfs_allocbt_update_lastrec
	// longest = 0 because numrec == 0.
	 agf->agf_longest = len = 0
					   xfs_create
					    ...
					     xfs_dialloc
					      ...
					      xfs_alloc_fix_freelist
					       xfs_alloc_space_available
					-> as longest=0, it will return
					false, no space for inode alloc.

Fix this issue by adding the bc_free_longest field to the xfs_btree_cur_t
structure to store the potential longest count that will be updated. The
assignment is done in xfs_alloc_fixup_trees() and xfs_free_ag_extent().

Reported by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/libxfs/xfs_alloc.c       | 14 ++++++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.c |  9 ++++++++-
 fs/xfs/libxfs/xfs_btree.h       |  1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6c55a6e88eba..86ba873d57a8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -577,6 +577,13 @@ xfs_alloc_fixup_trees(
 		nfbno2 = rbno + rlen;
 		nflen2 = (fbno + flen) - nfbno2;
 	}
+
+	/*
+	 * Record the potential maximum free length in advance.
+	 */
+	if (nfbno1 != NULLAGBLOCK || nfbno2 != NULLAGBLOCK)
+		cnt_cur->bc_ag.bc_free_longest = XFS_EXTLEN_MAX(nflen1, nflen2);
+
 	/*
 	 * Delete the entry from the by-size btree.
 	 */
@@ -2044,6 +2051,13 @@ xfs_free_ag_extent(
 	 * Now allocate and initialize a cursor for the by-size tree.
 	 */
 	cnt_cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
+	/*
+	 * Record the potential maximum free length in advance.
+	 */
+	if (haveleft)
+		cnt_cur->bc_ag.bc_free_longest = ltlen;
+	if (haveright)
+		cnt_cur->bc_ag.bc_free_longest = gtlen;
 	/*
 	 * Have both left and right contiguous neighbors.
 	 * Merge all three into a single free block.
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 6ef5ddd89600..8e7d1e0f1a63 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -161,7 +161,14 @@ xfs_allocbt_update_lastrec(
 			rrp = XFS_ALLOC_REC_ADDR(cur->bc_mp, block, numrecs);
 			len = rrp->ar_blockcount;
 		} else {
-			len = 0;
+			/*
+			 * Update in advance to prevent file creation failure
+			 * for concurrent processes even though there is no
+			 * numrec currently.
+			 * And there's no need to worry as the value that no
+			 * less than bc_free_longest will be inserted later.
+			 */
+			len = cpu_to_be32(cur->bc_ag.bc_free_longest);
 		}
 
 		break;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index f93374278aa1..985b1885a643 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -281,6 +281,7 @@ struct xfs_btree_cur
 			struct xfs_perag	*pag;
 			struct xfs_buf		*agbp;
 			struct xbtree_afakeroot	*afake;	/* for staging cursor */
+			xfs_extlen_t		bc_free_longest; /* potential longest free space */
 		} bc_ag;
 		struct {
 			struct xfbtree		*xfbtree;
-- 
2.39.2

