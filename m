Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298AAC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE49820872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:36:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dSZnp6DW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfIYVgD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:36:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60324 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbfIYVgD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:36:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYTm2054857;
        Wed, 25 Sep 2019 21:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Q+EV+14rIkDjV7nRhr7orpb8jHt3XCVs4IJD5vJVHjo=;
 b=dSZnp6DWF/0uODUpmawaczSJ7wdQzSqYfHc9xpfRoxda8QfFoqsXWVRs81hurTwvVSf7
 Ryf5Hz6tNRCvZKArUCRI9huJN8mBhVVKSADtKvY/rnD/AhvGgERnSYKWd1S6MCcMQ5Kp
 FoFGF3FB4QTYox+p4EzLsAW7o9ZFyWVWkPaHuTblo6NxeA5nk5nwI0wk+oTKk22Ws9pf
 Zwstzc3VYSvppZoPH4z2CIEC18Fr+BarhMlkBb5kKUvA1Fpn1Dvo7sugKTyNVX3AI+Jm
 0fW3o7y7VBXweygZ1sHCgOw+6PHrWdm/q5YfHHtnpj5WmRmWsVedyaipzsLaVw/Mw4WW 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgr7f1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYTv0097768;
        Wed, 25 Sep 2019 21:36:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2v82qakuae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:00 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLZxmW015953;
        Wed, 25 Sep 2019 21:35:59 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:35:59 -0700
Subject: [PATCH 10/11] xfs_scrub: fix read verify disk error handling
 strategy
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:35:57 -0700
Message-ID: <156944735791.298887.835608192403523684.stgit@magnolia>
In-Reply-To: <156944728875.298887.8311229116097714980.stgit@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The error handling strategy for media errors is totally bogus.  First of
all, short reads are entirely unhandled -- when we encounter a short
read, we know the disk was able to feed us the beginning of what we
asked for, so we need to single-step through the remainder to try to
capture the exact error that we hit.

Second, an actual IO error causes the entire region to be marked bad
even though it could be just a few MB of a multi-gigabyte extent that's
bad.  Therefore, single-step each block in the IO request until we stop
getting IO errors to find out if all the blocks are bad or if it's just
that extent.

Third, fix the fact that the loop updates its own counter variables with
the length fed to read(), which doesn't necessarily have anything to do
with the amount of data that the read actually produced.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/read_verify.c |   86 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 12 deletions(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 9d9be68d..3dac10ce 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -169,30 +169,92 @@ read_verify(
 	struct read_verify		*rv = arg;
 	struct read_verify_pool		*rvp;
 	unsigned long long		verified = 0;
+	ssize_t				io_max_size;
 	ssize_t				sz;
 	ssize_t				len;
+	int				io_error;
 	int				ret;
 
 	rvp = (struct read_verify_pool *)wq->wq_ctx;
+	if (rvp->errors_seen)
+		return;
+
+	io_max_size = RVP_IO_MAX_SIZE;
+
 	while (rv->io_length > 0) {
-		len = min(rv->io_length, RVP_IO_MAX_SIZE);
+		io_error = 0;
+		len = min(rv->io_length, io_max_size);
 		dbg_printf("diskverify %d %"PRIu64" %zu\n", rvp->disk->d_fd,
 				rv->io_start, len);
 		sz = disk_read_verify(rvp->disk, rvp->readbuf, rv->io_start,
 				len);
-		if (sz < 0) {
-			dbg_printf("IOERR %d %"PRIu64" %zu\n",
-					rvp->disk->d_fd, rv->io_start, len);
-			/* IO error, so try the next logical block. */
-			len = rvp->miniosz;
-			rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start, len,
-					errno, rv->io_end_arg);
+		if (sz == len && io_max_size < rvp->miniosz) {
+			/*
+			 * If the verify request was 100% successful and less
+			 * than a single block in length, we were trying to
+			 * read to the end of a block after a short read.  That
+			 * suggests there's something funny with this device,
+			 * so single-step our way through the rest of the @rv
+			 * range.
+			 */
+			io_max_size = rvp->miniosz;
+		} else if (sz < 0) {
+			io_error = errno;
+
+			/* Runtime error, bail out... */
+			if (io_error != EIO && io_error != EILSEQ) {
+				rvp->errors_seen = io_error;
+				return;
+			}
+
+			/*
+			 * A direct read encountered an error while performing
+			 * a multi-block read.  Reduce the transfer size to a
+			 * single block so that we can identify the exact range
+			 * of bad blocks and good blocks.  We single-step all
+			 * the way to the end of the @rv range, (re)starting
+			 * with the block that just failed.
+			 */
+			if (io_max_size > rvp->miniosz) {
+				io_max_size = rvp->miniosz;
+				continue;
+			}
+
+			/*
+			 * A direct read hit an error while we were stepping
+			 * through single blocks.  Mark everything bad from
+			 * io_start to the next miniosz block.
+			 */
+			sz = rvp->miniosz - (rv->io_start % rvp->miniosz);
+			dbg_printf("IOERR %d @ %"PRIu64" %zu err %d\n",
+					rvp->disk->d_fd, rv->io_start, sz,
+					io_error);
+			rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start, sz,
+					io_error, rv->io_end_arg);
+		} else if (sz < len) {
+			/*
+			 * A short direct read suggests that we might have hit
+			 * an IO error midway through the read but still had to
+			 * return the number of bytes that were actually read.
+			 *
+			 * We need to force an EIO, so try reading the rest of
+			 * the block (if it was a partial block read) or the
+			 * next full block.
+			 */
+			io_max_size = rvp->miniosz - (sz % rvp->miniosz);
+			dbg_printf("SHORT %d READ @ %"PRIu64" %zu try for %zd\n",
+					rvp->disk->d_fd, rv->io_start, sz,
+					io_max_size);
+		} else {
+			/* We should never get back more bytes than we asked. */
+			assert(sz == len);
 		}
 
-		progress_add(len);
-		verified += len;
-		rv->io_start += len;
-		rv->io_length -= len;
+		progress_add(sz);
+		if (io_error == 0)
+			verified += sz;
+		rv->io_start += sz;
+		rv->io_length -= sz;
 	}
 
 	free(rv);

