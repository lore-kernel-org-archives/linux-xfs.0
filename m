Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE825C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89AFF2063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b8lxfkMv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgEIQbL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:31:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49862 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEIQbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:31:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMgwi072397;
        Sat, 9 May 2020 16:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CiA2b95hoQaB/sQS5G8YbHsKYaCHbPAeA56x08MD670=;
 b=b8lxfkMvmK+KH3TgJ/HbB8Ln8/eQxPiJpbC1hk4WYS226JPDL1AAxzK7gL4zdCVUAeqo
 wXVp907NFuegUeQHTfPi+AR0Cw/+DjRAXdxWohfnDX9p7jC+NM0NTPRdMixQ+q8YKI/F
 iJ4xPhfvHSJ+jHqCjQtHm6NviXYnV3QlnK9eKCiaZf/q0QSK60Sel8NiS9IidiA1pUC3
 UMfa6jXEmxiVoBZEC0DMIFnDciS7VigX8QoHao5n9jmkPH/6pmwW6hw6VMR/dXLu/XlP
 SkP8e5EEGXdj6sT9Pw7IrjCrl4FpplVxdIT5YPnPeYcXXcV+CgbdlY/5XKbGU6xOv8Sj /Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30wkxqs6fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRcoc132545;
        Sat, 9 May 2020 16:31:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30wwxb5hww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:08 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049GV8ud025342;
        Sat, 9 May 2020 16:31:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:31:07 -0700
Subject: [PATCH 11/16] xfs_repair: remove verify_dfsbno
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:31:07 -0700
Message-ID: <158904186786.982941.13402008407746781785.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=2 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=2 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace this homegrown helper with its libxfs equivalent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

