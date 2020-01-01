Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1D2C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A009C206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BGztUJNT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgAABR7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:17:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57862 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABR7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:17:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011ES7F112764
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=YACodZyoXufm8VCNygx7WPqTgicy4ucn41eUuGoZ2gc=;
 b=BGztUJNTZJngDpUWch6AOCkLB5M9IRwH3LVc1DzEsskb3BXmpE718xAG6t1xwiSH1UsD
 Lqvp4BZ+QhoD+M7HKk/GWiC6mwyzrJrN2Qz3EYH0aLXIdgGkNAVWElxzb3eeY5MC5uHu
 JYp0WGY9Xfy+EdDKnPh84TDHoUYOdpEWgL2IDNaAqvAj+vcKH3XMD2m+xXPsudGpAryW
 WGRm30fIwnWVJyQz8aEkk3EGkrzSPfX1okiAimYJoFNZX0OKAu5q6oC8toe5TiwAl277
 yrIGn08Q4yRqTPd92mXH2uEmjVuZjMPvEwshWFH3zOyUflQZcY2GENmKwvWw0QMupk9c VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk2p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vp4190291
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x8bsrg5gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:57 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011HuQr014630
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:56 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:17:56 -0800
Subject: [PATCH 15/21] xfs: dynamically create the realtime rmapbt inode
 when attaching rtdev
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:17:53 -0800
Message-ID: <157784147380.1368137.15826925395082289505.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the administrator asks us to add a realtime volume to an existing
rmap filesystem, we must allocate and attach the rtrmapbt inode to the
system prior to enabling the rt volume.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_rtalloc.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0c5fe0c04307..765f648ffe2b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -22,6 +22,7 @@
 #include "xfs_da_format.h"
 #include "xfs_imeta.h"
 #include "xfs_error.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -876,6 +877,60 @@ xfs_alloc_rsum_cache(
  * Visible (exported) functions.
  */
 
+
+/* Add a realtime rmap btree inode. */
+STATIC int
+xfs_growfs_rt_rmap(
+	struct xfs_mount	*mp)
+{
+	struct xfs_imeta_end	ic;
+	struct xfs_inode	*ip = NULL;
+	struct xfs_trans	*tp;
+	int			error;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb) || mp->m_rrmapip != NULL)
+		return 0;
+
+	/* rtrmapbt requires metadir */
+	if (!xfs_sb_version_hasmetadir(&mp->m_sb))
+		return -EINVAL;
+
+	/* Ensure the path to the rtrmapbt inode exists. */
+	error = xfs_imeta_ensure_dirpath(mp, &XFS_IMETA_RTRMAPBT);
+	if (error)
+		return error;
+
+	/* Create the rtrmapbt inode. */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			xfs_imeta_create_space_res(mp), 0, 0, &tp);
+	if (error)
+		return error;
+
+	error = xfs_rtrmapbt_create(&tp, &ic, &ip);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_trans_commit(tp);
+	xfs_finish_inode_setup(ip);
+	xfs_imeta_end_update(mp, &ic, error);
+	if (error) {
+		xfs_irele(ip);
+		return error;
+	}
+
+	mp->m_rrmapip = ip;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_imeta_end_update(mp, &ic, error);
+	if (ip) {
+		xfs_finish_inode_setup(ip);
+		xfs_irele(ip);
+	}
+	return error;
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -955,6 +1010,9 @@ xfs_growfs_rt(
 	if (error)
 		return error;
 	error = xfs_growfs_rt_alloc(mp, rsumblocks, nrsumblocks, mp->m_rsumip);
+	if (error)
+		return error;
+	error = xfs_growfs_rt_rmap(mp);
 	if (error)
 		return error;
 

