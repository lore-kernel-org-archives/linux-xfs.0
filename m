Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FDFCA9EBB
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0979D2190F
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eMbBur+L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfKCWYb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:24:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39456 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfKCWYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:24:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOND8086445
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=zWcR5due7SAm0ZJ+J5bCqTd5ODSjMZO0l6G2YDOlu/s=;
 b=eMbBur+LEdaKKym4SiyN1b8rzO8FpP2N6fgLxXIqv4iSuDlRFlOHaF6M5q9FCMUHDrMO
 cfRMK2U+yX6AlhnfAuXVxaGNI3puaSHBV89KPT2FC+FGh+kBMll/eRfYQPq9FSttc7xC
 IRfY6Yneu450azbppbS0usz4e/n7i8/QPxOpMbBwlo/P/nhVbnVG+yA3N37bLfiSyk9v
 9aR+lQjysUXT22wAfIFUABbWiLLUvnuMBQidWVChsQtJdHV6U+pHbydeyscO1vlnoOa4
 Ryg3/vmR+R3jkdEqDn2QN16PPi84aql22uIu0ZG/DZvJp23GCMNcesXa6hyVXuLxjVIR Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w117tm5yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOMCV026368
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w1kxk9rbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:24 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA3MOCUO016398
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:24:12 -0800
Subject: [PATCH 1/6] xfs: decrease indenting problems in xfs_dabuf_map
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:24:10 -0800
Message-ID: <157281985084.4151907.11548453010559620958.stgit@magnolia>
In-Reply-To: <157281984457.4151907.11281776450827989936.stgit@magnolia>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=807
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=886 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030234
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the code that complains when a dir/attr mapping doesn't exist
but the caller requires a mapping.  This small restructuring helps us to
reduce the indenting level.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 1e2dc65adeb8..9925d4a7dc33 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2567,26 +2567,30 @@ xfs_dabuf_map(
 	}
 
 	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
-		error = mappedbno == -2 ? -1 : -EFSCORRUPTED;
-		if (unlikely(error == -EFSCORRUPTED)) {
-			if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
-				int i;
-				xfs_alert(mp, "%s: bno %lld dir: inode %lld",
-					__func__, (long long)bno,
-					(long long)dp->i_ino);
-				for (i = 0; i < *nmaps; i++) {
-					xfs_alert(mp,
+		/* Caller ok with no mapping. */
+		if (mappedbno == -2) {
+			error = -1;
+			goto out;
+		}
+
+		/* Caller expected a mapping, so abort. */
+		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
+			int i;
+
+			xfs_alert(mp, "%s: bno %lld dir: inode %lld", __func__,
+					(long long)bno, (long long)dp->i_ino);
+			for (i = 0; i < *nmaps; i++) {
+				xfs_alert(mp,
 "[%02d] br_startoff %lld br_startblock %lld br_blockcount %lld br_state %d",
-						i,
-						(long long)irecs[i].br_startoff,
-						(long long)irecs[i].br_startblock,
-						(long long)irecs[i].br_blockcount,
-						irecs[i].br_state);
-				}
+					i,
+					(long long)irecs[i].br_startoff,
+					(long long)irecs[i].br_startblock,
+					(long long)irecs[i].br_blockcount,
+					irecs[i].br_state);
 			}
-			XFS_ERROR_REPORT("xfs_da_do_buf(1)",
-					 XFS_ERRLEVEL_LOW, mp);
 		}
+		XFS_ERROR_REPORT("xfs_da_do_buf(1)", XFS_ERRLEVEL_LOW, mp);
+		error = -EFSCORRUPTED;
 		goto out;
 	}
 	error = xfs_buf_map_from_irec(mp, map, nmaps, irecs, nirecs);

