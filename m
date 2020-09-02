Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7179C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F63C206CD
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:56:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="em+8MC6S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIBC4S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 22:56:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50594 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgIBC4R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 22:56:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822srUx003347;
        Wed, 2 Sep 2020 02:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hAMjb30CTTTosv8HsuF+Kk/IhThq7KIj2r0dJXC2Ylc=;
 b=em+8MC6SK96Z1nylAtfHGwtktnlv+ZufVUQPSnFP0kl1lLJ+2pfdOVSBwO7tszrPETb/
 XFyta5l2ZUOuDui53BxxX7X6ZQCk2TGiXMG9+GhIZumRS8Y38IrMxtIlKsu/uiA/YHWM
 dAWFh/PsaAiA68pCeaXHsrI7lgg9Bd9i9YtknVdVe1jQ+Ip0DmmWFoF+rD3GlhJFsFi0
 foq9MM+4UjG9csWxN12bwE5Dps9rbOb8H42W9Trx4occHy3bwSHhK+qgcATGoUlL9Yfo
 TeQ24eQAZxg0APGWAesy6d0tN6aB8/dQ7NcmWAN1X8qdwIgWVQ/U8XyyDqsDGj1cEAMo HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 337eeqyvhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 02:56:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822thXE177312;
        Wed, 2 Sep 2020 02:56:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3380xxqvav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 02:56:13 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0822uDGk004699;
        Wed, 2 Sep 2020 02:56:13 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:56:12 -0700
Subject: [PATCH 3/5] xfs: support inode btree blockcounts in online scrub
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 01 Sep 2020 19:56:11 -0700
Message-ID: <159901537133.547164.1323656639235820928.stgit@magnolia>
In-Reply-To: <159901535219.547164.1381621861988558776.stgit@magnolia>
References: <159901535219.547164.1381621861988558776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020026
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add the necessary bits to the online scrub code to check the inode btree
counters when enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
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

