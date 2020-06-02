Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A986C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE6A206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nJjphJAQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgFBE2S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:28:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35016 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgFBE2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:28:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524I5H7107526;
        Tue, 2 Jun 2020 04:26:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JF690Fqk1VGSWMJI7GfOpQPOFxBM6VRV8xFLfPI5WX4=;
 b=nJjphJAQ2EqsLgsxAstO5LJqteiouSdyHlfp3jrI9tKeNlWsYC3I9WPC9okCQbC3rIUW
 a2tY3LSJN+Uvqm7iGpmsLe+b5XniC08aSMslG3eRf5zK7v4AZ2cwaILCHJwS33Yp6m9u
 LgPxR8k5SEK3/eWm2CAjL4atLvrqZC7xqHVtOkiiE/KQ6hFDnWi3xNCDHXE/nWndy1wD
 tQ1s+GkXgq8FPTPWaG74BE2tXCWoqKnWSl3i5X2lqpyJjHNkNOEsBF9e9nOc5yWGt3EX
 PBwL0Qw1k+sXYTxI13/AGmYQa1dC/g6lbOQZnZN0enGu5ZHRv8W6xtQHC+mfWnZKY7Sx XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfem1t99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:26:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HwJW040244;
        Tue, 2 Jun 2020 04:26:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31c18sggpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:26:13 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524QDYJ020695;
        Tue, 2 Jun 2020 04:26:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:26:12 -0700
Subject: [PATCH 11/17] xfs_repair: refactor verify_dfsbno_range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:26:11 -0700
Message-ID: <159107197191.313760.3511623910256790079.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor this function to use libxfs type checking helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/dinode.c          |   26 +++++++++-----------------
 2 files changed, 10 insertions(+), 17 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c03f0efa..69f79a08 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -184,6 +184,7 @@
 #define xfs_verify_agbno		libxfs_verify_agbno
 #define xfs_verify_cksum		libxfs_verify_cksum
 #define xfs_verify_dir_ino		libxfs_verify_dir_ino
+#define xfs_verify_fsbno		libxfs_verify_fsbno
 #define xfs_verify_ino			libxfs_verify_ino
 #define xfs_verify_rtbno		libxfs_verify_rtbno
 #define xfs_zero_extent			libxfs_zero_extent
diff --git a/repair/dinode.c b/repair/dinode.c
index b343534c..135703d9 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -228,31 +228,23 @@ verify_dfsbno(xfs_mount_t	*mp,
 #define XR_DFSBNORANGE_OVERFLOW	3
 
 static __inline int
-verify_dfsbno_range(xfs_mount_t	*mp,
-		xfs_fsblock_t	fsbno,
-		xfs_filblks_t	count)
+verify_dfsbno_range(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno,
+	xfs_filblks_t		count)
 {
-	xfs_agnumber_t	agno;
-	xfs_agblock_t	agbno;
-	xfs_sb_t	*sbp = &mp->m_sb;;
-
 	/* the start and end blocks better be in the same allocation group */
-	agno = XFS_FSB_TO_AGNO(mp, fsbno);
-	if (agno != XFS_FSB_TO_AGNO(mp, fsbno + count - 1)) {
+	if (XFS_FSB_TO_AGNO(mp, fsbno) !=
+	    XFS_FSB_TO_AGNO(mp, fsbno + count - 1)) {
 		return XR_DFSBNORANGE_OVERFLOW;
 	}
 
-	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
-	if (verify_ag_bno(sbp, agno, agbno)) {
+	if (!libxfs_verify_fsbno(mp, fsbno))
 		return XR_DFSBNORANGE_BADSTART;
-	}
-
-	agbno = XFS_FSB_TO_AGBNO(mp, fsbno + count - 1);
-	if (verify_ag_bno(sbp, agno, agbno)) {
+	if (!libxfs_verify_fsbno(mp, fsbno + count - 1))
 		return XR_DFSBNORANGE_BADEND;
-	}
 
-	return (XR_DFSBNORANGE_VALID);
+	return XR_DFSBNORANGE_VALID;
 }
 
 static int

