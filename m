Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC03DC5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A81C921D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oEl3k9ZL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgBTBpb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:45:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:45:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1iIqC169157;
        Thu, 20 Feb 2020 01:45:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=B3p0T+3MGew0vbmxKv0IMDOEay0/ir3wekfDtqnMRcs=;
 b=oEl3k9ZLNH8LSOvATDPaXWkJwcnMsTyIO4nbzMOuo7fqV8zHxozBGSMqCX7O3jQ2OrFU
 JR9FbrpV6+WW3QSW9OJilI2cVuCtHABBYT5o0S5YdXn6Wmm9/ofBOmMsMhGYhSEPwDo/
 Apg21dgFKZj9ODpL2Tzq5+fQhzix47XZRbq9tGV7X7BdQ0ncvfUK6fefVQVj/TJ7nBV6
 OzuEsqumlHawJ1wEeG0XlKG2cLI6vW893GEEdMVOtdFLtqpMv4QbVjU+4trbiJYk5bxK
 cKWZdnkA40I2RlMayLnO2k2J4MlyhhrzAFDDTHtyc3vI9lNa8+AbpHOo5ra7FKgfOEan +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2y8ud16sh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hcqF114270;
        Thu, 20 Feb 2020 01:45:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2y8ud2g6fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:23 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1jNX1003980;
        Thu, 20 Feb 2020 01:45:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:45:22 -0800
Subject: [PATCH 08/14] xfs: make xfs_buf_get_uncached return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Wed, 19 Feb 2020 17:45:21 -0800
Message-ID: <158216312194.603628.5152582204376597051.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
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
index 064587a6..6fbf976b 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -256,8 +256,8 @@ xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t len)
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
index a05e0fee..0bfe46f3 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1128,13 +1128,15 @@ libxfs_getbufr_uncached(
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
index b50b8b3a..e6b44575 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3404,8 +3404,14 @@ get_write_buf(
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

