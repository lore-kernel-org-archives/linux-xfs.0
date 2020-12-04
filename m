Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F77BC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B3C4224B1
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgLDBNp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:13:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgLDBNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:13:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B419iSR014512
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:13:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Y2BvPBmz78+AcBfQwPMRKtH3ndZAJkFp8i8QIZ6C804=;
 b=V1s5E8WelpbEo6PuOQtv20Pm+lz0uF1qeyQE9FrOZ5xBuFo89i1R8OhbGSBifZg7fG1u
 TaqXf1wV/t3Tf6RUGGVwdTOu4c24w3iC7r4AMaPO3O/ghoDJTYZ3Y9CQhB7ouI00pJZf
 A5GzAfLmr9C61w8t7fB02HoVNWHpw2DWv2jSmwZJZYIjyGKSllTecCDh3obliKJSCa12
 aJQ+GIT/oSjGdCERn2sRGA9QFH5Nh2+mrLKQld8iSVNhylVQXXIIn3U/f+RzwqV1fx+I
 siW2e+B/B4BEMvV7lgfegmCXhJpgWyjxklhcYqMoJDJhmwlFepZj+DMtDVF6NBmFI/ga 1Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egm0yn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Dec 2020 01:13:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41AElV115915
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:13:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540f2n4rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Dec 2020 01:13:03 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B41D3ls002735
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:13:03 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 17:13:03 -0800
Subject: [PATCH 3/3] xfs: scrub should mark a directory corrupt if any entries
 cannot be iget'd
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 03 Dec 2020 17:13:02 -0800
Message-ID: <160704438289.736504.15952269053640029711.stgit@magnolia>
In-Reply-To: <160704436050.736504.11280764290946254498.stgit@magnolia>
References: <160704436050.736504.11280764290946254498.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=3 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

It's possible that xfs_iget can return EINVAL for inodes that the inobt
thinks are free, or ENOENT for inodes that look free.  If this is the
case, mark the directory corrupt immediately when we check ftype.  Note
that we already check the ftype of the '.' and '..' entries, so we
can skip the iget part since we already know the inode type for '.' and
we have a separate parent pointer scrubber for '..'.

Fixes: a5c46e5e8912 ("xfs: scrub directory metadata")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index b045e95c2ea7..178b3455a170 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -66,8 +66,18 @@ xchk_dir_check_ftype(
 	 * eofblocks cleanup (which allocates what would be a nested
 	 * transaction), we can't use DONTCACHE here because DONTCACHE
 	 * inodes can trigger immediate inactive cleanup of the inode.
+	 *
+	 * If _iget returns -EINVAL or -ENOENT then the child inode number is
+	 * garbage and the directory is corrupt.  If the _iget returns
+	 * -EFSCORRUPTED or -EFSBADCRC then the child is corrupt which is a
+	 *  cross referencing error.  Any other error is an operational error.
 	 */
 	error = xfs_iget(mp, sdc->sc->tp, inum, 0, 0, &ip);
+	if (error == -EINVAL || error == -ENOENT) {
+		error = -EFSCORRUPTED;
+		xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, 0, &error);
+		goto out;
+	}
 	if (!xchk_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
 			&error))
 		goto out;
@@ -105,6 +115,7 @@ xchk_dir_actor(
 	struct xfs_name		xname;
 	xfs_ino_t		lookup_ino;
 	xfs_dablk_t		offset;
+	bool			checked_ftype = false;
 	int			error = 0;
 
 	sdc = container_of(dir_iter, struct xchk_dir_ctx, dir_iter);
@@ -133,6 +144,7 @@ xchk_dir_actor(
 		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
+		checked_ftype = true;
 		if (ino != ip->i_ino)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
@@ -144,6 +156,7 @@ xchk_dir_actor(
 		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
+		checked_ftype = true;
 		if (ip->i_ino == mp->m_sb.sb_rootino && ino != ip->i_ino)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
@@ -167,9 +180,11 @@ xchk_dir_actor(
 	}
 
 	/* Verify the file type.  This function absorbs error codes. */
-	error = xchk_dir_check_ftype(sdc, offset, lookup_ino, type);
-	if (error)
-		goto out;
+	if (!checked_ftype) {
+		error = xchk_dir_check_ftype(sdc, offset, lookup_ino, type);
+		if (error)
+			goto out;
+	}
 out:
 	/*
 	 * A negative error code returned here is supposed to cause the

