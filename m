Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE08C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD4DE22CED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PHS00NxX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbfIDEjR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:39:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54688 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfIDEjR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:39:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cZIY028267;
        Wed, 4 Sep 2019 04:39:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RN4NpqUCguKGNvXxhRafiafhimobEpl7EvJuFz0NaqY=;
 b=PHS00NxX6WzwiF5fwWDJ+9SmFZWxnCnKtrYc5Jc95Kv70BsOYfzmLXiFVhWVhMlC1GQ2
 /ApompwoaU9K0PUpMmFgetnKw5zePylIAlnaQk+ipn0sx7M9RFQDPVrQ9SeY6nWKA8in
 4j8tr8qIvf0XrzBgmLRyXeN/5LpaiuhxN4iRBCySNsWm51+MmrTPWLIaE+INw6gMv3Zl
 7gXGHjOxeR8f7o6x8ZT7iYdSqpg1Dnf4UdLuG9H7ir5bsSpByt4a/uJ4JEKOnxgpBHqF
 Jv205GfqM+3Ba335aeV5ZOvmXeeYyjsCi0zOGpxMjPbBTd8zfEY9V8haneHtOrDBQfgU 2g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ut6ds006x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:39:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cZ6e035633;
        Wed, 4 Sep 2019 04:39:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2usu51c6fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:39:14 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844cD0b016612;
        Wed, 4 Sep 2019 04:38:13 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:38:13 -0700
Subject: [PATCH 10/10] xfs_repair: add AG btree rmaps into the filesystem
 after syncing sb
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:38:12 -0700
Message-ID: <156757189224.1838441.6843620202811391667.stgit@magnolia>
In-Reply-To: <156757182283.1838441.193482978701233436.stgit@magnolia>
References: <156757182283.1838441.193482978701233436.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In rmap_store_ag_btree_rec(), we try to reserve 16 blocks to handle
adding all the AG btree rmaps to the rmap record.  Unfortunately, at
that point in phase5 we haven't yet reinitialied sb_fdblocks, so
reserving blocks can fail if repair reconstructed the primary sb from a
secondary sb.  Even if the function succeeds, this still leads to
incorrect fdblocks because phase 5 resets sb_fdblocks after running the
rmap transactions.

To avoid all this, move the rmap_store_ag_btree_rec call to after the sb
has been reset.  xfs/350 was helpful in finding cases where xfs_repair
errored out while repairing the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 2e18cc69..7f7d3d18 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2233,7 +2233,6 @@ phase5_func(
 #endif
 	xfs_agblock_t	num_extents;
 	struct agi_stat	agi_stat = {0,};
-	int		error;
 
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);
@@ -2426,14 +2425,6 @@ phase5_func(
 			finish_cursor(&fino_btree_curs);
 		finish_cursor(&bcnt_btree_curs);
 
-		/*
-		 * Put the per-AG btree rmap data into the rmapbt
-		 */
-		error = rmap_store_ag_btree_rec(mp, agno);
-		if (error)
-			do_error(
-_("unable to add AG %u reverse-mapping data to btree.\n"), agno);
-
 		/*
 		 * release the incore per-AG bno/bcnt trees so
 		 * the extent nodes can be recycled
@@ -2561,6 +2552,21 @@ phase5(xfs_mount_t *mp)
 	 */
 	sync_sb(mp);
 
+	/*
+	 * Put the per-AG btree rmap data into the rmapbt now that we've reset
+	 * the superblock counters.
+	 */
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = rmap_store_ag_btree_rec(mp, agno);
+		if (error)
+			do_error(
+_("unable to add AG %u reverse-mapping data to btree.\n"), agno);
+	}
+
+	/*
+	 * Put blocks that were unnecessarily reserved for btree
+	 * reconstruction back into the filesystem free space data.
+	 */
 	error = inject_lost_blocks(mp, lost_fsb);
 	if (error)
 		do_error(_("Unable to reinsert lost blocks into filesystem.\n"));

