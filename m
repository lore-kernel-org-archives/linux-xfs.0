Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38242 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751643AbeFHQwO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Jun 2018 12:52:14 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfs: don't call xfs_da_shrink_inode with NULL bp
Message-ID: <7e14237d-cd66-a6bf-7634-f120fcd782b3@sandeen.net>
Date: Fri, 8 Jun 2018 11:52:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: "Xu, Wen" <wen.xu@gatech.edu>

xfs_attr3_leaf_create may have errored out before instantiating a buffer,
for example if the blkno is out of range.  In that case there is no work 
to do to remove it, and in fact xfs_da_shrink_inode will lead to an oops
if we try.

This also seems to fix a flaw where the original error from
xfs_attr3_leaf_create gets overwritten in the cleanup case, and it
removes a pointless assignment to bp which isn't used after this.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199969
Reported-by: Xu, Wen <wen.xu@gatech.edu>
Tested-by: Xu, Wen <wen.xu@gatech.edu>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

NB: I've not regression tested this yet, just going on the reporter's
positive test result.

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2135b8e..397699d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -803,9 +803,8 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 	ASSERT(blkno == 0);
 	error = xfs_attr3_leaf_create(args, blkno, &bp);
 	if (error) {
-		error = xfs_da_shrink_inode(args, 0, bp);
-		bp = NULL;
-		if (error)
+		/* xfs_attr3_leaf_create may not have instantiated a block */
+		if (bp && (xfs_da_shrink_inode(args, 0, bp) != 0))
 			goto out;
 		xfs_idata_realloc(dp, size, XFS_ATTR_FORK);	/* try to put */
 		memcpy(ifp->if_u1.if_data, tmpbuffer, size);	/* it back */


