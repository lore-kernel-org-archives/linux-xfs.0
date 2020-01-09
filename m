Return-Path: <SRS0=Nxvu=26=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37BCC282DD
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4BEF20678
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YBXb/Exc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732174AbgAISpM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 13:45:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729778AbgAISpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jan 2020 13:45:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009IdE0g139941
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=FHq5iM1jUbaXN5sMFb98Gn8RLEvZOLRF0Bdq6ebn7FI=;
 b=YBXb/ExcKb3dmg0RzpYXCLufues9eA03vqfyDb63IcPsp7nfdE4RjJ2MZHhE+I1/6pJ0
 h6khrAIEMk3ijWkOv5Gdi1XxEMqiJ3q9bppPduo0pkBlCXbgsZad1KNu7AmA8iez6fMt
 o7cP2O14XYNOBHXwYUlnHlIqJIZmbhblOK5NH6XEkPFu2oWYc5KdjRUmeSVlv/dzL4gy
 DAyotsNhHCtcF6a09Qyc7YCM618JK0wvSvsawXKjeNOkmp++WEc4kvlp6gsj3cwpkklS
 EuGtnM2qzfgDACVy1Cwbq8BwW6VIum6+SVOuI5yXMhcxxBh3kdRX+zdjTu1ObPktIhfV Fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbr4puf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:45:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009IdDPO171425
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:45:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xdmryufc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:45:10 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 009Ij9pC026646
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:45:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 10:45:08 -0800
Subject: [PATCH 4/5] xfs: complain if anyone tries to create a too-large
 buffer log item
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 09 Jan 2020 10:45:08 -0800
Message-ID: <157859550791.164065.17052138010295333685.stgit@magnolia>
In-Reply-To: <157859548029.164065.5207227581806532577.stgit@magnolia>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001090154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001090154
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

