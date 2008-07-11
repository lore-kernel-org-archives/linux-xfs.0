Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Jul 2008 00:43:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B7h27L015250
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 00:43:02 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1FFD1BB50D7
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 00:44:06 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id hpBWYPtAKDmKOQGX for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 00:44:06 -0700 (PDT)
Date: Fri, 11 Jul 2008 17:43:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [XFS REGRESSION, PATCH] Fix reference counting race on log buffers
Message-ID: <20080711074355.GT29319@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org


When we release the iclog, we do an atomic_dec_and_lock to determine
if we are the last reference and need to trigger update of log
headers and writeout. However, in xlog_state_get_iclog_space() we
also need to check if we have the last reference count there.  If we
do, we release the log buffer, otherwise we decrement the reference
count.

The issue is that the compare and decrement in
xlog_state_get_iclog_space() is not atomic, so both places can see a
reference count of 2 and neither will release the iclog. That leads
to a filesystem hang.

Close the race by replacing the atomic_read() and atomic_dec() pair with
atomic_add_unless() to ensure that they are executed atomically.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Tim Shimmin <tes@sgi.com>
Tested-by: Eric Sandeen <sandeen@sandeen.net>
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
