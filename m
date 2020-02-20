Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42AFC5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 792B721D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FT9K9dSi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgBTBpA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:45:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46386 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgBTBpA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:45:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gp91092701;
        Thu, 20 Feb 2020 01:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kKGZRMai9DhmnELJEZRREsak6Og5Of1nAPhothqIX28=;
 b=FT9K9dSibfpV+RFdphXoyn7DcJsHOnSzPiugc8Xzhx6lggp+mWPhs6qBi2cruu5mPZ9Q
 354F8P7v86i+bjJhG1vlc7+hAuXmb/CLg9XNYM3dr8R9ijkn07woxW4Q+1LOxCQbDZ9l
 SSTRF2ItSUr6DSIk+7dN7COeLo1D0T2RH4y6SPrZFp0xAuUeEWJyTa5q1wxhc6xW1WFx
 h4IKx0MglZjkmBs594fE7Z/IJgDkYiPnli31Vi7pTnxlvsRjOQGVr1oDk6GKo/WYzHPD
 Ra55CSoOR66+/c8KHLL8cAKvGLqg1kR+Z+9ROtPBlcMJmsXvwF+7y/vXMuCiUgrYPmAJ rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y8udd6th9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gEru094272;
        Thu, 20 Feb 2020 01:44:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y8udbmjud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:56 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1iuQl002916;
        Thu, 20 Feb 2020 01:44:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:44:56 -0800
Subject: [PATCH 04/14] libxfs: refactor libxfs_readbuf out of existence
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:44:54 -0800
Message-ID: <158216309405.603628.3732022870551516081.stgit@magnolia>
In-Reply-To: <158216306957.603628.16404096061228456718.stgit@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The two libxfs_readbuf* functions are awfully similar, so refactor one
into the other to reduce duplicated code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c |   83 +++++++++++++++++++++------------------------------------
 1 file changed, 30 insertions(+), 53 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 4e1665c0..6eaa3e69 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -972,53 +972,6 @@ libxfs_readbuf_verify(
 	return bp->b_error;
 }
 
-static struct xfs_buf *
-libxfs_readbuf(
-	struct xfs_buftarg	*btp,
-	xfs_daddr_t		blkno,
-	size_t			len,
-	int			flags,
-	const struct xfs_buf_ops *ops)
-{
-	struct xfs_buf		*bp;
-	int			error;
-
-	error = libxfs_getbuf_flags(btp, blkno, len, 0, &bp);
-	if (error)
-		return NULL;
-
-	/*
-	 * if the buffer was prefetched, it is likely that it was not validated.
-	 * Hence if we are supplied an ops function and the buffer is marked as
-	 * unchecked, we need to validate it now.
-	 *
-	 * We do this verification even if the buffer is dirty - the
-	 * verification is almost certainly going to fail the CRC check in this
-	 * case as a dirty buffer has not had the CRC recalculated. However, we
-	 * should not be dirtying unchecked buffers and therefore failing it
-	 * here because it's dirty and unchecked indicates we've screwed up
-	 * somewhere else.
-	 */
-	bp->b_error = 0;
-	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
-		if (bp->b_flags & LIBXFS_B_UNCHECKED)
-			libxfs_readbuf_verify(bp, ops);
-		return bp;
-	}
-
-	/*
-	 * Set the ops on a cache miss (i.e. first physical read) as the
-	 * verifier may change the ops to match the type of buffer it contains.
-	 * A cache hit might reset the verifier to the original type if we set
-	 * it again, but it won't get called again and set to match the buffer
-	 * contents. *cough* xfs_da_node_buf_ops *cough*.
-	 */
-	error = libxfs_readbufr(btp, blkno, bp, len, flags);
-	if (!error)
-		libxfs_readbuf_verify(bp, ops);
-	return bp;
-}
-
 int
 libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 {
@@ -1059,20 +1012,44 @@ libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 	int		error = 0;
 
 	if (nmaps == 1)
-		return libxfs_readbuf(btp, map[0].bm_bn, map[0].bm_len,
-					flags, ops);
-
-	error = __libxfs_buf_get_map(btp, map, nmaps, 0, &bp);
+		error = libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
+				0, &bp);
+	else
+		error = __libxfs_buf_get_map(btp, map, nmaps, 0, &bp);
 	if (error)
 		return NULL;
 
+	/*
+	 * if the buffer was prefetched, it is likely that it was not validated.
+	 * Hence if we are supplied an ops function and the buffer is marked as
+	 * unchecked, we need to validate it now.
+	 *
+	 * We do this verification even if the buffer is dirty - the
+	 * verification is almost certainly going to fail the CRC check in this
+	 * case as a dirty buffer has not had the CRC recalculated. However, we
+	 * should not be dirtying unchecked buffers and therefore failing it
+	 * here because it's dirty and unchecked indicates we've screwed up
+	 * somewhere else.
+	 */
 	bp->b_error = 0;
-	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
+	if (bp->b_flags & (LIBXFS_B_UPTODATE | LIBXFS_B_DIRTY)) {
 		if (bp->b_flags & LIBXFS_B_UNCHECKED)
 			libxfs_readbuf_verify(bp, ops);
 		return bp;
 	}
-	error = libxfs_readbufr_map(btp, bp, flags);
+
+	/*
+	 * Set the ops on a cache miss (i.e. first physical read) as the
+	 * verifier may change the ops to match the type of buffer it contains.
+	 * A cache hit might reset the verifier to the original type if we set
+	 * it again, but it won't get called again and set to match the buffer
+	 * contents. *cough* xfs_da_node_buf_ops *cough*.
+	 */
+	if (nmaps == 1)
+		error = libxfs_readbufr(btp, map[0].bm_bn, bp, map[0].bm_len,
+				flags);
+	else
+		error = libxfs_readbufr_map(btp, bp, flags);
 	if (!error)
 		libxfs_readbuf_verify(bp, ops);
 

