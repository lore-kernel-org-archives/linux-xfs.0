Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754016AbdGJN2B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jul 2017 09:28:01 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 69FEDC0587F6
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48CCE756C5
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 1/6] xfs: fix recovery failure when log record header wraps log end
Date: Mon, 10 Jul 2017 09:27:55 -0400
Message-Id: <20170710132800.19506-2-bfoster@redhat.com>
In-Reply-To: <20170710132800.19506-1-bfoster@redhat.com>
References: <20170710132800.19506-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The high-level log recovery algorithm consists of two loops that
walk the physical log and process log records from the tail to the
head. The first loop handles the case where the tail is beyond the
head and processes records up to the end of the physical log. The
subsequent loop processes records from the beginning of the physical
log to the head.

Because log records can wrap around the end of the physical log, the
first loop mentioned above must handle this case appropriately.
Records are processed from in-core buffers, which means that this
algorithm must split the reads of such records into two partial
I/Os: 1.) from the beginning of the record to the end of the log and
2.) from the beginning of the log to the end of the record. This is
further complicated by the fact that the log record header and log
record data are read into independent buffers.

The current handling of each buffer correctly splits the reads when
either the header or data starts before the end of the log and wraps
around the end. The data read does not correctly handle the case
where the prior header read wrapped or ends on the physical log end
boundary. blk_no is incremented to or beyond the log end after the
header read to point to the record data, but the split data read
logic triggers, attempts to read from an invalid log block and
ultimately causes log recovery to fail. This can be reproduced
fairly reliably via xfstests tests generic/047 and generic/388 with
large iclog sizes (256k) and small (10M) logs.

If the record header read has pushed beyond the end of the physical
log, the subsequent data read is actually contiguous. Update the
data read logic to detect the case where blk_no has wrapped, mod it
against the log size to read from the correct address and issue one
contiguous read for the log data buffer. The log record is processed
as normal from the buffer(s), the loop exits after the current
iteration and the subsequent loop picks up with the first new record
after the start of the log.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b6a40bd..a388a84 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5218,7 +5218,7 @@ xlog_do_recovery_pass(
 	xfs_daddr_t		*first_bad)	/* out: first bad log rec */
 {
 	xlog_rec_header_t	*rhead;
-	xfs_daddr_t		blk_no;
+	xfs_daddr_t		blk_no, rblk_no;
 	xfs_daddr_t		rhead_blk;
 	char			*offset;
 	xfs_buf_t		*hbp, *dbp;
@@ -5371,9 +5371,19 @@ xlog_do_recovery_pass(
 			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
 			blk_no += hblks;
 
-			/* Read in data for log record */
-			if (blk_no + bblks <= log->l_logBBsize) {
-				error = xlog_bread(log, blk_no, bblks, dbp,
+			/*
+			 * Read the log record data in multiple reads if it
+			 * wraps around the end of the log. Note that if the
+			 * header already wrapped, blk_no could point past the
+			 * end of the log. The record data is contiguous in
+			 * that case.
+			 */
+			if (blk_no + bblks <= log->l_logBBsize ||
+			    blk_no >= log->l_logBBsize) {
+				/* mod blk_no in case the header wrapped and
+				 * pushed it beyond the end of the log */
+				rblk_no = do_mod(blk_no, log->l_logBBsize);
+				error = xlog_bread(log, rblk_no, bblks, dbp,
 						   &offset);
 				if (error)
 					goto bread_err2;
-- 
2.9.4

