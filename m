Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABB2C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C94BB65013
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhCEFMX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:12:23 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:36896 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229573AbhCEFL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:11:59 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 9A4F8ECB1E3
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-00Fbop-US
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-000lZr-MU
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 23/45] xfs: log tickets don't need log client id
Date:   Fri,  5 Mar 2021 16:11:21 +1100
Message-Id: <20210305051143.182133-24-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=hMR6LrX7Ow0noj7qeasA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We currently set the log ticket client ID when we reserve a
transaction. This client ID is only ever written to the log by
a CIL checkpoint or unmount records, and so anything using a high
level transaction allocated through xfs_trans_alloc() does not need
a log ticket client ID to be set.

For the CIL checkpoint, the client ID written to the journal is
always XFS_TRANSACTION, and for the unmount record it is always
XFS_LOG, and nothing else writes to the log. All of these operations
tell xlog_write() exactly what they need to write to the log (the
optype) and build their own opheaders for start, commit and unmount
records. Hence we no longer need to set the client id in either the
log ticket or the xfs_trans.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 47 ++++++++-----------------------------------
 fs/xfs/xfs_log.h      | 16 ++++++---------
 fs/xfs/xfs_log_cil.c  |  2 +-
 fs/xfs/xfs_log_priv.h | 10 ++-------
 fs/xfs/xfs_trans.c    |  6 ++----
 5 files changed, 19 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c2e69a1f5cad..429cb1e7cc67 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -431,10 +431,9 @@ xfs_log_regrant(
 int
 xfs_log_reserve(
 	struct xfs_mount	*mp,
-	int		 	unit_bytes,
-	int		 	cnt,
+	int			unit_bytes,
+	int			cnt,
 	struct xlog_ticket	**ticp,
-	uint8_t		 	client,
 	bool			permanent)
 {
 	struct xlog		*log = mp->m_log;
@@ -442,15 +441,13 @@ xfs_log_reserve(
 	int			need_bytes;
 	int			error = 0;
 
-	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
-
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
 
 	ASSERT(*ticp == NULL);
-	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent);
+	tic = xlog_ticket_alloc(log, unit_bytes, cnt, permanent);
 	*ticp = tic;
 
 	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
@@ -847,7 +844,7 @@ xlog_unmount_write(
 	struct xlog_ticket	*tic = NULL;
 	int			error;
 
-	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
+	error = xfs_log_reserve(mp, 600, 1, &tic, 0);
 	if (error)
 		goto out_err;
 
@@ -2170,35 +2167,13 @@ xlog_write_calc_vec_length(
 
 static xlog_op_header_t *
 xlog_write_setup_ophdr(
-	struct xlog		*log,
 	struct xlog_op_header	*ophdr,
-	struct xlog_ticket	*ticket,
-	uint			flags)
+	struct xlog_ticket	*ticket)
 {
 	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
-	ophdr->oh_clientid = ticket->t_clientid;
+	ophdr->oh_clientid = XFS_TRANSACTION;
 	ophdr->oh_res2 = 0;
-
-	/* are we copying a commit or unmount record? */
-	ophdr->oh_flags = flags;
-
-	/*
-	 * We've seen logs corrupted with bad transaction client ids.  This
-	 * makes sure that XFS doesn't generate them on.  Turn this into an EIO
-	 * and shut down the filesystem.
-	 */
-	switch (ophdr->oh_clientid)  {
-	case XFS_TRANSACTION:
-	case XFS_VOLUME:
-	case XFS_LOG:
-		break;
-	default:
-		xfs_warn(log->l_mp,
-			"Bad XFS transaction clientid 0x%x in ticket "PTR_FMT,
-			ophdr->oh_clientid, ticket);
-		return NULL;
-	}
-
+	ophdr->oh_flags = 0;
 	return ophdr;
 }
 
@@ -2439,11 +2414,7 @@ xlog_write(
 				if (index)
 					optype &= ~XLOG_START_TRANS;
 			} else {
-				ophdr = xlog_write_setup_ophdr(log, ptr,
-							ticket, optype);
-				if (!ophdr)
-					return -EIO;
-
+                                ophdr = xlog_write_setup_ophdr(ptr, ticket);
 				xlog_write_adv_cnt(&ptr, &len, &log_offset,
 					   sizeof(struct xlog_op_header));
 				added_ophdr = true;
@@ -3499,7 +3470,6 @@ xlog_ticket_alloc(
 	struct xlog		*log,
 	int			unit_bytes,
 	int			cnt,
-	char			client,
 	bool			permanent)
 {
 	struct xlog_ticket	*tic;
@@ -3517,7 +3487,6 @@ xlog_ticket_alloc(
 	tic->t_cnt		= cnt;
 	tic->t_ocnt		= cnt;
 	tic->t_tid		= prandom_u32();
-	tic->t_clientid		= client;
 	if (permanent)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 1bd080ce3a95..c0c3141944ea 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -117,16 +117,12 @@ int	  xfs_log_mount_finish(struct xfs_mount *mp);
 void	xfs_log_mount_cancel(struct xfs_mount *);
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
-void	  xfs_log_space_wake(struct xfs_mount *mp);
-int	  xfs_log_reserve(struct xfs_mount *mp,
-			  int		   length,
-			  int		   count,
-			  struct xlog_ticket **ticket,
-			  uint8_t		   clientid,
-			  bool		   permanent);
-int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
-void      xfs_log_unmount(struct xfs_mount *mp);
-int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
+void	xfs_log_space_wake(struct xfs_mount *mp);
+int	xfs_log_reserve(struct xfs_mount *mp, int length, int count,
+			struct xlog_ticket **ticket, bool permanent);
+int	xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
+void	xfs_log_unmount(struct xfs_mount *mp);
+int	xfs_log_force_umount(struct xfs_mount *mp, int logerror);
 bool	xfs_log_writable(struct xfs_mount *mp);
 
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index e9da074ecd69..0c81c13e2cf6 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -37,7 +37,7 @@ xlog_cil_ticket_alloc(
 {
 	struct xlog_ticket *tic;
 
-	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0);
+	tic = xlog_ticket_alloc(log, 0, 1, 0);
 
 	/*
 	 * set the current reservation to zero so we know to steal the basic
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index bb5fa6b71114..7f601c1c9f45 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -158,7 +158,6 @@ typedef struct xlog_ticket {
 	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
 	char		   t_ocnt;	 /* original count		 : 1  */
 	char		   t_cnt;	 /* current count		 : 1  */
-	char		   t_clientid;	 /* who does this belong to;	 : 1  */
 	char		   t_flags;	 /* properties of reservation	 : 1  */
 
         /* reservation array fields */
@@ -465,13 +464,8 @@ extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
 			    char *dp, int size);
 
 extern kmem_zone_t *xfs_log_ticket_zone;
-struct xlog_ticket *
-xlog_ticket_alloc(
-	struct xlog	*log,
-	int		unit_bytes,
-	int		count,
-	char		client,
-	bool		permanent);
+struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
+		int count, bool permanent);
 
 static inline void
 xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 52f3fdf1e0de..83c2b7f22eb7 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -194,11 +194,9 @@ xfs_trans_reserve(
 			ASSERT(resp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
 			error = xfs_log_regrant(mp, tp->t_ticket);
 		} else {
-			error = xfs_log_reserve(mp,
-						resp->tr_logres,
+			error = xfs_log_reserve(mp, resp->tr_logres,
 						resp->tr_logcount,
-						&tp->t_ticket, XFS_TRANSACTION,
-						permanent);
+						&tp->t_ticket, permanent);
 		}
 
 		if (error)
-- 
2.28.0

