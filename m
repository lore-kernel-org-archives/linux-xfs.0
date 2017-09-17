Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39469 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752067AbdIQVHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:20 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/47] xfs: fix quotacheck dquot id overflow infinite loop
Date: Sun, 17 Sep 2017 14:06:39 -0700
Message-Id: <20170917210712.10804-15-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit cfaf2d034360166e569a4929dd83ae9698bed856 upstream.

If a dquot has an id of U32_MAX, the next lookup index increment
overflows the uint32_t back to 0. This starts the lookup sequence
over from the beginning, repeats indefinitely and results in a
livelock.

Update xfs_qm_dquot_walk() to explicitly check for the lookup
overflow and exit the loop.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 8068867a8183..1fdd3face2d9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -111,6 +111,9 @@ xfs_qm_dquot_walk(
 			skipped = 0;
 			break;
 		}
+		/* we're done if id overflows back to zero */
+		if (!next_index)
+			break;
 	}
 
 	if (skipped) {
-- 
2.14.1

