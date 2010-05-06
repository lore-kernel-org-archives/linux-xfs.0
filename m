Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o461huLt064969 for <xfs@oss.sgi.com>; Wed, 5 May 2010 20:43:56 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FD311B0A173
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 18:46:04 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	Og2TiwyOnl4F3hsp for <xfs@oss.sgi.com>;
	Wed, 05 May 2010 18:46:04 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11655209-1927428
	for <xfs@oss.sgi.com>; Thu, 06 May 2010 11:16:03 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1O9q9w-0005DL-6Z
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:45:52 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1O9q9v-0000cF-5z
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:45:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/11] xfs: Don't reuse the same transaciton ID for duplicated
	transactions.
Date: Thu,  6 May 2010 11:45:41 +1000
Message-Id: <1273110351-2333-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1273110351-2333-1-git-send-email-david@fromorbit.com>
References: <1273110351-2333-1-git-send-email-david@fromorbit.com>
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

The transaction ID is written into the log as the unique identifier
for transactions during recover. When duplicating a transaction, we
reuse the log ticket, which means it has the same transaction ID as
the previous transaction.

Rather than regenerating a random transaction ID for the duplicated
transaction, just add one to the current ID so that duplicated
transaction can be easily spotted in the log and during recovery
during problem diagnosis.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3038dd5..687b220 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -360,6 +360,15 @@ xfs_log_reserve(
 		ASSERT(flags & XFS_LOG_PERM_RESERV);
 		internal_ticket = *ticket;
 
+		/*
+		 * this is a new transaction on the ticket, so we need to
+		 * change the transaction ID so that the next transaction has a
+		 * different TID in the log. Just add one to the existing tid
+		 * so that we can see chains of rolling transactions in the log
+		 * easily.
+		 */
+		internal_ticket->t_tid++;
+
 		trace_xfs_log_reserve(log, internal_ticket);
 
 		xlog_grant_push_ail(mp, internal_ticket->t_unit_res);
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
