Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B634C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62A0220884
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QSVwxRZG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgEVC4V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:56:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57330 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbgEVC4V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:56:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mGhK083010;
        Fri, 22 May 2020 02:54:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Eq0t0wtrcHTn8BxL7x/eAhXBzf18TATMKjTAiY9LtBc=;
 b=QSVwxRZGzAx6N0/hcCpe8/aCRpTCvRkOPFbL0Hvaz9ZqlwXDbDMG1phk8w77j6lCRKy2
 jn8b5QrHqSplhSc3AV8nX38ye7J7RGzU1ooquM6+iacTeq2NJbYu+KuOJz7U9DoNPd0I
 ck2TTxue9poJUSsYbK9SobMrZy11NfSSUpHVk0X4LogGsdtHBel83JuD9/TFxe3ccgnR
 hbL6dvkrfRDQFXHOrFTMc6/d6huaf1GQpc0QJZUhQk9A7diPbFj+KQC7ZHCh/tL3U0TA
 +31jZbmirQhWK6DBelsDvEDZ5BauFdQWnzOcZPEEoTHg3ubSdS7CUZZfkUuFThPV4jhr WQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31284mbj1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:54:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mh4n008803;
        Fri, 22 May 2020 02:54:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 313gj6px2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:54:15 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M2sETp004839;
        Fri, 22 May 2020 02:54:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:54:13 -0700
Subject: [PATCH 07/12] xfs: refactor eofb matching into a single helper
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Thu, 21 May 2020 19:54:12 -0700
Message-ID: <159011605255.77079.12439333473840564314.stgit@magnolia>
In-Reply-To: <159011600616.77079.14748275956667624732.stgit@magnolia>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=3 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the two eofb-matching logics into a single helper so that we
don't repeat ourselves.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   62 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 11a5e6897639..3a45ec948c1a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1436,6 +1436,36 @@ xfs_inode_match_id_union(
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
+	if (!match)
+		return false;
+
+	/* skip the inode if the file size is too small */
+	if ((eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE) &&
+	    XFS_ISIZE(ip) < eofb->eof_min_file_size)
+		return false;
+
+	return true;
+}
+
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
@@ -1443,7 +1473,6 @@ xfs_inode_free_eofblocks(
 {
 	struct xfs_eofblocks	*eofb = args;
 	bool			wait;
-	int			match;
 	int			ret;
 
 	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
@@ -1462,19 +1491,8 @@ xfs_inode_free_eofblocks(
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
@@ -1717,25 +1735,13 @@ xfs_inode_free_cowblocks(
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

