Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC77EC71156
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99F6E20796
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J4pEmyLI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbgLADiK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:38:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60062 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbgLADiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:38:10 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13Stlx065761;
        Tue, 1 Dec 2020 03:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5+2M8DidoMXwzBumheTOauduYlG2/kr4cmaArnwHRLo=;
 b=J4pEmyLI2FCDn5wPXmlpoo9Lj/rhrVF4/nZKIkjk5iEkZBECFABp2nqhiCa5yhKAX64D
 YkppnaBUVtMlxiS/VdCmoByxpo6nwtXK4sKWo/eTfpehDEavjGn2mjMrrmY9eG/P1T9H
 hDbx9feyJfCq0L6otXbqhmTRQYfi1hWPQPV460n3fi8PeLWaebc2mwDhrNIvRI3asVCt
 IgZbd0MjSuirye7+/Xk1V5gdfC/tE/n/sHt8cnQWOq1+R2pjOvmXSStpiYYWCQScAuRu
 dB7B/Os8cEqTvc8ncb8wGdwMDPG/fzGQfdR2iGd7lwFjowrUyqyv6ktADp54pZhm1ikm KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 353c2arhk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 03:37:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13UIP2181296;
        Tue, 1 Dec 2020 03:37:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540arh7qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 03:37:27 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B13bQHs004979;
        Tue, 1 Dec 2020 03:37:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:37:26 -0800
Subject: [PATCH 1/3] xfs: move kernel-specific superblock validation out of
 libxfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:37:25 -0800
Message-ID: <160679384513.447856.3675245763779550446.stgit@magnolia>
In-Reply-To: <160679383892.447856.12907477074923729733.stgit@magnolia>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A couple of the superblock validation checks apply only to the kernel,
so move them to xfs_mount.c before we start changing sb_inprogress.
This also reduces the diff between kernel and userspace libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |   23 ++++-------------------
 fs/xfs/libxfs/xfs_sb.h |    3 +++
 fs/xfs/xfs_mount.c     |   31 +++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5aeafa59ed27..a2c43fe38f64 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -223,6 +223,7 @@ xfs_validate_sb_common(
 	struct xfs_dsb		*dsb = bp->b_addr;
 	uint32_t		agcount = 0;
 	uint32_t		rem;
+	int			error;
 
 	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
 		xfs_warn(mp, "bad magic number");
@@ -382,16 +383,9 @@ xfs_validate_sb_common(
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
+	error = xfs_sb_validate_mount(mp, bp, sbp);
+	if (error)
+		return error;
 
 	/*
 	 * Currently only very few inode sizes are supported.
@@ -415,15 +409,6 @@ xfs_validate_sb_common(
 		return -EFBIG;
 	}
 
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
 
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 92465a9a5162..ee0a5858dd47 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -42,4 +42,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
 
+int xfs_sb_validate_mount(struct xfs_mount *mp, struct xfs_buf *bp,
+		struct xfs_sb *sbp);
+
 #endif	/* __XFS_SB_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7110507a2b6b..7bc7901d648d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -259,6 +259,37 @@ xfs_initialize_perag(
 	return error;
 }
 
+/* Validate the superblock is compatible with this mount. */
+int
+xfs_sb_validate_mount(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	struct xfs_sb		*sbp)
+{
+	/*
+	 * Don't touch the filesystem if a user tool thinks it owns the primary
+	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
+	 * we don't check them at all.
+	 */
+	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && sbp->sb_inprogress) {
+		xfs_warn(mp, "Offline file system operation in progress!");
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Until this is fixed only page-sized or smaller data blocks work.
+	 */
+	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
+		xfs_warn(mp,
+		"File system with blocksize %d bytes. "
+		"Only pagesize (%ld) or less will currently work.",
+				sbp->sb_blocksize, PAGE_SIZE);
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
 /*
  * xfs_readsb
  *

