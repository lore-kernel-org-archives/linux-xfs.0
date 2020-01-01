Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5A8C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0CA1206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:18:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TsxUa/PO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAABSM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:18:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53522 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABSM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:18:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EsqT094499
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=jiSye68SX84mgstKFzXGthMgYsaGOOp6cCx5lvwr0os=;
 b=TsxUa/PO2gIi/ahXSSrIRsOsyzgJ+h+VmkYhoaKNX+X7hTfgUMhDsyZ/6MMhDw1Nq2qI
 1ksqidUnem7YyHYxY1wztIRQhXtzgTvql8UUhnZu6O6sYidSyQ1ujXHSr8gI04V3+GlA
 FLPO1z+8o2dYxsTylP1u9UYOxkHAJrTAKNsfgr9UVWqrZ0ym+20nNHEAAtUbBHQ/4B1x
 HfiXuD+4v0Bs07hcBkP9zYsysO2dUD/YNz2xrQVo3cyXY7bsRLchZFVXMZMyEgavneA6
 CHzwZ40VC2qVkcRmAGPzH84bOWiaeN+AllLWkt1nuD1cqxSiuKIDnhZe6i0hTK9biesp vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:18:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011I9dT056970
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2x7medfgnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:18:09 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011I8C2002385
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:08 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:18:08 -0800
Subject: [PATCH 17/21] xfs: wire up getfsmap to the realtime reverse mapping
 btree
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:18:06 -0800
Message-ID: <157784148602.1368137.3512787997585276398.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Connect the getfsmap ioctl to the realtime rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 918456ca29e1..b4d23f023520 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -24,6 +24,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_rtalloc.h"
+#include "xfs_rtrmap_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 void
@@ -547,7 +548,65 @@ xfs_getfsmap_rtdev_rtbitmap(
 	return __xfs_getfsmap_rtdev(tp, keys, xfs_getfsmap_rtdev_rtbitmap_query,
 			info);
 }
-#endif /* CONFIG_XFS_RT */
+
+/* Transform a absolute-startblock rmap (rtdev, logdev) into a fsmap */
+STATIC int
+xfs_getfsmap_rtdev_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_getfsmap_info	*info = priv;
+	xfs_daddr_t			rec_daddr;
+
+	rec_daddr = XFS_FSB_TO_BB(mp, rec->rm_startblock);
+
+	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
+}
+
+/* Actually query the rtrmap btree. */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt_query(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*bt_cur;
+	int				error;
+
+	/* Query the rtrmapbt */
+	xfs_ilock(mp->m_rrmapip, XFS_ILOCK_SHARED);
+	bt_cur = xfs_rtrmapbt_init_cursor(mp, tp, mp->m_rrmapip);
+	error = xfs_rmap_query_range(bt_cur, &info->low, &info->high,
+			xfs_getfsmap_rtdev_helper, info);
+	if (error)
+		goto err;
+
+	/* Report any gaps at the end of the rtrmapbt */
+	info->last = true;
+	error = xfs_getfsmap_rtdev_helper(bt_cur, &info->high, info);
+	if (error)
+		goto err;
+
+err:
+	xfs_btree_del_cursor(bt_cur, error);
+	xfs_iunlock(mp->m_rrmapip, XFS_ILOCK_SHARED);
+	return error;
+}
+
+/* Execute a getfsmap query against the realtime device rmapbt. */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt(
+	struct xfs_trans		*tp,
+	struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	info->missing_owner = XFS_FMR_OWN_FREE;
+	return __xfs_getfsmap_rtdev(tp, keys, xfs_getfsmap_rtdev_rmapbt_query,
+			info);
+}
+#endif
 
 /* Execute a getfsmap query against the regular data device. */
 STATIC int
@@ -851,7 +910,10 @@ xfs_getfsmap(
 #ifdef CONFIG_XFS_RT
 	if (mp->m_rtdev_targp) {
 		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
-		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
+		if (use_rmap)
+			handlers[2].fn = xfs_getfsmap_rtdev_rmapbt;
+		else
+			handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
 	}
 #endif /* CONFIG_XFS_RT */
 

