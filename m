Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E78E37FEC
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 21:19:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB3CD304053
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 19:19:20 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0bVgMfoHVFvi8Ui2 for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 19:19:18 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XXL7q-0000Rn-RW
	for xfs@oss.sgi.com; Fri, 26 Sep 2014 12:19:14 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XXL7q-0006SI-Qk
	for xfs@oss.sgi.com; Fri, 26 Sep 2014 12:19:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] xfs: refactor recovery transaction start handling
Date: Fri, 26 Sep 2014 12:19:12 +1000
Message-Id: <1411697952-24741-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1411697952-24741-1-git-send-email-david@fromorbit.com>
References: <1411697952-24741-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Rework the transaction lookup and allocation code in
xlog_recovery_process_ophdr() to remove fold two related call-once
helper functions into a single helper. Then fold in all
XLOG_START_TRANS logic to that helper to clean up the remaining
logic in xlog_recovery_process_ophdr().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 77 +++++++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e4fd4b1..6e861ba 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3351,38 +3351,6 @@ out:
 	return error ? error : error2;
 }
 
-
-STATIC xlog_recover_t *
-xlog_recover_find_tid(
-	struct hlist_head	*head,
-	xlog_tid_t		tid)
-{
-	xlog_recover_t		*trans;
-
-	hlist_for_each_entry(trans, head, r_list) {
-		if (trans->r_log_tid == tid)
-			return trans;
-	}
-	return NULL;
-}
-
-STATIC void
-xlog_recover_new_tid(
-	struct hlist_head	*head,
-	xlog_tid_t		tid,
-	xfs_lsn_t		lsn)
-{
-	xlog_recover_t		*trans;
-
-	trans = kmem_zalloc(sizeof(xlog_recover_t), KM_SLEEP);
-	trans->r_log_tid   = tid;
-	trans->r_lsn	   = lsn;
-	INIT_LIST_HEAD(&trans->r_itemq);
-
-	INIT_HLIST_NODE(&trans->r_list);
-	hlist_add_head(&trans->r_list, head);
-}
-
 STATIC void
 xlog_recover_add_item(
 	struct list_head	*head)
@@ -3505,6 +3473,7 @@ xlog_recover_add_to_trans(
 	trace_xfs_log_recover_item_add(log, trans, item, 0);
 	return 0;
 }
+
 /*
  * Free up any resources allocated by the transaction
  *
@@ -3587,6 +3556,13 @@ xlog_recovery_process_trans(
 	return error;
 }
 
+/*
+ * Lookup the transaction recovery structure associated with the ID in the
+ * current ophdr. If the transaction doesn't exist and the start flag is set in
+ * the ophdr, then allocate a new transaction for future ID matches to find.
+ * Either way, return what we found during the lookup - an existing transaction
+ * or nothing.
+ */
 STATIC struct xlog_recover *
 xlog_recover_ophdr_to_trans(
 	struct hlist_head	rhash[],
@@ -3599,20 +3575,35 @@ xlog_recover_ophdr_to_trans(
 
 	tid = be32_to_cpu(ohead->oh_tid);
 	rhp = &rhash[XLOG_RHASH(tid)];
-	trans = xlog_recover_find_tid(rhp, tid);
-	if (trans)
-		return trans;
+	hlist_for_each_entry(trans, rhp, r_list) {
+		if (trans->r_log_tid == tid)
+			return trans;
+	}
 
 	/*
-	 * If this is a new transaction, the ophdr only contains the
-	 * start record. In that case, the only processing we need to do
-	 * on this opheader is allocate a new recovery container to hold
-	 * the recovery ops that will follow.
+	 * skip over non-start transaction headers - we could be
+	 * processing slack space before the next transaction starts
+	 */
+	if (!(ohead->oh_flags & XLOG_START_TRANS))
+		return NULL;
+
+	ASSERT(be32_to_cpu(ohead->oh_len) == 0);
+
+	/*
+	 * This is a new transaction so allocate a new recovery container to
+	 * hold the recovery ops that will follow.
+	 */
+	trans = kmem_zalloc(sizeof(struct xlog_recover), KM_SLEEP);
+	trans->r_log_tid = tid;
+	trans->r_lsn = be64_to_cpu(rhead->h_lsn);
+	INIT_LIST_HEAD(&trans->r_itemq);
+	INIT_HLIST_NODE(&trans->r_list);
+	hlist_add_head(&trans->r_list, rhp);
+
+	/*
+	 * Nothing more to do for this ophdr. Items to be added to this new
+	 * transaction will be in subsequent ophdr containers.
 	 */
-	if (ohead->oh_flags & XLOG_START_TRANS) {
-		ASSERT(be32_to_cpu(ohead->oh_len) == 0);
-		xlog_recover_new_tid(rhp, tid, be64_to_cpu(rhead->h_lsn));
-	}
 	return NULL;
 }
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
