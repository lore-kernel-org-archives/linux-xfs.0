Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA21C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61FE92186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qT7I5FON"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbfHZVcK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:32:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbfHZVcJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:32:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLFIuI162223;
        Mon, 26 Aug 2019 21:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=R87H1I18+LoaG7SaSOMBuU9moRCa4bs0hv8j2iblvW4=;
 b=qT7I5FONDl+rtun6pffCYMQHn661vuK366zFlkW0mtFFb46MiSe4T/IhgcO1IWXwbYKC
 dYZEmH1uFkFfEfSpj27uCbrguUgc5xJConCzJgrs5UdQIkiNA6qnk3QayoiUUBqpi87e
 cfP7b2iV8kQL3OsSzUmCs82cEtjpj6izdl68n5n/X+kKEyL4qoDK7w/xVIvSfhYPTt2b
 3dmKg/VBe1FF8zBBP2m65Ed3YXntvr1Rh8MUKcXY3qIAwEXDdmXiMtgPeplpIjMuAkjr
 pEF9PTreBEBYm4ocVR+WTe+cd3nFK/q8L1x+Rjdo9N2iP1XW5wutjnAvK1HXOw24l9ws 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2umq5t82fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIQto024938;
        Mon, 26 Aug 2019 21:32:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2umj1tka9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLW6Ds009209;
        Mon, 26 Aug 2019 21:32:06 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:32:05 -0700
Subject: [PATCH 09/11] libfrog: clean up platform_nproc
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:32:04 -0700
Message-ID: <156685512486.2843133.4982411923908096479.stgit@magnolia>
In-Reply-To: <156685506615.2843133.16536353613627426823.stgit@magnolia>
References: <156685506615.2843133.16536353613627426823.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
index 3bf7feab..d4a8b209 100644
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

