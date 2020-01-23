Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56813C3F68F
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CD01206D4
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YnPrpoVG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgAWHmL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:42:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56458 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgAWHmL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 02:42:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7cEUq170841;
        Thu, 23 Jan 2020 07:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vEZZotY7oxD2cVE02rd6xA1oV/uTeBOlCilya5pdcao=;
 b=YnPrpoVGo9s4/Vnc2Kt3F/BJFRp0x1ZamSlI2NlYOtEX4T2WhLxi0klm0aDQe+mnqvJ7
 ipTADYYaQdU1XmjqTXZR7Dn0X/rwePm42vctFYPNQsvCZrULeoIAzbD/9TetAsATkiYw
 0MSCaJRMddrEuRtbcADYVXmybIjH5G6tyWXC6nCJRtpvnjiAjtTi/Gxf7pLXQHRX3cZa
 Pdsq6TDqqdKMgasN2jfqKHxAPKS6b4SUoUNxpPARN5BWdP53fO5UZ+XpXxTztGm1qKvU
 +/n1iX7iqIWOmPGecNkmIG+x1sKJ13yXaOGwUeNaHeX4LXof6J0SngICTax6HmSFgd+a jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseurkta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7cWDl062330;
        Thu, 23 Jan 2020 07:42:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xppq50mbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:05 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00N7g4FN010049;
        Thu, 23 Jan 2020 07:42:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 23:42:03 -0800
Subject: [PATCH 02/12] xfs: make xfs_buf_read return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Wed, 22 Jan 2020 23:42:03 -0800
Message-ID: <157976532333.2388944.17938500318924937596.stgit@magnolia>
In-Reply-To: <157976531016.2388944.3654360225810285604.stgit@magnolia>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230065
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_buf_read() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |    8 ++++----
 fs/xfs/xfs_buf.h                |   13 +++++++++++--
 fs/xfs/xfs_log_recover.c        |   16 +++++++---------
 fs/xfs/xfs_symlink.c            |    8 ++++----
 4 files changed, 26 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index a266d05df146..d82985571a5f 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -418,10 +418,10 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			bp = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0,
-					&xfs_attr3_rmt_buf_ops);
-			if (!bp)
-				return -ENOMEM;
+			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
+					0, &bp, &xfs_attr3_rmt_buf_ops);
+			if (error)
+				return error;
 			error = bp->b_error;
 			if (error) {
 				xfs_buf_ioerror_alert(bp, __func__);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 56e081dd1d96..fb60c36a8a5b 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -213,16 +213,25 @@ xfs_buf_get(
 	return xfs_buf_get_map(target, &map, 1, 0);
 }
 
-static inline struct xfs_buf *
+static inline int
 xfs_buf_read(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		blkno,
 	size_t			numblks,
 	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
+	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_read_map(target, &map, 1, flags, ops);
+
+	*bpp = NULL;
+	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
+	if (!bp)
+		return -ENOMEM;
+
+	*bpp = bp;
+	return 0;
 }
 
 static inline void
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0d683fb96396..b29806846916 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2745,10 +2745,10 @@ xlog_recover_buffer_pass2(
 	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
 		buf_flags |= XBF_UNMAPPED;
 
-	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
-			  buf_flags, NULL);
-	if (!bp)
-		return -ENOMEM;
+	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
+			  buf_flags, &bp, NULL);
+	if (error)
+		return error;
 	error = bp->b_error;
 	if (error) {
 		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#1)");
@@ -2950,12 +2950,10 @@ xlog_recover_inode_pass2(
 	}
 	trace_xfs_log_recover_inode_recover(log, in_f);
 
-	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len, 0,
-			  &xfs_inode_buf_ops);
-	if (!bp) {
-		error = -ENOMEM;
+	error = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
+			0, &bp, &xfs_inode_buf_ops);
+	if (error)
 		goto error;
-	}
 	error = bp->b_error;
 	if (error) {
 		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#2)");
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a25502bc2071..4f10d764163b 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -53,10 +53,10 @@ xfs_readlink_bmap_ilocked(
 		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
 		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 
-		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
-				  &xfs_symlink_buf_ops);
-		if (!bp)
-			return -ENOMEM;
+		error = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
+				&bp, &xfs_symlink_buf_ops);
+		if (error)
+			return error;
 		error = bp->b_error;
 		if (error) {
 			xfs_buf_ioerror_alert(bp, __func__);

