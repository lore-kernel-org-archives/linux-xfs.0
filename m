Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5E1C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 05:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiCIFam (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 00:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiCIFam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 00:30:42 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35AE63D1E0
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 21:29:44 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AB96B53115E
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:29:40 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-003H54-IC
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 16:29:39 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-00BJWr-Gt
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 16:29:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/16] xfs: log tickets don't need log client id
Date:   Wed,  9 Mar 2022 16:29:26 +1100
Message-Id: <20220309052937.2696447-6-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220309052937.2696447-1-david@fromorbit.com>
References: <20220309052937.2696447-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62283b45
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=YlqFwBsl5h0Aqb0hd38A:9 a=AjGcO6oz07-iQ99wixmX:22
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h |  1 -
 fs/xfs/xfs_log.c               | 47 ++++++----------------------------
 fs/xfs/xfs_log.h               | 14 ++++------
 fs/xfs/xfs_log_cil.c           |  2 +-
 fs/xfs/xfs_log_priv.h          | 10 ++------
 fs/xfs/xfs_trans.c             |  6 ++---
 6 files changed, 18 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b322db523d65..2b89141ae81a 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -69,7 +69,6 @@ static inline uint xlog_get_cycle(char *ptr)
 
 /* Log Clients */
 #define XFS_TRANSACTION		0x69
-#define XFS_VOLUME		0x2
 #define XFS_LOG			0xaa
 
 #define XLOG_UNMOUNT_TYPE	0x556e	/* Un for Unmount */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f789acd2f755..f09663d3664b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -434,10 +434,9 @@ xfs_log_regrant(
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
@@ -445,15 +444,13 @@ xfs_log_reserve(
 	int			need_bytes;
 	int			error = 0;
 
-	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
-
 	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
 
 	ASSERT(*ticp == NULL);
-	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent);
+	tic = xlog_ticket_alloc(log, unit_bytes, cnt, permanent);
 	*ticp = tic;
 
 	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
@@ -961,7 +958,7 @@ xlog_unmount_write(
 	struct xlog_ticket	*tic = NULL;
 	int			error;
 
-	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
+	error = xfs_log_reserve(mp, 600, 1, &tic, 0);
 	if (error)
 		goto out_err;
 
@@ -2296,35 +2293,13 @@ xlog_write_calc_vec_length(
 
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
 
@@ -2549,11 +2524,7 @@ xlog_write(
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
@@ -3612,7 +3583,6 @@ xlog_ticket_alloc(
 	struct xlog		*log,
 	int			unit_bytes,
 	int			cnt,
-	char			client,
 	bool			permanent)
 {
 	struct xlog_ticket	*tic;
@@ -3630,7 +3600,6 @@ xlog_ticket_alloc(
 	tic->t_cnt		= cnt;
 	tic->t_ocnt		= cnt;
 	tic->t_tid		= prandom_u32();
-	tic->t_clientid		= client;
 	if (permanent)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index dc1b77b92fc1..09b8fe9994f2 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -117,15 +117,11 @@ int	  xfs_log_mount_finish(struct xfs_mount *mp);
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
+void	xfs_log_space_wake(struct xfs_mount *mp);
+int	xfs_log_reserve(struct xfs_mount *mp, int length, int count,
+			struct xlog_ticket **ticket, bool permanent);
+int	xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
+void	xfs_log_unmount(struct xfs_mount *mp);
 bool	xfs_log_writable(struct xfs_mount *mp);
 
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f7a5d1ec24e0..9e2af0f97fef 100644
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
index 23103d68423c..65fb97d596dd 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -164,7 +164,6 @@ typedef struct xlog_ticket {
 	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
 	char		   t_ocnt;	 /* original count		 : 1  */
 	char		   t_cnt;	 /* current count		 : 1  */
-	char		   t_clientid;	 /* who does this belong to;	 : 1  */
 	char		   t_flags;	 /* properties of reservation	 : 1  */
 
         /* reservation array fields */
@@ -498,13 +497,8 @@ extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
 			    char *dp, int size);
 
 extern struct kmem_cache *xfs_log_ticket_cache;
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
index 59e2f9031b9f..82590007e6c5 100644
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
2.33.0

