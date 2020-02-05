Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A59D4C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A3B5214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IWcWVb8L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgBEArs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:47:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45966 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727619AbgBEArs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:47:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dmnM124213;
        Wed, 5 Feb 2020 00:47:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Gmd8xXCZOassAtBEFWzM8ytUr8L3Zv+uPKjIVBEw3Uo=;
 b=IWcWVb8Lg9r6sLqpevj/i4I6OVbG+DCTXgk3o0k01yUzNo1GiGwfPBgdoCuCzhfYq/5+
 H9qNgrSDINRUqFZrcOc6vQRbdzT4maYhNpUA1xdtSyCc8ILqLpwUsuSWSHpzWI2IS3ik
 zbyCYCsq3ElE6+mYcr5G25ApFTkRB7Fy0PPsBtKZ4ZjFWrXX2ZJcb8K5+4YerVhJ1+YE
 WqVGTWaw02YiHjmQXda0Kqq0ITC+OhG4pBZdwcEHTW8HueNxzWH509tfJTak9O1O4wh7
 iV53rpEdLLT0tZC1JpPe70KJ9uhDqV6R8Oj3Eah/ndqupdtLrTI5VLOIV/dcYbrBvRHP sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xykbp00m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dZ3h125072;
        Wed, 5 Feb 2020 00:47:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xykc1gg2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:45 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0150liSa024049;
        Wed, 5 Feb 2020 00:47:44 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:47:44 -0800
Subject: [PATCH 3/4] libxfs: return flush failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:47:43 -0800
Message-ID: <158086366333.2079905.16346740147118345650.stgit@magnolia>
In-Reply-To: <158086364511.2079905.3531505051831183875.stgit@magnolia>
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Modify platform_flush_device so that we can return error status when
device flushes fail.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

