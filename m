Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF7AC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 15:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51E16208B6
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 15:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YC3G3gd8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgGBP1J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 11:27:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49192 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgGBP1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 11:27:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062FMVj7003956;
        Thu, 2 Jul 2020 15:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Wb3zZKIeekZVMEHl1ReiPgFO85tcuqS+LnyLnBMTRBA=;
 b=YC3G3gd8en62S7rOiWfiB95OyGHMM4TWazeSTJOe45cc04WQhi1aLnavaAhUym3uS+4N
 Bj3xgI2MuwN9Q33+77+79QBFLdh9PJycIE0bH/9neHcdfh1YxuwMLd/2sE12Fid7hbvm
 3MajQS8EPbOaHbNZ+dK6VU5UoJJbPFpPfYyS38DNS3MjnI877PCsw6bK+HV6jCWOhV1s
 xqalx2kG7e2Ak7wxObiiPIbDy3njqaGkpRSuCS8J5o0wVSiZgBuKPGdRcoGs8ER9PSNg
 UPuJZhOn5Ik7PVCCBjvegmonQ5efgGDDLFt/GLoUr6jAfjEooEkiZjvLntnvEtSxjBmF pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31wxrnh3h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 15:27:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062FN80G042438;
        Thu, 2 Jul 2020 15:27:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31y52mwuu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 15:27:06 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 062FR5Zx003739;
        Thu, 2 Jul 2020 15:27:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 15:27:04 +0000
Subject: [PATCH 2/3] xfs_repair: simplify free space btree calculations in
 init_freespace_cursors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 02 Jul 2020 08:27:03 -0700
Message-ID: <159370362331.3579756.9359456822795462355.stgit@magnolia>
In-Reply-To: <159370361029.3579756.1711322369086095823.stgit@magnolia>
References: <159370361029.3579756.1711322369086095823.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=2 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=2 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020107
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a summary variable to the bulkload structure so that we can track
the number of blocks that have been reserved for a particular (btree)
bulkload operation.  Doing so enables us to simplify the logic in
init_freespace_cursors that deals with figuring out how many more blocks
we need to fill the bnobt/cntbt properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/agbtree.c  |   33 +++++++++++++++++----------------
 repair/bulkload.c |    2 ++
 repair/bulkload.h |    3 +++
 3 files changed, 22 insertions(+), 16 deletions(-)


diff --git a/repair/agbtree.c b/repair/agbtree.c
index 339b1489..de8015ec 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -217,8 +217,6 @@ init_freespace_cursors(
 	struct bt_rebuild	*btr_bno,
 	struct bt_rebuild	*btr_cnt)
 {
-	unsigned int		bno_blocks;
-	unsigned int		cnt_blocks;
 	int			error;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_bno);
@@ -244,9 +242,7 @@ init_freespace_cursors(
 	 */
 	do {
 		unsigned int	num_freeblocks;
-
-		bno_blocks = btr_bno->bload.nr_blocks;
-		cnt_blocks = btr_cnt->bload.nr_blocks;
+		int		delta_bno, delta_cnt;
 
 		/* Compute how many bnobt blocks we'll need. */
 		error = -libxfs_btree_bload_compute_geometry(btr_bno->cur,
@@ -262,25 +258,30 @@ _("Unable to compute free space by block btree geometry, error %d.\n"), -error);
 			do_error(
 _("Unable to compute free space by length btree geometry, error %d.\n"), -error);
 
+		/*
+		 * Compute the deficit between the number of blocks reserved
+		 * and the number of blocks we think we need for the btree.
+		 */
+		delta_bno = (int)btr_bno->newbt.nr_reserved -
+				 btr_bno->bload.nr_blocks;
+		delta_cnt = (int)btr_cnt->newbt.nr_reserved -
+				 btr_cnt->bload.nr_blocks;
+
 		/* We don't need any more blocks, so we're done. */
-		if (bno_blocks >= btr_bno->bload.nr_blocks &&
-		    cnt_blocks >= btr_cnt->bload.nr_blocks)
+		if (delta_bno >= 0 && delta_cnt >= 0) {
+			*extra_blocks = delta_bno + delta_cnt;
 			break;
+		}
 
 		/* Allocate however many more blocks we need this time. */
-		if (bno_blocks < btr_bno->bload.nr_blocks)
-			reserve_btblocks(sc->mp, agno, btr_bno,
-					btr_bno->bload.nr_blocks - bno_blocks);
-		if (cnt_blocks < btr_cnt->bload.nr_blocks)
-			reserve_btblocks(sc->mp, agno, btr_cnt,
-					btr_cnt->bload.nr_blocks - cnt_blocks);
+		if (delta_bno < 0)
+			reserve_btblocks(sc->mp, agno, btr_bno, -delta_bno);
+		if (delta_cnt < 0)
+			reserve_btblocks(sc->mp, agno, btr_cnt, -delta_cnt);
 
 		/* Ok, now how many free space records do we have? */
 		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
 	} while (1);
-
-	*extra_blocks = (bno_blocks - btr_bno->bload.nr_blocks) +
-			(cnt_blocks - btr_cnt->bload.nr_blocks);
 }
 
 /* Rebuild the free space btrees. */
diff --git a/repair/bulkload.c b/repair/bulkload.c
index 81d67e62..8dd0a0c3 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -40,6 +40,8 @@ bulkload_add_blocks(
 	resv->len = len;
 	resv->used = 0;
 	list_add_tail(&resv->list, &bkl->resv_list);
+	bkl->nr_reserved += len;
+
 	return 0;
 }
 
diff --git a/repair/bulkload.h b/repair/bulkload.h
index 01f67279..a84e99b8 100644
--- a/repair/bulkload.h
+++ b/repair/bulkload.h
@@ -41,6 +41,9 @@ struct bulkload {
 
 	/* The last reservation we allocated from. */
 	struct bulkload_resv	*last_resv;
+
+	/* Number of blocks reserved via resv_list. */
+	unsigned int		nr_reserved;
 };
 
 #define for_each_bulkload_reservation(bkl, resv, n)	\

