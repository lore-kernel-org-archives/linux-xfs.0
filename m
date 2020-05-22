Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB809C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95541207D8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KQiijahc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgEVC40 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:56:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57394 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbgEVC4Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:56:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2m28p082957;
        Fri, 22 May 2020 02:54:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=oSqirtTJtmii6wG/zJrjq3Z/DsodXGcRv4uZ5ezrL+g=;
 b=KQiijahc7ps4Jkz65HPGlCoMHLhUkq6qu2QrOR1B/VaV2hDdVFC1a69MbLC47v8vFilk
 QSU2ev1WVZa/YPjFIPuhg3x4mLmmVfX6Wiu+jFQtKJQC64yYfiOLRTzZk2PZTN+UrLm0
 +PRw3eNaYD01ZdHV/8dqDJwRcoxxh3cfp7yWxRM0sre49elrm1EdfKSDDs25ObwIrSP/
 IbIX8ncVJmHX6pGR7F3Q6uwZ0mIzbwL3Uji/Qftkq5ceCDurZr7PANwuVePu+sVWQQir
 L9BxAC/cAStnfHSxn4lwFakSXEhMX01KudseoNDhf0fjHVrcqsfa5E8Ros8PA2bjqyVa qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284mbj1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:54:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2nEZb173910;
        Fri, 22 May 2020 02:54:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t3d3xxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:54:21 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04M2sKkv015500;
        Fri, 22 May 2020 02:54:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:54:20 -0700
Subject: [PATCH 08/12] xfs: fix inode ag walk predicate function return values
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@lst.de
Date:   Thu, 21 May 2020 19:54:19 -0700
Message-ID: <159011605915.77079.7480200493011915081.stgit@magnolia>
In-Reply-To: <159011600616.77079.14748275956667624732.stgit@magnolia>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There are a number of predicate functions that help the incore inode
walking code decide if we really want to apply the iteration function to
the inode.  These are boolean decisions, so change the return types to
boolean to match.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3a45ec948c1a..31d85cc4bd8b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -741,7 +741,12 @@ xfs_icache_inode_is_allocated(
  */
 #define XFS_LOOKUP_BATCH	32
 
-STATIC int
+/*
+ * Decide if the given @ip is eligible to be a part of the inode walk, and
+ * grab it if so.  Returns true if it's ready to go or false if we should just
+ * ignore it.
+ */
+STATIC bool
 xfs_inode_ag_walk_grab(
 	struct xfs_inode	*ip,
 	int			flags)
@@ -772,18 +777,18 @@ xfs_inode_ag_walk_grab(
 
 	/* nothing to sync during shutdown */
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return -EFSCORRUPTED;
+		return false;
 
 	/* If we can't grab the inode, it must on it's way to reclaim. */
 	if (!igrab(inode))
-		return -ENOENT;
+		return false;
 
 	/* inode is valid */
-	return 0;
+	return true;
 
 out_unlock_noent:
 	spin_unlock(&ip->i_flags_lock);
-	return -ENOENT;
+	return false;
 }
 
 STATIC int
@@ -835,7 +840,7 @@ xfs_inode_ag_walk(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || xfs_inode_ag_walk_grab(ip, iter_flags))
+			if (done || !xfs_inode_ag_walk_grab(ip, iter_flags))
 				batch[i] = NULL;
 
 			/*
@@ -1392,48 +1397,48 @@ xfs_reclaim_inodes_count(
 	return reclaimable;
 }
 
-STATIC int
+STATIC bool
 xfs_inode_match_id(
 	struct xfs_inode	*ip,
 	struct xfs_eofblocks	*eofb)
 {
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
 	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
-		return 0;
+		return false;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
 	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
-		return 0;
+		return false;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
 	    ip->i_d.di_projid != eofb->eof_prid)
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
 /*
  * A union-based inode filtering algorithm. Process the inode if any of the
  * criteria match. This is for global/internal scans only.
  */
-STATIC int
+STATIC bool
 xfs_inode_match_id_union(
 	struct xfs_inode	*ip,
 	struct xfs_eofblocks	*eofb)
 {
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
 	    uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
-		return 1;
+		return true;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
 	    gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
-		return 1;
+		return true;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
 	    ip->i_d.di_projid == eofb->eof_prid)
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
 /*
@@ -1446,7 +1451,7 @@ xfs_inode_matches_eofb(
 	struct xfs_inode	*ip,
 	struct xfs_eofblocks	*eofb)
 {
-	int			match;
+	bool			match;
 
 	if (!eofb)
 		return true;

