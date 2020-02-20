Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B99BC5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1101F21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:43:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tOdbj2/A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBTBnk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:43:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49416 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTBnk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:43:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1c5F6039404;
        Thu, 20 Feb 2020 01:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PSJLXYuRL2mRztiEFRJis2EjQkzceI4GjUq2nIISVMk=;
 b=tOdbj2/ATOq2kysXP1Do+kO17fdBsUiQDr+UBr+NV/ACiE7b4f6J5qWjSX1yuxJ5qwtw
 cIgGo/uRitANSpBYFGqejDwO1ib4g2r3ViU6YIjFZdFsqzjfKrdKEFZHHXkb7J9idjhf
 GYA+PbnCUz3G91wpI/2ZqHzli8px3z38RFPzBMLpx7zjZwAFB7oiFZiOCKHbXanfN74S
 gZXvoO3pDNxuFGtwxTmEzbsjSU2zrVTwXhV9AtVwmwUOBsqJEs5W5loOu8ttOSdEYq4H
 R11R+0T38l0FWQ0POHNVoyvcbPQzJLA/HFa9gLD6PdIcGqjk4B6Ujku52vhri0PAGxn8 kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2y8ud16sc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hbpV114128;
        Thu, 20 Feb 2020 01:43:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2y8ud2g3mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:37 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1hQu2002205;
        Thu, 20 Feb 2020 01:43:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:43:26 -0800
Subject: [PATCH 08/18] libxfs: make libxfs_readbuf_verify return an error
 code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:43:25 -0800
Message-ID: <158216300534.602314.4013285592257885758.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=888 suspectscore=2 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=2 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=942 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Return the bp->b_error from libxfs_readbuf_verify instead of making
callers check it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h |    3 +--
 libxfs/rdwr.c      |   10 +++++++---
 repair/prefetch.c  |    5 +++--
 3 files changed, 11 insertions(+), 7 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index f00ff8d3..b01f2896 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -208,8 +208,7 @@ libxfs_buf_read(
 
 #endif /* XFS_BUF_TRACING */
 
-extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
-			const struct xfs_buf_ops *ops);
+int libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 struct xfs_buf *libxfs_getsb(struct xfs_mount *);
 extern void	libxfs_bcache_purge(void);
 extern void	libxfs_bcache_free(void);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 2a4ef15a..24c5eaf6 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -943,14 +943,18 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
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

