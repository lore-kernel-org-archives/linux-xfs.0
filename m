Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E2FDC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60F5520718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:06:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hrXq5HC1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgAABGu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:06:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47468 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABGt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:06:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00116m7r090364
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=p2qCCtbR2bpLHiviiQqAD1CLaKOBJJ/77nKFsV/zvrs=;
 b=hrXq5HC13DafXgI1eqN1EZ8cKx5cCnj3pCw1AoFJSpMXVG2BSpptkT1DytNeYWrdU4D3
 WjJj7SZlBN2O+B3BorBznMw8sJnA1AQzLm7l6WXh+7S5E3cLzn72mt04NrFt+etPdeST
 t8DpNPrkZ1Y8zhuEuHdqAADbALHjhSnf2dmL/o1hPVoJQyWa3Tgdrp5vS4F8WYiAtBLo
 p2CthavjECO97wKu4R6m2lxRn6VGz90kcghSBB5w5MDDqFdDgiSKukRDPIxdtfsAbplW
 emo/O81J03ekWUNJGSMgSMuACUil4IfDt8zXbjhwox7MF2kykSqW1SpTXai4Q9Re9v1I EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001159Qg183719
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x8bsrfx7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:47 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00116kIL010248
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:46 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:06:45 -0800
Subject: [PATCH 07/11] xfs: refactor eofb matching into a single helper
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:06:43 -0800
Message-ID: <157784080384.1360343.10280402715883473936.stgit@magnolia>
In-Reply-To: <157784075463.1360343.1278255546758019580.stgit@magnolia>
References: <157784075463.1360343.1278255546758019580.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=854
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=917 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the two eofb-matching logics into a single helper so that we
don't repeat ourselves.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   59 +++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4060f43a2ca3..efac12e2ac18 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1422,6 +1422,33 @@ xfs_inode_match_id_union(
 	return 0;
 }
 
+/*
+ * Is this inode @ip eligible for eof/cow block reclamation, given some
+ * filtering parameters @eofb?  The inode is eligible if @eofb is null or
+ * if the predicate functions match.
+ */
+static bool
+xfs_inode_matches_eofb(
+	struct xfs_inode	*ip,
+	struct xfs_eofblocks	*eofb)
+{
+	int			match;
+
+	if (!eofb)
+		return true;
+
+	if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
+		match = xfs_inode_match_id_union(ip, eofb);
+	else
+		match = xfs_inode_match_id(ip, eofb);
+	if (match)
+		return true;
+
+	/* skip the inode if the file size is too small */
+	return !(eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
+		 XFS_ISIZE(ip) < eofb->eof_min_file_size);
+}
+
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
@@ -1429,7 +1456,6 @@ xfs_inode_free_eofblocks(
 {
 	struct xfs_eofblocks	*eofb = args;
 	bool			wait;
-	int			match;
 	int			ret = 0;
 
 	wait = (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC));
@@ -1448,19 +1474,8 @@ xfs_inode_free_eofblocks(
 	if (!wait && mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
-	if (eofb) {
-		if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
-			match = xfs_inode_match_id_union(ip, eofb);
-		else
-			match = xfs_inode_match_id(ip, eofb);
-		if (!match)
-			return 0;
-
-		/* skip the inode if the file size is too small */
-		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
-		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
-			return 0;
-	}
+	if (!xfs_inode_matches_eofb(ip, eofb))
+		return 0;
 
 	/*
 	 * If the caller is waiting, return -EAGAIN to keep the background
@@ -1702,25 +1717,13 @@ xfs_inode_free_cowblocks(
 	void			*args)
 {
 	struct xfs_eofblocks	*eofb = args;
-	int			match;
 	int			ret = 0;
 
 	if (!xfs_prep_free_cowblocks(ip))
 		return 0;
 
-	if (eofb) {
-		if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
-			match = xfs_inode_match_id_union(ip, eofb);
-		else
-			match = xfs_inode_match_id(ip, eofb);
-		if (!match)
-			return 0;
-
-		/* skip the inode if the file size is too small */
-		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
-		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
-			return 0;
-	}
+	if (!xfs_inode_matches_eofb(ip, eofb))
+		return 0;
 
 	/* Free the CoW blocks */
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);

