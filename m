Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30225C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 02:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F04BD20848
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 02:38:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x9WLsKzE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgH1Ciz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 22:38:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48078 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgH1Ciz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 22:38:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S2YdpU095331;
        Fri, 28 Aug 2020 02:38:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4fkm9ujBSzzhZwWzPaPVlhKU2gs4RH3WOV4navofItQ=;
 b=x9WLsKzEPvKqVEvMwZWU3gKfCTFYHvMH+PJ3aNL28R2jUY7CTr6mPsKuaFKvJER3l6ob
 T0cleqy/Scs76NPpkLn/7kYHPtRQOaoEZoj2xK8SwvvhX0tSFXAETb0Ejv03Pr9ZSMVD
 bmhME1XhdoGQ4LP4e17FijhmOaajFss5sswWTqJGiDFESYNBWhfUlCzZUqMXuU1/qqLr
 NgnXIrfHFFSno2bqzW3yKuNn3aWTPhfQ5F766IbsnQPWHXT/LXlOROVFKb/a2+so344Q
 Tp2KzO3OSXnUIyqbMw+fk+UEMWl04u2sbB9Qk8lYEnVZQbBjBsrow1Y9kJSu4UdToUIw fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 336ht3hnyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 02:38:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S2Ylqh138321;
        Fri, 28 Aug 2020 02:36:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 333ru280s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 02:36:51 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07S2ao2V023820;
        Fri, 28 Aug 2020 02:36:50 GMT
Received: from localhost (/10.159.133.199)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 19:36:50 -0700
Subject: [PATCH 3/5] xfs: support inode btree blockcounts in online scrub
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Aug 2020 19:36:49 -0700
Message-ID: <159858220970.3058056.11436591208519179894.stgit@magnolia>
In-Reply-To: <159858219107.3058056.6897728273666872031.stgit@magnolia>
References: <159858219107.3058056.6897728273666872031.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add the necessary bits to the online scrub code to check the inode btree
counters when enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index e9bcf1faa183..ae8e2e0ac64a 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -781,6 +781,35 @@ xchk_agi_xref_icounts(
 		xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
 }
 
+/* Check agi_[fi]blocks against tree size */
+static inline void
+xchk_agi_xref_fiblocks(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
+	xfs_agblock_t		blocks;
+	int			error = 0;
+
+	if (!xfs_sb_version_hasinobtcounts(&sc->mp->m_sb))
+		return;
+
+	if (sc->sa.ino_cur) {
+		error = xfs_btree_count_blocks(sc->sa.ino_cur, &blocks);
+		if (!xchk_should_check_xref(sc, &error, &sc->sa.ino_cur))
+			return;
+		if (blocks != be32_to_cpu(agi->agi_iblocks))
+			xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
+	}
+
+	if (sc->sa.fino_cur) {
+		error = xfs_btree_count_blocks(sc->sa.fino_cur, &blocks);
+		if (!xchk_should_check_xref(sc, &error, &sc->sa.fino_cur))
+			return;
+		if (blocks != be32_to_cpu(agi->agi_fblocks))
+			xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
+	}
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_agi_xref(
@@ -804,6 +833,7 @@ xchk_agi_xref(
 	xchk_agi_xref_icounts(sc);
 	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
+	xchk_agi_xref_fiblocks(sc);
 
 	/* scrub teardown will take care of sc->sa for us */
 }

