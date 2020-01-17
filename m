Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2160C33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AD3A20748
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g510Dp/6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgAQGX4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:23:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAQGXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:23:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68Wga186725;
        Fri, 17 Jan 2020 06:23:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=B7Z/fByoZxg/3dUJQ9envz1KDfvSTaSqmQQzp7jNceo=;
 b=g510Dp/6jkkoJCUnsGZSibsLuaqFF3vIYTk0Xd+sLN5Sm2MksR5Ea/gAH05LSg3Y915+
 pxF6mMNw3aD/OuB6A3Cgz8W6h/2JTzLi+66P1hNatbby216g/8T4n1u0AobtK57o1Vc9
 1uNmSnSngWfzyRFgON2PzmTMygjJ8ATjvNV0YqeluoF9EITtfgUZOpVQrG1/0GysJbmV
 ZPi8R2Hws3Vs+QnWczJ3+nWwTNDo2rEDPtNkV1EO2RJ4MZIICWNDjVVHNweiNHMlXhB8
 zMatAEAUGL2NSAFrOP3GtqhRPPgGJPtTLb/bDITA22sCXbgPAtwy6JnRtFpFNGQvQuuU lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xf74spt4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:23:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H695cq039105;
        Fri, 17 Jan 2020 06:23:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xjxm8a3ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:23:48 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00H6Nk9f021838;
        Fri, 17 Jan 2020 06:23:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 22:23:46 -0800
Subject: [PATCH 02/11] xfs: make xfs_buf_read return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Date:   Thu, 16 Jan 2020 22:23:44 -0800
Message-ID: <157924222437.3029431.18011964422343623236.stgit@magnolia>
In-Reply-To: <157924221149.3029431.1461924548648810370.stgit@magnolia>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_buf_read() to return numeric error codes like most
everywhere else in xfs.  Hoist the callers' error logging and EFSBADCRC
remapping code into xfs_buf_read to reduce code duplication.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c |   16 +++-------------
 fs/xfs/xfs_buf.c                |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h                |   14 +++-----------
 fs/xfs/xfs_log_recover.c        |   26 +++++++-------------------
 fs/xfs/xfs_symlink.c            |   17 ++++-------------
 5 files changed, 50 insertions(+), 56 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index a266d05df146..46c516809086 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -418,20 +418,10 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			bp = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0,
-					&xfs_attr3_rmt_buf_ops);
-			if (!bp)
-				return -ENOMEM;
-			error = bp->b_error;
-			if (error) {
-				xfs_buf_ioerror_alert(bp, __func__);
-				xfs_buf_relse(bp);
-
-				/* bad CRC means corrupted metadata */
-				if (error == -EFSBADCRC)
-					error = -EFSCORRUPTED;
+			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
+					0, &bp, &xfs_attr3_rmt_buf_ops);
+			if (error)
 				return error;
-			}
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a00e63d08a3b..8c9cd1ab870b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -851,6 +851,39 @@ xfs_buf_read_map(
 	return bp;
 }
 
+int
+xfs_buf_read(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp,
+	const struct xfs_buf_ops *ops)
+{
+	struct xfs_buf		*bp;
+	int			error;
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+
+	*bpp = NULL;
+	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
+	if (!bp)
+		return -ENOMEM;
+	error = bp->b_error;
+	if (error) {
+		xfs_buf_ioerror_alert(bp, __func__);
+		xfs_buf_stale(bp);
+		xfs_buf_relse(bp);
+
+		/* bad CRC means corrupted metadata */
+		if (error == -EFSBADCRC)
+			error = -EFSCORRUPTED;
+		return error;
+	}
+
+	*bpp = bp;
+	return 0;
+}
+
 /*
  *	If we are not low on memory then do the readahead in a deadlock
  *	safe manner.
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 56e081dd1d96..f04722554f63 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -213,17 +213,9 @@ xfs_buf_get(
 	return xfs_buf_get_map(target, &map, 1, 0);
 }
 
-static inline struct xfs_buf *
-xfs_buf_read(
-	struct xfs_buftarg	*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
-	xfs_buf_flags_t		flags,
-	const struct xfs_buf_ops *ops)
-{
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_read_map(target, &map, 1, flags, ops);
-}
+int xfs_buf_read(struct xfs_buftarg *target, xfs_daddr_t blkno, size_t numblks,
+		xfs_buf_flags_t flags, struct xfs_buf **bpp,
+		const struct xfs_buf_ops *ops);
 
 static inline void
 xfs_buf_readahead(
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0d683fb96396..ac79537d3275 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2745,15 +2745,10 @@ xlog_recover_buffer_pass2(
 	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
 		buf_flags |= XBF_UNMAPPED;
 
-	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
-			  buf_flags, NULL);
-	if (!bp)
-		return -ENOMEM;
-	error = bp->b_error;
-	if (error) {
-		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#1)");
-		goto out_release;
-	}
+	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
+			  buf_flags, &bp, NULL);
+	if (error)
+		return error;
 
 	/*
 	 * Recover the buffer only if we get an LSN from it and it's less than
@@ -2950,17 +2945,10 @@ xlog_recover_inode_pass2(
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
-	error = bp->b_error;
-	if (error) {
-		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#2)");
-		goto out_release;
-	}
 	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
 	dip = xfs_buf_offset(bp, in_f->ilf_boffset);
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a25502bc2071..f4b14569039f 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -53,20 +53,11 @@ xfs_readlink_bmap_ilocked(
 		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
 		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 
-		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
-				  &xfs_symlink_buf_ops);
-		if (!bp)
-			return -ENOMEM;
-		error = bp->b_error;
-		if (error) {
-			xfs_buf_ioerror_alert(bp, __func__);
-			xfs_buf_relse(bp);
-
-			/* bad CRC means corrupted metadata */
-			if (error == -EFSBADCRC)
-				error = -EFSCORRUPTED;
+		error = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
+				&bp, &xfs_symlink_buf_ops);
+		if (error)
 			goto out;
-		}
+
 		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
 		if (pathlen < byte_cnt)
 			byte_cnt = pathlen;

