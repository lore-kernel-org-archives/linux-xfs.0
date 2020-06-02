Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDBFC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF30020738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:25:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HB+qM4bm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgFBEZ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:25:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33840 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFBEZ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:25:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524Gfsg106493;
        Tue, 2 Jun 2020 04:25:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FTGHLV7G+ugo0tkrFuj4rLHZRCw962nJ8h/xSYiWln0=;
 b=HB+qM4bm+6ghzuCgzdTVXBDd6B3RcZ5o0PZfDawy5fJ2iDyxYAsbsQn6XGYtAkTKodJR
 mPKRWpUhOAZ8svNmjhKJeRvlaiKGIFLUcXRDX/hg5JUBQdZqAmxbfNdTvcOVKerFODKT
 fBawLxM8XK5wqwwdvIV2lOTkxdwLHhPZJz7Kz0MDOEUkLrto3AOAWQud0SbqJVjB3JrF
 BsHPQChhWr/57ZLJvuJ1PAXOINTrSsJ9Pfi7sGdJAkty6zGqThBG+PIVHzHGEN0P42lk
 ftDpnXPXLpABES5OB1AmdZhewDyvoYRLnkTLIrjb+BlprmfTUJm4E7Ju/gxFq/kf1XTL xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfem1t8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:25:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524Hvdq040061;
        Tue, 2 Jun 2020 04:25:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31c18sggfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:25:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524PsuT020597;
        Tue, 2 Jun 2020 04:25:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:25:53 -0700
Subject: [PATCH 08/17] xfs_repair: tag inobt vs finobt errors properly
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:25:52 -0700
Message-ID: <159107195269.313760.9235612924680444467.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

