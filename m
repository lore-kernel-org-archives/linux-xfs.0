Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C297C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 424A4206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o0dZXUXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgAABRy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:17:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57782 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABRx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:17:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EQUf112696
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=8r8wsZ+6lFSxzUrlosO7mhAPNe2pWkxWM7PtbrezdCc=;
 b=o0dZXUXuxOYdIrL0lRxnhpWH7zKKe+IWIzKeIYeSdoUEnH2oP71tdJdCG/8bC0trvSUE
 Jp8XNSkgzvo97BljyapETJrSlm3Php+TnoyCNMFAINRC7ADnjxG268G5z+n9C6Ltjc8Z
 MxC3lhqdq6wSfdLD0CcVx+hEx82L/o6s7ydOs2/RKCHMr29+z4V8yhPMk0N1453sfYos
 ieO0sIBBFPmUsI01kzgnkKipwCo+CjfHgvbGc8nbaQnL5ZerLUeTsllFP9wP7lKK4Uy/
 IFv4u5np8FKCO1mrG2hPM5A8fCu5UPdzS92TNo5x4NZDIvUBpYvc2TqdKfChVQfelU1A 6A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk2p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uIG045280
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x7medfggw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Honw024704
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:50 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:17:50 -0800
Subject: [PATCH 14/21] xfs: create routine to allocate and initialize a
 realtime rmap btree inode
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:17:47 -0800
Message-ID: <157784146773.1368137.10722362288135408498.stgit@magnolia>
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

Create a library routine to allocate and initialize an empty realtime
rmapbt inode.  We'll use this for growfs, mkfs, and repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   42 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    5 +++++
 2 files changed, 47 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 647ae157fc98..d96d48e44631 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -25,6 +25,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_imeta.h"
 
 /*
  * Realtime Reverse map btree.
@@ -791,3 +792,44 @@ xfs_rtrmapbt_to_disk(
 		memcpy(trp, frp, sizeof(*frp) * dmxr);
 	}
 }
+
+/*
+ * Create a realtime rmap btree inode.  The caller must clean up @ic and
+ * release the inode stored in @ipp (if it isn't NULL) regardless of the return
+ * value.
+ */
+int
+xfs_rtrmapbt_create(
+	struct xfs_trans	**tpp,
+	struct xfs_imeta_end	*ic,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = (*tpp)->t_mountp;
+	struct xfs_inode	*ip;
+	struct xfs_btree_block	*block;
+	xfs_ino_t		ino = NULLFSINO;
+	int			error;
+
+	*ipp = NULL;
+	error = xfs_imeta_lookup(mp, &XFS_IMETA_RTRMAPBT, &ino);
+	if (error)
+		return error;
+	if (ino != NULLFSINO)
+		return -EEXIST;
+
+	error = xfs_imeta_create(tpp, &XFS_IMETA_RTRMAPBT, S_IFREG, ipp, ic);
+	if (error)
+		return error;
+
+	ip = *ipp;
+	ip->i_d.di_format = XFS_DINODE_FMT_RMAP;
+	ASSERT(ip->i_df.if_broot_bytes == 0);
+	ASSERT(ip->i_df.if_bytes == 0);
+	ip->i_df.if_broot_bytes = XFS_RTRMAP_BROOT_SPACE_CALC(0, 0);
+	ip->i_df.if_broot = kmem_alloc(ip->i_df.if_broot_bytes, KM_NOFS);
+	block = ip->i_df.if_broot;
+	block->bb_numrecs = cpu_to_be16(0);
+	block->bb_level = cpu_to_be16(0);
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 857b576d5b08..ad5c0452f5fe 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -101,4 +101,9 @@ void xfs_rtrmapbt_to_disk(struct xfs_mount *mp,
 		struct xfs_btree_block *rblock, int rblocklen,
 		struct xfs_rtrmap_root *dblock, int dblocklen);
 
+struct xfs_imeta_end;
+
+int xfs_rtrmapbt_create(struct xfs_trans **tpp, struct xfs_imeta_end *ic,
+		struct xfs_inode **ipp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */

