Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B7D557FEC
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 21:19:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 97B358F8035
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 19:19:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kixLZU78qW3A15Uk for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 19:19:20 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XXL7q-0000Rl-QX
	for xfs@oss.sgi.com; Fri, 26 Sep 2014 12:19:14 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XXL7q-0006S8-Px
	for xfs@oss.sgi.com; Fri, 26 Sep 2014 12:19:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: fix double free in xlog_recover_commit_trans
Date: Fri, 26 Sep 2014 12:19:10 +1000
Message-Id: <1411697952-24741-4-git-send-email-david@fromorbit.com>
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

When an error occurs during buffer submission in
xlog_recover_commit_trans(), we free the trans structure twice. Fix
it by only freeing the structure in the caller regardless of the
success or failure of the function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 685e98b..28eb078 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3526,8 +3526,6 @@ out:
 	if (!list_empty(&done_list))
 		list_splice_init(&done_list, &trans->r_itemq);
 
-	xlog_recover_free_trans(trans);
-
 	error2 = xfs_buf_delwri_submit(&buffer_list);
 	return error ? error : error2;
 }
@@ -3552,6 +3550,10 @@ xlog_recovery_process_trans(
 	if (flags & XLOG_WAS_CONT_TRANS)
 		flags &= ~XLOG_CONTINUE_TRANS;
 
+	/*
+	 * Callees must not free the trans structure. We'll decide if we need to
+	 * free it or not based on the operation being done and it's result.
+	 */
 	switch (flags) {
 	/* expected flag values */
 	case 0:
@@ -3563,6 +3565,8 @@ xlog_recovery_process_trans(
 		break;
 	case XLOG_COMMIT_TRANS:
 		error = xlog_recover_commit_trans(log, trans, pass);
+		/* success or fail, we are now done with this transaction. */
+		freeit = true;
 		break;
 
 	/* unexpected flag values */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
