Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92DBC4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A981822260
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgJOHWM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:12 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35826 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729106AbgJOHWM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:12 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3BDB358C531
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvF-GC
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLa-8V
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/27] xfsprogs: get rid of ancient btree tracing fragments
Date:   Thu, 15 Oct 2020 18:21:33 +1100
Message-Id: <20201015072155.1631135-6-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=lOe2rhpUBD3KteouZl8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

If we are going to do any userspace tracing, it will be via the
existing libxfs tracepoint hooks, not the ancient Irix tracing
macros.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile          |  1 -
 include/libxfs.h          |  1 -
 include/xfs_btree_trace.h | 87 ---------------------------------------
 3 files changed, 89 deletions(-)
 delete mode 100644 include/xfs_btree_trace.h

diff --git a/include/Makefile b/include/Makefile
index 3031fb5ca3ad..632b819fcded 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -16,7 +16,6 @@ LIBHFILES = libxfs.h \
 	kmem.h \
 	list.h \
 	parent.h \
-	xfs_btree_trace.h \
 	xfs_inode.h \
 	xfs_log_recover.h \
 	xfs_metadump.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index b9370139becc..eb2db7f9647d 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -67,7 +67,6 @@ struct iomap;
 #include "xfs_inode_buf.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
-#include "xfs_btree_trace.h"
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
diff --git a/include/xfs_btree_trace.h b/include/xfs_btree_trace.h
deleted file mode 100644
index 72feab634cc9..000000000000
--- a/include/xfs_btree_trace.h
+++ /dev/null
@@ -1,87 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2008 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __XFS_BTREE_TRACE_H__
-#define	__XFS_BTREE_TRACE_H__
-
-struct xfs_btree_cur;
-struct xfs_buf;
-
-
-/*
- * Trace hooks.
- * i,j = integer (32 bit)
- * b = btree block buffer (xfs_buf_t)
- * p = btree ptr
- * r = btree record
- * k = btree key
- */
-
-#ifdef XFS_BTREE_TRACE
-
-/*
- * Trace buffer entry types.
- */
-#define XFS_BTREE_KTRACE_ARGBI   1
-#define XFS_BTREE_KTRACE_ARGBII  2
-#define XFS_BTREE_KTRACE_ARGFFFI 3
-#define XFS_BTREE_KTRACE_ARGI    4
-#define XFS_BTREE_KTRACE_ARGIPK  5
-#define XFS_BTREE_KTRACE_ARGIPR  6
-#define XFS_BTREE_KTRACE_ARGIK   7
-#define XFS_BTREE_KTRACE_ARGR	 8
-#define XFS_BTREE_KTRACE_CUR     9
-
-/*
- * Sub-types for cursor traces.
- */
-#define XBT_ARGS	0
-#define XBT_ENTRY	1
-#define XBT_ERROR	2
-#define XBT_EXIT	3
-
-void xfs_btree_trace_argbi(const char *, struct xfs_btree_cur *,
-		struct xfs_buf *, int, int);
-void xfs_btree_trace_argbii(const char *, struct xfs_btree_cur *,
-		struct xfs_buf *, int, int, int);
-void xfs_btree_trace_argi(const char *, struct xfs_btree_cur *, int, int);
-void xfs_btree_trace_argipk(const char *, struct xfs_btree_cur *, int,
-		union xfs_btree_ptr, union xfs_btree_key *, int);
-void xfs_btree_trace_argipr(const char *, struct xfs_btree_cur *, int,
-		union xfs_btree_ptr, union xfs_btree_rec *, int);
-void xfs_btree_trace_argik(const char *, struct xfs_btree_cur *, int,
-		union xfs_btree_key *, int);
-void xfs_btree_trace_argr(const char *, struct xfs_btree_cur *,
-		union xfs_btree_rec *, int);
-void xfs_btree_trace_cursor(const char *, struct xfs_btree_cur *, int, int);
-
-#define	XFS_BTREE_TRACE_ARGBI(c, b, i)	\
-	xfs_btree_trace_argbi(__func__, c, b, i, __LINE__)
-#define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)	\
-	xfs_btree_trace_argbii(__func__, c, b, i, j, __LINE__)
-#define	XFS_BTREE_TRACE_ARGI(c, i)	\
-	xfs_btree_trace_argi(__func__, c, i, __LINE__)
-#define	XFS_BTREE_TRACE_ARGIPK(c, i, p, k)	\
-	xfs_btree_trace_argipk(__func__, c, i, p, k, __LINE__)
-#define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)	\
-	xfs_btree_trace_argipr(__func__, c, i, p, r, __LINE__)
-#define	XFS_BTREE_TRACE_ARGIK(c, i, k)	\
-	xfs_btree_trace_argik(__func__, c, i, k, __LINE__)
-#define XFS_BTREE_TRACE_ARGR(c, r)	\
-	xfs_btree_trace_argr(__func__, c, r, __LINE__)
-#define	XFS_BTREE_TRACE_CURSOR(c, t)	\
-	xfs_btree_trace_cursor(__func__, c, t, __LINE__)
-#else
-#define	XFS_BTREE_TRACE_ARGBI(c, b, i)
-#define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)
-#define	XFS_BTREE_TRACE_ARGI(c, i)
-#define	XFS_BTREE_TRACE_ARGIPK(c, i, p, s)
-#define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)
-#define	XFS_BTREE_TRACE_ARGIK(c, i, k)
-#define XFS_BTREE_TRACE_ARGR(c, r)
-#define	XFS_BTREE_TRACE_CURSOR(c, t)
-#endif	/* XFS_BTREE_TRACE */
-
-#endif /* __XFS_BTREE_TRACE_H__ */
-- 
2.28.0

