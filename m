Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2991AC35242
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F003A2071E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:19:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mXalQi8p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgAXFTn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 00:19:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39330 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729253AbgAXFTn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 00:19:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5IGtS033679;
        Fri, 24 Jan 2020 05:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=X93lnSDO9KrpxGU44aphzX7SIy90u6ngHcbkjUq5bIM=;
 b=mXalQi8pXpx6jWID+x8/j7FsQGa0S3XBUnl3PXQweEZxpk4qADDGxtfVDODNaql0uSw5
 /N51eHYZRCXzoeA/h41cLQpLLzXRPJjRI2WAasA+/jV11YscCOKK8yh+PysTOUtNrJuP
 5awirGN4OI6Gpk2qNNdpZMNPQ0doLbZvAdrMPI4e4TO86Lv4EsvdLEnBhwjjjVlQEYBD
 Wvfa1+enSmV8PB8an5A7dU/hO+ff5QdnYpNb+d+RS6TAtAjL8BCxCpcPGrJx8XlxtOWb
 SHNj6XJlpTxg098Ol5dJcAIx6Fw6+uZO2T2YxmP9m3lgpI1cY7s3Qj89yVSqkDi04Cld cQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xktnrps3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:19:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5IJFZ156100;
        Fri, 24 Jan 2020 05:19:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xqmuy39k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:19:37 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O5Ja03020650;
        Fri, 24 Jan 2020 05:19:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 21:19:36 -0800
Subject: [PATCH 06/12] xfs: make xfs_buf_read return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Thu, 23 Jan 2020 21:19:35 -0800
Message-ID: <157984317522.3139258.12286918099052261683.stgit@magnolia>
In-Reply-To: <157984313582.3139258.1136501362141645797.stgit@magnolia>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240042
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
 fs/xfs/xfs_buf.h                |   10 +++-------
 fs/xfs/xfs_log_recover.c        |   16 +++++++---------
 fs/xfs/xfs_symlink.c            |    8 ++++----
 4 files changed, 18 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 7266e280b3e8..8b7f74b3bea2 100644
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
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 7f7bd1edd99e..aa145ad25e9a 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -213,22 +213,18 @@ xfs_buf_get(
 	return xfs_buf_get_map(target, &map, 1, 0, bpp);
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
-	struct xfs_buf		*bp;
-	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	error = xfs_buf_read_map(target, &map, 1, flags, &bp, ops);
-	if (error)
-		return NULL;
-	return bp;
+	return xfs_buf_read_map(target, &map, 1, flags, bpp, ops);
 }
 
 static inline void
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c805a02f0078..ac79537d3275 100644
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
 
 	/*
 	 * Recover the buffer only if we get an LSN from it and it's less than
@@ -2945,12 +2945,10 @@ xlog_recover_inode_pass2(
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
 	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
 	dip = xfs_buf_offset(bp, in_f->ilf_boffset);
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index b255a393a73b..b94d7b9b55d0 100644
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
 		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
 		if (pathlen < byte_cnt)
 			byte_cnt = pathlen;

