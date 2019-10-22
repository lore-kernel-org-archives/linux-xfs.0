Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6541CA9EB9
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 753D620B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dhEjon9m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732790AbfJVSsQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:48:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45204 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbfJVSsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:48:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiAOK109486;
        Tue, 22 Oct 2019 18:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=wvagb+Gs3gehSKyUZuM4DWdCt2GXmK8sP0sJDlViVaU=;
 b=dhEjon9maihPeeI07CE4J3pWhB5M5LNUEu7QKgliRW/uIoqKPHSjy3PBl9A6X6ntgvjE
 hnVn2JxrQ2ZRNqBd3SEHWchJSOxWqp+icSir/LdNn1NBMNIYIrT6hZlEUFZsZHOIQs3s
 Da+MfzFNlsz69Uwkqlwn9CxaPRHJFdnprvmBVglp8EqQFI1p9PLGkI6GE0vOcn64DD84
 fxe+QSn2S6h8r0ywwVKvxkRKKjxfbeDOOHHA4uh5ZkOaFy11WHlT3ErTJIII7ps2AYoX
 kKVIE4w7RlaOsaYksr5qvEXLScRHr8lT+xEbzPBialwMcq/4h/bMIxZYszMi1JBDIsYK Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vqswtguuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiOws070581;
        Tue, 22 Oct 2019 18:48:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vsx2rkg2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:13 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MImC6Z026031;
        Tue, 22 Oct 2019 18:48:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:48:12 -0700
Subject: [PATCH 1/4] libfrog: clean up platform_nproc
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:48:11 -0700
Message-ID: <157177009113.1460186.17260250829884616599.stgit@magnolia>
In-Reply-To: <157177008495.1460186.12329293699422541895.stgit@magnolia>
References: <157177008495.1460186.12329293699422541895.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The platform_nproc function should check for error returns and obviously
garbage values and deal with them appropriately.  Fix the header
declaration since it's part of the libfrog platform support code, not
libxfs.  xfs_scrub will make use of it in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h           |    1 -
 include/platform_defs.h.in |    2 ++
 libfrog/linux.c            |    9 ++++++++-
 3 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 63696df5..227084ae 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -135,7 +135,6 @@ extern void	libxfs_device_close (dev_t);
 extern int	libxfs_device_alignment (void);
 extern void	libxfs_report(FILE *);
 extern void	platform_findsizes(char *path, int fd, long long *sz, int *bsz);
-extern int	platform_nproc(void);
 
 /* check or write log footer: specify device, log size in blocks & uuid */
 typedef char	*(libxfs_get_block_t)(char *, int, void *);
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index d111ec6d..adb00181 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -77,4 +77,6 @@ typedef unsigned short umode_t;
 # define ASSERT(EX)	((void) 0)
 #endif
 
+extern int	platform_nproc(void);
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/libfrog/linux.c b/libfrog/linux.c
index b6c24879..79bd79eb 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -242,10 +242,17 @@ platform_align_blockdev(void)
 	return max_block_alignment;
 }
 
+/* How many CPUs are online? */
 int
 platform_nproc(void)
 {
-	return sysconf(_SC_NPROCESSORS_ONLN);
+	long nproc = sysconf(_SC_NPROCESSORS_ONLN);
+
+	if (nproc < 1)
+		return 1;
+	if (nproc >= INT_MAX)
+		return INT_MAX;
+	return nproc;
 }
 
 unsigned long

