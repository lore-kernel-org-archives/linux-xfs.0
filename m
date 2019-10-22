Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1FBCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F1DF20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kmAh5iGp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbfJVSsW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:48:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48570 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbfJVSsW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:48:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiBux089154;
        Tue, 22 Oct 2019 18:48:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=u9yZelFhmdywhRDlY8rt4prtk4UKoipm0zee2Yj1TnY=;
 b=kmAh5iGpjUJ8cf9LiKHqUy4Iymvll0Eo55UikMu5Wx7rhrFQ48Rw8ytpv6+C+gRYm5nz
 WqxvEMfs/WUUc8AcygiROKeF+pYgB4CcSA5V+AnyIYkPTE+Qi/gWuf9Fz2/aRZx4uBqe
 RvwQKtBoWMAR5hixY/U+eq3s4H8/B/LC+OrpRE0ZxrCuprRtfIHWo4lNQlzsocvZxK8i
 KOfQknY3dUJslvrQBCdPctTGav0nABP9iJmyH5ORgRsw3r+pmcAPIiBy2Wmm2I2ObN17
 cWvRad53B9gP6eBQRoSlPCRNDG/Co1tx2NSLvYtae563ZygXm7jhsptpqvLrfDA9IBZ6 Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vqu4qrk4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiOx1070581;
        Tue, 22 Oct 2019 18:48:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vsx2rkgap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:19 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MImIh5003079;
        Tue, 22 Oct 2019 18:48:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:48:18 -0700
Subject: [PATCH 2/4] libxfs: remove libxfs_nproc
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:48:17 -0700
Message-ID: <157177009727.1460186.2780524441344390421.stgit@magnolia>
In-Reply-To: <157177008495.1460186.12329293699422541895.stgit@magnolia>
References: <157177008495.1460186.12329293699422541895.stgit@magnolia>
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

Remove libxfs_nproc since it's a wrapper around a libfrog function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h  |    1 -
 libxfs/init.c     |   11 -----------
 repair/phase4.c   |    6 +++---
 repair/prefetch.c |    2 +-
 repair/slab.c     |    2 +-
 5 files changed, 5 insertions(+), 17 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 227084ae..405572ee 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -161,7 +161,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #endif
 
 
-extern int		libxfs_nproc(void);
 extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
 
 #include "xfs_ialloc.h"
diff --git a/libxfs/init.c b/libxfs/init.c
index 4446a62a..9e762435 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -853,17 +853,6 @@ libxfs_report(FILE *fp)
 	fprintf(fp, "%s", c);
 }
 
-int
-libxfs_nproc(void)
-{
-	int	nr;
-
-	nr = platform_nproc();
-	if (nr < 1)
-		nr = 1;
-	return nr;
-}
-
 unsigned long
 libxfs_physmem(void)
 {
diff --git a/repair/phase4.c b/repair/phase4.c
index 66e69db7..e1ba778f 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -235,7 +235,7 @@ process_rmap_data(
 	if (!rmap_needs_work(mp))
 		return;
 
-	create_work_queue(&wq, mp, libxfs_nproc());
+	create_work_queue(&wq, mp, platform_nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, check_rmap_btrees, i, NULL);
 	destroy_work_queue(&wq);
@@ -243,12 +243,12 @@ process_rmap_data(
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return;
 
-	create_work_queue(&wq, mp, libxfs_nproc());
+	create_work_queue(&wq, mp, platform_nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, compute_ag_refcounts, i, NULL);
 	destroy_work_queue(&wq);
 
-	create_work_queue(&wq, mp, libxfs_nproc());
+	create_work_queue(&wq, mp, platform_nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		queue_work(&wq, process_inode_reflink_flags, i, NULL);
 		queue_work(&wq, check_refcount_btrees, i, NULL);
diff --git a/repair/prefetch.c b/repair/prefetch.c
index beb36cd6..8e3772ed 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -1015,7 +1015,7 @@ do_inode_prefetch(
 	 */
 	if (check_cache && !libxfs_bcache_overflowed()) {
 		queue.wq_ctx = mp;
-		create_work_queue(&queue, mp, libxfs_nproc());
+		create_work_queue(&queue, mp, platform_nproc());
 		for (i = 0; i < mp->m_sb.sb_agcount; i++)
 			queue_work(&queue, func, i, NULL);
 		destroy_work_queue(&queue);
diff --git a/repair/slab.c b/repair/slab.c
index ba5c2327..f075ee5b 100644
--- a/repair/slab.c
+++ b/repair/slab.c
@@ -234,7 +234,7 @@ qsort_slab(
 		return;
 	}
 
-	create_work_queue(&wq, NULL, libxfs_nproc());
+	create_work_queue(&wq, NULL, platform_nproc());
 	hdr = slab->s_first;
 	while (hdr) {
 		qs = malloc(sizeof(struct qsort_slab));

