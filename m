Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBEFC3A5A1
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 01:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC80D2173E
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 01:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfHZBkQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Aug 2019 21:40:16 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43997 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726308AbfHZBkQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Aug 2019 21:40:16 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1761C362104
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 11:40:12 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i23zO-0000rU-ET
        for linux-xfs@vger.kernel.org; Mon, 26 Aug 2019 11:40:10 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i23zO-0002uy-Cj
        for linux-xfs@vger.kernel.org; Mon, 26 Aug 2019 11:40:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: add kmem allocation trace points
Date:   Mon, 26 Aug 2019 11:40:05 +1000
Message-Id: <20190826014007.10877-2-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190826014007.10877-1-david@fromorbit.com>
References: <20190826014007.10877-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=FmdZ9Uzk2mMA:10 a=20KFwNOVAAAA:8
        a=XRU6-s-TUilnfxTrP2AA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When trying to correlate XFS kernel allocations to memory reclaim
behaviour, it is useful to know what allocations XFS is actually
attempting. This information is not directly available from
tracepoints in the generic memory allocation and reclaim
tracepoints, so these new trace points provide a high level
indication of what the XFS memory demand actually is.

There is no per-filesystem context in this code, so we just trace
the type of allocation, the size and the allocation constraints.
The kmem code also doesn't include much of the common XFS headers,
so there are a few definitions that need to be added to the trace
headers and a couple of types that need to be made common to avoid
needing to include the whole world in the kmem code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/kmem.c             | 11 +++++++++--
 fs/xfs/libxfs/xfs_types.h |  8 ++++++++
 fs/xfs/xfs_mount.h        |  7 -------
 fs/xfs/xfs_trace.h        | 33 +++++++++++++++++++++++++++++++++
 4 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 16bb9a328678..0a78ef0588f9 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -3,10 +3,10 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include <linux/sched/mm.h>
+#include "xfs.h"
 #include <linux/backing-dev.h>
-#include "kmem.h"
 #include "xfs_message.h"
+#include "xfs_trace.h"
 
 void *
 kmem_alloc(size_t size, xfs_km_flags_t flags)
@@ -15,6 +15,8 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 	gfp_t	lflags = kmem_flags_convert(flags);
 	void	*ptr;
 
+	trace_kmem_alloc(size, flags, _RET_IP_);
+
 	do {
 		ptr = kmalloc(size, lflags);
 		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
@@ -35,6 +37,8 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
 	void	*ptr;
 	gfp_t	lflags;
 
+	trace_kmem_alloc_large(size, flags, _RET_IP_);
+
 	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
 	if (ptr)
 		return ptr;
@@ -65,6 +69,8 @@ kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
 	gfp_t	lflags = kmem_flags_convert(flags);
 	void	*ptr;
 
+	trace_kmem_realloc(newsize, flags, _RET_IP_);
+
 	do {
 		ptr = krealloc(old, newsize, lflags);
 		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
@@ -85,6 +91,7 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 	gfp_t	lflags = kmem_flags_convert(flags);
 	void	*ptr;
 
+	trace_kmem_zone_alloc(kmem_cache_size(zone), flags, _RET_IP_);
 	do {
 		ptr = kmem_cache_alloc(zone, lflags);
 		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 802b34cd10fe..300b3e91ca3a 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -169,6 +169,14 @@ typedef struct xfs_bmbt_irec
 	xfs_exntst_t	br_state;	/* extent state */
 } xfs_bmbt_irec_t;
 
+/* per-AG block reservation types */
+enum xfs_ag_resv_type {
+	XFS_AG_RESV_NONE = 0,
+	XFS_AG_RESV_AGFL,
+	XFS_AG_RESV_METADATA,
+	XFS_AG_RESV_RMAPBT,
+};
+
 /*
  * Type verifier functions
  */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 4adb6837439a..fdb60e09a9c5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -327,13 +327,6 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 }
 
 /* per-AG block reservation data structures*/
-enum xfs_ag_resv_type {
-	XFS_AG_RESV_NONE = 0,
-	XFS_AG_RESV_AGFL,
-	XFS_AG_RESV_METADATA,
-	XFS_AG_RESV_RMAPBT,
-};
-
 struct xfs_ag_resv {
 	/* number of blocks originally reserved here */
 	xfs_extlen_t			ar_orig_reserved;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8094b1920eef..8bb8b4704a00 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -23,6 +23,7 @@ struct xlog;
 struct xlog_ticket;
 struct xlog_recover;
 struct xlog_recover_item;
+struct xlog_rec_header;
 struct xfs_buf_log_format;
 struct xfs_inode_log_format;
 struct xfs_bmbt_irec;
@@ -30,6 +31,10 @@ struct xfs_btree_cur;
 struct xfs_refcount_irec;
 struct xfs_fsmap;
 struct xfs_rmap_irec;
+struct xfs_icreate_log;
+struct xfs_owner_info;
+struct xfs_trans_res;
+struct xfs_inobt_rec_incore;
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
@@ -3575,6 +3580,34 @@ TRACE_EVENT(xfs_pwork_init,
 		  __entry->nr_threads, __entry->pid)
 )
 
+DECLARE_EVENT_CLASS(xfs_kmem_class,
+	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip),
+	TP_ARGS(size, flags, caller_ip),
+	TP_STRUCT__entry(
+		__field(ssize_t, size)
+		__field(int, flags)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->size = size;
+		__entry->flags = flags;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("size %zd flags 0x%x caller %pS",
+		  __entry->size,
+		  __entry->flags,
+		  (char *)__entry->caller_ip)
+)
+
+#define DEFINE_KMEM_EVENT(name) \
+DEFINE_EVENT(xfs_kmem_class, name, \
+	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
+	TP_ARGS(size, flags, caller_ip))
+DEFINE_KMEM_EVENT(kmem_alloc);
+DEFINE_KMEM_EVENT(kmem_alloc_large);
+DEFINE_KMEM_EVENT(kmem_realloc);
+DEFINE_KMEM_EVENT(kmem_zone_alloc);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.23.0.rc1

