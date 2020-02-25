Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649A3C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3712920838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pfiqzD3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBYAM0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:12:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48452 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAM0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:12:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07d4C050110;
        Tue, 25 Feb 2020 00:12:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0CZKn5v/e+jLmhrjWQZv3eOlRUhanMzPSJnPr1xyio8=;
 b=pfiqzD3mwDoS397WtTLJQ0fpA2AdYEiA9kmGuNi9AAKr7R2yJiBYEhqWgqsZ0OXLfNuC
 4s4JaK/y8tR3R22Y66gBgrhSFUdHCibxCNl3ntxE3wmMPdSS7I9q4jbdQmjeXhzByCrg
 yZq7poz6oATRp/5kev/U1t+uhOhPDAxfqZK4766qeIBEtoSW/8PRyYe2QT8MTFoy6iQJ
 NHWVYdhZKAN379rNorXZ+ikjD9pO7N7oVwOK1zKenkX614FVDuqm42hklZS1kq5y9NMW
 wuRUwxUFZZdhssWwcE3InHftNHBG+rfq2Kb9DLCjxJNrir3oxxqBfNBAoGZ2IphT9FAq /g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q3d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07tV6108964;
        Tue, 25 Feb 2020 00:12:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ybe12epv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:21 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0CKYQ030920;
        Tue, 25 Feb 2020 00:12:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:12:20 -0800
Subject: [PATCH 08/25] libxfs: make libxfs_readbuf_verify return an error
 code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:12:19 -0800
Message-ID: <158258953956.451378.12584291966139198190.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=893 spamscore=0
 suspectscore=2 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=940 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=2 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Return the bp->b_error from libxfs_readbuf_verify instead of making
callers check it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h |    3 +--
 libxfs/rdwr.c      |   10 +++++++---
 repair/prefetch.c  |    5 +++--
 3 files changed, 11 insertions(+), 7 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 0370d685..d96b5318 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -206,8 +206,7 @@ libxfs_buf_read(
 
 #endif /* XFS_BUF_TRACING */
 
-extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
-			const struct xfs_buf_ops *ops);
+int libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 struct xfs_buf *libxfs_getsb(struct xfs_mount *mp);
 extern void	libxfs_bcache_purge(void);
 extern void	libxfs_bcache_free(void);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7100d4df..fb22c118 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -939,14 +939,18 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
 	return error;
 }
 
-void
-libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops)
+int
+libxfs_readbuf_verify(
+	struct xfs_buf		*bp,
+	const struct xfs_buf_ops *ops)
 {
 	if (!ops)
-		return;
+		return bp->b_error;
+
 	bp->b_ops = ops;
 	bp->b_ops->verify_read(bp);
 	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
+	return bp->b_error;
 }
 
 static struct xfs_buf *
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 12272932..a3858f9a 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -400,9 +400,10 @@ pf_read_inode_dirs(
 	int			icnt = 0;
 	int			hasdir = 0;
 	int			isadir;
+	int			error;
 
-	libxfs_readbuf_verify(bp, &xfs_inode_buf_ops);
-	if (bp->b_error)
+	error = -libxfs_readbuf_verify(bp, &xfs_inode_buf_ops);
+	if (error)
 		return;
 
 	for (icnt = 0; icnt < (bp->b_bcount >> mp->m_sb.sb_inodelog); icnt++) {

