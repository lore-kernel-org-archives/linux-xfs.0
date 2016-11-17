Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:10553 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752723AbcKQX5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 18:57:05 -0500
Received: from disappointment.disaster.area ([192.168.1.110] helo=disappointment)
        by dastard with esmtp (Exim 4.80)
        (envelope-from <dave@fromorbit.com>)
        id 1c7WWq-0008NQ-Og
        for linux-xfs@vger.kernel.org; Fri, 18 Nov 2016 10:55:40 +1100
Received: from dave by disappointment with local (Exim 4.87)
        (envelope-from <dave@disappointment.disaster>)
        id 1c7WWr-00020H-MK
        for linux-xfs@vger.kernel.org; Fri, 18 Nov 2016 10:55:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: add more AGF/AGFL manipulation tracepoints
Date: Fri, 18 Nov 2016 10:55:33 +1100
Message-Id: <1479426935-7112-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1479426935-7112-1-git-send-email-david@fromorbit.com>
References: <20161117213224.GD28177@dastard>
 <1479426935-7112-1-git-send-email-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So we can see what blocks are added to or removed from the AGFL during
allocation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  8 ++++++--
 fs/xfs/xfs_trace.h        | 11 ++++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index effb64cf714f..a5a9d8360e74 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2264,10 +2264,12 @@ xfs_alloc_get_freelist(
 	xfs_mount_t	*mp = tp->t_mountp;
 	xfs_perag_t	*pag;	/* per allocation group data */
 
+	agf = XFS_BUF_TO_AGF(agbp);
+	trace_xfs_alloc_get_freelist(mp, agf, 0, _RET_IP_);
+
 	/*
 	 * Freelist is empty, give up.
 	 */
-	agf = XFS_BUF_TO_AGF(agbp);
 	if (!agf->agf_flcount) {
 		*bnop = NULLAGBLOCK;
 		return 0;
@@ -2392,8 +2394,9 @@ xfs_alloc_put_freelist(
 	__be32			*agfl_bno;
 	int			startoff;
 
-	agf = XFS_BUF_TO_AGF(agbp);
 	mp = tp->t_mountp;
+	agf = XFS_BUF_TO_AGF(agbp);
+	trace_xfs_alloc_put_freelist(mp, agf, 0, _RET_IP_);
 
 	if (!agflbp && (error = xfs_alloc_read_agfl(mp, tp,
 			be32_to_cpu(agf->agf_seqno), &agflbp)))
@@ -2555,6 +2558,7 @@ xfs_read_agf(
 	if (!*bpp)
 		return 0;
 
+	trace_xfs_read_agf_detail(mp, XFS_BUF_TO_AGF(*bpp), 0, _RET_IP_);
 	ASSERT(!(*bpp)->b_error);
 	xfs_buf_set_ref(*bpp, XFS_AGF_REF);
 	return 0;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0907752be62d..73e001d795ce 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1516,7 +1516,7 @@ TRACE_EVENT(xfs_trans_commit_lsn,
 		  __entry->lsn)
 );
 
-TRACE_EVENT(xfs_agf,
+DECLARE_EVENT_CLASS(xfs_agf_class,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags,
 		 unsigned long caller_ip),
 	TP_ARGS(mp, agf, flags, caller_ip),
@@ -1572,6 +1572,15 @@ TRACE_EVENT(xfs_agf,
 		  __entry->longest,
 		  (void *)__entry->caller_ip)
 );
+#define DEFINE_AGF_EVENT(name) \
+DEFINE_EVENT(xfs_agf_class, name, \
+	TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags, \
+		 unsigned long caller_ip), \
+	TP_ARGS(mp, agf, flags, caller_ip))
+DEFINE_AGF_EVENT(xfs_agf);
+DEFINE_AGF_EVENT(xfs_read_agf_detail);
+DEFINE_AGF_EVENT(xfs_alloc_get_freelist);
+DEFINE_AGF_EVENT(xfs_alloc_put_freelist);
 
 TRACE_EVENT(xfs_free_extent,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
-- 
2.8.0.rc3

