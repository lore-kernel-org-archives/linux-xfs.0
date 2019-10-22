Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C2ACA9EB9
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E37FE20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hcWRLWsv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732564AbfJVSwJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:52:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55264 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732691AbfJVSwJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:52:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiDjh091013;
        Tue, 22 Oct 2019 18:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=KXjgXIBYcc5w9PxiCt/Zq8JG1cOC6iZGrmN5vbgWcfA=;
 b=hcWRLWsv0oEXH8ecH1lGNJaYRJathhdL/hIyY06oO4BQAhhE7PrmUKkNIMEgkCpmBuhr
 zo4Eb4CQ/7i5mIUigTvOyJfrc1BXlyXdLHPi1qDpe16zCkXJvxpI0BdN6Yx8oGQF5Pk9
 AOTZ847PjQVhSV6S+cRwM9jZSSI6BJZRWebpAch6mEPXkx0+rOhbCwt+ogWm/u25/7de
 EhxMawNJHP/JlQLU35VvmkRO6WuuC0B6BrqdDj2XWns7F8NMSIkJUXx3KzPu2pyRARWI
 qRMqHqRWA+K+O02qGrQy4MzPkI7Af6RtnTzfPHtsdWOsDYURcN15m7gc3BCUgbkjdq3M Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vqteprrrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhpPI148419;
        Tue, 22 Oct 2019 18:50:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vsp4010ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:50:06 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIo57x031467;
        Tue, 22 Oct 2019 18:50:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:50:05 -0700
Subject: [PATCH 1/3] xfs_scrub: implement background mode for phase 6
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Date:   Tue, 22 Oct 2019 11:50:04 -0700
Message-ID: <157177020437.1460684.1573285913657154325.stgit@magnolia>
In-Reply-To: <157177019803.1460684.3524666107607426492.stgit@magnolia>
References: <157177019803.1460684.3524666107607426492.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Phase 6 doesn't implement background mode, which means that it doesn't
run in single-threaded mode with one -b and it doesn't sleep between
calls with multiple -b like every other phase does.  It also doesn't
restrict the amount of work per kernel call, which is a key part of
throttling.  Wire up the necessary pieces to make it behave like the man
page says it should.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 scrub/read_verify.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index a963a3fd..82605c8c 100644
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
@@ -89,7 +101,7 @@ read_verify_pool_alloc(
 	 */
 	if (miniosz % disk->d_lbasize)
 		return EINVAL;
-	if (RVP_IO_MAX_SIZE % miniosz)
+	if (rvp_io_max_size() % miniosz)
 		return EINVAL;
 
 	rvp = calloc(1, sizeof(struct read_verify_pool));
@@ -97,7 +109,7 @@ read_verify_pool_alloc(
 		return errno;
 
 	ret = posix_memalign((void **)&rvp->readbuf, page_size,
-			RVP_IO_MAX_SIZE);
+			rvp_io_max_size());
 	if (ret)
 		goto out_free;
 	ret = ptcounter_alloc(verifier_threads, &rvp->verified_bytes);
@@ -181,7 +193,7 @@ read_verify(
 	if (rvp->runtime_error)
 		return;
 
-	io_max_size = RVP_IO_MAX_SIZE;
+	io_max_size = rvp_io_max_size();
 
 	while (rv->io_length > 0) {
 		read_error = 0;
@@ -257,6 +269,7 @@ read_verify(
 			verified += sz;
 		rv->io_start += sz;
 		rv->io_length -= sz;
+		background_sleep();
 	}
 
 	free(rv);

