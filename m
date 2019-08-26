Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07F3C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E3921872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="liXP1aw9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbfHZVbI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:31:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbfHZVbI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:31:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLQjXC003298;
        Mon, 26 Aug 2019 21:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=fNSAPzY8W1yyqujPnOtiqKr14rhvXtgnEmnhOiH7COQ=;
 b=liXP1aw9gd2d6rkKb7slPHYTn5wQRU7SisOmsg1JRhgYe6uE2DnWDQUNLzKsUXkrsw5B
 PWfL6DplSX4CXXsBYaStghkwVFFUPxmqAjTkZedtrSVRAV5sMlZGfia5fUe7MyCujYwO
 ELtNuDhJVxs0ruW3e7ZJDwJRQMDkBZlMJ2wDiKbS6M1Gk7YZ9ZdA5PEuv5gEWafIoknx
 fBZ9HqDR0ngOdVF2A2DbrZJx1HMV7sqWOGuthrwO4Gw5meZTXIwp9KdCyJ4TZZRWZJm8
 tFQT3CCJKRCPfQhwsmqz4YFHhstNWyXKbOn6sKXRm8told0KIAZD3rrtRwXgO+eT5LG9 ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2umqbe80jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIuw1185187;
        Mon, 26 Aug 2019 21:31:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2umj2xvyce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:04 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLV3Wg029837;
        Mon, 26 Aug 2019 21:31:03 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:31:03 -0700
Subject: [PATCH 11/11] xfs_scrub: simulate errors in the read-verify phase
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:31:02 -0700
Message-ID: <156685506243.2841898.2647440855248405584.stgit@magnolia>
In-Reply-To: <156685499099.2841898.18430382226915450537.stgit@magnolia>
References: <156685499099.2841898.18430382226915450537.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
index e34a8217..2178c528 100644
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
index 71fc274f..d068634b 100644
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

