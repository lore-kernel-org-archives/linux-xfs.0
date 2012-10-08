Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q98AtFap055646 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 05:55:15 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	yaTyYMtieWhghOZc for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 03:56:43 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLB0r-0000W0-Dj
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:41 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLB0m-00028F-AK
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/14] xfs: only update the last_sync_lsn when a transaction
	completes
Date: Mon,  8 Oct 2012 21:56:12 +1100
Message-Id: <1349693772-8064-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1349693772-8064-1-git-send-email-david@fromorbit.com>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
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

The log write code stamps each iclog with the current tail LSN in
the iclog header so that recovery knows where to find the tail of
thelog once it has found the head. Normally this is taken from the
first item on the AIL - the log item that corresponds to the oldest
active item in the log.

The problem is that when the AIL is empty, the tail lsn is dervied
from the the l_last_sync_lsn, which is the LSN of the last iclog to
be written to the log. In most cases this doesn't happen, because
the AIL is rarely empty on an active filesystem. However, when it
does, it opens up an interesting case when the transaction being
committed to the iclog spans multiple iclogs.

That is, the first iclog is stamped with the l_last_sync_lsn, and IO
is issued. Then the next iclog is setup, the changes copied into the
iclog (takes some time), and then the l_last_sync_lsn is stamped
into the header and IO is issued. This is still the same
transaction, so the tail lsn of both iclogs must be the same for log
recovery to find the entire transaction to be able to replay it.

The problem arises in that the iclog buffer IO completion updates
the l_last_sync_lsn with it's own LSN. Therefore, If the first iclog
completes it's IO before the second iclog is filled and has the tail
lsn stamped in it, it will stamp the LSN of the first iclog into
it's tail lsn field. If the system fails at this point, log recovery
will not see a complete transaction, so the transaction will no be
replayed.

The fix is simple - the l_last_sync_lsn is updated when a iclog
buffer IO completes, and this is incorrect. The l_last_sync_lsn
shoul dbe updated when a transaction is completed by a iclog buffer
IO. That is, only iclog buffers that have transaction commit
callbacks attached to them should update the l_last_sync_lsn. This
means that the last_sync_lsn will only move forward when a commit
record it written, not in the middle of a large transaction that is
rolling through multiple iclog buffers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d2d5969..46b6986 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2461,14 +2461,27 @@ xlog_state_do_callback(
 
 
 				/*
-				 * update the last_sync_lsn before we drop the
+				 * Completion of a iclog IO does not imply that
+				 * a transaction has completed, as transactions
+				 * can be large enough to span many iclogs. We
+				 * cannot change the tail of the log half way
+				 * through a transaction as this may be the only
+				 * transaction in the log and moving th etail to
+				 * point to the middle of it will prevent
+				 * recovery from finding the start of the
+				 * transaction. Hence we should only update the
+				 * last_sync_lsn if this iclog contains
+				 * transaction completion callbacks on it.
+				 *
+				 * We have to do this before we drop the
 				 * icloglock to ensure we are the only one that
 				 * can update it.
 				 */
 				ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
 					be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
-				atomic64_set(&log->l_last_sync_lsn,
-					be64_to_cpu(iclog->ic_header.h_lsn));
+				if (iclog->ic_callback)
+					atomic64_set(&log->l_last_sync_lsn,
+						be64_to_cpu(iclog->ic_header.h_lsn));
 
 			} else
 				ioerrors++;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
