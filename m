Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B840C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BFD8215A4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N0ulRJMW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgCKAsY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:48:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47518 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgCKAsY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 20:48:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0mNYV009162
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EHF/XkIhQKoDOXH/tDnj784K4mIC+X9675Dhe0V1JO4=;
 b=N0ulRJMWTP9PieaH6Si4AcbaegF8fnlWHx5Bkzpi6zwLlYIrlHlpHM3oh/0IkHFccKDU
 cMemYTG3coak1CVhGImIiFufAxE+Vcfef8IBGo21EIgVLND3N4Qlox3ql8W99aT3TA0H
 lsPPC4rw5Toig4D5R5V8rsC89VdM5rZCToeP8st9UZPmhik/fxPwCHi3BCYpYmLaLG6H
 +5Q4GU5JUxFukQv0CXCKGREYjk7JByemaKpPKZsyUYnpjR4Ad48OatiJd4Kz5NllNXu4
 G0Z/+Yv446KmplSgf0yKd9ZArm5Irjtpf/JcTdSwaq4C0HGyNHuPgLehIlbwwMuX8hwY fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yp9v63sdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0lp9I029446
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2yp8rnndcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:22 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02B0mLcn020212
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 17:48:21 -0700
Subject: [PATCH 3/3] xfs: scrub should mark dir corrupt if entry points to
 unallocated inode
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Mar 2020 17:48:20 -0700
Message-ID: <158388770010.939608.11408184090778445318.stgit@magnolia>
In-Reply-To: <158388768123.939608.12366470947594416375.stgit@magnolia>
References: <158388768123.939608.12366470947594416375.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110001
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

We can also remove the !hasftype code from the function, because any
DT_ flags we encounter on those filesystems were synthesized in core,
not read in from disk.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index ef7cc8e101ab..c186c83544ac 100644
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
@@ -66,17 +62,26 @@ xchk_dir_check_ftype(
 	 * eofblocks cleanup (which allocates what would be a nested
 	 * transaction), we can't use DONTCACHE here because DONTCACHE
 	 * inodes can trigger immediate inactive cleanup of the inode.
+	 *
+	 * We use UNTRUSTED here to force validation of the inode number (using
+	 * the inode btree) before we look up the inode record.  If this fails
+	 * validation for any reason, we will receive EINVAL, which indicates a
+	 * corrupt directory entry.
 	 */
-	error = xfs_iget(mp, sdc->sc->tp, inum, 0, 0, &ip);
+	error = xfs_iget(mp, sdc->sc->tp, inum, XFS_IGET_UNTRUSTED, 0, &ip);
+	if (error == -EINVAL)
+		error = -EFSCORRUPTED;
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
+	}
 	xfs_irele(ip);
 out:
 	return error;
@@ -166,8 +171,8 @@ xchk_dir_actor(
 		goto out;
 	}
 
-	/* Verify the file type.  This function absorbs error codes. */
-	error = xchk_dir_check_ftype(sdc, offset, lookup_ino, type);
+	/* Verify the inode pointer.  This function absorbs error codes. */
+	error = xchk_dir_check_iptr(sdc, offset, lookup_ino, type);
 	if (error)
 		goto out;
 out:

