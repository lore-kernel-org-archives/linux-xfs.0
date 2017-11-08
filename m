Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43857 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbdKHA0l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2017 19:26:41 -0500
Date: Tue, 7 Nov 2017 16:26:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_repair: always release btree buffers when refcountbt
 checks fail
Message-ID: <20171108002636.GD26910@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

During phase 4 of repair, we compare the refcount records we've computed
against what's in the refcount btree.  If the btree is corrupt the
libxfs refcount calls will fail, but on our way out of the function we
don't make sure to clear all the btree cursor's buffer pointers.  This
leads to a repair deadlock in xfs/372 when fuzzing ptrs[1] to -1U
because we forgot to release a buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/rmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/repair/rmap.c b/repair/rmap.c
index 01d6f0f..d51590b 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1359,7 +1359,8 @@ _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) le
 
 err:
 	if (bt_cur)
-		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+		libxfs_btree_del_cursor(bt_cur, error ? XFS_BTREE_ERROR :
+							XFS_BTREE_NOERROR);
 	if (agbp)
 		libxfs_putbuf(agbp);
 	free_slab_cursor(&rl_cur);
