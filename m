Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E9FC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 15:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F1B9208B8
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 15:27:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YeZf0KEP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgGBP1S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 11:27:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57602 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgGBP1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 11:27:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062FMW5U186916;
        Thu, 2 Jul 2020 15:27:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PnqRJzm3HKaISCOmnUkMdk86UMAUz1E20hnIPfXGsC8=;
 b=YeZf0KEPbKxOA7hZ9loiUkbh2P+lPv/5yS37bo19+B+1/84nDZgeEAYjQ4Qh056W6XeI
 +EorQUU9d8kFFgPo5Pn+349R1TZw7ZV1+CIUEwboMgsoBfYp1iledsj4eSQPpR2Tkv+V
 0YHD4bI1JwQGICRzgGIgkehDleDOYocW1ohX7wcdmuzyHmwiBfIfzdrOaNzINUIOXCUv
 TZavtsT7fFc+8rYPIBbkXxhcWqsHHrunWYbQaHriIWSSdUVbIKI+c7KSNpYk95BteXek
 OkvdMcxSvvg8jHvWFwh+qIdfrIQF391zPxqgo7wcv6nr2yMKymArRzeAHABHVzZ/HzON hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31xx1e5ye0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 15:27:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062FNAnO042689;
        Thu, 2 Jul 2020 15:27:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31y52mwv3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 15:27:15 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 062FREY9004563;
        Thu, 2 Jul 2020 15:27:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 15:27:10 +0000
Subject: [PATCH 3/3] xfs_repair: try to fill the AGFL before we fix the
 freelist
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 02 Jul 2020 08:27:09 -0700
Message-ID: <159370362968.3579756.14752877317465395252.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=2 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020107
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit 9851fd79bfb1, we added a slight amount of slack to the free
space btrees being reconstructed so that the initial fix_freelist call
(which is run against a totally empty AGFL) would never have to split
either free space btree in order to populate the free list.

The new btree bulk loading code in xfs_repair can re-create this
situation because it can set the slack values to zero if the filesystem
is very full.  However, these days repair has the infrastructure needed
to ensure that overestimations of the btree block counts end up on the
AGFL or get freed back into the filesystem at the end of phase 5.

Fix this problem by reserving extra blocks in the bnobt reservation, and
checking that there are enough overages in the bnobt/cntbt fakeroots to
populate the AGFL with the minimum number of blocks it needs to handle a
split in the bno/cnt/rmap btrees.

Note that we reserve blocks for the new bnobt/cntbt/AGFL at the very end
of the reservation steps in phase 5, so the extra allocation should not
cause repair to fail if it can't find blocks for btrees.

Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/agbtree.c |   51 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)


diff --git a/repair/agbtree.c b/repair/agbtree.c
index de8015ec..9f64d54b 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -65,8 +65,8 @@ consume_freespace(
 }
 
 /* Reserve blocks for the new per-AG structures. */
-static void
-reserve_btblocks(
+static uint32_t
+reserve_agblocks(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	struct bt_rebuild	*btr,
@@ -86,8 +86,7 @@ reserve_btblocks(
 		 */
 		ext_ptr = findfirst_bcnt_extent(agno);
 		if (!ext_ptr)
-			do_error(
-_("error - not enough free space in filesystem\n"));
+			break;
 
 		/* Use up the extent we've got. */
 		len = min(ext_ptr->ex_blockcount, nr_blocks - blocks_allocated);
@@ -110,6 +109,23 @@ _("error - not enough free space in filesystem\n"));
 	fprintf(stderr, "blocks_allocated = %d\n",
 		blocks_allocated);
 #endif
+	return blocks_allocated;
+}
+
+static inline void
+reserve_btblocks(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr,
+	uint32_t		nr_blocks)
+{
+	uint32_t		got;
+
+	got = reserve_agblocks(mp, agno, btr, nr_blocks);
+	if (got != nr_blocks)
+		do_error(
+	_("error - not enough free space in filesystem, AG %u\n"),
+				agno);
 }
 
 /* Feed one of the new btree blocks to the bulk loader. */
@@ -217,8 +233,11 @@ init_freespace_cursors(
 	struct bt_rebuild	*btr_bno,
 	struct bt_rebuild	*btr_cnt)
 {
+	unsigned int		agfl_goal;
 	int			error;
 
+	agfl_goal = libxfs_alloc_min_freelist(sc->mp, NULL);
+
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_bno);
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_cnt);
 
@@ -243,6 +262,7 @@ init_freespace_cursors(
 	do {
 		unsigned int	num_freeblocks;
 		int		delta_bno, delta_cnt;
+		int		agfl_wanted;
 
 		/* Compute how many bnobt blocks we'll need. */
 		error = -libxfs_btree_bload_compute_geometry(btr_bno->cur,
@@ -268,16 +288,33 @@ _("Unable to compute free space by length btree geometry, error %d.\n"), -error)
 				 btr_cnt->bload.nr_blocks;
 
 		/* We don't need any more blocks, so we're done. */
-		if (delta_bno >= 0 && delta_cnt >= 0) {
+		if (delta_bno >= 0 && delta_cnt >= 0 &&
+		    delta_bno + delta_cnt >= agfl_goal) {
 			*extra_blocks = delta_bno + delta_cnt;
 			break;
 		}
 
 		/* Allocate however many more blocks we need this time. */
-		if (delta_bno < 0)
+		if (delta_bno < 0) {
 			reserve_btblocks(sc->mp, agno, btr_bno, -delta_bno);
-		if (delta_cnt < 0)
+			delta_bno = 0;
+		}
+		if (delta_cnt < 0) {
 			reserve_btblocks(sc->mp, agno, btr_cnt, -delta_cnt);
+			delta_cnt = 0;
+		}
+
+		/*
+		 * Try to fill the bnobt cursor with extra blocks to populate
+		 * the AGFL.  If we don't get all the blocks we want, stop
+		 * trying to fill the AGFL because the AG is totally out of
+		 * space.
+		 */
+		agfl_wanted = agfl_goal - (delta_bno + delta_cnt);
+		if (agfl_wanted > 0 &&
+		    agfl_wanted != reserve_agblocks(sc->mp, agno, btr_bno,
+						    agfl_wanted))
+			agfl_goal = 0;
 
 		/* Ok, now how many free space records do we have? */
 		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);

