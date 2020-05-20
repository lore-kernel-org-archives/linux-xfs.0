Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC5DC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE731207D8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:46:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U1lj0Pa4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgETBqG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:46:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgETBqG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:46:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1gebl164539;
        Wed, 20 May 2020 01:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zogVLiD9rH0YiIIzAndoIdj66uzYDzKPJLd7R4cVrw0=;
 b=U1lj0Pa4lG0EERK7ft8X9bSjR6XmFxHyBsFcoR48aLI2vmR+5BCoup7maWqVTJ1M6HDQ
 98I29lzxqZGoRgqgdhyw6IzmYrBMUHKwfI/0XsWqeAmO5AGBOavyV64PLsdBOnlMAsyi
 2Ayb5tszHwzX0/1LnU2Mul0+8QQGM2szQchrkfAHqVGEUFK7tAoQVuHuJmjtWeqs7YKT
 RPQ7dTPKTMfCoM2x9+HMkEs6mGk+oZFvN3mLMqSGahuKEoZm95ZTs73eDzKM0CKYnEJj
 vN8HQqrRHaGzK1bOD/ZPZwHkKtSFQBKF6UNXnebZtB+WRn3mPDSvNKXz1vewVeMn0ZJO Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31284m0hbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:46:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1gc9H143169;
        Wed, 20 May 2020 01:46:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 313gj2kb4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:46:03 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K1k3V6004002;
        Wed, 20 May 2020 01:46:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:46:03 -0700
Subject: [PATCH 07/11] xfs: refactor eofb matching into a single helper
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 19 May 2020 18:46:02 -0700
Message-ID: <158993916213.976105.11958914131452778480.stgit@magnolia>
In-Reply-To: <158993911808.976105.13679179790848338795.stgit@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=3 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200011
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
index ac66e7d8698d..1f12c6a0c48e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1436,6 +1436,33 @@ xfs_inode_match_id_union(
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
@@ -1443,7 +1470,6 @@ xfs_inode_free_eofblocks(
 {
 	struct xfs_eofblocks	*eofb = args;
 	bool			wait;
-	int			match;
 	int			ret = 0;
 
 	wait = (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC));
@@ -1462,19 +1488,8 @@ xfs_inode_free_eofblocks(
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
@@ -1716,25 +1731,13 @@ xfs_inode_free_cowblocks(
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

