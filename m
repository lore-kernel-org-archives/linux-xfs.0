Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B60C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABB25206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:30:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jnm0++/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgFBEa0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:30:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBEa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:30:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524I2J6121433;
        Tue, 2 Jun 2020 04:28:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=txP3NwgyJoEAunm6pAdqdtMEcNC34AmBQ0nS60+YkQI=;
 b=jnm0++/g2KOwNBfkBXDc+XBKoI4sosHI2YBdn40+ijAkxRO8J7K5COjtrv1NqjCCdPci
 Fc+BZJ6JavQ3kPtKi2cjtg9NWb2Hs/9PrcM9HKxGYLmLO6Y8JvKv3/9nx4zoVJyPfvGa
 x0wdwk9u002yUMhGBYtML5OVUYJps9SGScciBDQ97tVbsUN7UYRo7F1WCtoKqHxtWYdX
 Kre97URJZO/2z2VPODyjw5oAJcLzhFUVfQq6J9qsdXltC1q/ZubDe/1pGPnfawV2Lb39
 NFGXBGb6g+r9xhJbV9NuaF4uDaIF9Z13UPYQNg+GYbzLhCPji/7/9fzRfZ83rvA8NPQ9 fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31d5qr20tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:28:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524Huks126748;
        Tue, 2 Jun 2020 04:26:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31c25mnh94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:26:20 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524QK90019890;
        Tue, 2 Jun 2020 04:26:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:26:20 -0700
Subject: [PATCH 12/17] xfs_repair: remove verify_dfsbno
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:26:18 -0700
Message-ID: <159107197805.313760.6515122377279848689.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=2 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace this homegrown helper with its libxfs equivalent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/attr_repair.c |    2 +-
 repair/dinode.c      |   21 +--------------------
 repair/dinode.h      |    4 ----
 repair/prefetch.c    |    9 +++++----
 repair/scan.c        |    2 +-
 5 files changed, 8 insertions(+), 30 deletions(-)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 5f884033..6cec0f70 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1092,7 +1092,7 @@ process_longform_attr(
 	}
 
 	/* FIX FOR bug 653709 -- EKN */
-	if (!xfs_verify_fsbno(mp, bno)) {
+	if (!libxfs_verify_fsbno(mp, bno)) {
 		do_warn(
 	_("block in attribute fork of inode %" PRIu64 " is not valid\n"), ino);
 		return 1;
diff --git a/repair/dinode.c b/repair/dinode.c
index 135703d9..67adddd7 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -203,25 +203,6 @@ verify_aginum(xfs_mount_t	*mp,
 	return verify_ag_bno(sbp, agno, agbno);
 }
 
-/*
- * return 1 if block number is good, 0 if out of range
- */
-int
-verify_dfsbno(xfs_mount_t	*mp,
-		xfs_fsblock_t	fsbno)
-{
-	xfs_agnumber_t	agno;
-	xfs_agblock_t	agbno;
-	xfs_sb_t	*sbp = &mp->m_sb;;
-
-	/* range check ag #, ag block.  range-checking offset is pointless */
-
-	agno = XFS_FSB_TO_AGNO(mp, fsbno);
-	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
-
-	return verify_ag_bno(sbp, agno, agbno) == 0;
-}
-
 #define XR_DFSBNORANGE_VALID	0
 #define XR_DFSBNORANGE_BADSTART	1
 #define XR_DFSBNORANGE_BADEND	2
@@ -835,7 +816,7 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
 		 * btree, we'd do it right here.  For now, if there's a
 		 * problem, we'll bail out and presumably clear the inode.
 		 */
-		if (!verify_dfsbno(mp, get_unaligned_be64(&pp[i])))  {
+		if (!libxfs_verify_fsbno(mp, get_unaligned_be64(&pp[i])))  {
 			do_warn(
 _("bad bmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
 				get_unaligned_be64(&pp[i]), lino);
diff --git a/repair/dinode.h b/repair/dinode.h
index c8e563b5..4bf7affd 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -9,10 +9,6 @@
 struct blkmap;
 struct prefetch_args;
 
-int
-verify_dfsbno(xfs_mount_t	*mp,
-		xfs_fsblock_t	fsbno);
-
 void
 convert_extent(
 	xfs_bmbt_rec_t		*rp,
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 3ac49db1..686bf7be 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -188,8 +188,9 @@ pf_read_bmbt_reclist(
 				(irec.br_startoff >= fs_max_file_offset))
 			goto out_free;
 
-		if (!verify_dfsbno(mp, irec.br_startblock) || !verify_dfsbno(mp,
-				irec.br_startblock + irec.br_blockcount - 1))
+		if (!libxfs_verify_fsbno(mp, irec.br_startblock) ||
+		    !libxfs_verify_fsbno(mp, irec.br_startblock +
+					     irec.br_blockcount - 1))
 			goto out_free;
 
 		if (!args->dirs_only && ((irec.br_startoff +
@@ -337,7 +338,7 @@ pf_scanfunc_bmap(
 
 	for (i = 0; i < numrecs; i++) {
 		dbno = get_unaligned_be64(&pp[i]);
-		if (!verify_dfsbno(mp, dbno))
+		if (!libxfs_verify_fsbno(mp, dbno))
 			return 0;
 		if (!pf_scan_lbtree(dbno, level, isadir, args, pf_scanfunc_bmap))
 			return 0;
@@ -379,7 +380,7 @@ pf_read_btinode(
 
 	for (i = 0; i < numrecs; i++) {
 		dbno = get_unaligned_be64(&pp[i]);
-		if (!verify_dfsbno(mp, dbno))
+		if (!libxfs_verify_fsbno(mp, dbno))
 			break;
 		if (!pf_scan_lbtree(dbno, level, isadir, args, pf_scanfunc_bmap))
 			break;
diff --git a/repair/scan.c b/repair/scan.c
index 8e81c552..dcd4864d 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -491,7 +491,7 @@ _("inode %" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
 		 * we'd do it right here.  For now, if there's a problem,
 		 * we'll bail out and presumably clear the inode.
 		 */
-		if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
+		if (!libxfs_verify_fsbno(mp, be64_to_cpu(pp[i])))  {
 			do_warn(
 _("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
 			       (unsigned long long) be64_to_cpu(pp[i]), ino);

