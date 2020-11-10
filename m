Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3662DC388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB53A20797
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g2SyRqnJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgKJSDs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:03:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57620 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgKJSDs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:03:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHxGGv018638;
        Tue, 10 Nov 2020 18:03:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zSSxh/JZ8Nt2nN6WaBm0QxRrw6WvA29Svi2OAulv8A8=;
 b=g2SyRqnJrW/kOfiyuIxmcQ8kCsUQrLPNQwdAO4ujBiJLD9NPBg/6obDRg+hWkMq2aufn
 DLB8YapLwOqX8fKAeTSs8gLLlvtvxDJg4qlulPMkhGjRjxCsIuA+l+u5z/2FZpcg4Xt2
 zP+q9PbvBDXhjJXgRLY6ueC2UFfsFI4eIVUetFIHAYFXvpqIjpoBFJsUuF0qot+16hLR
 Llda3jp32veluehOpByJOAuaennFokDFHdjCz333fF3Gqn7NaXA5ZHZw1hbFtfeOqnXt
 tK4ugIOXZWFzc4QTFHF0WBhGFgmsOTjqkZ/wWZ023kocUkcNF4/uOZ2SDhrhTc6shVXi SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72ek8n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 18:03:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAI16mc092721;
        Tue, 10 Nov 2020 18:03:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp76m86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 18:03:43 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AAI3g1N012592;
        Tue, 10 Nov 2020 18:03:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 10:03:42 -0800
Subject: [PATCH 6/9] xfs_repair: skip the rmap and refcount btree checks when
 the levels are garbage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 10 Nov 2020 10:03:41 -0800
Message-ID: <160503142152.1201232.17430855751236887491.stgit@magnolia>
In-Reply-To: <160503138275.1201232.927488386999483691.stgit@magnolia>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In validate_ag[fi], we should check that the levels of the rmap and
refcount btrees are valid.  If they aren't, we need to tell phase4 to
skip the comparison between the existing and incore rmap and refcount
data.  The comparison routines use libxfs btree cursors, which assume
that the caller validated bc_nlevels and will corrupt memory if we load
a btree cursor with a garbage level count.

This was found by examing a core dump from a failed xfs/086 invocation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/scan.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 42b299f75067..2a38ae5197c6 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2279,23 +2279,31 @@ validate_agf(
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
 		struct rmap_priv	priv;
+		unsigned int		levels;
 
 		memset(&priv.high_key, 0xFF, sizeof(priv.high_key));
 		priv.high_key.rm_blockcount = 0;
 		priv.agcnts = agcnts;
 		priv.last_rec.rm_owner = XFS_RMAP_OWN_UNKNOWN;
 		priv.nr_blocks = 0;
+
+		levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+		if (levels >= XFS_BTREE_MAXLEVELS) {
+			do_warn(_("bad levels %u for rmapbt root, agno %d\n"),
+				levels, agno);
+			rmap_avoid_check();
+		}
+
 		bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
 		if (libxfs_verify_agbno(mp, agno, bno)) {
-			scan_sbtree(bno,
-				    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]),
-				    agno, 0, scan_rmapbt, 1, XFS_RMAP_CRC_MAGIC,
-				    &priv, &xfs_rmapbt_buf_ops);
+			scan_sbtree(bno, levels, agno, 0, scan_rmapbt, 1,
+					XFS_RMAP_CRC_MAGIC, &priv,
+					&xfs_rmapbt_buf_ops);
 			if (be32_to_cpu(agf->agf_rmap_blocks) != priv.nr_blocks)
 				do_warn(_("bad rmapbt block count %u, saw %u\n"),
 					priv.nr_blocks,
 					be32_to_cpu(agf->agf_rmap_blocks));
-		} else  {
+		} else {
 			do_warn(_("bad agbno %u for rmapbt root, agno %d\n"),
 				bno, agno);
 			rmap_avoid_check();
@@ -2303,20 +2311,28 @@ validate_agf(
 	}
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		unsigned int	levels;
+
+		levels = be32_to_cpu(agf->agf_refcount_level);
+		if (levels >= XFS_BTREE_MAXLEVELS) {
+			do_warn(_("bad levels %u for refcountbt root, agno %d\n"),
+				levels, agno);
+			refcount_avoid_check();
+		}
+
 		bno = be32_to_cpu(agf->agf_refcount_root);
 		if (libxfs_verify_agbno(mp, agno, bno)) {
 			struct refc_priv	priv;
 
 			memset(&priv, 0, sizeof(priv));
-			scan_sbtree(bno,
-				    be32_to_cpu(agf->agf_refcount_level),
-				    agno, 0, scan_refcbt, 1, XFS_REFC_CRC_MAGIC,
-				    &priv, &xfs_refcountbt_buf_ops);
+			scan_sbtree(bno, levels, agno, 0, scan_refcbt, 1,
+					XFS_REFC_CRC_MAGIC, &priv,
+					&xfs_refcountbt_buf_ops);
 			if (be32_to_cpu(agf->agf_refcount_blocks) != priv.nr_blocks)
 				do_warn(_("bad refcountbt block count %u, saw %u\n"),
 					priv.nr_blocks,
 					be32_to_cpu(agf->agf_refcount_blocks));
-		} else  {
+		} else {
 			do_warn(_("bad agbno %u for refcntbt root, agno %d\n"),
 				bno, agno);
 			refcount_avoid_check();

