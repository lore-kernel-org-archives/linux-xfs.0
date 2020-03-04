Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05738C3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB800215A4
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgCDHyI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:54:08 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33973 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728531AbgCDHyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 02:54:08 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1058A3A2A16
        for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2020 18:54:02 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqw-0007lr-6o
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:02 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqw-0005ct-3C
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/11] xfs: remove some stale comments from the log code
Date:   Wed,  4 Mar 2020 18:54:00 +1100
Message-Id: <20200304075401.21558-11-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200304075401.21558-1-david@fromorbit.com>
References: <20200304075401.21558-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=HAJyDiJqIqQbgm0xHfYA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 71 ++++++++++++++----------------------------------
 1 file changed, 20 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a687c20dd77d..89956484848f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -477,14 +477,6 @@ xfs_log_reserve(
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
@@ -1968,7 +1960,7 @@ xlog_dealloc_log(
 	log->l_mp->m_log = NULL;
 	destroy_workqueue(log->l_ioend_workqueue);
 	kmem_free(log);
-}	/* xlog_dealloc_log */
+}
 
 /*
  * Update counters atomically now that memcpy is done.
@@ -2511,14 +2503,6 @@ xlog_write(
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
 /*
  * An iclog has just finished IO completion processing, so we need to update
  * the iclog state and propagate that up into the overall log state. Hence we
@@ -2887,8 +2871,8 @@ xlog_state_done_syncing(
 	 */
 	wake_up_all(&iclog->ic_write_wait);
 	spin_unlock(&log->l_icloglock);
-	xlog_state_do_callback(log, aborted);	/* also cleans log */
-}	/* xlog_state_done_syncing */
+	xlog_state_do_callback(log, aborted);
+}
 
 
 /*
@@ -3008,14 +2992,14 @@ xlog_state_get_iclog_space(
 
 	*logoffsetp = log_offset;
 	return 0;
-}	/* xlog_state_get_iclog_space */
-
-/* The first cnt-1 times through here we don't need to
- * move the grant write head because the permanent
- * reservation has reserved cnt times the unit amount.
- * Release part of current permanent unit reservation and
- * reset current reservation to be one units worth.  Also
- * move grant reservation head forward.
+}
+
+/*
+ * The first cnt-1 times a ticket goes through here we don't need to move the
+ * grant write head because the permanent reservation has reserved cnt times the
+ * unit amount.  Release part of current permanent unit reservation and reset
+ * current reservation to be one units worth.  Also move grant reservation head
+ * forward.
  */
 STATIC void
 xlog_regrant_reserve_log_space(
@@ -3047,7 +3031,7 @@ xlog_regrant_reserve_log_space(
 
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
-}	/* xlog_regrant_reserve_log_space */
+}
 
 
 /*
@@ -3096,11 +3080,11 @@ xlog_ungrant_log_space(
 }
 
 /*
- * This routine will mark the current iclog in the ring as WANT_SYNC
- * and move the current iclog pointer to the next iclog in the ring.
- * When this routine is called from xlog_state_get_iclog_space(), the
- * exact size of the iclog has not yet been determined.  All we know is
- * that every data block.  We have run out of space in this log record.
+ * This routine will mark the current iclog in the ring as WANT_SYNC and move
+ * the current iclog pointer to the next iclog in the ring.  When this routine
+ * is called from xlog_state_get_iclog_space(), the exact size of the iclog has
+ * not yet been determined.  All we know is that every data block.  We have run
+ * out of space in this log record.
  */
 STATIC void
 xlog_state_switch_iclogs(
@@ -3143,7 +3127,7 @@ xlog_state_switch_iclogs(
 	}
 	ASSERT(iclog == log->l_iclog);
 	log->l_iclog = iclog->ic_next;
-}	/* xlog_state_switch_iclogs */
+}
 
 /*
  * Write out all data in the in-core log as of this exact moment in time.
@@ -3397,14 +3381,6 @@ xlog_state_want_sync(
 	}
 }
 
-
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
@@ -3562,13 +3538,6 @@ xlog_ticket_alloc(
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
@@ -3654,7 +3623,7 @@ xlog_verify_tail_lsn(
 	if (blocks < BTOBB(iclog->ic_offset) + 1)
 		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
     }
-}	/* xlog_verify_tail_lsn */
+}
 
 /*
  * Perform a number of checks on the iclog before writing to disk.
@@ -3757,7 +3726,7 @@ xlog_verify_iclog(
 		}
 		ptr += sizeof(xlog_op_header_t) + op_len;
 	}
-}	/* xlog_verify_iclog */
+}
 #endif
 
 /*
-- 
2.24.0.rc0

