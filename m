Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31FCC47247
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 806272063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kYXG2hd+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgEIQcp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:32:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50814 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbgEIQco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:32:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMgTs072385;
        Sat, 9 May 2020 16:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CeG4LjkC8zgOjL5UIuqXmW6sr/ZBjbyNImx/p/ZlNhk=;
 b=kYXG2hd+lW7qLTtwTgYo8sORMHJEd5kq1NSmcebwdI5O1NGQY8Upr7FcYci+M+sUin4x
 g3daHrdVP1pPdBHFF6pOQTuU0aQat5wGsycvpz62cxzBj4kETNg1Gee8ylOKXlDy2WpY
 bBMDn/0t1fGq+Gaf3ihTtoBALrS1wMqemkvF306ZrsTLkT6lKfclJ3bN4t0dLohiCDcM
 xRuyvZnTu4Cv9dogqdD2ivI4jMmTlYleLujX1N1OwPMJsgYUj+KZjwRK0a1UaDm+fV2d
 40dJMcqOnH1yRIMjoLdzmKAAQ/7+7RxEsbfoCSVQRF989yf9cIOOBHUUORFrH7PuyDX7 Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30wkxqs6jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRdtk132601;
        Sat, 9 May 2020 16:30:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30wwxb5hmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:30:42 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GUgS0025865;
        Sat, 9 May 2020 16:30:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:30:41 -0700
Subject: [PATCH 07/16] xfs_repair: tag inobt vs finobt errors properly
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:30:42 -0700
Message-ID: <158904184198.982941.18130519450590388566.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Amend the generic inode btree block scanner function to tag correctly
which tree it's complaining about.  Previously, dubious finobt headers
would be attributed to the "inode btree", which is at best ambiguous
and misleading at worst.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 7508f7e8..fff54ecf 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1949,6 +1949,7 @@ scan_inobt(
 	const struct xfs_buf_ops *ops)
 {
 	struct aghdr_cnts	*agcnts = priv;
+	char			*name;
 	xfs_agino_t		lastino = 0;
 	int			i;
 	int			numrecs;
@@ -1961,17 +1962,32 @@ scan_inobt(
 
 	hdr_errors = 0;
 
+	switch (magic) {
+	case XFS_FIBT_MAGIC:
+	case XFS_FIBT_CRC_MAGIC:
+		name = "fino";
+		break;
+	case XFS_IBT_MAGIC:
+	case XFS_IBT_CRC_MAGIC:
+		name = "ino";
+		break;
+	default:
+		name = "(unknown)";
+		assert(0);
+		break;
+	}
+
 	if (be32_to_cpu(block->bb_magic) != magic) {
-		do_warn(_("bad magic # %#x in inobt block %d/%d\n"),
-			be32_to_cpu(block->bb_magic), agno, bno);
+		do_warn(_("bad magic # %#x in %sbt block %d/%d\n"),
+			be32_to_cpu(block->bb_magic), name, agno, bno);
 		hdr_errors++;
 		bad_ino_btree = 1;
 		if (suspect)
 			return;
 	}
 	if (be16_to_cpu(block->bb_level) != level) {
-		do_warn(_("expected level %d got %d in inobt block %d/%d\n"),
-			level, be16_to_cpu(block->bb_level), agno, bno);
+		do_warn(_("expected level %d got %d in %sbt block %d/%d\n"),
+			level, be16_to_cpu(block->bb_level), name, agno, bno);
 		hdr_errors++;
 		bad_ino_btree = 1;
 		if (suspect)
@@ -1993,8 +2009,8 @@ scan_inobt(
 	default:
 		set_bmap(agno, bno, XR_E_MULT);
 		do_warn(
-_("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
-			state, agno, bno, suspect);
+_("%sbt btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
+			name, state, agno, bno, suspect);
 	}
 
 	numrecs = be16_to_cpu(block->bb_numrecs);
@@ -2016,8 +2032,8 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 
 		if (hdr_errors)  {
 			bad_ino_btree = 1;
-			do_warn(_("dubious inode btree block header %d/%d\n"),
-				agno, bno);
+			do_warn(_("dubious %sbt btree block header %d/%d\n"),
+				name, agno, bno);
 			suspect++;
 		}
 
@@ -2038,8 +2054,8 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			startino = be32_to_cpu(rp[i].ir_startino);
 			if (i > 0 && startino <= lastino)
 				do_warn(_(
-	"out-of-order ino btree record %d (%u) block %u/%u\n"),
-						i, startino, agno, bno);
+	"out-of-order %s btree record %d (%u) block %u/%u\n"),
+						name, i, startino, agno, bno);
 			else
 				lastino = startino + XFS_INODES_PER_CHUNK - 1;
 

