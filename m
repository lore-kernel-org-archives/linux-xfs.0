Return-Path: <SRS0=UWJz=XS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45194C432C1
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 23:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1652D20578
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 23:52:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W3BZeWBH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391342AbfIWXwm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 19:52:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45830 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729276AbfIWXwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Sep 2019 19:52:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NNn2ZU182889;
        Mon, 23 Sep 2019 23:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=z8v6pRKfgeAMh8a2cn4fAW4RJmRihCQkoJSet/YC1QA=;
 b=W3BZeWBHMvwuN+n8GHtK4GOPcRorgZZ+W0DUOhcR/WY4DrXwSPfrquNnD8LrgMku8SpD
 2fBKVIZsc0kuhfp7yHou5l2K0nyXdmwml6EScsurCJ6N7wQDDtS4TKJqy1LktO7lsy9u
 ZA9EbFsX2G2UEIF9NezIhM7wqqpXtZh5yyRMLfxo3XJf6asUNntzqXn7pZhajGDuChpu
 XaztGYLCHYPfPxZWhAMGzw8vvMyWL8jPeKG5BqtnS3dgH37WUau1CBcqO0GoApVbKiCK
 Xnk1dS69+MycvMmoHqb8Cz74pUKK0LJ6bsT6iSau5fJSO1BoNFpl2qONIxtAU1Rycq7F cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgqt313-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 23:52:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NNm8S7030146;
        Mon, 23 Sep 2019 23:52:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2v6yvm4v6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 23:52:26 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8NNqPW1006429;
        Mon, 23 Sep 2019 23:52:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 16:52:25 -0700
Date:   Mon, 23 Sep 2019 16:52:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: revert 1baa2800e62d ("xfs: remove the unused
 XFS_ALLOC_USERDATA flag")
Message-ID: <20190923235224.GW2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909230204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909230204
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Revert this commit, as it caused periodic regressions in xfs/173 w/
1k blocks[1].

[1] https://lore.kernel.org/lkml/20190919014602.GN15734@shao2-debian/

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.h |    7 ++++---
 fs/xfs/libxfs/xfs_bmap.c  |    8 ++++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 58fa85cec325..d6ed5d2c07c2 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -81,9 +81,10 @@ typedef struct xfs_alloc_arg {
 /*
  * Defines for datatype
  */
-#define XFS_ALLOC_INITIAL_USER_DATA	(1 << 0)/* special case start of file */
-#define XFS_ALLOC_USERDATA_ZERO		(1 << 1)/* zero extent on allocation */
-#define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
+#define XFS_ALLOC_USERDATA		(1 << 0)/* allocation is for user data*/
+#define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
+#define XFS_ALLOC_USERDATA_ZERO		(1 << 2)/* zero extent on allocation */
+#define XFS_ALLOC_NOBUSY		(1 << 3)/* Busy extents not allowed */
 
 static inline bool
 xfs_alloc_is_userdata(int datatype)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index eaf2d4250a26..4edc25a2ba80 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4042,8 +4042,12 @@ xfs_bmapi_allocate(
 	 */
 	if (!(bma->flags & XFS_BMAPI_METADATA)) {
 		bma->datatype = XFS_ALLOC_NOBUSY;
-		if (whichfork == XFS_DATA_FORK && bma->offset == 0)
-			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
+		if (whichfork == XFS_DATA_FORK) {
+			if (bma->offset == 0)
+				bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
+			else
+				bma->datatype |= XFS_ALLOC_USERDATA;
+		}
 		if (bma->flags & XFS_BMAPI_ZERO)
 			bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
 	}
