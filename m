Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E7D2C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F26D2064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d6J1ZuoY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgAABJi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53288 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABJi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119bYH109853
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=CagbB94odETlEZcrFpS621J9eybQAQZHkRNViqrmyk8=;
 b=d6J1ZuoYfJm8G7K/sDI/UFB+gytyqbOa/TzaK6dnTn2Td3Aq9jvrLMqWWAYEPhR0jnHR
 wogLDrfLt8RuS9yEmSiI8RQeHAkkg8mXSZ19K1Qbxc4USqHJKnMoOu22EATYLBHXLNp3
 BLop6/El+G0L7/QxRWLFxo2eedsMPn10tTygnGQy+JQsOXof/x6vuI0epIE3e3lEGpWR
 KbBiEKzfErsRJ1g0xHnNuJjgd4Hhc/TcUn6OasBeqRAvXSS1p5SVOWeJwuIraVk45qYD
 A+9uTa9xQu02Yg7/6FJKFEcSmYvhkDXn6QhUWZylNIj1/weZLkUcxF3WRXff8SICAPY0 iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xKL012522
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x8gueedrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:36 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00119Xku031579
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:33 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:09:32 -0800
Subject: [PATCH 08/10] xfs: force inactivation before fallocate when space
 is low
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:09:29 -0800
Message-ID: <157784096970.1362752.7717767986299881332.stgit@magnolia>
In-Reply-To: <157784092020.1362752.15046503361741521784.stgit@magnolia>
References: <157784092020.1362752.15046503361741521784.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=926
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=976 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we think that inactivation will free enough blocks to make it easier
to satisfy an fallocate request, force inactivation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 6553d533d659..5b66f89d5f36 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -28,6 +28,7 @@
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_sb.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -697,6 +698,41 @@ xfs_free_eofblocks(
 	return error;
 }
 
+/*
+ * If we suspect that the target device isn't going to be able to satisfy the
+ * entire request, try forcing inode inactivation to free up space.  While it's
+ * perfectly fine to fill a preallocation request with a bunch of short
+ * extents, we'd prefer to do the inactivation work now to combat long term
+ * fragmentation in new file data.
+ */
+static void
+xfs_alloc_reclaim_inactive_space(
+	struct xfs_mount	*mp,
+	bool			is_rt,
+	xfs_filblks_t		allocatesize_fsb)
+{
+	struct xfs_perag	*pag;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_extlen_t		free;
+	xfs_agnumber_t		agno;
+
+	if (is_rt) {
+		if (sbp->sb_frextents * sbp->sb_rextsize >= allocatesize_fsb)
+			return;
+	} else {
+		for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+			pag = xfs_perag_get(mp, agno);
+			free = pag->pagf_freeblks;
+			xfs_perag_put(pag);
+
+			if (free >= allocatesize_fsb)
+				return;
+		}
+	}
+
+	xfs_inactive_force(mp);
+}
+
 int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
@@ -786,6 +822,8 @@ xfs_alloc_file_space(
 			quota_flag = XFS_QMOPT_RES_REGBLKS;
 		}
 
+		xfs_alloc_reclaim_inactive_space(mp, rt, allocatesize_fsb);
+
 		/*
 		 * Allocate and setup the transaction.
 		 */

