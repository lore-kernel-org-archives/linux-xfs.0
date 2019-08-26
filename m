Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3C0C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91CCC2186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dZ8PuXuS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbfHZV2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:28:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47624 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbfHZV2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:28:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLFIu0162223;
        Mon, 26 Aug 2019 21:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yZUVfoBSfpGRbLZug5wtfLE/WtdyQfQKvcoGxtk7qkg=;
 b=dZ8PuXuSPjAB2+sQpdLE23k+OBdHLerrfgVdnFZuTUd89T9jNb0lvlBmTNk0XggPay90
 IKby/kRG+fUOnTlEVcXUNbMYdsoSq0N++zcArn5lbwFE53CiJv2q0siGJnba78dPlDHC
 PEhyNEC0+CJBqPc9RMRIbefKGr9Kgz9hXg+dS+2IwsOwSPpdYy4pu7H4NrNQ57jZTAKo
 jSWI8ErMSNWxk24WL/ScvyQJgxdX9KIhnEPhM5kdF2/IMY4hbrpKN3bYw70koQhuaOpG
 MBnBdZc+DW5aqRHDa+mjgy1HCjUFMdBa2fexRzzESG26jce52rMCHE8zY7JLzde+iAh4 Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2umq5t81x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIt3p185073;
        Mon, 26 Aug 2019 21:28:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2umj2xvw3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:11 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLSAu7027938;
        Mon, 26 Aug 2019 21:28:10 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:28:10 -0700
Subject: [PATCH 3/4] xfs_scrub: convert to per-ag inode bulkstat operations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:28:09 -0700
Message-ID: <156685488926.2841421.6064707653494434162.stgit@magnolia>
In-Reply-To: <156685486843.2841421.7117771040713668517.stgit@magnolia>
References: <156685486843.2841421.7117771040713668517.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we're done reworking the xfrog bulkstat wrapper functions, we
can adapt xfs_scrub to use the per-ag iteration functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/fscounters.c |   22 ++++++----------------
 scrub/inodes.c     |   20 ++++++--------------
 2 files changed, 12 insertions(+), 30 deletions(-)


diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index d95418ba..91487ebc 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -35,29 +35,25 @@ struct xfs_count_inodes {
  * exist in the filesystem, assuming we've already scrubbed that.
  */
 static bool
-xfs_count_inodes_range(
+xfs_count_inodes_ag(
 	struct scrub_ctx	*ctx,
 	const char		*descr,
-	uint64_t		first_ino,
-	uint64_t		last_ino,
+	uint32_t		agno,
 	uint64_t		*count)
 {
 	struct xfs_inumbers_req	*ireq;
 	uint64_t		nr = 0;
 	int			error;
 
-	ASSERT(!(first_ino & (XFS_INODES_PER_CHUNK - 1)));
-	ASSERT((last_ino & (XFS_INODES_PER_CHUNK - 1)));
-
-	ireq = xfrog_inumbers_alloc_req(1, first_ino);
+	ireq = xfrog_inumbers_alloc_req(1, 0);
 	if (!ireq) {
 		str_info(ctx, descr, _("Insufficient memory; giving up."));
 		return false;
 	}
+	xfrog_inumbers_set_ag(ireq, agno);
 
 	while (!(error = xfrog_inumbers(&ctx->mnt, ireq))) {
-		if (ireq->hdr.ocount == 0 ||
-		    ireq->inumbers[0].xi_startino >= last_ino)
+		if (ireq->hdr.ocount == 0)
 			break;
 		nr += ireq->inumbers[0].xi_alloccount;
 	}
@@ -83,8 +79,6 @@ xfs_count_ag_inodes(
 	struct xfs_count_inodes	*ci = arg;
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	char			descr[DESCR_BUFSZ];
-	uint64_t		ag_ino;
-	uint64_t		next_ag_ino;
 	bool			moveon;
 
 	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
@@ -92,11 +86,7 @@ xfs_count_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno, 0);
-	next_ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno + 1, 0);
-
-	moveon = xfs_count_inodes_range(ctx, descr, ag_ino, next_ag_ino - 1,
-			&ci->counters[agno]);
+	moveon = xfs_count_inodes_ag(ctx, descr, agno, &ci->counters[agno]);
 	if (!moveon)
 		ci->moveon = false;
 }
diff --git a/scrub/inodes.c b/scrub/inodes.c
index bcdc60b9..ae59d7ef 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -81,12 +81,11 @@ xfs_iterate_inodes_range_check(
  * but we also can detect iget failures.
  */
 static bool
-xfs_iterate_inodes_range(
+xfs_iterate_inodes_ag(
 	struct scrub_ctx	*ctx,
 	const char		*descr,
 	void			*fshandle,
-	uint64_t		first_ino,
-	uint64_t		last_ino,
+	uint32_t		agno,
 	xfs_inode_iter_fn	fn,
 	void			*arg)
 {
@@ -113,13 +112,14 @@ xfs_iterate_inodes_range(
 		return false;
 	}
 
-	ireq = xfrog_inumbers_alloc_req(1, first_ino);
+	ireq = xfrog_inumbers_alloc_req(1, 0);
 	if (!ireq) {
 		str_info(ctx, descr, _("Insufficient memory; giving up."));
 		free(breq);
 		return false;
 	}
 	inogrp = &ireq->inumbers[0];
+	xfrog_inumbers_set_ag(ireq, agno);
 
 	/* Find the inode chunk & alloc mask */
 	error = xfrog_inumbers(&ctx->mnt, ireq);
@@ -144,9 +144,6 @@ xfs_iterate_inodes_range(
 		for (i = 0, bs = breq->bulkstat;
 		     i < inogrp->xi_alloccount;
 		     i++, bs++) {
-			if (bs->bs_ino > last_ino)
-				goto out;
-
 			handle.ha_fid.fid_ino = bs->bs_ino;
 			handle.ha_fid.fid_gen = bs->bs_gen;
 			error = fn(ctx, &handle, bs, arg);
@@ -211,8 +208,6 @@ xfs_scan_ag_inodes(
 	struct xfs_scan_inodes	*si = arg;
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	char			descr[DESCR_BUFSZ];
-	uint64_t		ag_ino;
-	uint64_t		next_ag_ino;
 	bool			moveon;
 
 	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
@@ -220,11 +215,8 @@ xfs_scan_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno, 0);
-	next_ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno + 1, 0);
-
-	moveon = xfs_iterate_inodes_range(ctx, descr, ctx->fshandle, ag_ino,
-			next_ag_ino - 1, si->fn, si->arg);
+	moveon = xfs_iterate_inodes_ag(ctx, descr, ctx->fshandle, agno,
+			si->fn, si->arg);
 	if (!moveon)
 		si->moveon = false;
 }

