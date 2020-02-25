Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E20C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9860520732
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:10:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SqmMfy21"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgBYAKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:10:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54396 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAKy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:10:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P09PLl033778;
        Tue, 25 Feb 2020 00:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8xL7qF9tvmSvXDoC4uO3vBJxq0NjddwfYnr2X/6QYc0=;
 b=SqmMfy21R7frmbJXuVA7ZWEhZBD+1K41ZsxidJp6dMhpQUkZjJ/gWxnUBGfSA1KO1KqO
 5wNURN+nSyX4gzwedJ30bDQOda6fpXg/5MG5bdkJ1ByxJuU0DT+ifWTPFdmOPC5Nu5tK
 lbzLXWkm9F3rcTrA3Jc7x4KFuFwRYxJXyO7L9G2AMN660lRqRwYEBXWrKsfMiVQng9MH
 JOFywi7+jaCREzSrCOycnIS/8yNlJHP8xH8FX8NWWP8Ee0XT8urwY+EkFnpT15a8W2Ld
 3rMPNs7Qy63k1t8NVSO80zvQDVewg2p4IzX2qFifOTSpj5+HiRg/cmwgzTh3NYssA6Wh qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ycppr8gfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:10:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P089fj014562;
        Tue, 25 Feb 2020 00:10:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ybdshxv9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:10:49 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0AmRc030282;
        Tue, 25 Feb 2020 00:10:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:10:48 -0800
Subject: [PATCH 3/7] libxfs: return flush failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:10:47 -0800
Message-ID: <158258944722.451075.6707059486566989861.stgit@magnolia>
In-Reply-To: <158258942838.451075.5401001111357771398.stgit@magnolia>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
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

