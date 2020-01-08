Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37BDFC33C9B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088192067D
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:19:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R7l7UPZ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgAHETZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:19:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49280 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgAHETZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 23:19:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JKMm026771
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=0YTjrK1Y/VjjRU+qvZyyDez58iVQ91n5CAscoCCl4vA=;
 b=R7l7UPZ2/dNC8YpQMSzdwiH6ZF95aDrw5u+LUkFMfAuShsIDqji3t8e6oHoiDBqH1vkH
 FCygdMCzVvtE6xj5IGmsajy+xKUecRWIJc8CvpNaVCkRWRUJk2QWQh2ZmfLHQOhZs1cy
 1Rb6w+RE3UreOghPA41G6gk+dFBg3oWytrvLdj6n5vzhdT2g+ZXSN7h3iV4vFvVgaCLG
 wFB74WErx8N7k3lRFUzrNJLTJ4YbL+bWSfOb2514A6MbhNWnJUWJpI8BgPpE1QqVjZx4
 P+1G4Ov+JzRWocFhNTR/XWruu9iAkJuyc8dPgOftZ1LXaqJ+G2oFoecNZjLHh9Pmre9z /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xajnq1enm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:19:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JDvQ073143
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:19:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xcpcrrxq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:19:15 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0084ILOM018570
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:18:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 20:18:20 -0800
Subject: [PATCH 2/3] xfs: complain if anyone tries to create a too-large
 buffer log item
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 07 Jan 2020 20:18:19 -0800
Message-ID: <157845709897.84011.1433283906403215456.stgit@magnolia>
In-Reply-To: <157845708352.84011.17764262087965041304.stgit@magnolia>
References: <157845708352.84011.17764262087965041304.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080037
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Complain if someone calls xfs_buf_item_init on a buffer that is larger
than the dirty bitmap can handle, or tries to log a region that's past
the end of the dirty bitmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3984779e5911..bfbe8a5b8959 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -761,18 +761,25 @@ xfs_buf_item_init(
 	 * buffer. This makes the implementation as simple as possible.
 	 */
 	error = xfs_buf_item_get_format(bip, bp->b_map_count);
-	ASSERT(error == 0);
-	if (error) {	/* to stop gcc throwing set-but-unused warnings */
-		kmem_cache_free(xfs_buf_item_zone, bip);
-		return error;
+	if (error) {
+		xfs_err(mp, "could not allocate buffer item, err=%d", error);
+		goto err;
 	}
 
-
 	for (i = 0; i < bip->bli_format_count; i++) {
 		chunks = DIV_ROUND_UP(BBTOB(bp->b_maps[i].bm_len),
 				      XFS_BLF_CHUNK);
 		map_size = DIV_ROUND_UP(chunks, NBWORD);
 
+		if (map_size > XFS_BLF_DATAMAP_SIZE) {
+			xfs_err(mp,
+	"buffer item dirty bitmap (%u uints) too small to reflect %u bytes!",
+					map_size,
+					BBTOB(bp->b_maps[i].bm_len));
+			error = -EFSCORRUPTED;
+			goto err;
+		}
+
 		bip->bli_formats[i].blf_type = XFS_LI_BUF;
 		bip->bli_formats[i].blf_blkno = bp->b_maps[i].bm_bn;
 		bip->bli_formats[i].blf_len = bp->b_maps[i].bm_len;
@@ -782,6 +789,9 @@ xfs_buf_item_init(
 	bp->b_log_item = bip;
 	xfs_buf_hold(bp);
 	return 0;
+err:
+	kmem_cache_free(xfs_buf_item_zone, bip);
+	return error;
 }
 
 
@@ -805,6 +815,9 @@ xfs_buf_item_log_segment(
 	uint		end_bit;
 	uint		mask;
 
+	ASSERT(first < XFS_BLF_DATAMAP_SIZE * XFS_BLF_CHUNK * NBWORD);
+	ASSERT(last < XFS_BLF_DATAMAP_SIZE * XFS_BLF_CHUNK * NBWORD);
+
 	/*
 	 * Convert byte offsets to bit numbers.
 	 */

