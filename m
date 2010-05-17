Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4HNMKla014367 for <xfs@oss.sgi.com>; Mon, 17 May 2010 18:22:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81CB79C4D46
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 16:25:35 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	xsQV0PVWwK1DTSiZ for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 16:25:35 -0700 (PDT)
Received: from dastard (unverified [121.44.136.97])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	24605596-1927428
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 08:54:35 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OE9fm-00059b-3O
	for xfs@oss.sgi.com; Tue, 18 May 2010 09:24:34 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OE9fh-0000Rg-7n
	for xfs@oss.sgi.com; Tue, 18 May 2010 09:24:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/12] xfs: clean up log ticket overrun debug output
Date: Tue, 18 May 2010 09:24:21 +1000
Message-Id: <1274138668-1662-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1274138668-1662-1-git-send-email-david@fromorbit.com>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
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

Push the error message output when a ticket overrun is detected
into the ticket printing functions. Also remove the debug version
of the code as the production version will still panic just as
effectively on a debug kernel via the panic mask being set.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_error.c |    2 +-
 fs/xfs/xfs_log.c   |   19 +++++--------------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index ef96175..047b8a8 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -170,7 +170,7 @@ xfs_cmn_err(int panic_tag, int level, xfs_mount_t *mp, char *fmt, ...)
 	va_list ap;
 
 #ifdef DEBUG
-	xfs_panic_mask |= XFS_PTAG_SHUTDOWN_CORRUPT;
+	xfs_panic_mask |= (XFS_PTAG_SHUTDOWN_CORRUPT | XFS_PTAG_LOGRES);
 #endif
 
 	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 83be6a6..1efb303 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1645,6 +1645,10 @@ xlog_print_tic_res(xfs_mount_t *mp, xlog_ticket_t *ticket)
 			    "bad-rtype" : res_type_str[r_type-1]),
 			    ticket->t_res_arr[i].r_len);
 	}
+
+	xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, mp,
+		"xfs_log_write: reservation ran out. Need to up reservation");
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 }
 
 /*
@@ -1897,21 +1901,8 @@ xlog_write(
 	*start_lsn = 0;
 
 	len = xlog_write_calc_vec_length(ticket, log_vector);
-	if (ticket->t_curr_res < len) {
+	if (ticket->t_curr_res < len)
 		xlog_print_tic_res(log->l_mp, ticket);
-#ifdef DEBUG
-		xlog_panic(
-	"xfs_log_write: reservation ran out. Need to up reservation");
-#else
-		/* Customer configurable panic */
-		xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, log->l_mp,
-	"xfs_log_write: reservation ran out. Need to up reservation");
-
-		/* If we did not panic, shutdown the filesystem */
-		xfs_force_shutdown(log->l_mp, SHUTDOWN_CORRUPT_INCORE);
-#endif
-	}
-
 	ticket->t_curr_res -= len;
 
 	index = 0;
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
