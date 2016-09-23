Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966025AbcIWUbD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Sep 2016 16:31:03 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9CAF97EAB9
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2016 20:31:02 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-125.bos.redhat.com [10.18.41.125])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u8NKV2NA020958
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2016 16:31:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/5] xfs: pass current lsn to log recovery buffer validation
Date: Fri, 23 Sep 2016 16:30:57 -0400
Message-Id: <1474662660-61550-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1474662660-61550-1-git-send-email-bfoster@redhat.com>
References: <1474662660-61550-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The current LSN must be available to the buffer validation function to
provide the ability to update the metadata LSN of the buffer. Pass the
current_lsn value down to xlog_recover_validate_buf_type() in
preparation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e24fb7b..bf325f2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2360,7 +2360,8 @@ static void
 xlog_recover_validate_buf_type(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp,
-	xfs_buf_log_format_t	*buf_f)
+	xfs_buf_log_format_t	*buf_f,
+	xfs_lsn_t		current_lsn)
 {
 	struct xfs_da_blkinfo	*info = bp->b_addr;
 	__uint32_t		magic32;
@@ -2569,7 +2570,8 @@ xlog_recover_do_reg_buffer(
 	struct xfs_mount	*mp,
 	xlog_recover_item_t	*item,
 	struct xfs_buf		*bp,
-	xfs_buf_log_format_t	*buf_f)
+	xfs_buf_log_format_t	*buf_f,
+	xfs_lsn_t		current_lsn)
 {
 	int			i;
 	int			bit;
@@ -2642,7 +2644,7 @@ xlog_recover_do_reg_buffer(
 	/* Shouldn't be any more regions */
 	ASSERT(i == item->ri_total);
 
-	xlog_recover_validate_buf_type(mp, bp, buf_f);
+	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
 }
 
 /*
@@ -2685,7 +2687,7 @@ xlog_recover_do_dquot_buffer(
 	if (log->l_quotaoffs_flag & type)
 		return false;
 
-	xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
+	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
 	return true;
 }
 
@@ -2773,7 +2775,7 @@ xlog_recover_buffer_pass2(
 	 */
 	lsn = xlog_recover_get_buf_lsn(mp, bp);
 	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
-		xlog_recover_validate_buf_type(mp, bp, buf_f);
+		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
 		goto out_release;
 	}
 
@@ -2789,7 +2791,7 @@ xlog_recover_buffer_pass2(
 		if (!dirty)
 			goto out_release;
 	} else {
-		xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
+		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 	}
 
 	/*
-- 
2.5.5

