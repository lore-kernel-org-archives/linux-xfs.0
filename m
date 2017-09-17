Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbdIQVGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:06:36 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/25] xfs: handle -EFSCORRUPTED during head/tail verification
Date: Sun, 17 Sep 2017 14:06:14 -0700
Message-Id: <20170917210631.10725-9-hch@lst.de>
In-Reply-To: <20170917210631.10725-1-hch@lst.de>
References: <20170917210631.10725-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit a4c9b34d6a17081005ec459b57b8effc08f4c731 upstream.

Torn write and tail overwrite detection both trigger only on
-EFSBADCRC errors. While this is the most likely failure scenario
for each condition, -EFSCORRUPTED is still possible in certain cases
depending on what ends up on disk when a torn write or partial tail
overwrite occurs. For example, an invalid log record h_len can lead
to an -EFSCORRUPTED error when running the log recovery CRC pass.

Therefore, update log head and tail verification to trigger the
associated head/tail fixups in the event of -EFSCORRUPTED errors
along with -EFSBADCRC. Also, -EFSCORRUPTED can currently be returned
from xlog_do_recovery_pass() before rhead_blk is initialized if the
first record encountered happens to be corrupted. This leads to an
incorrect 'first_bad' return value. Initialize rhead_blk earlier in
the function to address that problem as well.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a5e2ca8f5cd6..43d5df3a563f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1102,7 +1102,7 @@ xlog_verify_tail(
 	first_bad = 0;
 	error = xlog_do_recovery_pass(log, head_blk, *tail_blk,
 				      XLOG_RECOVER_CRCPASS, &first_bad);
-	while (error == -EFSBADCRC && first_bad) {
+	while ((error == -EFSBADCRC || error == -EFSCORRUPTED) && first_bad) {
 		int	tail_distance;
 
 		/*
@@ -1188,7 +1188,7 @@ xlog_verify_head(
 	 */
 	error = xlog_do_recovery_pass(log, *head_blk, tmp_rhead_blk,
 				      XLOG_RECOVER_CRCPASS, &first_bad);
-	if (error == -EFSBADCRC) {
+	if ((error == -EFSBADCRC || error == -EFSCORRUPTED) && first_bad) {
 		/*
 		 * We've hit a potential torn write. Reset the error and warn
 		 * about it.
@@ -5257,7 +5257,7 @@ xlog_do_recovery_pass(
 	LIST_HEAD		(buffer_list);
 
 	ASSERT(head_blk != tail_blk);
-	rhead_blk = 0;
+	blk_no = rhead_blk = tail_blk;
 
 	for (i = 0; i < XLOG_RHASH_SIZE; i++)
 		INIT_HLIST_HEAD(&rhash[i]);
@@ -5335,7 +5335,6 @@ xlog_do_recovery_pass(
 	}
 
 	memset(rhash, 0, sizeof(rhash));
-	blk_no = rhead_blk = tail_blk;
 	if (tail_blk > head_blk) {
 		/*
 		 * Perform recovery around the end of the physical log.
-- 
2.14.1

