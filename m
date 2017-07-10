Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754167AbdGJN2C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jul 2017 09:28:02 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D95E7C04B328
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD4C9182FD
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 5/6] xfs: handle -EFSCORRUPTED during head/tail verification
Date: Mon, 10 Jul 2017 09:27:59 -0400
Message-Id: <20170710132800.19506-6-bfoster@redhat.com>
In-Reply-To: <20170710132800.19506-1-bfoster@redhat.com>
References: <20170710132800.19506-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

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
---
 fs/xfs/xfs_log_recover.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d3bef45..2e34797 100644
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
2.9.4

