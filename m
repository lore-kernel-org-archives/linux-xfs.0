Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883EBC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5250A206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="URVOho5d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgAABJ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53468 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABJ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xGK109440
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+gu6c/+phbpbueK2PB++XJTEL12CzCVytt5Y6RJqKac=;
 b=URVOho5dlJ3z42/EmWQ/Ze/2IF4AWjTXew2DKy5mSGHp/geeYPOBh5B579/hsOVJs6jh
 P4D8ZNNei4L7nbkaZCqj71ZwY2y8GHFOKpudw96a/WMITSRpMXV1/HmDVfUTZDg0AkTO
 57MHxWf8ppc/iEFAIZCWz1HNIG1VXSbNsI/D2WheyiPFcpSuiNqhikVQG/unOy/BBUUF
 KRLviDtd6ps3FGMW8vq5bC1+dlKKCuj7ce/YpGbkX7HPkIJpilj+xgkpWTk7RABB7FWm
 h0H+I+13gN8hBkerrEusTFrC5oQnZrYOJssgfBrc5MfCdNwiSRrMjEnewSHMbxloXwcx UQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2x5xftk2dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118x7B172393
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2x8gj9165s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:55 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00119tBu011236
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:55 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:09:54 -0800
Subject: [PATCH 1/3] xfs: add secondary and indirect classes to the health
 tracking system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:09:52 -0800
Message-ID: <157784099235.1362990.8871707427723670043.stgit@magnolia>
In-Reply-To: <157784098622.1362990.10967551303351018359.stgit@magnolia>
References: <157784098622.1362990.10967551303351018359.stgit@magnolia>
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
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Establish two more classes of health tracking bits:

 * Indirect problems, which suggest problems in other health domains
   that we weren't able to preserve.

 * Secondary problems, which track state that's related to primary
   evidence of health problems; and

The first class we'll use in an upcoming patch to record in the AG
health status the fact that we ran out of memory and had to inactivate
an inode with defective metadata.  The second class we use to indicate
that repair knows that an inode is bad and we need to fix it later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_health.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_health.c        |   24 ++++++++++++++++--------
 2 files changed, 58 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index d55026c9073a..f899efbfef30 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -31,6 +31,19 @@
  *  - !checked && sick  => errors have been observed during normal operation,
  *                         but the metadata has not been checked thoroughly
  *  - !checked && !sick => has not been examined since mount
+ *
+ * Evidence of health problems can be sorted into three basic categories:
+ *
+ * a) Primary evidence, which signals that something is defective within the
+ *    general grouping of metadata.
+ *
+ * b) Secondary evidence, which are side effects of primary problem but are
+ *    not themselves problems.  These can be forgotten when the primary
+ *    health problems are addressed.
+ *
+ * c) Indirect evidence, which points to something being wrong in another
+ *    group, but we had to release resources and this is all that's left of
+ *    that state.
  */
 
 struct xfs_mount;
@@ -101,6 +114,35 @@ struct xfs_da_args;
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT)
 
+/* Secondary state related to (but not primary evidence of) health problems. */
+#define XFS_SICK_FS_SECONDARY	(0)
+#define XFS_SICK_RT_SECONDARY	(0)
+#define XFS_SICK_AG_SECONDARY	(0)
+#define XFS_SICK_INO_SECONDARY	(0)
+
+/* Evidence of health problems elsewhere. */
+#define XFS_SICK_FS_INDIRECT	(0)
+#define XFS_SICK_RT_INDIRECT	(0)
+#define XFS_SICK_AG_INDIRECT	(0)
+#define XFS_SICK_INO_INDIRECT	(0)
+
+/* All health masks. */
+#define XFS_SICK_FS_ALL	(XFS_SICK_FS_PRIMARY | \
+				 XFS_SICK_FS_SECONDARY | \
+				 XFS_SICK_FS_INDIRECT)
+
+#define XFS_SICK_RT_ALL	(XFS_SICK_RT_PRIMARY | \
+				 XFS_SICK_RT_SECONDARY | \
+				 XFS_SICK_RT_INDIRECT)
+
+#define XFS_SICK_AG_ALL	(XFS_SICK_AG_PRIMARY | \
+				 XFS_SICK_AG_SECONDARY | \
+				 XFS_SICK_AG_INDIRECT)
+
+#define XFS_SICK_INO_ALL	(XFS_SICK_INO_PRIMARY | \
+				 XFS_SICK_INO_SECONDARY | \
+				 XFS_SICK_INO_INDIRECT)
+
 /*
  * These functions must be provided by the xfs implementation.  Function
  * behavior with respect to the first argument should be as follows:
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 2d3da765722e..87a8f362cc2e 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -99,7 +99,7 @@ xfs_fs_mark_sick(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_FS_ALL));
 	trace_xfs_fs_mark_sick(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
@@ -126,11 +126,13 @@ xfs_fs_mark_healthy(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_FS_ALL));
 	trace_xfs_fs_mark_healthy(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_fs_sick &= ~mask;
+	if (!(mp->m_fs_sick & XFS_SICK_FS_PRIMARY))
+		mp->m_fs_sick &= ~XFS_SICK_FS_SECONDARY;
 	mp->m_fs_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -154,7 +156,7 @@ xfs_rt_mark_sick(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
 	trace_xfs_rt_mark_sick(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
@@ -182,11 +184,13 @@ xfs_rt_mark_healthy(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
 	trace_xfs_rt_mark_healthy(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_rt_sick &= ~mask;
+	if (!(mp->m_rt_sick & XFS_SICK_RT_PRIMARY))
+		mp->m_rt_sick &= ~XFS_SICK_RT_SECONDARY;
 	mp->m_rt_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -227,7 +231,7 @@ xfs_ag_mark_sick(
 	struct xfs_perag	*pag,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
 	trace_xfs_ag_mark_sick(pag->pag_mount, pag->pag_agno, mask);
 
 	spin_lock(&pag->pag_state_lock);
@@ -254,11 +258,13 @@ xfs_ag_mark_healthy(
 	struct xfs_perag	*pag,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
 	trace_xfs_ag_mark_healthy(pag->pag_mount, pag->pag_agno, mask);
 
 	spin_lock(&pag->pag_state_lock);
 	pag->pag_sick &= ~mask;
+	if (!(pag->pag_sick & XFS_SICK_AG_PRIMARY))
+		pag->pag_sick &= ~XFS_SICK_AG_SECONDARY;
 	pag->pag_checked |= mask;
 	spin_unlock(&pag->pag_state_lock);
 }
@@ -282,7 +288,7 @@ xfs_inode_mark_sick(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_INO_ALL));
 	trace_xfs_inode_mark_sick(ip, mask);
 
 	spin_lock(&ip->i_flags_lock);
@@ -309,11 +315,13 @@ xfs_inode_mark_healthy(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_INO_ALL));
 	trace_xfs_inode_mark_healthy(ip, mask);
 
 	spin_lock(&ip->i_flags_lock);
 	ip->i_sick &= ~mask;
+	if (!(ip->i_sick & XFS_SICK_INO_PRIMARY))
+		ip->i_sick &= ~XFS_SICK_INO_SECONDARY;
 	ip->i_checked |= mask;
 	spin_unlock(&ip->i_flags_lock);
 }

