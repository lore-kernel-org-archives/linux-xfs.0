Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37852 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751739AbeFGWBY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 18:01:24 -0400
Subject: Re: NULL pointer dereference in xfs_trans_binval() when mounting and
 operating a crafted xfs image
References: <66348561-0B03-4CAE-893A-25161D66D6AF@gatech.edu>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fff2a2c8-b607-05ea-e97e-f53f054fb428@sandeen.net>
Date: Thu, 7 Jun 2018 17:01:22 -0500
MIME-Version: 1.0
In-Reply-To: <66348561-0B03-4CAE-893A-25161D66D6AF@gatech.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Xu, Wen" <wen.xu@gatech.edu>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On 6/7/18 3:41 PM, Xu, Wen wrote:
> Dear XFS developers,
> 
> There is a NULL pointer dereference in xfs_trans_binval() when mounting and operating a crafted xfs image in 4.17-rc7 w/ for-next branch found by fuzzing.

...

> - Reason
> https://elixir.bootlin.com/linux/latest/source/fs/xfs/xfs_trans_buf.c#L610
> bp is NULL when calling xfs_trans_binval().

Yep, it looks like xfs_da_shrink_inode can error out before allocating
bp (i.e. in this case with an out of bounds blkno).  Does this fix it?

=========

xfs: don't call xfs_da_shrink_inode with NULL bp

xfs_attr3_leaf_create may have errored out before instantiating a buffer,
for example if the blkno is out of range.  In that case there is no work 
to do to remove it, and in fact xfs_da_shrink_inode will lead to an oops
if we try.

This also seems to fix a flaw where the original error from
xfs_attr3_leaf_create gets overwritten in the cleanup case, and it
removes a pointless assignment to bp which isn't used after this.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199969
Reported-by: Xu, Wen <wen.xu@gatech.edu>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

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


