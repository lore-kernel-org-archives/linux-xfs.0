Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C27767F77
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 09:37:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0682304039
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D3pCuT5eHBL03U8B (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:29 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 5211D8F4E0
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 15:37:29 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-36.bos.redhat.com [10.18.41.36])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tACFbTln032668
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 10:37:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/8] xfs: refactor log record unpack and data processing
Date: Thu, 12 Nov 2015 10:37:22 -0500
Message-Id: <1447342648-40012-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1447342648-40012-1-git-send-email-bfoster@redhat.com>
References: <1447342648-40012-1-git-send-email-bfoster@redhat.com>
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

xlog_do_recovery_pass() duplicates a couple function calls related to
processing log records because the function must handle wrapping around
the end of the log if the head is behind the tail. This is implemented
as separate loops. CRC verification pass support will modify how records
are processed in both of these loops.

Rather than continue to duplicate code, factor the calls that process a
log record into a new helper and call that helper from both loops. This
patch contains no functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4f880d6..236ebaf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4190,6 +4190,26 @@ xlog_unpack_data(
 	return 0;
 }
 
+/*
+ * Unpack and process a log record.
+ */
+STATIC int
+xlog_recover_process(
+	struct xlog		*log,
+	struct hlist_head	rhash[],
+	struct xlog_rec_header	*rhead,
+	char			*dp,
+	int			pass)
+{
+	int			error;
+
+	error = xlog_unpack_data(rhead, dp, log);
+	if (error)
+		return error;
+
+	return xlog_recover_process_data(log, rhash, rhead, dp, pass);
+}
+
 STATIC int
 xlog_valid_rec_header(
 	struct xlog		*log,
@@ -4432,12 +4452,8 @@ xlog_do_recovery_pass(
 					goto bread_err2;
 			}
 
-			error = xlog_unpack_data(rhead, offset, log);
-			if (error)
-				goto bread_err2;
-
-			error = xlog_recover_process_data(log, rhash,
-							rhead, offset, pass);
+			error = xlog_recover_process(log, rhash, rhead, offset,
+						     pass);
 			if (error)
 				goto bread_err2;
 			blk_no += bblks;
@@ -4465,12 +4481,7 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err2;
 
-		error = xlog_unpack_data(rhead, offset, log);
-		if (error)
-			goto bread_err2;
-
-		error = xlog_recover_process_data(log, rhash,
-						rhead, offset, pass);
+		error = xlog_recover_process(log, rhash, rhead, offset, pass);
 		if (error)
 			goto bread_err2;
 		blk_no += bblks + hblks;
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
