Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57341C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2208B21D7E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:19:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l+NNkejF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgBYATL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:19:11 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYATL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:19:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07lkg050164;
        Tue, 25 Feb 2020 00:17:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=G8Dvj0PnqCg7xqEvalNlKBqBsUAy1h0ElwPViQLh68s=;
 b=l+NNkejFWkO8vZ5s7ezdxHrazpKzB4gvY2aaoVWoNXgrZKDvc2oA6D9pB4q94o9ELcHe
 MYFW79j8DhsyjBk94YBCTYsrt8FVIHyAjYy9fbPbcu/yWUjQX9eHKqVfgdtmsmuQF3WU
 YzZM0GF5nEdBW994SPwvjuTdsWX2IRmKl6EyEqSO16ugHNPGNrmArGyDg+vwLMpNYp8F
 s2JBeTyvNUgY7I21U0Fsp1s6Z/d1N6ciZAKjpqirNNbXE71Leiw7XdQsXyybcy0GE65O
 AVuRoYlGGilXM0rZ/zn7kGXPDvVcfbLw/oAcV/lYSxOazXtSEir3OtElF7SlsK48V1f5 Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q46w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:17:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08Crw158884;
        Tue, 25 Feb 2020 00:15:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2yby5e9teb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:04 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0F3bQ001422;
        Tue, 25 Feb 2020 00:15:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:15:03 -0800
Subject: [PATCH 08/14] xfs: make xfs_buf_get_uncached return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Mon, 24 Feb 2020 16:15:02 -0800
Message-ID: <158258970244.453666.9282937965577259280.stgit@magnolia>
In-Reply-To: <158258964941.453666.10913737544282124969.stgit@magnolia>
References: <158258964941.453666.10913737544282124969.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 2842b6db3d539bec08d080b22635b6e8acaa30ec

Convert xfs_buf_get_uncached() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h        |    4 ++--
 libxfs/rdwr.c             |    8 +++++---
 libxfs/xfs_ag.c           |   21 ++++++++++++---------
 libxlog/xfs_log_recover.c |    7 +++++--
 mkfs/xfs_mkfs.c           |    8 +++++++-
 5 files changed, 31 insertions(+), 17 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index cd38ec09..703a2168 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -254,8 +254,8 @@ xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t len)
 	return 0;
 }
 
-struct xfs_buf *libxfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen,
-		int flags);
+int libxfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags,
+		struct xfs_buf **bpp);
 int libxfs_buf_read_uncached(struct xfs_buftarg *targ, xfs_daddr_t daddr,
 		size_t bblen, int flags, struct xfs_buf **bpp,
 		const struct xfs_buf_ops *ops);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0778a15f..2d056009 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -889,13 +889,15 @@ libxfs_getbufr_uncached(
  * Allocate an uncached buffer that points nowhere.  The refcount will be 1,
  * and the cache node hash list will be empty to indicate that it's uncached.
  */
-struct xfs_buf *
+int
 libxfs_buf_get_uncached(
 	struct xfs_buftarg	*targ,
 	size_t			bblen,
-	int			flags)
+	int			flags,
+	struct xfs_buf		**bpp)
 {
-	return libxfs_getbufr_uncached(targ, XFS_BUF_DADDR_NULL, bblen);
+	*bpp = libxfs_getbufr_uncached(targ, XFS_BUF_DADDR_NULL, bblen);
+	return *bpp != NULL ? 0 : -ENOMEM;
 }
 
 /*
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 5bf6975d..73fb30cb 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -23,25 +23,28 @@
 #include "xfs_ag_resv.h"
 #include "xfs_health.h"
 
-static struct xfs_buf *
+static int
 xfs_get_aghdr_buf(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		blkno,
 	size_t			numblks,
+	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
-	bp = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, 0);
-	if (!bp)
-		return NULL;
+	error = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, 0, &bp);
+	if (error)
+		return error;
 
 	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
 	bp->b_bn = blkno;
 	bp->b_maps[0].bm_bn = blkno;
 	bp->b_ops = ops;
 
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 static inline bool is_log_ag(struct xfs_mount *mp, struct aghdr_init_data *id)
@@ -340,13 +343,13 @@ xfs_ag_init_hdr(
 	struct aghdr_init_data	*id,
 	aghdr_init_work_f	work,
 	const struct xfs_buf_ops *ops)
-
 {
 	struct xfs_buf		*bp;
+	int			error;
 
-	bp = xfs_get_aghdr_buf(mp, id->daddr, id->numblks, ops);
-	if (!bp)
-		return -ENOMEM;
+	error = xfs_get_aghdr_buf(mp, id->daddr, id->numblks, &bp, ops);
+	if (error)
+		return error;
 
 	(*work)(mp, bp, id);
 
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index e7e57bd2..78fbafab 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -35,11 +35,13 @@ xlog_buf_bbcount_valid(
  * to map to a range of nbblks basic blocks at any valid (basic
  * block) offset within the log.
  */
-xfs_buf_t *
+struct xfs_buf *
 xlog_get_bp(
 	struct xlog	*log,
 	int		nbblks)
 {
+	struct xfs_buf	*bp;
+
 	if (!xlog_buf_bbcount_valid(log, nbblks)) {
 		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
 			nbblks);
@@ -67,7 +69,8 @@ xlog_get_bp(
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
-	return libxfs_buf_get_uncached(log->l_dev, nbblks, 0);
+	libxfs_buf_get_uncached(log->l_dev, nbblks, 0, &bp);
+	return bp;
 }
 
 /*
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 295deb86..efe4feaa 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3404,8 +3404,14 @@ alloc_write_buf(
 	int			bblen)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
-	bp = libxfs_buf_get_uncached(btp, bblen, 0);
+	error = -libxfs_buf_get_uncached(btp, bblen, 0, &bp);
+	if (error) {
+		fprintf(stderr, _("Could not get memory for buffer, err=%d\n"),
+				error);
+		exit(1);
+	}
 	bp->b_bn = daddr;
 	bp->b_maps[0].bm_bn = daddr;
 	return bp;

