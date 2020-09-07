Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4648BC43461
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE022137B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iQePF0bA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgIGRxm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:53:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729284AbgIGRxc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 13:53:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087Hmm77100032;
        Mon, 7 Sep 2020 17:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HzklU7pYdqb300LB1XsfU+sQG/3H0IncHvESLSaIGJo=;
 b=iQePF0bAYFSEUc40OXJqCJqNJkfjCiQuwOLz0M7TquwLu944k76DjGXhXKqVVTmvIX4C
 FYa1x7uMLLTaVvjYZR45/ZeoA6nNP1uTEZR+1nHu3cQN+C3JQkjYDSzVn+RmtD2q5YuY
 V7GxWuUtIXg2kTDG+LBVcYgfEYFslYPXnzzHIy/sqr0FlDg8TKS1b2snG/jDbBfadgQC
 FLm8NWHupbWzYfnxen3F/14iGogut62I0Y0ZlFMB1M24HxV9RI8MC8/YHEjSI13xCGxe
 z2J8/ck9iM1C4WpEAeM9NBrSqIONiM59V0SLr22//h3NjSOUl1TMvJ2AI88DCI1fChmB TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33c2mkqjaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 17:53:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HovMk017110;
        Mon, 7 Sep 2020 17:53:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmk15nt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 17:53:30 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 087HrUMb003281;
        Mon, 7 Sep 2020 17:53:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 10:52:42 -0700
Subject: [PATCH 7/7] xfs_repair: use libxfs_verify_rtbno to verify rt extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 10:52:41 -0700
Message-ID: <159950116137.567790.6513237616093378971.stgit@magnolia>
In-Reply-To: <159950111751.567790.16914248540507629904.stgit@magnolia>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the existing realtime block validation function to check the first
and last block of an extent in a realtime file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 7577b50ffb2b..24ad6f0f071e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -176,16 +176,15 @@ verify_dfsbno_range(
 
 	return XR_DFSBNORANGE_VALID;
 }
-
 static int
 process_rt_rec(
-	xfs_mount_t		*mp,
-	xfs_bmbt_irec_t 	*irec,
+	struct xfs_mount	*mp,
+	struct xfs_bmbt_irec	*irec,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
 	int			check_dups)
 {
-	xfs_fsblock_t		b;
+	xfs_fsblock_t		b, lastb;
 	xfs_rtblock_t		ext;
 	int			state;
 	int			pwe;		/* partially-written extent */
@@ -193,7 +192,7 @@ process_rt_rec(
 	/*
 	 * check numeric validity of the extent
 	 */
-	if (irec->br_startblock >= mp->m_sb.sb_rblocks) {
+	if (!libxfs_verify_rtbno(mp, irec->br_startblock)) {
 		do_warn(
 _("inode %" PRIu64 " - bad rt extent start block number %" PRIu64 ", offset %" PRIu64 "\n"),
 			ino,
@@ -201,21 +200,23 @@ _("inode %" PRIu64 " - bad rt extent start block number %" PRIu64 ", offset %" P
 			irec->br_startoff);
 		return 1;
 	}
-	if (irec->br_startblock + irec->br_blockcount - 1 >= mp->m_sb.sb_rblocks) {
+
+	lastb = irec->br_startblock + irec->br_blockcount - 1;
+	if (!libxfs_verify_rtbno(mp, lastb)) {
 		do_warn(
 _("inode %" PRIu64 " - bad rt extent last block number %" PRIu64 ", offset %" PRIu64 "\n"),
 			ino,
-			irec->br_startblock + irec->br_blockcount - 1,
+			lastb,
 			irec->br_startoff);
 		return 1;
 	}
-	if (irec->br_startblock + irec->br_blockcount - 1 < irec->br_startblock) {
+	if (lastb < irec->br_startblock) {
 		do_warn(
 _("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
   "end %" PRIu64 ", offset %" PRIu64 "\n"),
 			ino,
 			irec->br_startblock,
-			irec->br_startblock + irec->br_blockcount - 1,
+			lastb,
 			irec->br_startoff);
 		return 1;
 	}

