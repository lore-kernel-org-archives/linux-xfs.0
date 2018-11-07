Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:35267 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbeKHFm6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Nov 2018 00:42:58 -0500
Received: by mail-yw1-f66.google.com with SMTP id w135-v6so7110231ywd.2
        for <linux-xfs@vger.kernel.org>; Wed, 07 Nov 2018 12:11:02 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 2/2] xfs: take a ref on failed bufs in xfs_inode_item_push
Date: Wed,  7 Nov 2018 15:10:55 -0500
Message-Id: <20181107201055.25883-3-josef@toxicpanda.com>
In-Reply-To: <20181107201055.25883-1-josef@toxicpanda.com>
References: <20181107201055.25883-1-josef@toxicpanda.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: kernel-team@fb.com, linux-xfs@vger.kernel.org

If we failed to writeout a xfs_buf we'll grab a ref for it and put it on
li->li_buf.  Then when submitting the failed bufs we'll clear LI_FAILED
on the li, which clears the LI_FAILED flag, but also drops the ref on
the buf.  Since it isn't on a IO list at this point this could very well
be the last ref on the buf, which wreaks havoc when we go to add the buf
to the delwrite list.  Fix this by holding a ref on the buf before we
call xfs_buf_resubmit_failed_buffers in order to make sure the buf
doesn't disappear before we're able to clear the error and add it to the
delwri list.  This fixes the panics I was seeing with error injection.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_inode_item.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fa1c4fe2ffbf..df49adf1989c 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -503,13 +503,16 @@ xfs_inode_item_push(
 	 * previously. Resubmit the buffer for IO.
 	 */
 	if (test_bit(XFS_LI_FAILED, &lip->li_flags)) {
-		if (!xfs_buf_trylock(bp))
+		xfs_buf_hold(bp);
+		if (!xfs_buf_trylock(bp)) {
+			xfs_buf_rele(bp);
 			return XFS_ITEM_LOCKED;
+		}
 
 		if (!xfs_buf_resubmit_failed_buffers(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
 
-		xfs_buf_unlock(bp);
+		xfs_buf_relse(bp);
 		return rval;
 	}
 
-- 
2.14.3
