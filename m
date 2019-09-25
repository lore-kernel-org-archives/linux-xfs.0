Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD156C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F65D20872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:36:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hIF3iN9N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfIYVgK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:36:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38892 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbfIYVgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:36:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYYev058088;
        Wed, 25 Sep 2019 21:36:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DHp6NeqHX2UVAq8iW1ZZUFju6HMRz5iZsEGCXgnurz0=;
 b=hIF3iN9NFIHrrXDJptghvx3+BDtMiaucQZP05nhpTDzIkVSAtZIwz8S1MU9sXbbQykul
 0iSVPpXbikbF1znohOKig7nX/3201KBmsuj6umPO2b70O+Vf0G8twTncestIiP//9Nej
 VtlDSvLtKrfkMApgzP1ebKge2zHwe3lGBg6JHlKQbL1G40fRDxaodS3QR5mtOWzc9EUv
 hucRL/GaOkj6HeSDjqQ4I5yjjt1CGPOVclBQxRnoUSYj4Uxi1zcCMKdtGBq31/SqL9UT
 vHl0QFLyLfu8KrtchifC4DwJXPcgM9vcnNmfC/c0nxHBgV4aBR/M6F3lKZPXrNTUfol0 cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tyh6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYQgT023793;
        Wed, 25 Sep 2019 21:36:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v7vnyurm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:06 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLa5cD015992;
        Wed, 25 Sep 2019 21:36:05 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:36:05 -0700
Subject: [PATCH 11/11] xfs_scrub: simulate errors in the read-verify phase
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:36:04 -0700
Message-ID: <156944736394.298887.1875941495906616797.stgit@magnolia>
In-Reply-To: <156944728875.298887.8311229116097714980.stgit@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a debugging hook so that we can simulate disk errors during the
media scan to test that the code works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/disk.c      |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.c |    2 ++
 2 files changed, 69 insertions(+)


diff --git a/scrub/disk.c b/scrub/disk.c
index bf9c795a..214a5346 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -276,6 +276,59 @@ disk_close(
 #define LBASIZE(d)		(1ULL << (d)->d_lbalog)
 #define BTOLBA(d, bytes)	(((uint64_t)(bytes) + LBASIZE(d) - 1) >> (d)->d_lbalog)
 
+/* Simulate disk errors. */
+static int
+disk_simulate_read_error(
+	struct disk		*disk,
+	uint64_t		start,
+	uint64_t		*length)
+{
+	static int64_t		interval;
+	uint64_t		start_interval;
+
+	/* Simulated disk errors are disabled. */
+	if (interval < 0)
+		return 0;
+
+	/* Figure out the disk read error interval. */
+	if (interval == 0) {
+		char		*p;
+
+		/* Pretend there's bad media every so often, in bytes. */
+		p = getenv("XFS_SCRUB_DISK_ERROR_INTERVAL");
+		if (p == NULL) {
+			interval = -1;
+			return 0;
+		}
+		interval = strtoull(p, NULL, 10);
+		interval &= ~((1U << disk->d_lbalog) - 1);
+	}
+
+	/*
+	 * We simulate disk errors by pretending that there are media errors at
+	 * predetermined intervals across the disk.  If a read verify request
+	 * crosses one of those intervals we shorten it so that the next read
+	 * will start on an interval threshold.  If the read verify request
+	 * starts on an interval threshold, we send back EIO as if it had
+	 * failed.
+	 */
+	if ((start % interval) == 0) {
+		dbg_printf("fd %d: simulating disk error at %"PRIu64".\n",
+				disk->d_fd, start);
+		return EIO;
+	}
+
+	start_interval = start / interval;
+	if (start_interval != (start + *length) / interval) {
+		*length = ((start_interval + 1) * interval) - start;
+		dbg_printf(
+"fd %d: simulating short read at %"PRIu64" to length %"PRIu64".\n",
+				disk->d_fd, start, *length);
+	}
+
+	return 0;
+}
+
 /* Read-verify an extent of a disk device. */
 ssize_t
 disk_read_verify(
@@ -284,6 +337,20 @@ disk_read_verify(
 	uint64_t		start,
 	uint64_t		length)
 {
+	if (debug) {
+		int		ret;
+
+		ret = disk_simulate_read_error(disk, start, &length);
+		if (ret) {
+			errno = ret;
+			return -1;
+		}
+
+		/* Don't actually issue the IO */
+		if (getenv("XFS_SCRUB_DISK_VERIFY_SKIP"))
+			return length;
+	}
+
 	/* Convert to logical block size. */
 	if (disk->d_flags & DISK_FLAG_SCSI_VERIFY)
 		return disk_scsi_verify(disk, BTOLBAT(disk, start),
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 05478093..b6a01274 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -111,6 +111,8 @@
  * XFS_SCRUB_NO_SCSI_VERIFY	-- disable SCSI VERIFY (if present)
  * XFS_SCRUB_PHASE		-- run only this scrub phase
  * XFS_SCRUB_THREADS		-- start exactly this number of threads
+ * XFS_SCRUB_DISK_ERROR_INTERVAL-- simulate a disk error every this many bytes
+ * XFS_SCRUB_DISK_VERIFY_SKIP	-- pretend disk verify read calls succeeded
  *
  * Available even in non-debug mode:
  * SERVICE_MODE			-- compress all error codes to 1 for LSB

