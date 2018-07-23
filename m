Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388107AbeGWOFX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 10:05:23 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D28714059FFD
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE7C5111AF23
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 05/15] xfs: remove unused deferred ops committed field
Date: Mon, 23 Jul 2018 09:04:04 -0400
Message-Id: <20180723130414.47980-6-bfoster@redhat.com>
In-Reply-To: <20180723130414.47980-1-bfoster@redhat.com>
References: <20180723130414.47980-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

dop_committed is set when deferred item processing rolls the
transaction at least once, but is only ever accessed in tracepoints.
The transaction roll/commit events are already available via
independent tracepoints, so remove the otherwise unused field.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c | 1 -
 fs/xfs/libxfs/xfs_defer.h | 1 -
 fs/xfs/xfs_trace.h        | 8 ++------
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ee734a8b3fa9..0df09c094e42 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -249,7 +249,6 @@ xfs_defer_trans_roll(
 		xfs_defer_trans_abort(*tp, dop, error);
 		return error;
 	}
-	dop->dop_committed = true;
 
 	/* Rejoin the joined inodes. */
 	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index c17c9deda995..58c979c9f3fa 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -49,7 +49,6 @@ enum xfs_defer_ops_type {
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 struct xfs_defer_ops {
-	bool			dop_committed;	/* did any trans commit? */
 	bool			dop_low;	/* alloc in low mode */
 	struct list_head	dop_intake;	/* unlogged pending work */
 	struct list_head	dop_pending;	/* logged pending work */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b668fc127aa7..cc6995cfce66 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2229,14 +2229,12 @@ DECLARE_EVENT_CLASS(xfs_defer_class,
 	TP_fast_assign(
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
 		__entry->dop = dop;
-		__entry->committed = dop->dop_committed;
 		__entry->low = dop->dop_low;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ops %p committed %d low %d, caller %pS",
+	TP_printk("dev %d:%d ops %p low %d, caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->dop,
-		  __entry->committed,
 		  __entry->low,
 		  (char *)__entry->caller_ip)
 )
@@ -2259,14 +2257,12 @@ DECLARE_EVENT_CLASS(xfs_defer_error_class,
 	TP_fast_assign(
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
 		__entry->dop = dop;
-		__entry->committed = dop->dop_committed;
 		__entry->low = dop->dop_low;
 		__entry->error = error;
 	),
-	TP_printk("dev %d:%d ops %p committed %d low %d err %d",
+	TP_printk("dev %d:%d ops %p low %d err %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->dop,
-		  __entry->committed,
 		  __entry->low,
 		  __entry->error)
 )
-- 
2.17.1

