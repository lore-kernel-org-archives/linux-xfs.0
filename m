Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D55797F55
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 08:45:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C38448F804B
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 06:45:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CjLJQovjKh5wwJ6U (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jul 2015 06:45:40 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 199CE19CF3E
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 13:45:40 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-63.bos.redhat.com [10.18.41.63])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t6DDjd9M002561
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 09:45:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: close xc_cil list_empty() races with cil commit
	sequence
Date: Mon, 13 Jul 2015 09:45:38 -0400
Message-Id: <1436795138-53887-1-git-send-email-bfoster@redhat.com>
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

We have seen somewhat rare reports of the following assert from
xlog_cil_push_background() failing during ltp tests or somewhat
innocuous desktop root fs workloads (e.g., virt operations, initramfs
construction):

    ASSERT(!list_empty(&cil->xc_cil));

The reasoning behind the assert is that the transaction has inserted
items to the CIL and hit background push codepath all with
cil->xc_ctx_lock held for reading. This locks out background commit from
emptying the CIL, which acquires the lock for writing. Therefore, the
reasoning is that the items previously inserted in the CIL should still
be present.

The cil->xc_ctx_lock read lock is not sufficient to protect the xc_cil
list, however, due to how CIL insertion is handled.
xlog_cil_insert_items() inserts and reorders the dirty transaction items
to the tail of the CIL under xc_cil_lock. It uses list_move_tail() to
achieve insertion and reordering in the same block of code. This
function removes and reinserts an item to the tail of the list. If a
transaction commits an item that was already logged and thus already
resides in the CIL, and said item is the sole item on the list, the
removal and reinsertion creates a temporary state where the list is
actually empty.

This state is not valid and thus should never be observed by concurrent
transaction commit-side checks in the circumstances outlined above. We
do not want to acquire the xc_cil_lock in all of these instances as it
was previously removed and replaced with a separate push lock for
performance reasons. Therefore, close any races with list_empty() on the
insertion side by ensuring that the list is never in a transient empty
state.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Close the race on the insert side by not removing/reinserting an item
  if already at the tail.
v1: http://oss.sgi.com/archives/xfs/2015-06/msg00389.html

 fs/xfs/xfs_log_cil.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index abc2ccb..4e76493 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -307,7 +307,13 @@ xlog_cil_insert_items(
 		if (!(lidp->lid_flags & XFS_LID_DIRTY))
 			continue;
 
-		list_move_tail(&lip->li_cil, &cil->xc_cil);
+		/*
+		 * Only move the item if it isn't already at the tail. This is
+		 * to prevent a transient list_empty() state when reinserting
+		 * an item that is already the only item in the CIL.
+		 */
+		if (!list_is_last(&lip->li_cil, &cil->xc_cil))
+			list_move_tail(&lip->li_cil, &cil->xc_cil);
 	}
 
 	/* account for space used by new iovec headers  */
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
