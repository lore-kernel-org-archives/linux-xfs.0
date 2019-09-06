Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2233DC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DBB1206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pqY5Rc38"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388503AbfIFDj4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:39:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfIFDj4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:39:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dsgj113447;
        Fri, 6 Sep 2019 03:39:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=wvagb+Gs3gehSKyUZuM4DWdCt2GXmK8sP0sJDlViVaU=;
 b=pqY5Rc38l5EzKJ1/x6GzsEoGQREDWwhbL7sCIi5hawKxOGIAXlCho3xqFypaV9lq7Ol+
 VoHId1FaWUl/sJWv/QupYWcDZilXXLAH/r61HUD/e0vSZsgRZyWT2+Zwzb1lXMVyDYIM
 WTk47AWtpCuwRUTJPgYunEVwtAyj1LBs0eUR4c/iGztQSUD+WydHoGRbdW97KY9Q/9tq
 wUp1/kRuVuid+5KoOFXAu/IIKfJATpGJ9yMl/r5x3HGKCcGfGaIHYRZroi5AHc4SVWSO
 B3TW8fAlLI33E5U4kqou4T1r80Gf8EefaNpA1BKV9MqyrkNY0Hq94mUOcQBlaGSR4C1N nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uufr0801a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cTgt096070;
        Fri, 6 Sep 2019 03:39:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uu1b99tm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863dquK020389;
        Fri, 6 Sep 2019 03:39:52 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:39:51 -0700
Subject: [PATCH 09/11] libfrog: clean up platform_nproc
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:39:51 -0700
Message-ID: <156774119138.2645432.6957640581961453315.stgit@magnolia>
In-Reply-To: <156774113533.2645432.14942831726168941966.stgit@magnolia>
References: <156774113533.2645432.14942831726168941966.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
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

