Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03E7C433E4
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC4A6204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HHejy9Oo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgHQXAg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:00:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41792 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgHQXAe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:00:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMuw9Q136142;
        Mon, 17 Aug 2020 23:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HsRxM1oSlxMo1eeof782reUI9q/L3hg6Oz7kwDvvZVU=;
 b=HHejy9OofTsXxy8XA9WzCUWt0nTEN8rxEEWG2ThsZ5DSO46138byprr/nTUtWs2nT6DS
 yGP0/dlGEtBCaqOKeAvK8ulwen4NCdbxxBCCbpH4iYmmWEH8l9yYtaEvybw3Xp9hC/Xz
 Z/mKDnuT+pXP7F7jmxRSjCOBkyuf531TNzzzHtDWrsDsFzFTnuqLWbfgG03IlAco2P8I
 r08ZW9ZabG/ZvCfdth7tP3v66AeeXd1cOavyt2BBpg2KwHgFipc4sNJlkYVP+llPStn/
 +wiAF/cxYNop11/GYReBb+JMq2HyxcK8ivZw/tJ8XUpJ9Ab5OPXWQYAhnFBx6oQeLR0i kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bn1g4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:00:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw9rJ084669;
        Mon, 17 Aug 2020 22:58:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32xsfr591g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:58:32 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HMwVUD025142;
        Mon, 17 Aug 2020 22:58:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:58:31 -0700
Subject: [PATCH 4/7] xfs_repair: check inode btree block counters in AGI
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:58:30 -0700
Message-ID: <159770511056.3958545.1816196170854601929.stgit@magnolia>
In-Reply-To: <159770508586.3958545.417872750558976156.stgit@magnolia>
References: <159770508586.3958545.417872750558976156.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=2 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=2 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
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
index 42b299f75067..f05d0c918ce9 100644
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
@@ -2347,6 +2365,9 @@ validate_agi(
 	xfs_agnumber_t		agno,
 	struct aghdr_cnts	*agcnts)
 {
+	struct ino_priv		priv = {
+		.agcnts = agcnts,
+	};
 	xfs_agblock_t		bno;
 	int			i;
 	uint32_t		magic;
@@ -2356,7 +2377,7 @@ validate_agi(
 		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_IBT_CRC_MAGIC
 							 : XFS_IBT_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agi->agi_level),
-			    agno, 0, scan_inobt, 1, magic, agcnts,
+			    agno, 0, scan_inobt, 1, magic, &priv,
 			    &xfs_inobt_buf_ops);
 	} else {
 		do_warn(_("bad agbno %u for inobt root, agno %d\n"),
@@ -2369,7 +2390,7 @@ validate_agi(
 			magic = xfs_sb_version_hascrc(&mp->m_sb) ?
 					XFS_FIBT_CRC_MAGIC : XFS_FIBT_MAGIC;
 			scan_sbtree(bno, be32_to_cpu(agi->agi_free_level),
-				    agno, 0, scan_inobt, 1, magic, agcnts,
+				    agno, 0, scan_inobt, 1, magic, &priv,
 				    &xfs_finobt_buf_ops);
 		} else {
 			do_warn(_("bad agbno %u for finobt root, agno %d\n"),
@@ -2377,6 +2398,17 @@ validate_agi(
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

