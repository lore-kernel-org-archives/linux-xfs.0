Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBDAC54FD3
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDD7520836
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BHSEZ9Q4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgCXRpV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 13:45:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXRpU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 13:45:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SK0iPtyANh19UBJzIvjAVNCxYDNIMyFeAHSobzjfq8k=; b=BHSEZ9Q4aJ7ZuSWIhBTWE759KH
        0vXTFZL/YQWGnY/afiOIzNRqk7XRpqPYPqoEvBBuughm0EyHUWfONsHcC2p3gzRLFoU88nBdzFVYe
        mcLIV0uLxqthur3KAj94Gbiy+zlZRcS6g/RxXcABRNGuSdGiIuDuB6aUattJ0xwGo1znBSHwF40qa
        /hAToo9SZLzWLQ7UftFNdUN0McSMrGoe5pBOseo82KdvrOfaGZVYbjXj4FqKL5LnpLhme5WM/zEH8
        YDmAXw4vMc7FcexD4+HnruYPreVoKheUvD09pdJSHtuZ5b5ru/974itjiNbBCHFpvRgAhTSkxexiD
        2v1PiXXg==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGnc8-0003J5-3n; Tue, 24 Mar 2020 17:45:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 8/8] xfs: remove some stale comments from the log code
Date:   Tue, 24 Mar 2020 18:44:59 +0100
Message-Id: <20200324174459.770999-9-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324174459.770999-1-hch@lst.de>
References: <20200324174459.770999-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 59 +++++++++++-------------------------------------
 1 file changed, 13 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1d6ed696f717..521fe77e3aaa 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -463,14 +463,6 @@ xfs_log_reserve(
 	return error;
 }
 
-
-/*
- * NOTES:
- *
- *	1. currblock field gets updated at startup and after in-core logs
- *		marked as with WANT_SYNC.
- */
-
 /*
  * Write out an unmount record using the ticket provided. We have to account for
  * the data space used in the unmount ticket as this write is not done from a
@@ -1910,7 +1902,7 @@ xlog_dealloc_log(
 	log->l_mp->m_log = NULL;
 	destroy_workqueue(log->l_ioend_workqueue);
 	kmem_free(log);
-}	/* xlog_dealloc_log */
+}
 
 /*
  * Update counters atomically now that memcpy is done.
@@ -2454,14 +2446,6 @@ xlog_write(
 	return error;
 }
 
-
-/*****************************************************************************
- *
- *		State Machine functions
- *
- *****************************************************************************
- */
-
 static void
 xlog_state_activate_iclog(
 	struct xlog_in_core	*iclog,
@@ -2822,7 +2806,7 @@ xlog_state_done_syncing(
 	 */
 	wake_up_all(&iclog->ic_write_wait);
 	spin_unlock(&log->l_icloglock);
-	xlog_state_do_callback(log);	/* also cleans log */
+	xlog_state_do_callback(log);
 }
 
 /*
@@ -2942,13 +2926,14 @@ xlog_state_get_iclog_space(
 
 	*logoffsetp = log_offset;
 	return 0;
-}	/* xlog_state_get_iclog_space */
+}
 
 /*
- * The first cnt-1 times through here we don't need to move the grant write head
- * because the permanent reservation has reserved cnt times the unit amount.
- * Release part of current permanent unit reservation and reset current
- * reservation to be one units worth.  Also move grant reservation head forward.
+ * The first cnt-1 times a ticket goes through here we don't need to move the
+ * grant write head because the permanent reservation has reserved cnt times the
+ * unit amount.  Release part of current permanent unit reservation and reset
+ * current reservation to be one units worth.  Also move grant reservation head
+ * forward.
  */
 void
 xlog_ticket_regrant(
@@ -3030,12 +3015,8 @@ xlog_ticket_done(
 }
 
 /*
- * Mark the current iclog in the ring as WANT_SYNC and move the current iclog
- * pointer to the next iclog in the ring.
- *
- * When called from xlog_state_get_iclog_space(), the exact size of the iclog
- * has not yet been determined, all we know is that we have run out of space in
- * the current iclog.
+ * This routine will mark the current iclog in the ring as WANT_SYNC and move
+ * the current iclog pointer to the next iclog in the ring.
  */
 STATIC void
 xlog_state_switch_iclogs(
@@ -3080,7 +3061,7 @@ xlog_state_switch_iclogs(
 	}
 	ASSERT(iclog == log->l_iclog);
 	log->l_iclog = iclog->ic_next;
-}	/* xlog_state_switch_iclogs */
+}
 
 /*
  * Write out all data in the in-core log as of this exact moment in time.
@@ -3287,13 +3268,6 @@ xfs_log_force_lsn(
 	return ret;
 }
 
-/*****************************************************************************
- *
- *		TICKET functions
- *
- *****************************************************************************
- */
-
 /*
  * Free a used ticket when its refcount falls to zero.
  */
@@ -3450,13 +3424,6 @@ xlog_ticket_alloc(
 	return tic;
 }
 
-
-/******************************************************************************
- *
- *		Log debug routines
- *
- ******************************************************************************
- */
 #if defined(DEBUG)
 /*
  * Make sure that the destination ptr is within the valid data region of
@@ -3542,7 +3509,7 @@ xlog_verify_tail_lsn(
 	if (blocks < BTOBB(iclog->ic_offset) + 1)
 		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
     }
-}	/* xlog_verify_tail_lsn */
+}
 
 /*
  * Perform a number of checks on the iclog before writing to disk.
@@ -3645,7 +3612,7 @@ xlog_verify_iclog(
 		}
 		ptr += sizeof(xlog_op_header_t) + op_len;
 	}
-}	/* xlog_verify_iclog */
+}
 #endif
 
 /*
-- 
2.25.1

