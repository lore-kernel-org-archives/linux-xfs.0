Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630D1C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 04:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3550321582
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 04:24:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UzdVQYkh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfLREYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 23:24:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42298 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLREYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 23:24:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI4OGrE149822;
        Wed, 18 Dec 2019 04:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=prEGOIZY3WeNDPXcT4Zix/eP2mrdNN8EPiI3jgh/qjA=;
 b=UzdVQYkhdpATAZsziobWUDxlc7FVa3u5bw6sGK69XOgl8knwlusS1HnJs0WmyaSF/JnR
 oLjte7kGf1jRLSAFhYkxZEr69MYrOZ7Ka8NUHTh/wyNbNgfoDdeE9JBqKhtQ5YvfQuTH
 h1s1Wxsua5jREHZCwqo98QJwEM9ELcQsei/XbOk1pWQP2NMvzKLsk8OHc6YC7jTuVL5V
 +H+UQqY2Wmv/44nJB+RKkrPqxIEv04o8t6D7Cv1kv9RqVMFcXhI3p7K4Jonrb1jigf+/
 fQrBJZsUiYoz+xedGxPLQB8m9ZNP/pXNM4tXQQ/battrwkfJdLj9H9/evFTyqEqS3Yza rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wvqpqb1ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 04:24:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI4OEds024915;
        Wed, 18 Dec 2019 04:24:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wxm75mp94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 04:24:19 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBI4O4lY022392;
        Wed, 18 Dec 2019 04:24:04 GMT
Received: from localhost (/10.159.137.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 20:24:03 -0800
Date:   Tue, 17 Dec 2019 20:24:02 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_repair: fix totally broken unit conversion in directory
 invalidation
Message-ID: <20191218042402.GL12765@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180033
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Your humble author forgot that xfs_dablk_t has the same units as
xfs_fileoff_t, and totally screwed up the directory buffer invalidation
loop in dir_binval.  Not only is there an off-by-one error in the loop
conditional, but the unit conversions are wrong.

Fix all this stupidity by adding a for loop macro to take care of these
details for us so that everyone can iterate all logical directory blocks
(xfs_dir2_db_t) that start within a given bmbt record.

The pre-5.5 xfs_da_get_buf implementation mostly hides the off-by-one
error because dir_binval turns on "don't complain if no mapping" mode,
but on dirblocksize > fsblocksize filesystems the incorrect units can
cause us to miss invalidating some blocks, which can lead to other
buffer cache errors later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_dir2.h |   10 ++++++++++
 repair/phase6.c   |    8 ++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index f5424477..13221243 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -308,6 +308,16 @@ xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
 		  sizeof(struct xfs_dir2_leaf_tail));
 }
 
+/*
+ * For a given dir/attr geometry and extent mapping record, walk every file
+ * offset block (xfs_dablk_t) in the mapping that corresponds to the start
+ * of a logical directory block (xfs_dir2_db_t).
+ */
+#define for_each_xfs_bmap_dabno(geo, irec, dabno) \
+	for ((dabno) = round_up((irec)->br_startoff, (geo)->fsbcount); \
+	     (dabno) < (irec)->br_startoff + (irec)->br_blockcount; \
+	     (dabno) += (geo)->fsbcount)
+
 /*
  * The Linux API doesn't pass down the total size of the buffer
  * we read into down to the filesystem.  With the filldir concept
diff --git a/repair/phase6.c b/repair/phase6.c
index 91d208a6..a4dd3188 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1276,7 +1276,7 @@ dir_binval(
 	struct xfs_ifork	*ifp;
 	struct xfs_da_geometry	*geo;
 	struct xfs_buf		*bp;
-	xfs_dablk_t		dabno, end_dabno;
+	xfs_dablk_t		dabno;
 	int			error = 0;
 
 	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
@@ -1286,11 +1286,7 @@ dir_binval(
 	geo = tp->t_mountp->m_dir_geo;
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	for_each_xfs_iext(ifp, &icur, &rec) {
-		dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
-				geo->fsbcount - 1);
-		end_dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
-				rec.br_blockcount);
-		for (; dabno <= end_dabno; dabno += geo->fsbcount) {
+		for_each_xfs_bmap_dabno(geo, &rec, dabno) {
 			bp = NULL;
 			error = -libxfs_da_get_buf(tp, ip, dabno, -2, &bp,
 					whichfork);
