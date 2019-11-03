Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6FECA9ED0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FD6121D56
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZfSsmfYK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfKCWYa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:24:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfKCWYa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:24:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOSpX086713
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vPf4pMDgowIi3LRC22oAtYnUVI0ncvt5Fs4X277GySI=;
 b=ZfSsmfYKJhM8cfJ7mzGRbx/3lg/J9K2skWNSPzcpKEuKK7B6l7SDHaOqy/+qsgoKDaz2
 uffG3V75HC2PJ2gdo7/lc4ANdpwBkLkeuh81vAiKzxfa3IDAAdl57R6ou87XUYquSBUO
 NWizsqFRcZbd3JBXEtgYpHJbPyCTMGAJnLg96fZs+60QG3WocaieAB8H4XhH+maW60N3
 Q79p/gKcvfZ7lGqFIYoDr30evV5qzMosb+CeEwVTdkYz2D3Bl1EuhkaDSZS0t3w98rZ8
 DrITSsxJk1UM6q5we/Z7bUIyL8tc9fUEOftSZUT9BKjqWUH/Vymx9n52234f+GmciX8L tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w117tm5yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MORe5026812
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w1kxk9r8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:27 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA3MNpOf005096
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:23:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:23:51 -0800
Subject: [PATCH 1/3] xfs: relax shortform directory size checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:23:49 -0800
Message-ID: <157281982989.4150947.13552708841526849932.stgit@magnolia>
In-Reply-To: <157281982341.4150947.10288936972373805803.stgit@magnolia>
References: <157281982341.4150947.10288936972373805803.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=314
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=392 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030234
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Each of the four functions that operate on shortform directories checks
that the directory's di_size is at least as large as the shortform
directory header.  This is now checked by the inode fork verifiers
(di_size is used to allocate if_bytes, and if_bytes is checked against
the header structure size) so we can turn these checks into ASSERTions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_block.c |    8 +-------
 fs/xfs/libxfs/xfs_dir2_sf.c    |   32 ++++----------------------------
 2 files changed, 5 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 49e4bc39e7bb..e1afa35141c5 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1073,13 +1073,7 @@ xfs_dir2_sf_to_block(
 	mp = dp->i_mount;
 	ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
-	/*
-	 * Bomb out if the shortform directory is way too short.
-	 */
-	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		return -EIO;
-	}
+	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 
 	oldsfp = (xfs_dir2_sf_hdr_t *)ifp->if_u1.if_data;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index ae16ca7c422a..d6b164a2fe57 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -277,13 +277,7 @@ xfs_dir2_sf_addname(
 	ASSERT(xfs_dir2_sf_lookup(args) == -ENOENT);
 	dp = args->dp;
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
-	/*
-	 * Make sure the shortform value has some of its header.
-	 */
-	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
-		return -EIO;
-	}
+	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
@@ -793,13 +787,7 @@ xfs_dir2_sf_lookup(
 	dp = args->dp;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
-	/*
-	 * Bail out if the directory is way too short.
-	 */
-	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
-		return -EIO;
-	}
+	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
@@ -879,13 +867,7 @@ xfs_dir2_sf_removename(
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
 	oldsize = (int)dp->i_d.di_size;
-	/*
-	 * Bail out if the directory is way too short.
-	 */
-	if (oldsize < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
-		return -EIO;
-	}
+	ASSERT(oldsize >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == oldsize);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
@@ -963,13 +945,7 @@ xfs_dir2_sf_replace(
 	dp = args->dp;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
-	/*
-	 * Bail out if the shortform directory is way too small.
-	 */
-	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
-		return -EIO;
-	}
+	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;

