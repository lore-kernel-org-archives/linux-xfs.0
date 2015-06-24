Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8524D7F60
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 09:04:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0440DAC001
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 07:04:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OZI66j50zeq8YfXM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2015 07:04:03 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 45BF1AED7A
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 14:04:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t5OE42dG019873
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 10:04:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: close xc_cil list_empty() races with cil commit sequence
Date: Wed, 24 Jun 2015 10:04:01 -0400
Message-Id: <1435154641-7790-1-git-send-email-bfoster@redhat.com>
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
transaction commit-side checks in the circumstances outlined above.
Update all of the xc_cil checks to acquire xc_cil_lock before assessing
the state of xc_cil.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index abc2ccb..324d449 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -687,7 +687,7 @@ xlog_cil_push_background(
 	 * The cil won't be empty because we are called while holding the
 	 * context lock so whatever we added to the CIL will still be there
 	 */
-	ASSERT(!list_empty(&cil->xc_cil));
+	ASSERT(!xlog_cil_empty(log));
 
 	/*
 	 * don't do a background push if we haven't used up all the
@@ -731,13 +731,17 @@ xlog_cil_push_now(
 	 * there's no work we need to do.
 	 */
 	spin_lock(&cil->xc_push_lock);
+	spin_lock(&cil->xc_cil_lock);
 	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
+		spin_unlock(&cil->xc_cil_lock);
 		spin_unlock(&cil->xc_push_lock);
 		return;
 	}
+	spin_unlock(&cil->xc_cil_lock);
 
 	cil->xc_push_seq = push_seq;
 	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
+
 	spin_unlock(&cil->xc_push_lock);
 }
 
@@ -749,8 +753,10 @@ xlog_cil_empty(
 	bool		empty = false;
 
 	spin_lock(&cil->xc_push_lock);
+	spin_lock(&cil->xc_cil_lock);
 	if (list_empty(&cil->xc_cil))
 		empty = true;
+	spin_unlock(&cil->xc_cil_lock);
 	spin_unlock(&cil->xc_push_lock);
 	return empty;
 }
@@ -887,12 +893,15 @@ restart:
 	 * it means we haven't yet started the push, because if it had started
 	 * we would have found the context on the committing list.
 	 */
+	spin_lock(&cil->xc_cil_lock);
 	if (sequence == cil->xc_current_sequence &&
 	    !list_empty(&cil->xc_cil)) {
+		spin_unlock(&cil->xc_cil_lock);
 		spin_unlock(&cil->xc_push_lock);
 		goto restart;
 	}
 
+	spin_unlock(&cil->xc_cil_lock);
 	spin_unlock(&cil->xc_push_lock);
 	return commit_lsn;
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
