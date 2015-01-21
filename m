Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6383C7F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 18:40:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43B34304053
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 16:39:59 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2giH1K7OPv8CTqPD for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 16:39:57 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: ensure buffer types are set correctly
Date: Wed, 21 Jan 2015 11:39:38 +1100
Message-Id: <1421800780-26008-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1421800780-26008-1-git-send-email-david@fromorbit.com>
References: <1421800780-26008-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

Jan Kara reported that log recovery was finding buffers with invalid
types in them. This should not happen, and indicates a bug in the
logging of buffers. To catch this, add asserts to the buffer
formatting code to ensure that the buffer type is in range when the
transaction is committed.

We don't set a type on buffers being marked stale - they are not
going to get replayed, the format item exists only for recovery to
be able to prevent replay of the buffer, so the type does not
matter. Hence that needs special casing here.

Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 925ead2..507d96a 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -319,6 +319,10 @@ xfs_buf_item_format(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
+	ASSERT((bip->bli_flags & XFS_BLI_STALE) ||
+	       (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF
+	        && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF));
+
 
 	/*
 	 * If it is an inode buffer, transfer the in-memory state to the
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
