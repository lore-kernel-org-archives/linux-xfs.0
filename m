Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795D9C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 05:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiCIFav (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 00:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiCIFau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 00:30:50 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC0E83DA6F
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 21:29:51 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C56CE53114A
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:29:40 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-003H5W-Rh
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 16:29:39 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-00BJXW-Pz
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 16:29:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/16] xfs: remove xlog_verify_dest_ptr
Date:   Wed,  9 Mar 2022 16:29:34 +1100
Message-Id: <20220309052937.2696447-14-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220309052937.2696447-1-david@fromorbit.com>
References: <20220309052937.2696447-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62283b4f
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
        a=VwQbUJbxAAAA:8 a=TtUvnfYE3bnzAJtYeuQA:9 a=biEYGPWJfzWAr4FL6Ov7:22
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Just check that the offset in xlog_write_vec is smaller than the iclog
size and remove the expensive cycling through all iclogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 35 +----------------------------------
 fs/xfs/xfs_log_priv.h |  4 ----
 2 files changed, 1 insertion(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7dd2bcc7819b..ca8a9313d9c5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -61,10 +61,6 @@ xlog_sync(
 	struct xlog_in_core	*iclog);
 #if defined(DEBUG)
 STATIC void
-xlog_verify_dest_ptr(
-	struct xlog		*log,
-	void			*ptr);
-STATIC void
 xlog_verify_grant_tail(
 	struct xlog *log);
 STATIC void
@@ -77,7 +73,6 @@ xlog_verify_tail_lsn(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog);
 #else
-#define xlog_verify_dest_ptr(a,b)
 #define xlog_verify_grant_tail(a)
 #define xlog_verify_iclog(a,b,c)
 #define xlog_verify_tail_lsn(a,b)
@@ -1640,9 +1635,6 @@ xlog_alloc_log(
 				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!iclog->ic_data)
 			goto out_free_iclog;
-#ifdef DEBUG
-		log->l_iclog_bak[i] = &iclog->ic_header;
-#endif
 		head = &iclog->ic_header;
 		memset(head, 0, sizeof(xlog_rec_header_t));
 		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
@@ -2234,6 +2226,7 @@ xlog_write_iovec(
 	uint32_t		*record_cnt,
 	uint32_t		*data_cnt)
 {
+	ASSERT(*log_offset < iclog->ic_log->l_iclog_size);
 	ASSERT(*log_offset % sizeof(int32_t) == 0);
 	ASSERT(write_len % sizeof(int32_t) == 0);
 
@@ -2327,7 +2320,6 @@ xlog_write_partial(
 	int			*contwr)
 {
 	struct xlog_in_core	*iclog = *iclogp;
-	struct xlog		*log = iclog->ic_log;
 	struct xlog_op_header	*ophdr;
 	int			index = 0;
 	uint32_t		rlen;
@@ -2366,7 +2358,6 @@ xlog_write_partial(
 		if (rlen != reg->i_len)
 			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
 
-		xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
 		xlog_write_iovec(iclog, log_offset, reg->i_addr,
 				rlen, len, record_cnt, data_cnt);
 
@@ -2434,7 +2425,6 @@ xlog_write_partial(
 			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
 			ophdr->oh_len = cpu_to_be32(rlen);
 
-			xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
 			xlog_write_iovec(iclog, log_offset,
 					reg->i_addr + reg_offset,
 					rlen, len, record_cnt, data_cnt);
@@ -3558,29 +3548,6 @@ xlog_ticket_alloc(
 }
 
 #if defined(DEBUG)
-/*
- * Make sure that the destination ptr is within the valid data region of
- * one of the iclogs.  This uses backup pointers stored in a different
- * part of the log in case we trash the log structure.
- */
-STATIC void
-xlog_verify_dest_ptr(
-	struct xlog	*log,
-	void		*ptr)
-{
-	int i;
-	int good_ptr = 0;
-
-	for (i = 0; i < log->l_iclog_bufs; i++) {
-		if (ptr >= log->l_iclog_bak[i] &&
-		    ptr <= log->l_iclog_bak[i] + log->l_iclog_size)
-			good_ptr++;
-	}
-
-	if (!good_ptr)
-		xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
-}
-
 /*
  * Check to make sure the grant write head didn't just over lap the tail.  If
  * the cycles are the same, we can't be overlapping.  Otherwise, make sure that
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 6e9c7d924363..8c98b57e2a63 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -420,10 +420,6 @@ struct xlog {
 
 	struct xfs_kobj		l_kobj;
 
-	/* The following field are used for debugging; need to hold icloglock */
-#ifdef DEBUG
-	void			*l_iclog_bak[XLOG_MAX_ICLOGS];
-#endif
 	/* log recovery lsn tracking (for buffer submission */
 	xfs_lsn_t		l_recovery_lsn;
 
-- 
2.33.0

