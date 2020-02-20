Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF63C7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7347521D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TyOovzwP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgBTBpU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:45:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35698 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBpU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:45:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hJle064447;
        Thu, 20 Feb 2020 01:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DdJBvO4X/YREnXQf0rdoG7mcYiqvKKx6K4ZmHIdNxEM=;
 b=TyOovzwPBeS+AU+trAYYdRvdepVx6Yuqhz/s0ibLjB8rqfHWlfxLoFlYuXM1IvCuBmGa
 9DFwrtiz220wk60URraIamJmwHARLUIftDky1JoVCeGD9AdU44QRWwmiPo0X63LoFtqd
 812EKY+NZS3Yxb55oh/f6nkMii/JjjHCk4PIG+xR//uap53/i9Y0rZcuaV/JccfMrzfP
 fs61ZLo21l6n0YqDwM3hrkTcnkXr2aXqJnCVZbxvxNrC/Gd85vVuVFcVd0ysCQTAKgYw
 lKnF/cFlrY2h0xk2BOcPcZnTL9A09i1Hlj1YHAFfTXrQ7XDDQ9yY9JgTkNAm0sAlN1qJ Vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2y8udket59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1heTK114487;
        Thu, 20 Feb 2020 01:45:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2y8ud2g64a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:11 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1jA7w003879;
        Thu, 20 Feb 2020 01:45:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:45:10 -0800
Subject: [PATCH 06/14] xfs: make xfs_buf_read_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Wed, 19 Feb 2020 17:45:09 -0800
Message-ID: <158216310939.603628.10002177840493046583.stgit@magnolia>
In-Reply-To: <158216306957.603628.16404096061228456718.stgit@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1011
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 4ed8e27b4f755f50d78dc3d9f9760b60e891f97b

Convert xfs_buf_read_map() to return numeric error codes like most
everywhere else in xfs.  This involves moving the open-coded logic that
reports metadata IO read / corruption errors and stales the buffer into
xfs_buf_read_map so that the logic is all in one place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c       |   11 +++++++----
 libxfs/xfs_attr_remote.c |   10 ----------
 2 files changed, 7 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index ec233d0d..1bf813e3 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2952,14 +2952,17 @@ xfs_read_agf(
 	trace_xfs_read_agf(mp, agno);
 
 	ASSERT(agno != NULLAGNUMBER);
-	error = xfs_trans_read_buf(
-			mp, tp, mp->m_ddev_targp,
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
+	/*
+	 * Callers of xfs_read_agf() currently interpret a NULL bpp as EAGAIN
+	 * and need to be converted to check for EAGAIN specifically.
+	 */
+	if (error == -EAGAIN)
+		return 0;
 	if (error)
 		return error;
-	if (!*bpp)
-		return 0;
 
 	ASSERT(!(*bpp)->b_error);
 	xfs_buf_set_ref(*bpp, XFS_AGF_REF);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index c7a4be35..00371bdc 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -421,16 +421,6 @@ xfs_attr_rmtval_get(
 					&xfs_attr3_rmt_buf_ops);
 			if (!bp)
 				return -ENOMEM;
-			error = bp->b_error;
-			if (error) {
-				xfs_buf_ioerror_alert(bp, __func__);
-				xfs_buf_relse(bp);
-
-				/* bad CRC means corrupted metadata */
-				if (error == -EFSBADCRC)
-					error = -EFSCORRUPTED;
-				return error;
-			}
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,

