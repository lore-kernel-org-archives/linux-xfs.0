Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47602 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbeK2Kcc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 05:32:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wASNTDmR157315
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:13 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2nxy9rd799-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:13 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wASNTCgC016521
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:12 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wASNTCwn027525
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:12 GMT
Subject: [PATCH 3/6] xfs: move XFS_AG_BTREE_CMP_FORMAT_STR mappings to libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Nov 2018 15:29:11 -0800
Message-ID: <154344775094.4341.5105915870413863379.stgit@magnolia>
In-Reply-To: <154344773243.4341.5458822684407979916.stgit@magnolia>
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move XFS_AG_BTREE_CMP_FORMAT_STR to libxfs so that we don't forget to
keep it updated, and TRACE_DEFINE_ENUM the values while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_types.h |    5 +++++
 fs/xfs/xfs_trace.h        |    7 +++----
 2 files changed, 8 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 05e8fa558f3e..297cf2318f83 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -104,6 +104,11 @@ typedef enum {
 	XFS_LOOKUP_EQi, XFS_LOOKUP_LEi, XFS_LOOKUP_GEi
 } xfs_lookup_t;
 
+#define XFS_AG_BTREE_CMP_FORMAT_STR \
+	{ XFS_LOOKUP_EQi,	"eq" }, \
+	{ XFS_LOOKUP_LEi,	"le" }, \
+	{ XFS_LOOKUP_GEi,	"ge" }
+
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index dcde4e9907f7..3f57002ca660 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2626,10 +2626,9 @@ DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 #define DEFINE_AG_EXTENT_EVENT(name) DEFINE_DISCARD_EVENT(name)
 
 /* ag btree lookup tracepoint class */
-#define XFS_AG_BTREE_CMP_FORMAT_STR \
-	{ XFS_LOOKUP_EQ,	"eq" }, \
-	{ XFS_LOOKUP_LE,	"le" }, \
-	{ XFS_LOOKUP_GE,	"ge" }
+TRACE_DEFINE_ENUM(XFS_LOOKUP_EQi);
+TRACE_DEFINE_ENUM(XFS_LOOKUP_LEi);
+TRACE_DEFINE_ENUM(XFS_LOOKUP_GEi);
 DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_lookup_t dir),
