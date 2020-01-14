Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D0AC33CA9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88DCD20678
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:32:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="axgqzBCL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgANGcI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 01:32:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36526 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgANGcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 01:32:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6CqHe155463;
        Tue, 14 Jan 2020 06:31:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=zgc2pmfxRT3EDN1Y50rmDRgfceKI6bfxOw9qzDTB/CY=;
 b=axgqzBCLw02LlfdNs38rjXp3cAV2Ir1NMBf0tY4Av0GSXEuYG+BsqmtimFY/ysJfBOiE
 ybpgW8jZSWN1aJuzQ2ewyNeF+ljRnCO8oYdnpoolUFXxQt2hVOWghgETr+I2503qX7+3
 U/f6phBZojJwnISz58DcAso1SEoAvOYP1u7MXhLyWaZeCl8lK+VA44JiSxVL+a/2UqHi
 yhoq2GVdD7g4BpW5jwFh7RhqsfYnxo1Gs6smyplFIrx2Uct6Kls9xzFTWXdTgK2Ow/lA
 IkpkuYcPYMzYJW0nSS3C//V/v2hOWLI2Dot+D6lNrbV92/5ZbeZAVJmJcOU783kWfxRc yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xf74s3ufy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:31:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6UxAF016974;
        Tue, 14 Jan 2020 06:31:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xh8erg0xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:31:58 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00E6VvcD001456;
        Tue, 14 Jan 2020 06:31:57 GMT
Received: from localhost (/10.159.236.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 22:31:57 -0800
Subject: [PATCH 4/6] xfs: complain if anyone tries to create a too-large
 buffer log item
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Date:   Mon, 13 Jan 2020 22:31:57 -0800
Message-ID: <157898351709.1566005.2980159067952563739.stgit@magnolia>
In-Reply-To: <157898348940.1566005.3231891474158666998.stgit@magnolia>
References: <157898348940.1566005.3231891474158666998.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001140056
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001140055
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

