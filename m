Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA837C2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81B42206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="u9JzhYF7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgDVCIY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:08:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39058 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgDVCIX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:08:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22r1f074469
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=uOj+CbXWCSdps4EiyrysApajr2U/yXlpWgxR1HZkPiM=;
 b=u9JzhYF7Zzb+z+KEzfrjDj2mcIC0kzalnVjWXZBB/ZrkRLaqeub/jvvw+PWgZKfbxx3k
 Kn+xDv5IvLVf/F0B9azwXd4HX39QDxPPilh48vTmceoSfWLa9sqhc/xiVIVsQ9Dic5MU
 OFPF+p1c+j8HnnnXv2fY2+5b+/E2YC4IKYdlPHLUTOD4bthSBRmBdIYQn8jZE/TrHIYp
 +h/xlvpnxFVSm9dqGAmtBcvboXBX9xj5CNzynyzzuX8aovqDtu8r3cU4hrxYKmi2KICY
 EDGlVCl686Z9Vd/gelH2LKciG2yt9h9Ng63Iuznqz86BG6qNTLwQSQ2cUm3IM71Gzasf jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30ft6n81n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M28MV7086736
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30gb1hbhg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:22 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M28Lo0014722
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:08:21 -0700
Subject: [PATCH 2/3] xfs: reduce log recovery transaction block reservations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:08:20 -0700
Message-ID: <158752130035.2142108.11825776210575708747.stgit@magnolia>
In-Reply-To: <158752128766.2142108.8793264653760565688.stgit@magnolia>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=3 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

On filesystems that support them, bmap intent log items can be used to
change mappings in inode data or attr forks.  However, if the bmbt must
expand, the enormous block reservations that we make for finishing
chains of deferred log items become a liability because the bmbt block
allocator sets minleft to the transaction reservation and there probably
aren't any AGs in the filesystem that have that much free space.

Whereas previously we would reserve 93% of the free blocks in the
filesystem, now we only want to reserve 7/8ths of the free space in the
least full AG, and no more than half of the usable blocks in an AG.  In
theory we shouldn't run out of space because (prior to the unclean
shutdown) all of the in-progress transactions successfully reserved the
worst case number of disk blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |   55 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e9b3e901d009..a416b028b320 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2669,6 +2669,44 @@ xlog_recover_process_data(
 	return 0;
 }
 
+/*
+ * Estimate a block reservation for a log recovery transaction.  Since we run
+ * separate transactions for each chain of deferred ops that get created as a
+ * result of recovering unfinished log intent items, we must be careful not to
+ * reserve so many blocks that block allocations fail because we can't satisfy
+ * the minleft requirements (e.g. for bmbt blocks).
+ */
+static int
+xlog_estimate_recovery_resblks(
+	struct xfs_mount	*mp,
+	unsigned int		*resblks)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	unsigned int		free = 0;
+	int			error;
+
+	/* Don't use more than 7/8th of the free space in the least full AG. */
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		unsigned int	ag_free;
+
+		error = xfs_alloc_pagf_init(mp, NULL, agno, 0);
+		if (error)
+			return error;
+		pag = xfs_perag_get(mp, agno);
+		ag_free = pag->pagf_freeblks + pag->pagf_flcount;
+		free = max(free, (ag_free * 7) / 8);
+		xfs_perag_put(pag);
+	}
+
+	/* Don't try to reserve more than half the usable AG blocks. */
+	*resblks = min(free, xfs_alloc_ag_max_usable(mp) / 2);
+	if (*resblks == 0)
+		return -ENOSPC;
+
+	return 0;
+}
+
 /* Take all the collected deferred ops and finish them in order. */
 static int
 xlog_finish_defer_ops(
@@ -2677,27 +2715,20 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_freezer *dff, *next;
 	struct xfs_trans	*tp;
-	int64_t			freeblks;
 	uint			resblks;
 	int			error = 0;
 
 	list_for_each_entry_safe(dff, next, dfops_freezers, dff_list) {
+		error = xlog_estimate_recovery_resblks(mp, &resblks);
+		if (error)
+			break;
+
 		/*
 		 * We're finishing the defer_ops that accumulated as a result
 		 * of recovering unfinished intent items during log recovery.
 		 * We reserve an itruncate transaction because it is the
-		 * largest permanent transaction type.  Since we're the only
-		 * user of the fs right now, take 93% (15/16) of the available
-		 * free blocks.  Use weird math to avoid a 64-bit division.
+		 * largest permanent transaction type.
 		 */
-		freeblks = percpu_counter_sum(&mp->m_fdblocks);
-		if (freeblks <= 0) {
-			error = -ENOSPC;
-			break;
-		}
-
-		resblks = min_t(int64_t, UINT_MAX, freeblks);
-		resblks = (resblks * 15) >> 4;
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
 				0, XFS_TRANS_RESERVE, &tp);
 		if (error)

