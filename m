Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1E9CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A13F20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gBuCANyc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732580AbfJVSst (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:48:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45902 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbfJVSst (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:48:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiA3u109476;
        Tue, 22 Oct 2019 18:48:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=SfUxYsiQ/Tv8u7nKcTamwY5sBmhFYKIjTjZOl9AqeCI=;
 b=gBuCANycH/awjRRytMQ0vgnKUOiKnMjRAHi5Yg/eC0yDHeeG86I0rG0Bl4i++fmr23gJ
 7FlaVb40ow/XVLcMZoAWFRdvHddwP5h77OZ4ekCZBNLx/AoZeqQ8i6msZ3xlwW8uk9TR
 XFKAyM8qhvV09GeTPpPQzB/XZFhmxXv83rd8veyD6vzbvnMF+GD7sz0e5uI/JoSW8DOH
 u7pFb2VJvADvuh/o+3TqRSxC9onqigngijHXtZq452I+xUXynbjfBUhVD0JyX3zoQPWp
 XRlUOwkAk+GTnzVDKtYgG2XvoX3jywTQiPGBvs+UU2GlgxJGzmDlaM8Kx16h1rBWP6Ou VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vqswtguxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhmo8148188;
        Tue, 22 Oct 2019 18:48:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vsp400w78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:42 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MImgD7030050;
        Tue, 22 Oct 2019 18:48:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:48:41 -0700
Subject: [PATCH 1/2] xfs_scrub: clean out the nproc global variable
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Date:   Tue, 22 Oct 2019 11:48:40 -0700
Message-ID: <157177012076.1460310.2224258008333069219.stgit@magnolia>
In-Reply-To: <157177011420.1460310.11140985141007340173.stgit@magnolia>
References: <157177011420.1460310.11140985141007340173.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Get rid of this global variable since we already have a libfrog function
that does exactly what it does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 scrub/disk.c      |    2 ++
 scrub/xfs_scrub.c |    8 --------
 scrub/xfs_scrub.h |    1 -
 3 files changed, 2 insertions(+), 9 deletions(-)


diff --git a/scrub/disk.c b/scrub/disk.c
index 8a8a411b..a1ef798a 100644
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

