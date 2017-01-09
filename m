Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57244 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934484AbdAIPjf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:35 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/32] xfs: always succeed when deduping zero bytes
Date: Mon,  9 Jan 2017 16:38:41 +0100
Message-Id: <1483976343-661-11-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit fba3e594ef0ad911fa8f559732d588172f212d71 upstream.

It turns out that btrfs and xfs had differing interpretations of what
to do when the dedupe length is zero.  Change xfs to follow btrfs'
semantics so that the userland interface is consistent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_reflink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0edf835..4d99100 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1345,8 +1345,14 @@ xfs_reflink_remap_range(
 		goto out_unlock;
 	}
 
-	if (len == 0)
+	/* Zero length dedupe exits immediately; reflink goes to EOF. */
+	if (len == 0) {
+		if (is_dedupe) {
+			ret = 0;
+			goto out_unlock;
+		}
 		len = isize - pos_in;
+	}
 
 	/* Ensure offsets don't wrap and the input is inside i_size */
 	if (pos_in + len < pos_in || pos_out + len < pos_out ||
-- 
2.1.4

