Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CA0C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F9FE206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:40:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FAdKT2xW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388476AbfIFDkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:40:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53840 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731630AbfIFDkn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:40:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863ddfO113410;
        Fri, 6 Sep 2019 03:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=y6+qHqr7xBMm9s/tTX9s7XM0bExTbiHKaptTsujZ3ls=;
 b=FAdKT2xWOiLbO+Nqx4VvUberebOXa3d6R1kekiKEUCANAEOUuv0Xyj6JEKg4/4FXuv8U
 Q7COcl1jAlhsQqrifGk/ulqIaC/kQEm4Kx8WhrBC2fQb/30JHs9eFNDa76dUEp1qKxTq
 cGlYj5esBsQVh0zJxHnvthTgQpk0pf4xWSwMgENWCzGBReh5H3zAUH8Vbok/gHJrKohk
 ravTj2EbQcRAJC4i5Pkt7u8AnWLzc2IA+/+j2etzjzbY2NdQULVpk2Z7t7nARQ2zlbu+
 iz3+lgc5+/rDyKNn1LOLMCM4cnXisHzIbcDXnKRC+sc4ZDMXO8/WD3iMnMFJ3FdQEajX ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uufr08030-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:40:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cQ9K077940;
        Fri, 6 Sep 2019 03:40:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2utvr4k1r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:40:40 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863eeNp020735;
        Fri, 6 Sep 2019 03:40:40 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:40:40 -0700
Subject: [PATCH 1/3] xfs_scrub: implement background mode for phase 6
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:40:39 -0700
Message-ID: <156774123948.2646704.14264815195950334701.stgit@magnolia>
In-Reply-To: <156774123336.2646704.1827381294403838403.stgit@magnolia>
References: <156774123336.2646704.1827381294403838403.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Phase 6 doesn't implement background mode, which means that it doesn't
run in single-threaded mode with one -b and it doesn't sleep between
calls with multiple -b like every other phase does.  Wire up the
necessary pieces to make it behave like the man page says it should.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/read_verify.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 834571a7..414d25a6 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -32,7 +32,19 @@
  * because that's the biggest SCSI VERIFY(16) we dare to send.
  */
 #define RVP_IO_MAX_SIZE		(33554432)
-#define RVP_IO_MAX_SECTORS	(RVP_IO_MAX_SIZE >> BBSHIFT)
+
+/*
+ * If we're running in the background then we perform IO in 128k chunks
+ * to reduce the load on the IO subsystem.
+ */
+#define RVP_BACKGROUND_IO_MAX_SIZE	(131072)
+
+/* What's the real maximum IO size? */
+static inline unsigned int
+rvp_io_max_size(void)
+{
+	return bg_mode > 0 ? RVP_BACKGROUND_IO_MAX_SIZE : RVP_IO_MAX_SIZE;
+}
 
 /* Tolerate 64k holes in adjacent read verify requests. */
 #define RVP_IO_BATCH_LOCALITY	(65536)
@@ -84,7 +96,7 @@ read_verify_pool_alloc(
 	 */
 	if (miniosz % disk->d_lbasize)
 		return EINVAL;
-	if (RVP_IO_MAX_SIZE % miniosz)
+	if (rvp_io_max_size() % miniosz)
 		return EINVAL;
 
 	rvp = calloc(1, sizeof(struct read_verify_pool));
@@ -92,7 +104,7 @@ read_verify_pool_alloc(
 		return errno;
 
 	ret = posix_memalign((void **)&rvp->readbuf, page_size,
-			RVP_IO_MAX_SIZE);
+			rvp_io_max_size());
 	if (ret)
 		goto out_free;
 	ret = ptcounter_alloc(verifier_threads, &rvp->verified_bytes);
@@ -177,7 +189,7 @@ read_verify(
 	if (rvp->errors_seen)
 		return;
 
-	io_max_size = RVP_IO_MAX_SIZE;
+	io_max_size = rvp_io_max_size();
 
 	while (rv->io_length > 0) {
 		io_error = 0;
@@ -253,6 +265,7 @@ read_verify(
 			verified += sz;
 		rv->io_start += sz;
 		rv->io_length -= sz;
+		background_sleep();
 	}
 
 	free(rv);

