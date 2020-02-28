Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A482C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B0C92469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H5LJJ1Sm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgB1XjP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:39:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43772 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgB1XjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:39:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWosJ027944;
        Fri, 28 Feb 2020 23:37:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=h2l+WLHd8gzI7SId1V0WMD65XPz+zdst2vGa0D6/0I4=;
 b=H5LJJ1SmaE3jX41kmpeio5hZONCOLXWsxeQl7ZNjyU1cfpR6j45aabLhVMODLOxVqaw2
 /5hZtPTRTvddEKi6cuC1j3CRQN10ODoGHNS/ZhwahINChJ8B50lWj35hW6k1idel33oO
 GZ9poFHYaA1++JKqgFwbDeV/g7B7H1yznyiKM6tvgp8qhZMvyY28ftXkLwwBpkAMwCR9
 6EBea+jk9HJDBL68AXcG5rV3ASF8WLcJA5ZFvCZ7DSoks2Mu3FM5HCFi5RmuKnZe7X8A
 H8ZlqV15+HyDrKoCpeLeyyuoc9V8R55+yzbSUhvCL6DI2PEAO1u/jt7/rk+RWo8W92v/ eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ydct3nt2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:37:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWCE1165618;
        Fri, 28 Feb 2020 23:37:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ydj4s320j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:37:08 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNb7p4012722;
        Fri, 28 Feb 2020 23:37:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:37:07 -0800
Subject: [PATCH 08/26] libxfs: make libxfs_readbuf_verify return an error
 code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:37:06 -0800
Message-ID: <158293302639.1549542.14051278736637867131.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=2
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=915 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=965 mlxscore=0 suspectscore=2 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
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
index bbec1135..83c6142f 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -946,14 +946,18 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
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

