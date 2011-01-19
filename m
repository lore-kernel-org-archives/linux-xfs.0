Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0J4TJcM179275 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 22:29:19 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87D2C1621768
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 20:31:36 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	UHAarZUiiOjnuGIJ for <xfs@oss.sgi.com>;
	Tue, 18 Jan 2011 20:31:36 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PfPhc-0007Et-Kp
	for xfs@oss.sgi.com; Wed, 19 Jan 2011 15:31:24 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PfPgJ-000456-CS
	for xfs@oss.sgi.com; Wed, 19 Jan 2011 15:30:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] xfs: handle CIl transaction commit failures correctly
Date: Wed, 19 Jan 2011 15:30:00 +1100
Message-Id: <1295411400-15614-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1295411400-15614-1-git-send-email-david@fromorbit.com>
References: <1295411400-15614-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Failure to commit a transaction into the CIL is not handled
correctly. This currently can only happen when racing with a
shutdown, so it rare. Handle the error similar to a log vector
memory allocation failure, and for both failures clear the PF_TRANS
flag from the task correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 50753d3..504a804 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1754,15 +1754,26 @@ xfs_trans_commit_cil(
 	 */
 	log_vector = xfs_trans_alloc_log_vecs(tp);
 	if (!log_vector)
-		return ENOMEM;
+		goto out_enomem;
 
 	error = xfs_log_commit_cil(mp, tp, log_vector, commit_lsn, flags);
-	if (error)
-		return error;
+	if (error) {
+		/*
+		 * We will only get an error if no modifications have been
+		 * made to the items in the transaction. Hence treat it
+		  the same as a memory allocation failure.
+		 */
+		goto out_enomem;
+	}
 
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 	xfs_trans_free(tp);
 	return 0;
+
+out_enomem:
+	/* caller cleans up transaction */
+	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	return ENOMEM;
 }
 
 /*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
