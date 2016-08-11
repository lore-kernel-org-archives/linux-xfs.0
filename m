Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2561A7CAE
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 12:11:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E1E818F8050
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id p7KWbBIZeQmmICjP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:10 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 95E2B8553E
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 17:11:09 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-69.bos.redhat.com [10.18.41.69])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7BHB94A009725
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 13:11:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/5] xfs: pass current lsn to log recovery buffer validation
Date: Thu, 11 Aug 2016 13:11:04 -0400
Message-Id: <1470935467-52772-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
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

The current LSN must be available to the buffer validation function to
provide the ability to update the metadata LSN of the buffer. Pass the
current_lsn value down to xlog_recover_validate_buf_type() in
preparation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 97a0af9..283bb7e 100644
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
