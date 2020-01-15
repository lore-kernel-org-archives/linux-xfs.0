Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CCBAC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C452465A
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aCBkh9In"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgAORDh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:03:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34818 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbgAORDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:03:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhOfc193068;
        Wed, 15 Jan 2020 17:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=zgc2pmfxRT3EDN1Y50rmDRgfceKI6bfxOw9qzDTB/CY=;
 b=aCBkh9InikH9RxHJdM3NMqecXV5Dw5rhLFIqIT+i49gxe9jBmalyW3gEtn08zzQT6itc
 2TF2iWb/yIXx+7A9geLQz7blseOx8GQe2FzJNGuc24VQmTMOsJHWdhoabTBSVlSf0eA1
 rp/MUMtrz1/QRe2DQ/PD5a5N+dLSCzV8duyXPk477lyNp+FEujqEGWx2F+J/EQpSL1ba
 ZOl6QT2eKQuEnsNOGXuJGmOS3JSip9CiAh0QnEaY333iZp+mxHSzyPYWVNz9h0QKw5bR
 ndCjLUkHqXb1KOKYsEe4xRaEIYbD87pjRqtrm3frIAN255iIM8XjbmSGLighMD6/1xTt hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xf73twbb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhwVM021561;
        Wed, 15 Jan 2020 17:03:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xj1prgn4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:26 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FH3QHK001388;
        Wed, 15 Jan 2020 17:03:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:03:25 -0800
Subject: [PATCH 5/7] xfs: complain if anyone tries to create a too-large
 buffer log item
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 15 Jan 2020 09:03:24 -0800
Message-ID: <157910780494.2028015.15375533254246477035.stgit@magnolia>
In-Reply-To: <157910777330.2028015.5017943601641757827.stgit@magnolia>
References: <157910777330.2028015.5017943601641757827.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Complain if someone calls xfs_buf_item_init on a buffer that is larger
than the dirty bitmap can handle, or tries to log a region that's past
the end of the dirty bitmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9737f177a49b..be691d1d9fad 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -763,6 +763,15 @@ xfs_buf_item_init(
 				      XFS_BLF_CHUNK);
 		map_size = DIV_ROUND_UP(chunks, NBWORD);
 
+		if (map_size > XFS_BLF_DATAMAP_SIZE) {
+			kmem_cache_free(xfs_buf_item_zone, bip);
+			xfs_err(mp,
+	"buffer item dirty bitmap (%u uints) too small to reflect %u bytes!",
+					map_size,
+					BBTOB(bp->b_maps[i].bm_len));
+			return -EFSCORRUPTED;
+		}
+
 		bip->bli_formats[i].blf_type = XFS_LI_BUF;
 		bip->bli_formats[i].blf_blkno = bp->b_maps[i].bm_bn;
 		bip->bli_formats[i].blf_len = bp->b_maps[i].bm_len;
@@ -795,6 +804,9 @@ xfs_buf_item_log_segment(
 	uint		end_bit;
 	uint		mask;
 
+	ASSERT(first < XFS_BLF_DATAMAP_SIZE * XFS_BLF_CHUNK * NBWORD);
+	ASSERT(last < XFS_BLF_DATAMAP_SIZE * XFS_BLF_CHUNK * NBWORD);
+
 	/*
 	 * Convert byte offsets to bit numbers.
 	 */

