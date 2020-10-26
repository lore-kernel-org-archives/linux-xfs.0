Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3E6C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C916207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ALQDQpJ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407105AbgJZXfu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:35:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37436 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407099AbgJZXfu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:35:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxqL158474;
        Mon, 26 Oct 2020 23:35:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tj6HR0Rxv+LVKDeVRzWqtypgOAubfMlVVk9Qyui2Fzw=;
 b=ALQDQpJ081hFUEq4hkON4Lo9VIKn0d2qk1/nOlNNqC8exvRqOMqPb3HyPmOAQaQWVMwW
 OMb59Qow8UvK1cpKqCY2XnIPtlPG7sjOeMufNU0vAGdYBccnmnG6vIoAOU115Y59Y/40
 ldCeefH094tMKSsf16p8zXLLzBZFa1FnEc5Kf+xfAZHXPL1iFrLC7QS2Te8Jj+lpktqg
 i7Vg6hUPQ3v2nmkOmpReQnZTJswqDyRXGMlp7eFUf6ZL+NpkF5o5Wa3H7Hk5nTRnqs7Z
 9F5vY7qnuHIdjE/C+7I4aVWMEKD+1utFpIy0WE6XHqFhVQJmMe6xvRAlHzBPmybwDeYM Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxuZ110524;
        Mon, 26 Oct 2020 23:33:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34cx5wfrkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:33:46 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNXjtL028649;
        Mon, 26 Oct 2020 23:33:45 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:33:45 -0700
Subject: [PATCH 6/9] xfs_repair: check inode btree block counters in AGI
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:33:44 -0700
Message-ID: <160375522427.880355.15446960142376313542.stgit@magnolia>
In-Reply-To: <160375518573.880355.12052697509237086329.stgit@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=2
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that both inode btree block counters in the AGI are correct.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |   38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 2a38ae5197c6..c826af7dee86 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1948,6 +1948,12 @@ _("invalid inode count, inode chunk %d/%u, count %d ninodes %d\n"),
 	return suspect;
 }
 
+struct ino_priv {
+	struct aghdr_cnts	*agcnts;
+	uint32_t		ino_blocks;
+	uint32_t		fino_blocks;
+};
+
 /*
  * this one walks the inode btrees sucking the info there into
  * the incore avl tree.  We try and rescue corrupted btree records
@@ -1976,7 +1982,8 @@ scan_inobt(
 	void			*priv,
 	const struct xfs_buf_ops *ops)
 {
-	struct aghdr_cnts	*agcnts = priv;
+	struct ino_priv		*ipriv = priv;
+	struct aghdr_cnts	*agcnts = ipriv->agcnts;
 	char			*name;
 	xfs_agino_t		lastino = 0;
 	int			i;
@@ -2022,6 +2029,17 @@ scan_inobt(
 			return;
 	}
 
+	switch (magic) {
+	case XFS_FIBT_MAGIC:
+	case XFS_FIBT_CRC_MAGIC:
+		ipriv->fino_blocks++;
+		break;
+	case XFS_IBT_MAGIC:
+	case XFS_IBT_CRC_MAGIC:
+		ipriv->ino_blocks++;
+		break;
+	}
+
 	/*
 	 * check for btree blocks multiply claimed, any unknown/free state
 	 * is ok in the bitmap block.
@@ -2363,6 +2381,9 @@ validate_agi(
 	xfs_agnumber_t		agno,
 	struct aghdr_cnts	*agcnts)
 {
+	struct ino_priv		priv = {
+		.agcnts = agcnts,
+	};
 	xfs_agblock_t		bno;
 	int			i;
 	uint32_t		magic;
@@ -2372,7 +2393,7 @@ validate_agi(
 		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_IBT_CRC_MAGIC
 							 : XFS_IBT_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agi->agi_level),
-			    agno, 0, scan_inobt, 1, magic, agcnts,
+			    agno, 0, scan_inobt, 1, magic, &priv,
 			    &xfs_inobt_buf_ops);
 	} else {
 		do_warn(_("bad agbno %u for inobt root, agno %d\n"),
@@ -2385,7 +2406,7 @@ validate_agi(
 			magic = xfs_sb_version_hascrc(&mp->m_sb) ?
 					XFS_FIBT_CRC_MAGIC : XFS_FIBT_MAGIC;
 			scan_sbtree(bno, be32_to_cpu(agi->agi_free_level),
-				    agno, 0, scan_inobt, 1, magic, agcnts,
+				    agno, 0, scan_inobt, 1, magic, &priv,
 				    &xfs_finobt_buf_ops);
 		} else {
 			do_warn(_("bad agbno %u for finobt root, agno %d\n"),
@@ -2393,6 +2414,17 @@ validate_agi(
 		}
 	}
 
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		if (be32_to_cpu(agi->agi_iblocks) != priv.ino_blocks)
+			do_warn(_("bad inobt block count %u, saw %u\n"),
+					priv.ino_blocks,
+					be32_to_cpu(agi->agi_iblocks));
+		if (be32_to_cpu(agi->agi_fblocks) != priv.fino_blocks)
+			do_warn(_("bad finobt block count %u, saw %u\n"),
+					priv.fino_blocks,
+					be32_to_cpu(agi->agi_fblocks));
+	}
+
 	if (be32_to_cpu(agi->agi_count) != agcnts->agicount) {
 		do_warn(_("agi_count %u, counted %u in ag %u\n"),
 			 be32_to_cpu(agi->agi_count), agcnts->agicount, agno);

