Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD348C7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B097521D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M3ZfTO2a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgBTBmG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60278 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727338AbgBTBmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1dIC5112981;
        Thu, 20 Feb 2020 01:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8xL7qF9tvmSvXDoC4uO3vBJxq0NjddwfYnr2X/6QYc0=;
 b=M3ZfTO2aRum4FEdUtrXHcNnzkGaEq5bA+2pIx67ypa9otk7FJ67c5Sk8cahfa0aMQexT
 kURdchO35Jfgy7KANhVpGSCuTWo3T4Ox1PiNEFGy94p41HJbGEtDlm9VcCOiFpqdRutm
 pjqIAQqJYnBE6ft92wf3uyLxDbz0ZfmHeM382XPCTBw2d6DODBQ6KDgJoz4AVGrwKRD7
 wY+zaOEx5wDQgDq0MbiOLAmTccaTCef16QQuRu4Iu3SULd9dpDT7wOSd+KMZGFKZrpc5
 HzStJf0rtFH2Yj74tlOcKWnQDLwv9F8Dgoutr8fO9wZkzqLOmSPBBR27kDMXoWx/0WoT Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y8udkesvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1cPEK030968;
        Thu, 20 Feb 2020 01:42:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y8udbmehe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:02 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1g1hB001477;
        Thu, 20 Feb 2020 01:42:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:42:01 -0800
Subject: [PATCH 3/8] libxfs: return flush failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 19 Feb 2020 17:42:00 -0800
Message-ID: <158216292041.601264.6025267041941901980.stgit@magnolia>
In-Reply-To: <158216290180.601264.5491208016048898068.stgit@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Modify platform_flush_device so that we can return error status when
device flushes fail.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/linux.c    |   25 +++++++++++++++++--------
 libfrog/platform.h |    2 +-
 2 files changed, 18 insertions(+), 9 deletions(-)


diff --git a/libfrog/linux.c b/libfrog/linux.c
index 41a168b4..60bc1dc4 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -140,20 +140,29 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
 	return error;
 }
 
-void
-platform_flush_device(int fd, dev_t device)
+/*
+ * Flush dirty pagecache and disk write cache to stable media.  Returns 0 for
+ * success or -1 (with errno set) for failure.
+ */
+int
+platform_flush_device(
+	int		fd,
+	dev_t		device)
 {
 	struct stat	st;
+	int		ret;
+
 	if (major(device) == RAMDISK_MAJOR)
-		return;
+		return 0;
 
-	if (fstat(fd, &st) < 0)
-		return;
+	ret = fstat(fd, &st);
+	if (ret)
+		return ret;
 
 	if (S_ISREG(st.st_mode))
-		fsync(fd);
-	else
-		ioctl(fd, BLKFLSBUF, 0);
+		return fsync(fd);
+
+	return ioctl(fd, BLKFLSBUF, 0);
 }
 
 void
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 76887e5e..0aef318a 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -12,7 +12,7 @@ int platform_check_ismounted(char *path, char *block, struct stat *sptr,
 int platform_check_iswritable(char *path, char *block, struct stat *sptr);
 int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
 		int fatal);
-void platform_flush_device(int fd, dev_t device);
+int platform_flush_device(int fd, dev_t device);
 char *platform_findrawpath(char *path);
 char *platform_findblockpath(char *path);
 int platform_direct_blockdev(void);

