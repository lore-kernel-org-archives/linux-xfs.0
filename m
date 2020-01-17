Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58BCC33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BD0620748
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:24:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cT+Jmzem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgAQGYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:24:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45332 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAQGYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:24:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68W8m150051;
        Fri, 17 Jan 2020 06:23:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/Y0dwkGulex17Wu/uw8aAs5aSbhgm+aTaeVBzKTR96E=;
 b=cT+JmzemclB1xiWboPPwol03KWA81Y6kG44F45ziQgfYvIBQBAMW5YPD/bEylEQMaads
 Xn3DniIw5DmYoQtlZvXQWYZtQ12dYj26buNnUvoDxNaHa6CROT7C2BYNwL1JX6mbi1gJ
 p1pTTAN1mIA/5G0PvTiTG8SxxSJpYyuoLhU+TuSslFY2tF9xqtg2whNPrd31U6DM+vSE
 zQQxWt9s1HwovOvMmmFRtr0FPAYc3xufz8e6djU9zaqBEs4bzIm6z99mhcm50rNGucfP
 eiFzj3/BCc8EcQDAJuPD2zicVubrt98bIbP9xV5NiCyfKv1veIzPmTtNSw94mlIdppSZ /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xf73u6rch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:23:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68VFw129477;
        Fri, 17 Jan 2020 06:23:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xjxp4hh54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:23:56 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00H6NuJV021862;
        Fri, 17 Jan 2020 06:23:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 22:23:55 -0800
Subject: [PATCH 03/11] xfs: make xfs_buf_get return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Date:   Thu, 16 Jan 2020 22:23:50 -0800
Message-ID: <157924223066.3029431.11184155620620599754.stgit@magnolia>
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

Convert xfs_buf_get() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c |    6 +++---
 fs/xfs/libxfs/xfs_sb.c          |    8 ++++----
 fs/xfs/xfs_buf.h                |   15 ++++++++++++---
 3 files changed, 19 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 46c516809086..8b7f74b3bea2 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -545,9 +545,9 @@ xfs_attr_rmtval_set(
 		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
 		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
-		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt);
-		if (!bp)
-			return -ENOMEM;
+		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, &bp);
+		if (error)
+			return error;
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
 
 		xfs_attr_rmtval_copyin(mp, bp, args->dp->i_ino, &offset,
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 0ac69751fe85..6fdd007f81ab 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -985,9 +985,9 @@ xfs_update_secondary_sbs(
 	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
 		struct xfs_buf		*bp;
 
-		bp = xfs_buf_get(mp->m_ddev_targp,
+		error = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
-				 XFS_FSS_TO_BB(mp, 1));
+				 XFS_FSS_TO_BB(mp, 1), &bp);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
 		 * continue.  xfs_repair chooses the "best" superblock based
@@ -995,12 +995,12 @@ xfs_update_secondary_sbs(
 		 * superblocks un-updated than updated, and xfs_repair may
 		 * pick them over the properly-updated primary.
 		 */
-		if (!bp) {
+		if (error) {
 			xfs_warn(mp,
 		"error allocating secondary superblock for ag %d",
 				agno);
 			if (!saved_error)
-				saved_error = -ENOMEM;
+				saved_error = error;
 			continue;
 		}
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index f04722554f63..f957d734e4b6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -203,14 +203,23 @@ void xfs_buf_readahead_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
 			       const struct xfs_buf_ops *ops);
 
-static inline struct xfs_buf *
+static inline int
 xfs_buf_get(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		blkno,
-	size_t			numblks)
+	size_t			numblks,
+	struct xfs_buf		**bpp)
 {
+	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_get_map(target, &map, 1, 0);
+
+	*bpp = NULL;
+	bp = xfs_buf_get_map(target, &map, 1, 0);
+	if (!bp)
+		return -ENOMEM;
+
+	*bpp = bp;
+	return 0;
 }
 
 int xfs_buf_read(struct xfs_buftarg *target, xfs_daddr_t blkno, size_t numblks,

