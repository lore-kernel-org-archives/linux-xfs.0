Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NehWh067723 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:47 -0600
Message-Id: <20121203144312.161697268@sgi.com>
Date: Mon, 03 Dec 2012 17:42:44 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 36/36] xfs: only update the last_sync_lsn when a
	transaction completes
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline;
	filename=xfs-update-last_sync-when-trans-completes.patch
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: d35e88faa3b0fc2cea35c3b2dca358b5cd09b45f

    xfs: only update the last_sync_lsn when a transaction completes
    
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
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

---
 fs/xfs/xfs_log.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2216,14 +2216,27 @@ xlog_state_do_callback(
 
 
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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
