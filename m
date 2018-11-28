Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48942 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbeK2Kci (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 05:32:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wASNSU8w196568
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:18 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2nxx2ud9c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wASNTICv019130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:18 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wASNTIbn027541
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:18 GMT
Subject: [PATCH 4/6] xfs: move XFS_INODE_FORMAT_STR mappings to libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Nov 2018 15:29:17 -0800
Message-ID: <154344775711.4341.699323732443443292.stgit@magnolia>
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

Move XFS_INODE_FORMAT_STR to libxfs so that we don't forget to keep it
updated, and add necessary TRACE_DEFINE_ENUM.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    7 +++++++
 fs/xfs/xfs_trace.h         |   10 +++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b15412e4c535..d8902114786d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -925,6 +925,13 @@ typedef enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_UUID		/* added long ago, but never used */
 } xfs_dinode_fmt_t;
 
+#define XFS_INODE_FORMAT_STR \
+	{ XFS_DINODE_FMT_DEV,		"dev" }, \
+	{ XFS_DINODE_FMT_LOCAL,		"local" }, \
+	{ XFS_DINODE_FMT_EXTENTS,	"extent" }, \
+	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
+	{ XFS_DINODE_FMT_UUID,		"uuid" }
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3f57002ca660..94e289aca220 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1901,11 +1901,11 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
 	{ 0,	"target" }, \
 	{ 1,	"temp" }
 
-#define XFS_INODE_FORMAT_STR \
-	{ 0,	"invalid" }, \
-	{ 1,	"local" }, \
-	{ 2,	"extent" }, \
-	{ 3,	"btree" }
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_DEV);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_LOCAL);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_EXTENTS);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_BTREE);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_UUID);
 
 DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 	TP_PROTO(struct xfs_inode *ip, int which),
