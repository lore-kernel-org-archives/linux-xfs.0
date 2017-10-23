Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdJWOqs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Oct 2017 10:46:48 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 583BBC070134
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 14:46:48 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A85378DF4
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 14:46:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/4] xfs: sanity check log record range parameters
Date: Mon, 23 Oct 2017 10:46:43 -0400
Message-Id: <20171023144646.50107-2-bfoster@redhat.com>
In-Reply-To: <20171023144646.50107-1-bfoster@redhat.com>
References: <20171023144646.50107-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

If a malformatted filesystem is mounted and attempts log recovery,
we can end up passing garbage parameter values to
xlog_find_verify_log_record(). In turn, the latter can pass a NULL
head pointer to xlog_header_check_mount() and cause a kernel panic.

Add some parameter sanity checks to both functions. Checks in both
places are technically not necessary, but do so to help future proof
the code. This prevents a kernel panic and replaces it with a more
graceful mount failure.

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ee34899..80b37a2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -347,9 +347,12 @@ xlog_header_check_recover(
  */
 STATIC int
 xlog_header_check_mount(
-	xfs_mount_t		*mp,
-	xlog_rec_header_t	*head)
+	struct xfs_mount	*mp,
+	struct xlog_rec_header	*head)
 {
+	if (!head)
+		return -EINVAL;
+
 	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
 
 	if (uuid_is_null(&head->h_fs_uuid)) {
@@ -533,6 +536,10 @@ xlog_find_verify_log_record(
 
 	ASSERT(start_blk != 0 || *last_blk != start_blk);
 
+	if (start_blk < 0 || start_blk > log->l_logBBsize ||
+	    *last_blk < 0 || *last_blk > log->l_logBBsize)
+		return -EINVAL;
+
 	if (!(bp = xlog_get_bp(log, num_blks))) {
 		if (!(bp = xlog_get_bp(log, 1)))
 			return -ENOMEM;
-- 
2.9.5

