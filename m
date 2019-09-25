Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE57C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D0DA205F4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:37:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m4J594YS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfIYVhy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:37:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40628 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbfIYVhx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:37:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYNmg057949;
        Wed, 25 Sep 2019 21:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Ua8eM9qdeByXWS6BhqQ0Oufi5tysK8LbSZgcQLVNSYA=;
 b=m4J594YScb8+uBhAnMAlz2tXEPFoWClqlDASzZNTkj6/BRsRJJQyYz+dV4O0MxfR5pmm
 zVqtH/opQC9WtpEwCtTIfIxdprvtAoVtQHed6CYurK1KM8+/4g5vm8phEvgfjO3mn7tt
 Qtg7fKCnH9aCzC8EAoosQDFRWiWwgpceRYur6jx8EvBI9Km72E/z6QZnQ1pfIS1KFkZJ
 Gyb1YqZ87Vmfq55XvyHoBVkxWYQh1jo5DeIuerr9LcmK5lQWrf3d2fU2/ovFp7e3BZgb
 oV+1+mlrd7FlWNVmCVogpxPcuBKH1pbBtCTugZahC7IClofRQhmB3JgAOoBM2Q/AUBeL Lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v5b9tyhd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:37:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYQLL078645;
        Wed, 25 Sep 2019 21:37:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2v82tkrmwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:37:50 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLbnnO016372;
        Wed, 25 Sep 2019 21:37:49 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:37:49 -0700
Subject: [PATCH 1/3] xfs_scrub: implement background mode for phase 6
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Date:   Wed, 25 Sep 2019 14:37:47 -0700
Message-ID: <156944746789.300554.3921148458115224771.stgit@magnolia>
In-Reply-To: <156944746189.300554.10941200805627828695.stgit@magnolia>
References: <156944746189.300554.10941200805627828695.stgit@magnolia>
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

Phase 6 doesn't implement background mode, which means that it doesn't
run in single-threaded mode with one -b and it doesn't sleep between
calls with multiple -b like every other phase does.  Wire up the
necessary pieces to make it behave like the man page says it should.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
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

