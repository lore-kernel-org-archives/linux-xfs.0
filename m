Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 22:00:23 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B50IBk022495
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 22:00:22 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9B8F1BB4C6F
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 22:01:23 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id wPhOlc0ZolkEoKKJ for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 22:01:23 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] Fix reference counting race on log buffers
Date: Fri, 11 Jul 2008 15:01:21 +1000
Message-Id: <1215752481-6862-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <david@fromorbit.com>

When we release the iclog, we do an atomic_dec_and_lock to determine
if we are the last reference to enable update of log headers and
writeout. however, in xlog_state_get_iclog_space() we need to check
if we have the last reference count there.  if we do, we release the
log buffer, otherwise we decrement the reference count.

The issue is that the compare and decrement in
xlog_state_get_iclog_space() is not atomic, so both places can see a
reference count of 2 and neither will release the iclog. That leads
to a filesystem hang.

Close the hole replacing the compare and decrement with
atomic_add_unless() to ensure that they are executed atomically.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_log.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 760d543..0816c5d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2425,13 +2425,20 @@ restart:
 	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
 
-		/* If I'm the only one writing to this iclog, sync it to disk */
-		if (atomic_read(&iclog->ic_refcnt) == 1) {
+		/*
+		 * If I'm the only one writing to this iclog, sync it to disk.
+		 * We need to do an atomic compare and decrement here to avoid
+		 * racing with concurrent atomic_dec_and_lock() calls in
+		 * xlog_state_release_iclog() when there is more than one
+		 * reference to the iclog.
+		 */
+		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
+			/* we are the only one */
 			spin_unlock(&log->l_icloglock);
-			if ((error = xlog_state_release_iclog(log, iclog)))
+			error = xlog_state_release_iclog(log, iclog);
+			if (error)
 				return error;
 		} else {
-			atomic_dec(&iclog->ic_refcnt);
 			spin_unlock(&log->l_icloglock);
 		}
 		goto restart;
-- 
1.5.6
