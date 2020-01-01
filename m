Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56078C2D0DE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29BD8206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QEaX72eX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgAABOI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:14:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54512 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABOI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:14:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011E6fZ092009
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nUqkDh3U4ba5cz3sByq0lByBPpvASaMGGQq+HsYYcWM=;
 b=QEaX72eXZTPqwQjpuvsbHfkeiaYzaTBoyCHmZDZzyjFCprUhGxaR2Urm/kPr4POnArUF
 rggPojllVRfqGxIQR2vUUbQ484GSvrfrGLOmA2k1KFcCEfN4GWi/Y8kBsdmCSYSxbzWR
 0DR/n2b91iQkPaP1QihHbB2RGOmnwCF/rqwEei1d7NE5XVJO5XP/PSyc37ptSBzR9v9F
 L+Ekn0vXJS2ii+T880GSKCXtAOc+n03CcVDYUWNs0ta26VY4sYjO1VvsV1PEqLYjfsOn
 mwlW9ffMmaiQo0jZXM4zg7nzOazlA++d3/utG6xVD/pjfFiO3AIgGEwOhMfWbeMtahpd LA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011A9pd014231
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8guef3y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:06 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011E5Ob012751
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:05 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:14:05 -0800
Subject: [PATCH 14/21] xfs: hoist xfs_{bump,drop}link to libxfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:14:03 -0800
Message-ID: <157784124309.1365473.12548882203103913937.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move xfs_bumplink and xfs_droplink to libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    2 ++
 fs/xfs/xfs_inode.c             |   36 ------------------------------------
 3 files changed, 38 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index c4928f4dc0ee..12f3ad09795f 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -914,3 +914,39 @@ xfs_iunlink_remove(
 		xfs_perag_put(pag);
 	return error;
 }
+
+/*
+ * Decrement the link count on an inode & log the change.  If this causes the
+ * link count to go to zero, move the inode to AGI unlinked list so that it can
+ * be freed when the last active reference goes away via xfs_inactive().
+ */
+int
+xfs_droplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	drop_nlink(VFS_I(ip));
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	if (VFS_I(ip)->i_nlink)
+		return 0;
+
+	return xfs_iunlink(tp, ip);
+}
+
+/*
+ * Increment the link count on an inode & log the change.
+ */
+void
+xfs_bumplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	ASSERT(ip->i_d.di_version > 1);
+	inc_nlink(VFS_I(ip));
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index c4e851589c57..d716bffb06ed 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -48,6 +48,8 @@ void xfs_inode_init(struct xfs_trans *tp, const struct xfs_ialloc_args *args,
 
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
+void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 /* The libxfs client must provide these iunlink helper functions. */
 int xfs_iunlink_init(struct xfs_perag *pag);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 83bd046de786..af4c20a09514 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -668,42 +668,6 @@ xfs_dir_ialloc_roll(
 	return error;
 }
 
-/*
- * Decrement the link count on an inode & log the change.  If this causes the
- * link count to go to zero, move the inode to AGI unlinked list so that it can
- * be freed when the last active reference goes away via xfs_inactive().
- */
-static int			/* error */
-xfs_droplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
-{
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	drop_nlink(VFS_I(ip));
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	if (VFS_I(ip)->i_nlink)
-		return 0;
-
-	return xfs_iunlink(tp, ip);
-}
-
-/*
- * Increment the link count on an inode & log the change.
- */
-static void
-xfs_bumplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
-{
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	ASSERT(ip->i_d.di_version > 1);
-	inc_nlink(VFS_I(ip));
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-}
-
 int
 xfs_create(
 	struct xfs_inode		*dp,

