Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80251C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79FD52082C
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QuZYJqrH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfIFDkC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:40:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46398 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733012AbfIFDkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:40:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dEI1077818;
        Fri, 6 Sep 2019 03:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=mOWDBBO8dbjjr3lTgyLoSH687EEtqFjbkAfXclBNkVk=;
 b=QuZYJqrHqMmM7/N9Tx1MiSKGV+X+E87l2b+R9wuzNgLXx9iYAltJPwxP9pWK4G8MDNNz
 E5SzJQ8tsmizIQniEO3DtFHXBuhaEWqUJdkr1biBy0jlodmAglIBTui2TVs6L3/1m9or
 pVJhBe+YJlEj2RyypkMAIbbJMznDecQfRnz7nqe2/JBHx98++QTWJfywJcPhBsQlvpcm
 tlpFqmv9lPwQuvNuJyVEKP33+OvX/BCQ5UsCeZaGWUrv5kM22h942zDBBCU0TAR6Otrz
 Hh8pigxZ5YmT+BbBbRLXLt9HntB8ZBZU6wTg+P5ezVCXNS/SmoSpfOty6PGPu5XaB+S+ 5w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uuf51g3gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dI8A112843;
        Fri, 6 Sep 2019 03:39:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uud7p2t0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:59 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863dwxH016581;
        Fri, 6 Sep 2019 03:39:58 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:39:57 -0700
Subject: [PATCH 10/11] xfs_scrub: clean out the nproc global variable
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:39:57 -0700
Message-ID: <156774119750.2645432.3129933658637857973.stgit@magnolia>
In-Reply-To: <156774113533.2645432.14942831726168941966.stgit@magnolia>
References: <156774113533.2645432.14942831726168941966.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
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

