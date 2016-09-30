Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49661 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935817AbcI3DMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:12:07 -0400
Subject: [PATCH 59/63] xfs: simulate per-AG reservations being critically low
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:12:03 -0700
Message-ID: <147520512357.29434.13990134651991752941.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Create an error injection point that enables us to simulate being
critically low on per-AG block reservations.  This should enable us to
simulate this specific ENOSPC condition so that we can test falling back
to a regular file copy.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c |    4 +++-
 fs/xfs/xfs_error.h          |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index adf770f..e5ebc37 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -109,7 +109,9 @@ xfs_ag_resv_critical(
 	trace_xfs_ag_resv_critical(pag, type, avail);
 
 	/* Critically low if less than 10% or max btree height remains. */
-	return avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS;
+	return XFS_TEST_ERROR(avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS,
+			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL,
+			XFS_RANDOM_AG_RESV_CRITICAL);
 }
 
 /*
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 8d8e1b07..05f8666 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -95,7 +95,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE		24
 #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
 #define XFS_ERRTAG_BMAP_FINISH_ONE			26
-#define XFS_ERRTAG_MAX					27
+#define XFS_ERRTAG_AG_RESV_CRITICAL			27
+#define XFS_ERRTAG_MAX					28
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -127,6 +128,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE		1
 #define XFS_RANDOM_REFCOUNT_FINISH_ONE			1
 #define XFS_RANDOM_BMAP_FINISH_ONE			1
+#define XFS_RANDOM_AG_RESV_CRITICAL			4
 
 #ifdef DEBUG
 extern int xfs_error_test_active;

