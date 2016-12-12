Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751652AbcLLWA2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Dec 2016 17:00:28 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: handle error if xfs_btree_get_bufs fails
Message-ID: <4348f961-deda-8733-1cd7-dd7ca646bb6b@redhat.com>
Date: Mon, 12 Dec 2016 16:00:26 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Jason L Tibbitts III <tibbs@math.uh.edu>

Jason reported that a corrupted filesystem failed to replay
the log with a metadata block out of bounds warning:

XFS (dm-2): _xfs_buf_find: Block out of range: block 0x80270fff8, EOFS 0x9c40000 

_xfs_buf_find() and xfs_btree_get_bufs() return NULL if
that happens, and then when xfs_alloc_fix_freelist() calls
xfs_trans_binval() on that NULL bp, we oops with:

BUG: unable to handle kernel NULL pointer dereference at 00000000000000f8

We don't handle _xfs_buf_find errors very well, every
caller higher up the stack gets to guess at why it failed.
But we should at least handle it somehow.  I chose EIO here
for lack of a better idea.  :)

Reported-by: Jason L Tibbitts III <tibbs@math.uh.edu>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index effb64c..d125135 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1640,6 +1640,10 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 
 				bp = xfs_btree_get_bufs(args->mp, args->tp,
 					args->agno, fbno, 0);
+				if (!bp) {
+					error = -EIO;
+					goto error0;
+				}
 				xfs_trans_binval(args->tp, bp);
 			}
 			args->len = 1;
@@ -2185,6 +2189,10 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		if (error)
 			goto out_agbp_relse;
 		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
+		if (!bp) {
+			error = -EIO;
+			goto out_agbp_relse;
+		}
 		xfs_trans_binval(tp, bp);
 	}
 

