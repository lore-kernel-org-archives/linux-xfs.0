Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486D0C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 20:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A83F206FA
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 20:54:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FgpnhWYr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405328AbgFYUyo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 16:54:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405184AbgFYUyo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 16:54:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PKlx29047355;
        Thu, 25 Jun 2020 20:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0trtjucEJanzVBGP/Cf5cIF7Dbsh/PGow8ojnogotlY=;
 b=FgpnhWYrpnFKtWPSklVAfrkQLg0y/64LZBo8s7KhUgZ3hedRybNpaf/A39+KMf8ac/VU
 Xl2I4vaLKCrs8wQqogLV0v8QociKI5jtqIoFYSjFk/z1SGi6aNWrLq0x9/HHfjx+Lobx
 VHfQwfV0seM9vgJZSyeR0FrmtY4KAy4sG737s1mf8SXNgCSt++9J6VxKQtT0YMg38duc
 C+t1lAlzHL2HfVJ1ndOOfshsZpiNPFXcpkSNWmHsD3xY8Z7/JUto53qU+XXVcCMuXwvp
 Y82X607+tKfYmdxwM2+idBZIR2H5S19HgecMZ/71ApIOXK8ajMlMdrju8TgjBtjzzJCY 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31uusu2tbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 20:54:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PKmH8E070850;
        Thu, 25 Jun 2020 20:52:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31uur9k9fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 20:52:40 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PKqeZW025578;
        Thu, 25 Jun 2020 20:52:40 GMT
Received: from localhost (/10.159.246.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 20:52:39 +0000
Subject: [PATCH 2/2] xfs_repair: try to fill the AGFL before we fix the
 freelist
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 25 Jun 2020 13:52:39 -0700
Message-ID: <159311835912.1065505.9943855193663354771.stgit@magnolia>
In-Reply-To: <159311834667.1065505.8056215626287130285.stgit@magnolia>
References: <159311834667.1065505.8056215626287130285.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=2 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250122
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

Fix this problem by reserving blocks to a separate AGFL block
reservation, and checking that between this new reservation and any
overages in the bnobt/cntbt fakeroots, we have enough blocks sitting
around to populate the AGFL with the minimum number of blocks it needs
to handle a split in the bno/cnt/rmap btrees.

Note that we reserve blocks for the new bnobt/cntbt/AGFL at the very end
of the reservation steps in phase 5, so the extra allocation should not
cause repair to fail if it can't find blocks for btrees.

Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/agbtree.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 10 deletions(-)


diff --git a/repair/agbtree.c b/repair/agbtree.c
index 339b1489..7a4f316c 100644
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
@@ -219,8 +235,13 @@ init_freespace_cursors(
 {
 	unsigned int		bno_blocks;
 	unsigned int		cnt_blocks;
+	unsigned int		min_agfl_len;
+	bool			fill_agfl = true;
 	int			error;
 
+	*extra_blocks = 0;
+	min_agfl_len = libxfs_alloc_min_freelist(sc->mp, NULL);
+
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_bno);
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_cnt);
 
@@ -244,6 +265,9 @@ init_freespace_cursors(
 	 */
 	do {
 		unsigned int	num_freeblocks;
+		unsigned int	overflow = 0;
+		unsigned int	got;
+		int64_t		wanted;
 
 		bno_blocks = btr_bno->bload.nr_blocks;
 		cnt_blocks = btr_cnt->bload.nr_blocks;
@@ -262,25 +286,59 @@ _("Unable to compute free space by block btree geometry, error %d.\n"), -error);
 			do_error(
 _("Unable to compute free space by length btree geometry, error %d.\n"), -error);
 
+		if (bno_blocks > btr_bno->bload.nr_blocks)
+			overflow += bno_blocks - btr_bno->bload.nr_blocks;
+		if (cnt_blocks > btr_cnt->bload.nr_blocks)
+			overflow += cnt_blocks - btr_cnt->bload.nr_blocks;
+		if (overflow >= min_agfl_len)
+			fill_agfl = false;
+
 		/* We don't need any more blocks, so we're done. */
 		if (bno_blocks >= btr_bno->bload.nr_blocks &&
-		    cnt_blocks >= btr_cnt->bload.nr_blocks)
+		    cnt_blocks >= btr_cnt->bload.nr_blocks &&
+		    !fill_agfl) {
+			*extra_blocks = overflow;
 			break;
+		}
 
 		/* Allocate however many more blocks we need this time. */
-		if (bno_blocks < btr_bno->bload.nr_blocks)
+		if (bno_blocks < btr_bno->bload.nr_blocks) {
 			reserve_btblocks(sc->mp, agno, btr_bno,
 					btr_bno->bload.nr_blocks - bno_blocks);
-		if (cnt_blocks < btr_cnt->bload.nr_blocks)
+			bno_blocks = btr_bno->bload.nr_blocks;
+		}
+		if (cnt_blocks < btr_cnt->bload.nr_blocks) {
 			reserve_btblocks(sc->mp, agno, btr_cnt,
 					btr_cnt->bload.nr_blocks - cnt_blocks);
+			cnt_blocks = btr_cnt->bload.nr_blocks;
+		}
+
+		/*
+		 * Now try to fill the bnobt/cntbt cursors with extra blocks to
+		 * populate the AGFL.  If we don't get all the blocks we want,
+		 * stop trying to fill the AGFL.
+		 */
+		wanted = (int64_t)btr_bno->bload.nr_blocks +
+				(min_agfl_len / 2) - bno_blocks;
+		if (wanted > 0 && fill_agfl) {
+			got = reserve_agblocks(sc->mp, agno, btr_bno, wanted);
+			if (wanted > got)
+				fill_agfl = false;
+			btr_bno->bload.nr_blocks += got;
+		}
+
+		wanted = (int64_t)btr_cnt->bload.nr_blocks +
+				(min_agfl_len / 2) - cnt_blocks;
+		if (wanted > 0 && fill_agfl) {
+			got = reserve_agblocks(sc->mp, agno, btr_cnt, wanted);
+			if (wanted > got)
+				fill_agfl = false;
+			btr_cnt->bload.nr_blocks += got;
+		}
 
 		/* Ok, now how many free space records do we have? */
 		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
 	} while (1);
-
-	*extra_blocks = (bno_blocks - btr_bno->bload.nr_blocks) +
-			(cnt_blocks - btr_cnt->bload.nr_blocks);
 }
 
 /* Rebuild the free space btrees. */

