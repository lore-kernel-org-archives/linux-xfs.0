Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 82ECB7F54
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 20:21:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 71961304053
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 18:21:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YtZnR3ewXlZvKtbN for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 18:21:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XM5SC-0000KC-6h
	for xfs@oss.sgi.com; Tue, 26 Aug 2014 11:21:44 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XM5SC-0002UN-62
	for xfs@oss.sgi.com; Tue, 26 Aug 2014 11:21:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: fix double free in xlog_recover_commit_trans
Date: Tue, 26 Aug 2014 11:21:40 +1000
Message-Id: <1409016101-9511-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1409016101-9511-1-git-send-email-david@fromorbit.com>
References: <1409016101-9511-1-git-send-email-david@fromorbit.com>
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

When an error occurs during buffer submission in
xlog_recover_commit_trans(), we free the trans structure twice. Fix
it by only freeing the structure in the caller regardless of the
success or failure of the function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 460cf98..23895d5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3524,8 +3524,6 @@ out:
 	if (!list_empty(&done_list))
 		list_splice_init(&done_list, &trans->r_itemq);
 
-	xlog_recover_free_trans(trans);
-
 	error2 = xfs_buf_delwri_submit(&buffer_list);
 	return error ? error : error2;
 }
@@ -3571,6 +3569,11 @@ xlog_recovery_process_ophdr(
 	if (flags & XLOG_WAS_CONT_TRANS)
 		flags &= ~XLOG_CONTINUE_TRANS;
 
+	/*
+	 * Callees must not free the trans structure. We own it, so we'll decide
+	 * if we need to free it or not based on the operation being done and
+	 * it's result.
+	 */
 	switch (flags) {
 	/* expected flag values */
 	case 0:
@@ -3582,7 +3585,8 @@ xlog_recovery_process_ophdr(
 		break;
 	case XLOG_COMMIT_TRANS:
 		error = xlog_recover_commit_trans(log, trans, pass);
-		break;
+		xlog_recover_free_trans(trans);
+		return error;
 
 	/* unexpected flag values */
 	case XLOG_UNMOUNT_TRANS:
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
