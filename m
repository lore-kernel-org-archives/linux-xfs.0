Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58310 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938502AbdAIPj6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:58 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/32] xfs: pass state not whichfork to trace_xfs_extlist
Date: Mon,  9 Jan 2017 16:38:49 +0100
Message-Id: <1483976343-661-19-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>

From: Eric Sandeen <sandeen@sandeen.net>

commit 7710517fc37b1899722707883b54694ea710b3c0 upstream.

When xfs_bmap_trace_exlist called trace_xfs_extlist,
it sent in the "whichfork" var instead of the bmap "state"
as expected (even though state was already set up for this
purpose).

As a result, the xfs_bmap_class in tracing code used
"whichfork" not state in xfs_iext_state_to_fork(), and got
the wrong ifork pointer.  It all goes downhill from
there, including an ASSERT when ifp_bytes is empty
by the time it reaches xfs_iext_get_ext():

XFS: Assertion failed: idx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index aab523a..cfd1fdd 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -531,7 +531,7 @@ xfs_bmap_trace_exlist(
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(cnt == xfs_iext_count(ifp));
 	for (idx = 0; idx < cnt; idx++)
-		trace_xfs_extlist(ip, idx, whichfork, caller_ip);
+		trace_xfs_extlist(ip, idx, state, caller_ip);
 }
 
 /*
-- 
2.1.4

