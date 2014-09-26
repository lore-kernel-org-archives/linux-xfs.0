Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B54847FE2
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 21:19:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B221304032
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 19:19:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	V6TrmCnOkGMpe9b4 for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 19:19:19 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XXL7q-0000Rk-QE
	for xfs@oss.sgi.com; Fri, 26 Sep 2014 12:19:14 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XXL7q-0006S3-Pd
	for xfs@oss.sgi.com; Fri, 26 Sep 2014 12:19:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: recovery of XLOG_UNMOUNT_TRANS leaks memory
Date: Fri, 26 Sep 2014 12:19:09 +1000
Message-Id: <1411697952-24741-3-git-send-email-david@fromorbit.com>
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

The XLOG_UNMOUNT_TRANS case skips the transaction, despite the fact
an unmount record is always in a standalone transaction. Hence
whenever we come across one of these we need to free the transaction
structure associated with it as there is no commit record that
follows it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b5e081b..685e98b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3532,6 +3532,9 @@ out:
 	return error ? error : error2;
 }
 
+/*
+ * On error or completion, trans is freed.
+ */
 STATIC int
 xlog_recovery_process_trans(
 	struct xlog		*log,
@@ -3541,7 +3544,8 @@ xlog_recovery_process_trans(
 	unsigned int		flags,
 	int			pass)
 {
-	int			error = -EIO;
+	int			error = 0;
+	bool			freeit = false;
 
 	/* mask off ophdr transaction container flags */
 	flags &= ~XLOG_END_TRANS;
@@ -3563,18 +3567,19 @@ xlog_recovery_process_trans(
 
 	/* unexpected flag values */
 	case XLOG_UNMOUNT_TRANS:
+		/* just skip trans */
 		xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
-		error = 0; /* just skip trans */
+		freeit = true;
 		break;
 	case XLOG_START_TRANS:
-		xfs_warn(log->l_mp, "%s: bad transaction", __func__);
-		ASSERT(0);
-		break;
 	default:
 		xfs_warn(log->l_mp, "%s: bad flag 0x%x", __func__, flags);
 		ASSERT(0);
+		error = -EIO;
 		break;
 	}
+	if (error || freeit)
+		xlog_recover_free_trans(trans);
 	return error;
 }
 
@@ -3600,8 +3605,10 @@ xlog_recover_ophdr_to_trans(
 	 * on this opheader is allocate a new recovery container to hold
 	 * the recovery ops that will follow.
 	 */
-	if (ohead->oh_flags & XLOG_START_TRANS)
+	if (ohead->oh_flags & XLOG_START_TRANS) {
+		ASSERT(be32_to_cpu(ohead->oh_len) == 0);
 		xlog_recover_new_tid(rhp, tid, be64_to_cpu(rhead->h_lsn));
+	}
 	return NULL;
 }
 
@@ -3616,7 +3623,6 @@ xlog_recover_process_ophdr(
 	int			pass)
 {
 	struct xlog_recover	*trans;
-	int			error;
 	unsigned int		len;
 
 	/* Do we understand who wrote this op? */
@@ -3644,11 +3650,8 @@ xlog_recover_process_ophdr(
 		return 0;
 	}
 
-	error = xlog_recovery_process_trans(log, trans, dp, len,
-					    ohead->oh_flags, pass);
-	if (error)
-		xlog_recover_free_trans(trans);
-	return error;
+	return xlog_recovery_process_trans(log, trans, dp, len,
+					   ohead->oh_flags, pass);
 }
 
 /*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
