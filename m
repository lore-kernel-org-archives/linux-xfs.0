Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF89C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7840A2075F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:48:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fuP/AKuD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgETBsP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:48:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40868 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETBsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:48:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1fkcq163605;
        Wed, 20 May 2020 01:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4CYtu7BUJwdl2XX55givFa+cA6zS0lwk0iyINAMzb5w=;
 b=fuP/AKuDKm0B6kLljeekj7YMh9Q/uVC9q1+hfZWoDR4p1BS19GsCocghbHq0g187fUX6
 OYgjhvyRVkL/IJ3xarffbAGgQ4ttkqHjco5EMWS4vEXxs+8lBln2Uxg3nfEE3QJXuqmq
 k8IDuYzdnycofq2rjKXoEy3ZBxbl+zN7k98JuJctMftFr5BkMsnC4c/cxd7UDIQ9ahwW
 7ZGpBhzy79AryIg5KBmMPw1EeS1w9eHtjFHpDTJ1fx9AaEGapueAtc8V8b7+nGRuGMhE
 XmjQoFMIzh8hF7hrfSumRNTmUqVkCDMG3LihQZKVqjh6ybygdaXhSUQ4gtkK2wzxs+T7 Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284m0hbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:46:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1h8MV032620;
        Wed, 20 May 2020 01:46:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 312sxtue6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:46:10 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K1k9DK008479;
        Wed, 20 May 2020 01:46:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:46:09 -0700
Subject: [PATCH 08/11] xfs: fix inode ag walk predicate function return values
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 19 May 2020 18:46:08 -0700
Message-ID: <158993916840.976105.5237746648594071986.stgit@magnolia>
In-Reply-To: <158993911808.976105.13679179790848338795.stgit@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200011
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
index 1f12c6a0c48e..926927a5f42e 100644
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

