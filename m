Return-Path: <SRS0=pdRq=4R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54999C3F2D2
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 01:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 273E52468A
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 01:49:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xLQW0PDl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgB2Bt0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 20:49:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40782 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgB2Bt0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 20:49:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1lMka060344
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4uYXMqYVEklb1Jgqbt43gv6xNAKzbqsIP85arK5blj8=;
 b=xLQW0PDlLbdwTjaWacWywAbbyUKmd2+odT07UlfEGT9k6U0nG+WDq78M8vtkYaih1HR0
 x7PY/f8H9+lk6HdNJHBXB009gp0vYRQKy1cWDgyhReOMwEBc9z5cfTm9Q+NPfiBYQh8i
 atn5MIcOdXGWiUJAfIy8O7coXgC79ezpCZruy/7MoZvDx5E7gqa3g2pPdk1o2jTAkaZ3
 5YiB9M/hvs0qjKuDRDqEJnPR/P3u0myg08asuQTSirWki9ZMtXCPRgW0Evx7M6YCKokF
 X6+rf2BwDBXSXljzfrSJ7rz0hvpiRrJ3wcUT7YI0kpdUcfprEzZN/trjgF55HGsmDhFy nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ydcsnx739-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1gqhp165307
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yfe0d1r5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:23 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01T1nNSQ017131
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 17:49:23 -0800
Subject: [PATCH 3/3] xfs: scrub should mark dir corrupt if entry points to
 unallocated inode
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Feb 2020 17:49:22 -0800
Message-ID: <158294096213.1730101.1870315264682758950.stgit@magnolia>
In-Reply-To: <158294094367.1730101.10848559171120744339.stgit@magnolia>
References: <158294094367.1730101.10848559171120744339.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xchk_dir_check_ftype, we should mark the directory corrupt if we try
to _iget a directory entry's inode pointer and the inode btree says the
inode is not allocated.  This involves changing the IGET call to force
the inobt lookup to return EINVAL if the inode isn't allocated; and
rearranging the code so that we always perform the iget.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c |   43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 54afa75c95d1..a775fbf49a0d 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -39,9 +39,12 @@ struct xchk_dir_ctx {
 	struct xfs_scrub	*sc;
 };
 
-/* Check that an inode's mode matches a given DT_ type. */
+/*
+ * Check that a directory entry's inode pointer directs us to an allocated
+ * inode and (if applicable) the inode mode matches the entry's DT_ type.
+ */
 STATIC int
-xchk_dir_check_ftype(
+xchk_dir_check_iptr(
 	struct xchk_dir_ctx	*sdc,
 	xfs_fileoff_t		offset,
 	xfs_ino_t		inum,
@@ -52,13 +55,6 @@ xchk_dir_check_ftype(
 	int			ino_dtype;
 	int			error = 0;
 
-	if (!xfs_sb_version_hasftype(&mp->m_sb)) {
-		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
-			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
-					offset);
-		goto out;
-	}
-
 	/*
 	 * Grab the inode pointed to by the dirent.  We release the
 	 * inode before we cancel the scrub transaction.  Since we're
@@ -66,17 +62,30 @@ xchk_dir_check_ftype(
 	 * eofblocks cleanup (which allocates what would be a nested
 	 * transaction), we can't use DONTCACHE here because DONTCACHE
 	 * inodes can trigger immediate inactive cleanup of the inode.
+	 *
+	 * We use UNTRUSTED here so that iget will return EINVAL if we have an
+	 * inode pointer that points to an unallocated inode.
 	 */
-	error = xfs_iget(mp, sdc->sc->tp, inum, 0, 0, &ip);
+	error = xfs_iget(mp, sdc->sc->tp, inum, XFS_IGET_UNTRUSTED, 0, &ip);
+	if (error == -EINVAL) {
+		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+		return -EFSCORRUPTED;
+	}
 	if (!xchk_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
 			&error))
 		goto out;
 
-	/* Convert mode to the DT_* values that dir_emit uses. */
-	ino_dtype = xfs_dir3_get_dtype(mp,
-			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
-	if (ino_dtype != dtype)
-		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+	if (xfs_sb_version_hasftype(&mp->m_sb)) {
+		/* Convert mode to the DT_* values that dir_emit uses. */
+		ino_dtype = xfs_dir3_get_dtype(mp,
+				xfs_mode_to_ftype(VFS_I(ip)->i_mode));
+		if (ino_dtype != dtype)
+			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+	} else {
+		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
+			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
+					offset);
+	}
 	xfs_irele(ip);
 out:
 	return error;
@@ -168,8 +177,8 @@ xchk_dir_actor(
 		goto out;
 	}
 
-	/* Verify the file type.  This function absorbs error codes. */
-	error = xchk_dir_check_ftype(sdc, offset, lookup_ino, type);
+	/* Verify the inode pointer.  This function absorbs error codes. */
+	error = xchk_dir_check_iptr(sdc, offset, lookup_ino, type);
 	if (error)
 		goto out;
 out:

