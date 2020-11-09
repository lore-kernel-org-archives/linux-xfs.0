Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99017C388F7
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60AEA206A1
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:20:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ebwwiHAb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgKISUD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:20:03 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57608 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729292AbgKISUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Nov 2020 13:20:02 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IAMoe121308;
        Mon, 9 Nov 2020 18:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5lrFpoi3KjtnPanKYJ5V5VVZUl90Ss/7pGOK4+ciTm8=;
 b=ebwwiHAbwsFdEdIv3F7/agR87hxGitzpGU9J/Y06YzkIrSonAVAYmeOop/jebM4BZ8vi
 vue0FVS6W8swiYwequiOQ3NoaZBhWaNS7uoGxUFyiiyB/Tml/rKsATSi3HeOqnDcwgW3
 NO0b4zy/UeOhCxZubALg7cxdJx27ivcKANPKRFAiHc2H3tsuGhVvQp2MvB/0HCO35ZX7
 PYQlSCE7QUYq9aKFcdJoBz1ubv7KlO8Rs9Hy/GO46zt+3hQuoo8YsCrUMTlfBDNpPEQx
 sstHVjAJeG9QolCHO1vp+FJFDCcsdqnFl7V70WZKsLR1rhkKXbJCbxkjrYFP3e7Awomh Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3aqnnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 18:20:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IB2Ld136807;
        Mon, 9 Nov 2020 18:17:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34p5bqv21n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 18:17:59 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A9IHxwi027416;
        Mon, 9 Nov 2020 18:17:59 GMT
Received: from localhost (/10.159.239.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 10:17:58 -0800
Subject: [PATCH 4/4] xfs: directory scrub should check the null bestfree
 entries too
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 09 Nov 2020 10:17:58 -0800
Message-ID: <160494587794.772802.11043398495774645870.stgit@magnolia>
In-Reply-To: <160494585293.772802.13326482733013279072.stgit@magnolia>
References: <160494585293.772802.13326482733013279072.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach the directory scrubber to check all the bestfree entries,
including the null ones.  We want to be able to detect the case where
the entry is null but there actually /is/ a directory data block.

Found by fuzzing lbests[0] = ones in xfs/391.

Fixes: df481968f33b ("xfs: scrub directory freespace")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 7c432997edad..b045e95c2ea7 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -558,14 +558,27 @@ xchk_directory_leaf1_bestfree(
 	/* Check all the bestfree entries. */
 	for (i = 0; i < bestcount; i++, bestp++) {
 		best = be16_to_cpu(*bestp);
+		error = xfs_dir3_data_read(sc->tp, sc->ip,
+				xfs_dir2_db_to_da(args->geo, i),
+				XFS_DABUF_MAP_HOLE_OK,
+				&dbp);
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
+				&error))
+			break;
+
+		if (!dbp) {
+			if (best != NULLDATAOFF) {
+				xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
+						lblk);
+				break;
+			}
+			continue;
+		}
+
 		if (best == NULLDATAOFF)
-			continue;
-		error = xfs_dir3_data_read(sc->tp, sc->ip,
-				i * args->geo->fsbcount, 0, &dbp);
-		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
-				&error))
-			break;
-		xchk_directory_check_freesp(sc, lblk, dbp, best);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		else
+			xchk_directory_check_freesp(sc, lblk, dbp, best);
 		xfs_trans_brelse(sc->tp, dbp);
 		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 			break;

