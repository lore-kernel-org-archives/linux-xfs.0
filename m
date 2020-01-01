Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3271C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B1792064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FRlnyZi5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgAABHZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:07:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgAABHZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:07:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115MXP089341
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=fHy+ftDV2QFJwrWxozZmTJDvRyYXd2fVob9cvzGewBI=;
 b=FRlnyZi5S8D0UggvYBsLaLyIwvkRLXpQMs3Vz4A91Ky35EpUPZaLlknGcKd70rEVaBJc
 jwCAytF0lX1wl/qp4BTrwAZmyHCfKSTCb4twi4h7pPejpuvV8bf5hwGROjjFq1Zprtzb
 zmCwMX4JqkboRJacTD8fwEZoR1gY11BhCtfM0XWUxCdO3whv0a9A3r2qUY/OKv8Md6ki
 K7Tvam4FDoZSMzqldyJPO/7jPLeqM0GyWJEqrHbHowfz9LBXAjhYqMe7CQZHPSujzm17
 n/dob/zErlP6sXR0Dtp71upWlL2MMXm2k7lZk8Y9n5Ody/sakM+auN5VkjyK4Obl6up9 cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:07:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115G98006903
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2x8guee5py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:07:22 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00117Mv1026975
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:22 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:07:21 -0800
Subject: [PATCH 1/6] xfs: refactor messy xfs_inode_free_quota_* functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:07:19 -0800
Message-ID: <157784083934.1361522.92009645666228757.stgit@magnolia>
In-Reply-To: <157784083298.1361522.7064886067520069080.stgit@magnolia>
References: <157784083298.1361522.7064886067520069080.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The functions to run an eof/cowblocks scan to try to reduce quota usage
are kind of a mess -- the logic repeatedly initializes an eofb structure
and there are logic bugs in the code that result in the cowblocks scan
never actually happening.

Replace all three functions with a single function that fills out an
eofb if we're low on quota and runs both eof and cowblocks scans.

Fixes: 83104d449e8c4 ("xfs: garbage collect old cowextsz reservations")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c   |   15 ++++++---------
 fs/xfs/xfs_icache.c |   46 ++++++++++++++++------------------------------
 fs/xfs/xfs_icache.h |    4 ++--
 3 files changed, 24 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c93250108952..26e3edc07445 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -621,7 +621,7 @@ xfs_file_buffered_aio_write(
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
-	int			enospc = 0;
+	bool			cleared_space = false;
 	int			iolock;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
@@ -653,19 +653,16 @@ xfs_file_buffered_aio_write(
 	 * also behaves as a filter to prevent too many eofblocks scans from
 	 * running at the same time.
 	 */
-	if (ret == -EDQUOT && !enospc) {
+	if (ret == -EDQUOT && !cleared_space) {
 		xfs_iunlock(ip, iolock);
-		enospc = xfs_inode_free_quota_eofblocks(ip);
-		if (enospc)
-			goto write_retry;
-		enospc = xfs_inode_free_quota_cowblocks(ip);
-		if (enospc)
+		cleared_space = xfs_inode_free_quota_blocks(ip);
+		if (cleared_space)
 			goto write_retry;
 		iolock = 0;
-	} else if (ret == -ENOSPC && !enospc) {
+	} else if (ret == -ENOSPC && !cleared_space) {
 		struct xfs_eofblocks eofb = {0};
 
-		enospc = 1;
+		cleared_space = true;
 		xfs_flush_inodes(ip->i_mount);
 
 		xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 03d7624fa97e..09647dfe5946 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1529,33 +1529,31 @@ xfs_icache_free_eofblocks(
 }
 
 /*
- * Run eofblocks scans on the quotas applicable to the inode. For inodes with
- * multiple quotas, we don't know exactly which quota caused an allocation
+ * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
+ * with multiple quotas, we don't know exactly which quota caused an allocation
  * failure. We make a best effort by including each quota under low free space
  * conditions (less than 1% free space) in the scan.
  */
-static int
-__xfs_inode_free_quota_eofblocks(
-	struct xfs_inode	*ip,
-	int			(*execute)(struct xfs_mount *mp,
-					   struct xfs_eofblocks	*eofb))
+bool
+xfs_inode_free_quota_blocks(
+	struct xfs_inode	*ip)
 {
-	int scan = 0;
-	struct xfs_eofblocks eofb = {0};
-	struct xfs_dquot *dq;
+	struct xfs_eofblocks	eofb = {0};
+	struct xfs_dquot	*dq;
+	bool			do_work = false;
 
 	/*
 	 * Run a sync scan to increase effectiveness and use the union filter to
 	 * cover all applicable quotas in a single scan.
 	 */
-	eofb.eof_flags = XFS_EOF_FLAGS_UNION|XFS_EOF_FLAGS_SYNC;
+	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
 
 	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
 		dq = xfs_inode_dquot(ip, XFS_DQ_USER);
 		if (dq && xfs_dquot_lowsp(dq)) {
 			eofb.eof_uid = VFS_I(ip)->i_uid;
 			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
-			scan = 1;
+			do_work = true;
 		}
 	}
 
@@ -1564,21 +1562,16 @@ __xfs_inode_free_quota_eofblocks(
 		if (dq && xfs_dquot_lowsp(dq)) {
 			eofb.eof_gid = VFS_I(ip)->i_gid;
 			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
-			scan = 1;
+			do_work = true;
 		}
 	}
 
-	if (scan)
-		execute(ip->i_mount, &eofb);
-
-	return scan;
-}
+	if (!do_work)
+		return false;
 
-int
-xfs_inode_free_quota_eofblocks(
-	struct xfs_inode *ip)
-{
-	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_eofblocks);
+	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+	return true;
 }
 
 static inline unsigned long
@@ -1778,13 +1771,6 @@ xfs_icache_free_cowblocks(
 			XFS_ICI_COWBLOCKS_TAG);
 }
 
-int
-xfs_inode_free_quota_cowblocks(
-	struct xfs_inode *ip)
-{
-	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_cowblocks);
-}
-
 void
 xfs_inode_set_cowblocks_tag(
 	xfs_inode_t	*ip)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 0dc85a03dc6c..6727b792ee40 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -57,17 +57,17 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
+bool xfs_inode_free_quota_blocks(struct xfs_inode *ip);
+
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
-int xfs_inode_free_quota_eofblocks(struct xfs_inode *ip);
 void xfs_eofblocks_worker(struct work_struct *);
 void xfs_queue_eofblocks(struct xfs_mount *);
 
 void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
-int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 

