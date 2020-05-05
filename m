Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CA8C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03477206D7
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VpXvM8Vb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgEEBNx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:13:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgEEBNv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:13:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0451388P054672
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ljwrJm4LuzUxoEbcmIG8aipGWYU3NlAjJ/kde7xNyh0=;
 b=VpXvM8Vbfl6l6Eu4e+0XcPqorDIterkyjcOhIrH+nVP4z+RSklssZ1xp7ksILEFLoQya
 PtM2sCt7xoZzJmkpvWALUEhjX24nXicGvMnEXGORwQDtHkr/8QgZR4Lp5SyK8/Je3dos
 xyhKvsL5dnSYk1FqxTux9JDUnoMvmKgt+27nnR08lei1Rcdg6VtLTk302lGPS+lJYjk+
 HwaOKQxPHL6N9RNNJ8K9c6HB/UgIxzHRPFErAqvA48IE4ZmxE2fd/uNkIbcx9cj2rSlP
 vd8vN4eYV+DGSj8+t+LXMdpLD77z/1AcXj067jBYOQzH6LdWj4CMyD9ZVsveadxdIWNU Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30s0tma1c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515jiJ057250
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r3qs5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:48 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451DmYP017117
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:13:47 -0700
Subject: [PATCH 2/3] xfs: reduce log recovery transaction block reservations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:13:45 -0700
Message-ID: <158864122523.184729.12836505089842408007.stgit@magnolia>
In-Reply-To: <158864121286.184729.5959003885146573075.stgit@magnolia>
References: <158864121286.184729.5959003885146573075.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=3
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=3
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
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
 fs/xfs/libxfs/xfs_defer.c |    6 +---
 fs/xfs/libxfs/xfs_defer.h |    2 +
 fs/xfs/xfs_log_recover.c  |   70 +++++++++++++++++++++++++++++++++------------
 3 files changed, 54 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index bbbd0141d4a6..ea4d28851bbd 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -577,8 +577,8 @@ xfs_defer_freeze(
 	return 0;
 }
 
-/* Thaw a chain of deferred ops that are attached to a transaction. */
-int
+/* Thaw a chain of frozen deferred ops by attaching them to the transaction. */
+void
 xfs_defer_thaw(
 	struct xfs_defer_freezer	*dff,
 	struct xfs_trans		*tp)
@@ -588,8 +588,6 @@ xfs_defer_thaw(
 	/* Add the dfops items to the transaction. */
 	list_splice_init(&dff->dff_dfops, &tp->t_dfops);
 	tp->t_flags |= dff->dff_tpflags;
-
-	return 0;
 }
 
 /* Release a deferred op freezer and all resources associated with it. */
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 4789bf53dd96..7ae05e10d750 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -80,7 +80,7 @@ struct xfs_defer_freezer {
 
 /* Functions to freeze a chain of deferred operations for later. */
 int xfs_defer_freeze(struct xfs_trans *tp, struct xfs_defer_freezer **dffp);
-int xfs_defer_thaw(struct xfs_defer_freezer *dff, struct xfs_trans *tp);
+void xfs_defer_thaw(struct xfs_defer_freezer *dff, struct xfs_trans *tp);
 void xfs_defer_freeezer_finish(struct xfs_mount *mp,
 		struct xfs_defer_freezer *dff);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 908bfb284a9a..50b9d70e502f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2512,6 +2512,44 @@ xlog_recover_process_data(
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
@@ -2520,27 +2558,25 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_freezer *dff, *next;
 	struct xfs_trans	*tp;
-	int64_t			freeblks;
-	uint			resblks;
+	unsigned int		max_resblks;
 	int			error = 0;
 
+	error = xlog_estimate_recovery_resblks(mp, &max_resblks);
+	if (error)
+		goto out;
+
 	list_for_each_entry_safe(dff, next, dfops_freezers, dff_list) {
+		unsigned int	resblks;
+
+		resblks = min_t(int64_t, percpu_counter_sum(&mp->m_fdblocks),
+				max_resblks);
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
@@ -2548,12 +2584,7 @@ xlog_finish_defer_ops(
 
 		/* transfer all collected dfops to this transaction */
 		list_del_init(&dff->dff_list);
-		error = xfs_defer_thaw(dff, tp);
-		if (error) {
-			xfs_trans_cancel(tp);
-			xfs_defer_freeezer_finish(mp, dff);
-			break;
-		}
+		xfs_defer_thaw(dff, tp);
 
 		error = xfs_trans_commit(tp);
 		xfs_defer_freeezer_finish(mp, dff);
@@ -2561,6 +2592,7 @@ xlog_finish_defer_ops(
 			break;
 	}
 
+out:
 	/* Kill any remaining freezers. */
 	list_for_each_entry_safe(dff, next, dfops_freezers, dff_list) {
 		list_del_init(&dff->dff_list);

