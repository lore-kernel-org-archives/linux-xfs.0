Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751782AbdGEQQ3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jul 2017 12:16:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix contiguous dquot chunk iteration livelock
Date: Wed,  5 Jul 2017 12:16:27 -0400
Message-Id: <20170705161627.52734-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>

The patch below updated xfs_dq_get_next_id() to use the XFS iext
lookup helpers to locate the next quota id rather than to seek for
data in the quota file. The updated code fails to correctly handle
the case where the quota inode might have contiguous chunks part of
the same extent. In this case, the start block offset is calculated
based on the next expected id but the extent lookup returns the same
start offset as for the previous chunk. This causes the returned id
to go backwards and livelocks the quota iteration. This problem is
reproduced intermittently by generic/232.

To handle this case, check whether the startoff from the extent
lookup is behind the startoff calculated from the next quota id. If
so, bump up got.br_startoff to the specific file offset that is
expected to hold the next dquot chunk.

Fixes: bda250dbaf39 ("xfs: rewrite xfs_dq_get_next_id using xfs_iext_lookup_extent")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is still undergoing testing, but otherwise fixes the problem I've
observed with generic/232.

Brian

 fs/xfs/xfs_dquot.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8848b39..f89f7b52 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -733,10 +733,15 @@ xfs_dq_get_next_id(
 			return error;
 	}
 
-	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &idx, &got))
+	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &idx, &got)) {
+		/* contiguous chunk, bump startoff for the id calculation */
+		if (got.br_startoff < start)
+			got.br_startoff = start;
 		*id = got.br_startoff * mp->m_quotainfo->qi_dqperchunk;
-	else
+	} else {
 		error = -ENOENT;
+	}
+
 	xfs_iunlock(quotip, lock_flags);
 
 	return error;
-- 
2.9.4

