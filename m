Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57237C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3219C20738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iBah0MWA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgFBE2M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:28:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34950 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgFBE2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:28:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HSCc106939;
        Tue, 2 Jun 2020 04:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=stoltllz5Iif+4oSu0GDUH7VVUr1HtOCiF/ceWPxmCA=;
 b=iBah0MWA5P9A6TurH55lzq1OwefmwGZ9XJ8cxC1WJe1a4lYGYkyWmgxC14IOkMVCTOFx
 ca3GXsUlq2AGglRpqfZqPfqQN9xut/quvR/5mVXXH+u3iLiCB10cpnF0wQWssCHGjUrv
 8tu6bfk1aeWQq3883F30ZvR0myw5oqJl1rHDLxjgdLuL8z8DXyMp+14vvc6Pu8IVJn1/
 X6MFg/eCdKmEhYl/lDFjsHfRV1lJ0vZoZ78e1D/1KjPu2zZ8/c0DWO6E41GmaTJFIi9G
 Kwzp2TAIwW3dc29c8EgTBJPtV/VUa6l+N4qisgO/q40l/eAvd27QZ2BU/yqh7v/6aits KQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31bfem1t93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:26:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524JMLf102138;
        Tue, 2 Jun 2020 04:26:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31c12ng47p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:26:07 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0524Q6ZN021093;
        Tue, 2 Jun 2020 04:26:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:26:06 -0700
Subject: [PATCH 10/17] xfs_repair: convert to libxfs_verify_agbno
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:26:05 -0700
Message-ID: <159107196560.313760.8599787478905401609.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=2 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the homegrown verify_agbno callers to use the libxfs function,
as needed.  In some places we drop the "bno != 0" checks because those
conditionals are checking btree roots; btree roots should never be
zero if the corresponding feature bit is set; and repair skips the if
clause entirely if the feature bit is disabled.

In effect, this strengthens repair to validate that AG btree pointers
neither point to the AG headers nor past the end of the AG.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/dinode.c          |   11 -----------
 repair/dinode.h          |    5 -----
 repair/scan.c            |   36 +++++++++++++++++++++++-------------
 4 files changed, 24 insertions(+), 29 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 7b264ff2..c03f0efa 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -20,6 +20,7 @@
 #define xfs_agfl_walk			libxfs_agfl_walk
 
 #define xfs_ag_init_headers		libxfs_ag_init_headers
+#define xfs_ag_block_count		libxfs_ag_block_count
 
 #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
 #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
diff --git a/repair/dinode.c b/repair/dinode.c
index 1f1cc26b..b343534c 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -255,17 +255,6 @@ verify_dfsbno_range(xfs_mount_t	*mp,
 	return (XR_DFSBNORANGE_VALID);
 }
 
-int
-verify_agbno(xfs_mount_t	*mp,
-		xfs_agnumber_t	agno,
-		xfs_agblock_t	agbno)
-{
-	xfs_sb_t	*sbp = &mp->m_sb;;
-
-	/* range check ag #, ag block.  range-checking offset is pointless */
-	return verify_ag_bno(sbp, agno, agbno) == 0;
-}
-
 static int
 process_rt_rec(
 	xfs_mount_t		*mp,
diff --git a/repair/dinode.h b/repair/dinode.h
index 98238357..c8e563b5 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -9,11 +9,6 @@
 struct blkmap;
 struct prefetch_args;
 
-int
-verify_agbno(xfs_mount_t	*mp,
-		xfs_agnumber_t	agno,
-		xfs_agblock_t	agbno);
-
 int
 verify_dfsbno(xfs_mount_t	*mp,
 		xfs_fsblock_t	fsbno);
diff --git a/repair/scan.c b/repair/scan.c
index 719ad035..8e81c552 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -678,14 +678,14 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			len = be32_to_cpu(rp[i].ar_blockcount);
 			end = b + len;
 
-			if (b == 0 || !verify_agbno(mp, agno, b)) {
+			if (!libxfs_verify_agbno(mp, agno, b)) {
 				do_warn(
 	_("invalid start block %u in record %u of %s btree block %u/%u\n"),
 					b, i, name, agno, bno);
 				continue;
 			}
 			if (len == 0 || end <= b ||
-			    !verify_agbno(mp, agno, end - 1)) {
+			    !libxfs_verify_agbno(mp, agno, end - 1)) {
 				do_warn(
 	_("invalid length %u in record %u of %s btree block %u/%u\n"),
 					len, i, name, agno, bno);
@@ -950,6 +950,16 @@ rmap_in_order(
 	return offset > lastoffset;
 }
 
+static inline bool
+verify_rmap_agbno(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno)
+{
+	return agbno < libxfs_ag_block_count(mp, agno);
+}
+
+
 static void
 scan_rmapbt(
 	struct xfs_btree_block	*block,
@@ -1068,14 +1078,14 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			end = key.rm_startblock + key.rm_blockcount;
 
 			/* Make sure agbno & len make sense. */
-			if (!verify_agbno(mp, agno, b)) {
+			if (!verify_rmap_agbno(mp, agno, b)) {
 				do_warn(
 	_("invalid start block %u in record %u of %s btree block %u/%u\n"),
 					b, i, name, agno, bno);
 				continue;
 			}
 			if (len == 0 || end <= b ||
-			    !verify_agbno(mp, agno, end - 1)) {
+			    !verify_rmap_agbno(mp, agno, end - 1)) {
 				do_warn(
 	_("invalid length %u in record %u of %s btree block %u/%u\n"),
 					len, i, name, agno, bno);
@@ -1363,14 +1373,14 @@ _("leftover CoW extent has invalid startblock in record %u of %s btree block %u/
 			}
 			end = agb + len;
 
-			if (!verify_agbno(mp, agno, agb)) {
+			if (!libxfs_verify_agbno(mp, agno, agb)) {
 				do_warn(
 	_("invalid start block %u in record %u of %s btree block %u/%u\n"),
 					b, i, name, agno, bno);
 				continue;
 			}
 			if (len == 0 || end <= agb ||
-			    !verify_agbno(mp, agno, end - 1)) {
+			    !libxfs_verify_agbno(mp, agno, end - 1)) {
 				do_warn(
 	_("invalid length %u in record %u of %s btree block %u/%u\n"),
 					len, i, name, agno, bno);
@@ -2171,7 +2181,7 @@ scan_agfl(
 {
 	struct agfl_state	*as = priv;
 
-	if (verify_agbno(mp, as->agno, bno))
+	if (libxfs_verify_agbno(mp, as->agno, bno))
 		set_bmap(as->agno, bno, XR_E_FREE);
 	else
 		do_warn(_("bad agbno %u in agfl, agno %d\n"),
@@ -2244,7 +2254,7 @@ validate_agf(
 	uint32_t		magic;
 
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
-	if (bno != 0 && verify_agbno(mp, agno, bno)) {
+	if (libxfs_verify_agbno(mp, agno, bno)) {
 		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_ABTB_CRC_MAGIC
 							 : XFS_ABTB_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
@@ -2256,7 +2266,7 @@ validate_agf(
 	}
 
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
-	if (bno != 0 && verify_agbno(mp, agno, bno)) {
+	if (libxfs_verify_agbno(mp, agno, bno)) {
 		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_ABTC_CRC_MAGIC
 							 : XFS_ABTC_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
@@ -2276,7 +2286,7 @@ validate_agf(
 		priv.last_rec.rm_owner = XFS_RMAP_OWN_UNKNOWN;
 		priv.nr_blocks = 0;
 		bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
-		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+		if (libxfs_verify_agbno(mp, agno, bno)) {
 			scan_sbtree(bno,
 				    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]),
 				    agno, 0, scan_rmapbt, 1, XFS_RMAP_CRC_MAGIC,
@@ -2294,7 +2304,7 @@ validate_agf(
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
 		bno = be32_to_cpu(agf->agf_refcount_root);
-		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+		if (libxfs_verify_agbno(mp, agno, bno)) {
 			struct refc_priv	priv;
 
 			memset(&priv, 0, sizeof(priv));
@@ -2342,7 +2352,7 @@ validate_agi(
 	uint32_t		magic;
 
 	bno = be32_to_cpu(agi->agi_root);
-	if (bno != 0 && verify_agbno(mp, agno, bno)) {
+	if (libxfs_verify_agbno(mp, agno, bno)) {
 		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_IBT_CRC_MAGIC
 							 : XFS_IBT_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agi->agi_level),
@@ -2355,7 +2365,7 @@ validate_agi(
 
 	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
 		bno = be32_to_cpu(agi->agi_free_root);
-		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+		if (libxfs_verify_agbno(mp, agno, bno)) {
 			magic = xfs_sb_version_hascrc(&mp->m_sb) ?
 					XFS_FIBT_CRC_MAGIC : XFS_FIBT_MAGIC;
 			scan_sbtree(bno, be32_to_cpu(agi->agi_free_level),

