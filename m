Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B5EC4360D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88FBC205F4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bDSKLr/j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbfIYVjN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:39:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35026 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbfIYVjN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:39:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYc3r055018;
        Wed, 25 Sep 2019 21:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=mOWDBBO8dbjjr3lTgyLoSH687EEtqFjbkAfXclBNkVk=;
 b=bDSKLr/jGpxSB8HHaeHohhI9Rsj03xDrV5VSf3siAW62aK7PBXCbRBGyHi5Z0Fj8Cg0B
 a+9UHRa6YZDYSMhmaX7gI2ihCyxB+eo0zpsaDwFXroEbFJziY9h9fnGoD/pQFQLCLM9z
 2utejqpzwK6Og2k7C9Pr8XKRyoIeA094blO+MV86nrXQVtDD83idUYXJ1iYHwEvZtl5n
 VslJqdSWZG2SwZ1Dar7c1I3eZas7DMH/xhBDl2ILsuVE51739uo/Sik7QoXTr0qEtULN
 6NvHzRNjnTycbOpsiGg06Dx13d6X6o400+Inm0bfAz4rTyZlKLFS5uMvXiNyzhKSB4Q0 Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgr7fb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYQno097674;
        Wed, 25 Sep 2019 21:37:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v82qakwjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:37:10 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLb9L0015975;
        Wed, 25 Sep 2019 21:37:09 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:37:09 -0700
Subject: [PATCH 10/11] xfs_scrub: clean out the nproc global variable
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:37:08 -0700
Message-ID: <156944742829.300131.10853963179326362863.stgit@magnolia>
In-Reply-To: <156944736739.300131.5717633994765951730.stgit@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
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

Get rid of this global variable since we already have a libfrog function
that does exactly what it does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/disk.c      |    2 ++
 scrub/xfs_scrub.c |    8 --------
 scrub/xfs_scrub.h |    1 -
 3 files changed, 2 insertions(+), 9 deletions(-)


diff --git a/scrub/disk.c b/scrub/disk.c
index 214a5346..31dc4192 100644
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
index b6a01274..147c114c 100644
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
index f9a72052..37d78f61 100644
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

