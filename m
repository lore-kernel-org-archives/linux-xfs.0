Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9CFC433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E99723A63
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbhAIGat (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 01:30:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41228 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbhAIGat (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 01:30:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1096940F110580;
        Sat, 9 Jan 2021 06:30:07 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35y4ekg8ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 09 Jan 2021 06:30:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1096AVkm047918;
        Sat, 9 Jan 2021 06:28:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35y3tgvvmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jan 2021 06:28:06 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1096S5eQ025063;
        Sat, 9 Jan 2021 06:28:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 22:28:05 -0800
Subject: [PATCH 1/3] xfs_scrub: detect infinite loops when scanning inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 08 Jan 2021 22:28:04 -0800
Message-ID: <161017368431.1141483.1015560955108076159.stgit@magnolia>
In-Reply-To: <161017367756.1141483.3709627869982359451.stgit@magnolia>
References: <161017367756.1141483.3709627869982359451.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1034
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101090040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

During an inode scan (aka phase 3) when we're scanning the inode btree
to find files to check, make sure that each invocation of inumbers
actually gives us an inobt record with a startino that's at least as
large as what we asked for so that we always make forward progress.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/inodes.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index bdc12df3..4550db83 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -119,6 +119,7 @@ scan_ag_inodes(
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct xfs_bulkstat	*bs;
 	struct xfs_inumbers	*inumbers;
+	uint64_t		nextino = cvt_agino_to_ino(&ctx->mnt, agno, 0);
 	int			i;
 	int			error;
 	int			stale_count = 0;
@@ -153,6 +154,21 @@ scan_ag_inodes(
 	/* Find the inode chunk & alloc mask */
 	error = -xfrog_inumbers(&ctx->mnt, ireq);
 	while (!error && !si->aborted && ireq->hdr.ocount > 0) {
+		/*
+		 * Make sure that we always make forward progress while we
+		 * scan the inode btree.
+		 */
+		if (nextino > inumbers->xi_startino) {
+			str_corrupt(ctx, descr,
+	_("AG %u inode btree is corrupt near agino %lu, got %lu"), agno,
+				cvt_ino_to_agino(&ctx->mnt, nextino),
+				cvt_ino_to_agino(&ctx->mnt,
+						ireq->inumbers[0].xi_startino));
+			si->aborted = true;
+			break;
+		}
+		nextino = ireq->hdr.ino;
+
 		/*
 		 * We can have totally empty inode chunks on filesystems where
 		 * there are more than 64 inodes per block.  Skip these.

