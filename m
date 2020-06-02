Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC503C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B79EB20659
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:25:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bfgI+zi3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgFBEZY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:25:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33526 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFBEZY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:25:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HLmn106921;
        Tue, 2 Jun 2020 04:25:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YDcCzvPWwIOrFQb6qFvuy7GbWhGiPNN5BAHmj0HSvSs=;
 b=bfgI+zi3xlJm7+sE+wr3eZGYmViIAUe/dmerJt9ZB7gpAJVFPUK5dpRVx3lNkSsKekxu
 y4A9noLPJYgHkIXrvvbjjdjSwzujeTpq/snTmT3+Xb6v0BYrPPnuN2yqakm24fyi4hZV
 o1qZ79XMchkglrfFI6omJloi+SYX056A71YIZ0cCDTSPLIOrVzAW3m/FG8S72D4+jQdp
 iNByJjmzjj5VDm4CCXA6nApVJbWoIpiojRXwfSRuFE1JreJ/cSdpY/LA7AvVCJYXVWFZ
 Zh5ZLtWgncdHQkLCW3Qb0aJjorDkAKdsxhGtUpPUn2Wxpbw1Ogh1FkCGizP1l8Mr5jVF BQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfem1t7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:25:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524I1fd040399;
        Tue, 2 Jun 2020 04:25:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31c18sgg34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:25:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0524PGQd020761;
        Tue, 2 Jun 2020 04:25:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:25:16 -0700
Subject: [PATCH 02/17] xfs_repair: fix missing dir buffer corruption checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:25:15 -0700
Message-ID: <159107191545.313760.9884644443421173377.stgit@magnolia>
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

The da_read_buf() function operates in "salvage" mode, which means that
if the verifiers fail, it will return a buffer with b_error set.  The
callers of da_read_buf, however, do not adequately check for verifier
errors, which means that repair can fail to flag a corrupt filesystem.

Fix the callers to do this properly.  The dabtree block walker and the
dabtree path checker functions to complain any time the da node / leafn
verifiers fail.  Fix the directory block walking functions to complain
about EFSCORRUPTED, since they already dealt with EFSBADCRC.

Found by running xfs/496 against lhdr.stale = middlebit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/da_util.c |   25 ++++++++++++++++---------
 repair/dir2.c    |   21 +++++++++++++++++++++
 2 files changed, 37 insertions(+), 9 deletions(-)


diff --git a/repair/da_util.c b/repair/da_util.c
index 5061880f..7239c2e2 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -134,6 +134,15 @@ _("can't read %s block %u for inode %" PRIu64 "\n"),
 			goto error_out;
 		}
 
+		/* corrupt leafn/node; rebuild the dir. */
+		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
+			do_warn(
+_("corrupt %s tree block %u for inode %" PRIu64 "\n"),
+				FORKNAME(whichfork), bno, da_cursor->ino);
+			libxfs_buf_relse(bp);
+			goto error_out;
+		}
+
 		node = bp->b_addr;
 		libxfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
 
@@ -160,15 +169,6 @@ _("bad %s magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
 			goto error_out;
 		}
 
-		/* corrupt node; rebuild the dir. */
-		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
-			libxfs_buf_relse(bp);
-			do_warn(
-_("corrupt %s tree block %u for inode %" PRIu64 "\n"),
-				FORKNAME(whichfork), bno, da_cursor->ino);
-			goto error_out;
-		}
-
 		if (nodehdr.count > geo->node_ents) {
 			do_warn(
 _("bad %s record count in inode %" PRIu64 ", count = %d, max = %d\n"),
@@ -562,6 +562,13 @@ _("can't read %s block %u for inode %" PRIu64 "\n"),
 				FORKNAME(whichfork), dabno, cursor->ino);
 			return 1;
 		}
+		if (bp->b_error == -EFSCORRUPTED || bp->b_error == -EFSBADCRC) {
+			do_warn(
+_("corrupt %s tree block %u for inode %" PRIu64 "\n"),
+				FORKNAME(whichfork), dabno, cursor->ino);
+			libxfs_buf_relse(bp);
+			return 1;
+		}
 
 		newnode = bp->b_addr;
 		libxfs_da3_node_hdr_from_disk(mp, &nodehdr, newnode);
diff --git a/repair/dir2.c b/repair/dir2.c
index cbbce601..b374bc7b 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -983,6 +983,13 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
 			mp->m_dir_geo->datablk, ino);
 		return 1;
 	}
+	if (bp->b_error == -EFSCORRUPTED) {
+		do_warn(
+_("corrupt directory block %u for inode %" PRIu64 "\n"),
+			mp->m_dir_geo->datablk, ino);
+		libxfs_buf_relse(bp);
+		return 1;
+	}
 	/*
 	 * Verify the block
 	 */
@@ -1122,6 +1129,13 @@ _("can't read file block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			goto error_out;
 		}
+		if (bp->b_error == -EFSCORRUPTED) {
+			do_warn(
+_("corrupt directory leafn block %u for inode %" PRIu64 "\n"),
+				da_bno, ino);
+			libxfs_buf_relse(bp);
+			goto error_out;
+		}
 		leaf = bp->b_addr;
 		libxfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 		/*
@@ -1324,6 +1338,13 @@ _("can't read block %" PRIu64 " for directory inode %" PRIu64 "\n"),
 				dbno, ino);
 			continue;
 		}
+		if (bp->b_error == -EFSCORRUPTED) {
+			do_warn(
+_("corrupt directory data block %lu for inode %" PRIu64 "\n"),
+				dbno, ino);
+			libxfs_buf_relse(bp);
+			continue;
+		}
 		data = bp->b_addr;
 		if (!(be32_to_cpu(data->magic) == XFS_DIR2_DATA_MAGIC ||
 		      be32_to_cpu(data->magic) == XFS_DIR3_DATA_MAGIC))

