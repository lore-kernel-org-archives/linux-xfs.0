Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A25C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EC7D20706
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yn6gvK2b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388930AbgFYBSM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:18:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48974 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388863AbgFYBSL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 21:18:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P188IB082651;
        Thu, 25 Jun 2020 01:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EZ4f9Tu2NRK3pLKw5+LDrPtXdh5idm6nps41MOIKoho=;
 b=yn6gvK2bAtbCgcupbxJuvRLxPELJK/BUGWpo9T6WrBWbpOYtHcr+TaktwXtjjAM/fRVy
 i9tYfxm46QBz22T986tgkoByZFgH56c8kjvP/4gkFkSlxNiHPwdZRMdwvlu/BRkDOFN0
 Qz/+v28nPjNuHhRDuIzk/UCXVwGU11r55qv3ndUEiogGMzmb0/KECv4JE/CIhHAM9Ozx
 FHc2hbHCTAvANNTFnXO/4pmRiECjHp39fACF5/NclBYh3wKsyiIzX50gF08HU9iypftU
 TluVFJfI1hd3naqwJxzY/sFEx3KQSj52fWLOhzgn1LUaJ5HcwVrYz6XjH9mQAdLuBYfU uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31uut5nux4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 01:18:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P18XcD014121;
        Thu, 25 Jun 2020 01:18:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31uur85awd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 01:18:08 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05P1I7DK013056;
        Thu, 25 Jun 2020 01:18:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 01:18:07 +0000
Subject: [PATCH 4/9] xfs: only reserve quota blocks for bmbt changes if we're
 changing the data fork
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Date:   Wed, 24 Jun 2020 18:18:06 -0700
Message-ID: <159304788616.874036.5580426142663484238.stgit@magnolia>
In-Reply-To: <159304785928.874036.4735877085735285950.stgit@magnolia>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=1
 phishscore=0 impostorscore=0 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've reworked xfs_reflink_remap_extent to remap only one
extent per transaction, we actually know if the extent being removed is
an allocated mapping.  This means that we now know ahead of time if
we're going to be touching the data fork.

Since we only need blocks for a bmbt split if we're going to update the
data fork, we only need to get quota reservation if we know we're going
to touch the data fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c593d52156df..9cc1c340d0ec 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1043,7 +1043,11 @@ xfs_reflink_remap_extent(
 	 * Compute quota reservation if we think the quota block counter for
 	 * this file could increase.
 	 *
-	 * We start by reserving enough blocks to handle a bmbt split.
+	 * Adding a written extent to the extent map can cause a bmbt split,
+	 * and removing a mapped extent from the extent can cause a bmbt split.
+	 * The two operations cannot both cause a split since they operate on
+	 * the same index in the bmap btree, so we only need a reservation for
+	 * one bmbt split if either thing is happening.
 	 *
 	 * If we are mapping a written extent into the file, we need to have
 	 * enough quota block count reservation to handle the blocks in that
@@ -1056,8 +1060,9 @@ xfs_reflink_remap_extent(
 	 * before we started.  That should have removed all the delalloc
 	 * reservations, but we code defensively.
 	 */
-	qdelta = 0;
-	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	qres = qdelta = 0;
+	if (smap_mapped || dmap_written)
+		qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	if (dmap_written)
 		qres += dmap->br_blockcount;
 	if (qres > 0) {

