Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBDDC2D0DD
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71B05206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="boqW87uO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgAABPI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:15:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55002 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABPH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:15:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011F7vn092575
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=oXDtdBtKk4wWDYxThI9pIfR8ZSdnmfWr5FWimKL2Tbw=;
 b=boqW87uOlDtAbCkIL8++Gkz30etXMVNj9rQFUrexZ3yg7lnc8Rc7dFTaZaFFMNpRjHjn
 9c/yHKMkQIZ1HzHc9BUVMLAf/BCaxnbB8hM9LWy3IepLX8ko0nnc6mZiB8ryeolVtuQ5
 lcSaFUNzmbuu1fw22fyJ3bX5YKQip4nzts5EKwVN+UDV9pYWIAQ1jdedeWCSP0+P6M/6
 Gvz4Hpz4pJ1GoHy00DKPucMPXBH70HisBez6D79DFgNltv3cOKaAIwgEA/i61qWhZ7rQ
 tiDaSUFuoPOBkU/VrP7VF94yDYdqGgr/9pGesgf+m72p77ilrU/reKnnFa9riSngo887 IQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vAs045332
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x7medfeu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:06 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011F66b007752
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:06 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:15:05 -0800
Subject: [PATCH 02/13] xfs: create transaction reservations for metadata
 inode operations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:15:03 -0800
Message-ID: <157784130342.1366873.10936246006551101421.stgit@magnolia>
In-Reply-To: <157784129036.1366873.17175097590750371047.stgit@magnolia>
References: <157784129036.1366873.17175097590750371047.stgit@magnolia>
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

Create transaction reservation types and block reservation helpers to
help us calculate transaction requirements.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_imeta.c      |   20 +++++++++++++
 fs/xfs/libxfs/xfs_imeta.h      |    3 ++
 fs/xfs/libxfs/xfs_trans_resv.c |   61 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |    2 +
 4 files changed, 86 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 9994b867aeab..aadba5786d1c 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -17,6 +17,10 @@
 #include "xfs_imeta.h"
 #include "xfs_trace.h"
 #include "xfs_inode.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_trans_space.h"
 
 /*
  * Metadata Inode Number Management
@@ -378,3 +382,19 @@ xfs_imeta_mount(
 {
 	return 0;
 }
+
+/* Calculate the log block reservation to create a metadata inode. */
+unsigned int
+xfs_imeta_create_space_res(
+	struct xfs_mount	*mp)
+{
+	return XFS_IALLOC_SPACE_RES(mp);
+}
+
+/* Calculate the log block reservation to unlink a metadata inode. */
+unsigned int
+xfs_imeta_unlink_space_res(
+	struct xfs_mount	*mp)
+{
+	return XFS_REMOVE_SPACE_RES(mp);
+}
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 373d40703dec..7740e7bd03e5 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -40,4 +40,7 @@ void xfs_imeta_end_update(struct xfs_mount *mp, struct xfs_imeta_end *cleanup,
 bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
 int xfs_imeta_mount(struct xfs_mount *mp);
 
+unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
+unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
+
 #endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 7a9c04920505..8dc7aa72cf8f 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -832,6 +832,56 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
+/*
+ * Metadata inode creation needs enough space to create or mkdir a directory,
+ * plus logging the superblock.
+ */
+static unsigned int
+xfs_calc_imeta_create_resv(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret;
+
+	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+	ret += resp->tr_create.tr_logres;
+	return ret;
+}
+
+/* Metadata inode creation needs enough rounds to create or mkdir a directory */
+static int
+xfs_calc_imeta_create_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	return resp->tr_create.tr_logcount;
+}
+
+/*
+ * Metadata inode unlink needs enough space to remove a file plus logging the
+ * superblock.
+ */
+static unsigned int
+xfs_calc_imeta_unlink_resv(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret;
+
+	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+	ret += resp->tr_remove.tr_logres;
+	return ret;
+}
+
+/* Metadata inode creation needs enough rounds to remove a file. */
+static int
+xfs_calc_imeta_unlink_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	return resp->tr_remove.tr_logcount;
+}
+
 void
 xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
@@ -946,4 +996,15 @@ xfs_trans_resv_calc(
 	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
 	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
+
+	/* metadata inode creation and unlink */
+	resp->tr_imeta_create.tr_logres = xfs_calc_imeta_create_resv(mp, resp);
+	resp->tr_imeta_create.tr_logcount =
+			xfs_calc_imeta_create_count(mp, resp);
+	resp->tr_imeta_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_imeta_unlink.tr_logres = xfs_calc_imeta_unlink_resv(mp, resp);
+	resp->tr_imeta_unlink.tr_logcount =
+			xfs_calc_imeta_unlink_count(mp, resp);
+	resp->tr_imeta_unlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 }
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 7241ab28cf84..7f7d86671319 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -50,6 +50,8 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
+	struct xfs_trans_res	tr_imeta_create; /* create metadata inode */
+	struct xfs_trans_res	tr_imeta_unlink; /* unlink metadata inode */
 };
 
 /* shorthand way of accessing reservation structure */

