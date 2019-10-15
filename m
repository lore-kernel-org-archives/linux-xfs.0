Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1EEECE588
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D7F920650
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:23:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J0rnXwzo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388425AbfJORXk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 13:23:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44812 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbfJORXk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 13:23:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FHInus059692;
        Tue, 15 Oct 2019 17:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=zdUJIw2yrRA17eHu1vY34DvjBL6df6zATXz0rzYu1Hk=;
 b=J0rnXwzoQ6EIhfBRcrOTQcPht/oWjL4a2ecuUUvZNOfB3Giiewmm2hfJ7yS6MlaAyBVL
 bFMa38sj4Kf/V/XbQiYxYXtyiNbDSBQRaRRx66eWYw8TYfs5dFQU3+/NwS7+udLfxvRs
 1nnltt/CE9JpLtUE9tf9ON6GgAbp9GzEyMvDjn3t2ywrBiD5U66eOiHXvyJgKbgg4Mhi
 aw+vk1mp2bzjL9a32zcPeLdNxlBjTbspXZvUKE1DU1iBK3tmiWm1IY1HiNSuPSx92eVH
 pACyQdPA2yBfeSVkdgHnzrt9KosOrQdvp+p2Toy1W3nEbjyAsdT0U3jn/uhjdNDBOX5M Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vk7fr9f07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 17:23:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FHJBN1030467;
        Tue, 15 Oct 2019 17:23:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vn718q36n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 17:23:37 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9FHNarj013627;
        Tue, 15 Oct 2019 17:23:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 17:23:36 +0000
Date:   Tue, 15 Oct 2019 10:23:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 10/11] xfs_scrub: fix read verify disk error handling
 strategy
Message-ID: <20191015172333.GL13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150148
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
v2: fix errors_seen bogosity
---
 scrub/read_verify.c |   86 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 12 deletions(-)

diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 231df802..8aec25de 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -173,30 +173,92 @@ read_verify(
 	struct read_verify		*rv = arg;
 	struct read_verify_pool		*rvp;
 	unsigned long long		verified = 0;
+	ssize_t				io_max_size;
 	ssize_t				sz;
 	ssize_t				len;
+	int				io_error;
 	int				ret;
 
 	rvp = (struct read_verify_pool *)wq->wq_ctx;
+	if (rvp->runtime_error)
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
+				rvp->runtime_error = io_error;
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
