Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39435 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753736AbcKEAZU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:25:20 -0400
Subject: [PATCH 07/39] xfs: add scrub tracepoints
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:25:16 -0700
Message-ID: <147830551620.4165.8090533555442024062.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_types.h |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index cf044c0..442b223 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -95,6 +95,11 @@ typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
 #define	XFS_ATTR_FORK	1
 #define	XFS_COW_FORK	2
 
+#define XFS_FORK_DESC \
+	{ XFS_DATA_FORK,	"data" }, \
+	{ XFS_ATTR_FORK,	"attr" }, \
+	{ XFS_COW_FORK,		"CoW" }
+
 /*
  * Min numbers of data/attr fork btree root pointers.
  */

