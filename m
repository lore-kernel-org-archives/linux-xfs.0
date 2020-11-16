Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93FDC6379D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 17:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C98B222E8
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 17:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rbAO7uCc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbgKPRTi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 12:19:38 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57808 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730564AbgKPRTg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Nov 2020 12:19:36 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AGH9pbw085939;
        Mon, 16 Nov 2020 17:19:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=cPRKgSySESo2zxfnjsZbisf8mWb8HgIEQBGfeUYxtFQ=;
 b=rbAO7uCcIWLzWcLO+Gu8/TNyKzEQv6FPLpOuc7Y2MdFj1G8PG08qrG6WuO4e3xEW6oot
 j3zib8LQnDr4eQP4aAnFE1GU3u/bDY35Zj7qMVDwddpRlA+s2BPNgIuq+Kql+5IANK/G
 9IPfPkigLwVdPktaHkJeDzhVHV89RVNhfqMLnXKMKbNrTJB4JdpY/J3N27bvor3ivNCB
 3wyu1slw8vKnJin8wUbZsrUR5UPP+D9WHCvw3D9JMBMud/TNH8nLWHjnQn9UFaRB5ccp
 Kx2ONBeCpSH6tKQbWYDkH/HFRUfAsiHTeB0Ee5LAmBw9KjRfs3oxErh7ZEDWivRhfaz+ FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34t7vmx5ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Nov 2020 17:19:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AGH9XvV161540;
        Mon, 16 Nov 2020 17:19:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34usps99rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 17:19:26 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AGHJPbb018156;
        Mon, 16 Nov 2020 17:19:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 09:19:25 -0800
Date:   Mon, 16 Nov 2020 09:19:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 6/9] xfs_repair: check inode btree block counters in AGI
Message-ID: <20201116171924.GS9695@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375522427.880355.15446960142376313542.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375522427.880355.15446960142376313542.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=5 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011160101
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that both inode btree block counters in the AGI are correct.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix backwards complaint message, consolidate switch statements
---
 repair/scan.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index 2a38ae5197c6..44e794a0ac5a 100644
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
@@ -1994,10 +2001,12 @@ scan_inobt(
 	case XFS_FIBT_MAGIC:
 	case XFS_FIBT_CRC_MAGIC:
 		name = "fino";
+		ipriv->fino_blocks++;
 		break;
 	case XFS_IBT_MAGIC:
 	case XFS_IBT_CRC_MAGIC:
 		name = "ino";
+		ipriv->ino_blocks++;
 		break;
 	default:
 		name = "(unknown)";
@@ -2363,6 +2372,9 @@ validate_agi(
 	xfs_agnumber_t		agno,
 	struct aghdr_cnts	*agcnts)
 {
+	struct ino_priv		priv = {
+		.agcnts = agcnts,
+	};
 	xfs_agblock_t		bno;
 	int			i;
 	uint32_t		magic;
@@ -2372,7 +2384,7 @@ validate_agi(
 		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_IBT_CRC_MAGIC
 							 : XFS_IBT_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agi->agi_level),
-			    agno, 0, scan_inobt, 1, magic, agcnts,
+			    agno, 0, scan_inobt, 1, magic, &priv,
 			    &xfs_inobt_buf_ops);
 	} else {
 		do_warn(_("bad agbno %u for inobt root, agno %d\n"),
@@ -2385,7 +2397,7 @@ validate_agi(
 			magic = xfs_sb_version_hascrc(&mp->m_sb) ?
 					XFS_FIBT_CRC_MAGIC : XFS_FIBT_MAGIC;
 			scan_sbtree(bno, be32_to_cpu(agi->agi_free_level),
-				    agno, 0, scan_inobt, 1, magic, agcnts,
+				    agno, 0, scan_inobt, 1, magic, &priv,
 				    &xfs_finobt_buf_ops);
 		} else {
 			do_warn(_("bad agbno %u for finobt root, agno %d\n"),
@@ -2393,6 +2405,17 @@ validate_agi(
 		}
 	}
 
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		if (be32_to_cpu(agi->agi_iblocks) != priv.ino_blocks)
+			do_warn(_("bad inobt block count %u, saw %u\n"),
+					be32_to_cpu(agi->agi_iblocks),
+					priv.ino_blocks);
+		if (be32_to_cpu(agi->agi_fblocks) != priv.fino_blocks)
+			do_warn(_("bad finobt block count %u, saw %u\n"),
+					be32_to_cpu(agi->agi_fblocks),
+					priv.fino_blocks);
+	}
+
 	if (be32_to_cpu(agi->agi_count) != agcnts->agicount) {
 		do_warn(_("agi_count %u, counted %u in ag %u\n"),
 			 be32_to_cpu(agi->agi_count), agcnts->agicount, agno);
