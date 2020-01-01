Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A783C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0E8C2064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:08:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n3XIM8X+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgAABIz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:08:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48526 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:08:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115Ldn089332
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=sSO5AEcURlVdZIx2p89uVJB3CheRVEKywuaHPh29zB8=;
 b=n3XIM8X+xz44uz+84OU9lfO6wkq8YOIQ9NXgxguIpmwUVUE3bV9oElesjj1b3MHzYqhD
 cNobY93R3+ligfbQrcxu91/OQ5d7MykldiFdMnGF+ywb4gq9olAyESSlMENebTgv1zL3
 CZKx4PQl6GAWXre1BdXPNMGV74ufp47vbptg3Wea4WpWCOXPM+rsAobdjoeX9+959UJz
 GU3Vm8MbSHTN8BZRqMJ7vexnulYTlHyFkZOFkX38dlfdaduUZnulL/7z4c6uMSn023By
 FoJS38gmZRfTKuaOZy33a22lt2v1qvFca2peOaJ1TzwmA0+WO0Jg5mTIalP4N0Yu4pUR Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115E42165819
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2x8gj914m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:53 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00116qZ8004998
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:52 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:06:52 -0800
Subject: [PATCH 08/11] xfs: fix inode ag walk predicate function return
 values
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:06:49 -0800
Message-ID: <157784080993.1360343.7574164715616516765.stgit@magnolia>
In-Reply-To: <157784075463.1360343.1278255546758019580.stgit@magnolia>
References: <157784075463.1360343.1278255546758019580.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
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
---
 fs/xfs/xfs_icache.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index efac12e2ac18..fbe0d8fb59c1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -737,7 +737,12 @@ xfs_icache_inode_is_allocated(
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
@@ -768,18 +773,18 @@ xfs_inode_ag_walk_grab(
 
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
@@ -831,7 +836,7 @@ xfs_inode_ag_walk(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || xfs_inode_ag_walk_grab(ip, iter_flags))
+			if (done || !xfs_inode_ag_walk_grab(ip, iter_flags))
 				batch[i] = NULL;
 
 			/*
@@ -1378,48 +1383,48 @@ xfs_reclaim_inodes_count(
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
@@ -1432,7 +1437,7 @@ xfs_inode_matches_eofb(
 	struct xfs_inode	*ip,
 	struct xfs_eofblocks	*eofb)
 {
-	int			match;
+	bool			match;
 
 	if (!eofb)
 		return true;

