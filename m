Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF50EC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3AE12186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jh9m3R38"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbfHZVcQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:32:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53972 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbfHZVcP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:32:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLQogt003337;
        Mon, 26 Aug 2019 21:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=555upV/s/eH9nUfAjhk6HSrMBsulQH3wPfhiVz761Q4=;
 b=Jh9m3R38IXvFhNs82vWKwTE7BK6Ypyuu0wNdhCcsoS7p8mMF1Tzd3K1BNK8FkUhJS2H3
 9bStgf/l/d5Fn62D7W2MjHTe3NAJiscdKy2a2Stjwis6pZdvUSJWQqE1mQK3vR/tZ2os
 eHVQYqg0/sZIA/2EEJOxQ+Rh9K8L5M5FZgTpIFOk2FfqKGWxm3uye+H3vmLWbRZQsYyO
 tz89nl91PxPHGwnAMpaUCG5JlCpBjyk8fF+V9Q33QmBY+/TmjwhHnKxslJMQSlPGFE2T
 lpzeBCU33P+cbEABLsORi/igbSbaTTJzfTsiNLzTUTL8PsBW1EaKMQmxI9FOWr/6jqCm Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2umqbe80sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIcjr169563;
        Mon, 26 Aug 2019 21:32:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2umhu7x21k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:12 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLWCoh009276;
        Mon, 26 Aug 2019 21:32:12 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:32:12 -0700
Subject: [PATCH 10/11] xfs_scrub: clean out the nproc global variable
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:32:11 -0700
Message-ID: <156685513113.2843133.11215244971656871347.stgit@magnolia>
In-Reply-To: <156685506615.2843133.16536353613627426823.stgit@magnolia>
References: <156685506615.2843133.16536353613627426823.stgit@magnolia>
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

Get rid of this global variable since we already have a libfrog function
that does exactly what it does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/disk.c      |    2 ++
 scrub/xfs_scrub.c |    8 --------
 scrub/xfs_scrub.h |    1 -
 3 files changed, 2 insertions(+), 9 deletions(-)


diff --git a/scrub/disk.c b/scrub/disk.c
index 2178c528..9b458fb7 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -22,6 +22,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "disk.h"
+#include "platform_defs.h"
 
 #ifndef BLKROTATIONAL
 # define BLKROTATIONAL	_IO(0x12, 126)
@@ -42,6 +43,7 @@ __disk_heads(
 {
 	int			iomin;
 	int			ioopt;
+	int			nproc = platform_nproc();
 	unsigned short		rot;
 	int			error;
 
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index d068634b..99bf54f5 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -131,9 +131,6 @@ static bool			display_rusage;
 /* Background mode; higher values insert more pauses between scrub calls. */
 unsigned int			bg_mode;
 
-/* Maximum number of processors available to us. */
-int				nproc;
-
 /* Number of threads we're allowed to use. */
 unsigned int			force_nr_threads;
 
@@ -717,11 +714,6 @@ main(
 	}
 	memcpy(&ctx.fsinfo, fsp, sizeof(struct fs_path));
 
-	/* How many CPUs? */
-	nproc = sysconf(_SC_NPROCESSORS_ONLN);
-	if (nproc < 1)
-		nproc = 1;
-
 	/* Set up a page-aligned buffer for read verification. */
 	page_size = sysconf(_SC_PAGESIZE);
 	if (page_size < 0) {
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index fb34c587..bce56b1d 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -15,7 +15,6 @@ extern char *progname;
 extern unsigned int		force_nr_threads;
 extern unsigned int		bg_mode;
 extern unsigned int		debug;
-extern int			nproc;
 extern bool			verbose;
 extern long			page_size;
 extern bool			want_fstrim;

