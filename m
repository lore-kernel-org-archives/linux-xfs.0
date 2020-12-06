Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF77C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D0C23120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgLFXKP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:10:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgLFXKP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:10:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5uTl182072;
        Sun, 6 Dec 2020 23:09:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=778FeqnpNwqmUoFSLIic+EhgWDGScojXRtoI+gpAaK0=;
 b=Rx3CNOQg3+LcYj6to0dYNHnDrjvTE+Gywu8OM2YMTbPvLkVKiBqJr5MYxGM6eWtRZuSg
 h9wrJFn7VHItcKu+4RByySLN2vqMHh4esMP0NRok2AVh9BsTGlDXoHxYzudk8zDv2YUm
 5BARb0BTZHjYlDVq8//KrOpx8voMOToiVTirTm4Ls4LHyA9MyVyuRSWXYffkN+Iv3C0+
 M9l4qW5NY5pUDoZQiIQLk4bVVVA9C7kFaXn+6xgoZIdv1JuGUr7RumJNlk3bT6+/koSP
 XuxZGV0mJKmbK79b3XYajBWsx9QDUFHNCWLcJpQBKiTZFI66KjInNvZlk5vLOJUVJ4bx YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35825ktufx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:09:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5aZs120577;
        Sun, 6 Dec 2020 23:09:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 358m4v64dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:09:29 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6N9Sde011129;
        Sun, 6 Dec 2020 23:09:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:09:28 -0800
Subject: [PATCH 1/3] xfs: move kernel-specific superblock validation out of
 libxfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, sandeen@sandeen.net, bfoster@redhat.com,
        david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 06 Dec 2020 15:09:26 -0800
Message-ID: <160729616682.1606994.13360186718552701085.stgit@magnolia>
In-Reply-To: <160729616025.1606994.13590463307385382944.stgit@magnolia>
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=2
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A couple of the superblock validation checks apply only to the kernel,
so move them to xfs_fc_fill_super before we add the needsrepair "feature",
which will prevent the kernel (but not xfsprogs) from mounting the
filesystem.  This also reduces the diff between kernel and userspace
libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |   27 ---------------------------
 fs/xfs/xfs_super.c     |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5aeafa59ed27..05359690aaed 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -382,17 +382,6 @@ xfs_validate_sb_common(
 		return -EFSCORRUPTED;
 	}
 
-	/*
-	 * Until this is fixed only page-sized or smaller data blocks work.
-	 */
-	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
-		xfs_warn(mp,
-		"File system with blocksize %d bytes. "
-		"Only pagesize (%ld) or less will currently work.",
-				sbp->sb_blocksize, PAGE_SIZE);
-		return -ENOSYS;
-	}
-
 	/*
 	 * Currently only very few inode sizes are supported.
 	 */
@@ -408,22 +397,6 @@ xfs_validate_sb_common(
 		return -ENOSYS;
 	}
 
-	if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
-	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
-		xfs_warn(mp,
-		"file system too large to be mounted on this system.");
-		return -EFBIG;
-	}
-
-	/*
-	 * Don't touch the filesystem if a user tool thinks it owns the primary
-	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
-	 * we don't check them at all.
-	 */
-	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && sbp->sb_inprogress) {
-		xfs_warn(mp, "Offline file system operation in progress!");
-		return -EFSCORRUPTED;
-	}
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e3e229e52512..599566c1a3b4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1467,6 +1467,38 @@ xfs_fc_fill_super(
 #endif
 	}
 
+	/*
+	 * Don't touch the filesystem if a user tool thinks it owns the primary
+	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
+	 * we don't check them at all.
+	 */
+	if (mp->m_sb.sb_inprogress) {
+		xfs_warn(mp, "Offline file system operation in progress!");
+		error = -EFSCORRUPTED;
+		goto out_free_sb;
+	}
+
+	/*
+	 * Until this is fixed only page-sized or smaller data blocks work.
+	 */
+	if (mp->m_sb.sb_blocksize > PAGE_SIZE) {
+		xfs_warn(mp,
+		"File system with blocksize %d bytes. "
+		"Only pagesize (%ld) or less will currently work.",
+				mp->m_sb.sb_blocksize, PAGE_SIZE);
+		error = -ENOSYS;
+		goto out_free_sb;
+	}
+
+	/* Ensure this filesystem fits in the page cache limits */
+	if (xfs_sb_validate_fsb_count(&mp->m_sb, mp->m_sb.sb_dblocks) ||
+	    xfs_sb_validate_fsb_count(&mp->m_sb, mp->m_sb.sb_rblocks)) {
+		xfs_warn(mp,
+		"file system too large to be mounted on this system.");
+		error = -EFBIG;
+		goto out_free_sb;
+	}
+
 	/*
 	 * XFS block mappings use 54 bits to store the logical block offset.
 	 * This should suffice to handle the maximum file size that the VFS

