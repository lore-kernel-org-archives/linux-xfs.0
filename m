Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59438 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbcLAXGH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 18:06:07 -0500
Subject: [PATCH 1/2] xfs: pass state not whichfork to trace_xfs_extlist
References: <1a77ccd9-ec67-f5b7-f786-35c913334337@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <59e5ee2c-f6ad-60e0-3420-47a6adc7cff8@sandeen.net>
Date: Thu, 1 Dec 2016 17:06:04 -0600
MIME-Version: 1.0
In-Reply-To: <1a77ccd9-ec67-f5b7-f786-35c913334337@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

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
---

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c27344c..b085f9b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -517,7 +517,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(cnt == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)));
 	for (idx = 0; idx < cnt; idx++)
-		trace_xfs_extlist(ip, idx, whichfork, caller_ip);
+		trace_xfs_extlist(ip, idx, state, caller_ip);
 }
 
 /*


