Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37662 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965220AbeALWEI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 17:04:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0CLvM7X044711
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:08 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2ff5c081qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:08 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0CM47Qi010675
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:07 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0CM47cC008261
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:07 GMT
Subject: [PATCH 1/5] xfs: check sb_agblocks and sb_agblklog when validating
 superblock
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 12 Jan 2018 14:04:06 -0800
Message-ID: <151579464601.8694.5478076755339350941.stgit@magnolia>
In-Reply-To: <151579463950.8694.320025813242574491.stgit@magnolia>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Currently, we don't check sb_agblocks or sb_agblklog when we validate
the superblock, which means that we can fuzz garbage values into those
values and the mount succeeds.  This leads to all sorts of UBSAN
warnings in xfs/350 since we can then coerce other parts of xfs into
shifting by ridiculously large values.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    7 +++++++
 fs/xfs/libxfs/xfs_sb.c |    3 +++
 2 files changed, 10 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index fc4386a..2701ea0 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -233,6 +233,13 @@ typedef struct xfs_fsop_resblks {
 #define XFS_MAX_LOG_BLOCKS	(1024 * 1024ULL)
 #define XFS_MIN_LOG_BYTES	(10 * 1024 * 1024ULL)
 
+/* Limits on sb_agblocks/sb_agblklog */
+#define XFS_AG_BYTES(bblog)	((long long)BBSIZE << (bblog))
+#define XFS_AG_MIN_BYTES	((XFS_AG_BYTES(15)))	/* 16 MB */
+#define XFS_AG_MAX_BYTES	((XFS_AG_BYTES(31)))	/* 1 TB */
+#define XFS_AG_MIN_BLOCKS(blog)	(XFS_AG_MIN_BYTES >> (blog))
+#define XFS_AG_MAX_BLOCKS(blog)	((XFS_AG_MAX_BYTES - 1) >> (blog))
+
 /* keep the maximum size under 2^31 by a small amount */
 #define XFS_MAX_LOG_BYTES \
 	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 08e44a0..1f81b49 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -253,6 +253,9 @@ xfs_mount_validate_sb(
 	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
 	    sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE			||
 	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
+	    sbp->sb_agblocks < XFS_AG_MIN_BLOCKS(sbp->sb_blocklog)	||
+	    sbp->sb_agblocks > XFS_AG_MAX_BLOCKS(sbp->sb_blocklog)	||
+	    sbp->sb_agblklog != xfs_highbit32(sbp->sb_agblocks - 1) + 1	||
 	    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)	||
 	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||
 	    (sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)	||

