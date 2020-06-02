Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AAAC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D81720738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uLz9R1Zn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgFBE2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:28:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35218 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBE2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:28:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524IbmZ118597;
        Tue, 2 Jun 2020 04:26:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9+pig35i9TXg2G0aeBT9F738K+Am4Uu5gLaJi3/0epQ=;
 b=uLz9R1ZnP2LFq0h2O4TFz0jYUjRfF6LTB+Req2ayh18Cz2gBzOVZUoiB69h2P/3PX8CM
 b6fTrpS3a1d8S3T3VxXLJiybvqfMeB6h2Yp/wch/POaApCbtuPimTKRaL4ShlQ6ElSDb
 x+SVfbQ7fZjBn4qE27SEFK3+ULjWdafrBRjRicg2T10dQ4andN7Qg7LglEyVbKwBoHdy
 op4p3UmUBvE1XZb8wy2CKnfW4ill7iW20bQUj6fsYwqKHd9ne9n+rLNLYfP94qnldkoF
 S2Sygf/NCJ0X9r+esSPplAcbdTlqPcdSTwKxxeZGc9jWgtpWrA5+/Wq5UHXBE9WMxKYJ hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31bfem1t9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:26:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524JDh1091096;
        Tue, 2 Jun 2020 04:26:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31c1dwgeuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:26:40 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524Qdx9020808;
        Tue, 2 Jun 2020 04:26:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:26:38 -0700
Subject: [PATCH 15/17] xfs_repair: complain about free space only seen by one
 btree
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:26:38 -0700
Message-ID: <159107199799.313760.13799578994778490839.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=2 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During the free space btree walk, scan_allocbt claims in a comment that
we'll catch FREE1 blocks (i.e. blocks that were seen by only one free
space btree) later.  This never happens, with the result that xfs_repair
in dry-run mode can return 0 on a filesystem with corrupt free space
btrees.

Found by fuzzing xfs/358 with numrecs = middlebit (or sub).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase4.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index 8197db06..a43413c7 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -306,6 +306,12 @@ phase4(xfs_mount_t *mp)
 		for (j = ag_hdr_block; j < ag_end; j += blen)  {
 			bstate = get_bmap_ext(i, j, ag_end, &blen);
 			switch (bstate) {
+			case XR_E_FREE1:
+				if (no_modify)
+					do_warn(
+	_("free space (%u,%u-%u) only seen by one free space btree\n"),
+						i, j, j + blen - 1);
+				break;
 			case XR_E_BAD_STATE:
 			default:
 				do_warn(
@@ -313,7 +319,6 @@ phase4(xfs_mount_t *mp)
 					i, j);
 				/* fall through .. */
 			case XR_E_UNKNOWN:
-			case XR_E_FREE1:
 			case XR_E_FREE:
 			case XR_E_INUSE:
 			case XR_E_INUSE_FS:

