Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D86FC43215
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 18:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F63720727
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 18:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kfaPf419"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfKNSUA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 13:20:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44716 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfKNSUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 13:20:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEIJw6L101695
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:19:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=AMgqFXPQASnPSxA7EXCMQ400Q/TVoS0jKQUp+MnNlvM=;
 b=kfaPf419Cvijno61Wvemv//7whBkhZv7L7KUrKyzAdOF8ubB7IvOpNz4kqHrzrWPRN7h
 KnXG86h0Vm08RgO5yJTD/6vN5HmQvc+4/n4YALLMZby21Lsuu8qbzhScs+ACK+AASU+h
 T/6xMplb4fCkH3wvJ1ZVbvbUpft/zuMF5z5Iu0Zn9lA/pRM6MczqQcLnU8MGXeFk+/fa
 vRgoetCqQaEuAfuSQ0A901+XE21XYGsoj3EKI6qJ4kUnA5TWh0RwS2Njocv9fNFywXGv
 7hEmCbltnqoorF/tSKHoc/3dd8crjWOExbGgC9XYinQhEfzCe5hBuv4MYG1wl8yvEKlb 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w5mvu51na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:19:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEI42C5027017
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:19:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w8v365kpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:19:22 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAEIJLi5008139
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:19:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Nov 2019 10:19:21 -0800
Subject: [PATCH 1/9] xfs: separate the marking of sick and checked metadata
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Nov 2019 10:19:20 -0800
Message-ID: <157375556076.3692735.11924756899356721108.stgit@magnolia>
In-Reply-To: <157375555426.3692735.1357467392517392169.stgit@magnolia>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911140155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911140156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Split the setting of the sick and checked masks into separate functions
as part of preparing to add the ability for regular runtime fs code
(i.e. not scrub) to mark metadata structures sick when corruptions are
found.  Improve the documentation of libxfs' requirements for helper
behavior.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_health.h |   24 ++++++++++++++++++----
 fs/xfs/scrub/health.c      |   20 +++++++++++-------
 fs/xfs/xfs_health.c        |   49 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.c         |    5 ++++
 4 files changed, 85 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 272005ac8c88..3657a9cb8490 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -26,9 +26,11 @@
  * and the "sick" field tells us if that piece was found to need repairs.
  * Therefore we can conclude that for a given sick flag value:
  *
- *  - checked && sick  => metadata needs repair
- *  - checked && !sick => metadata is ok
- *  - !checked         => has not been examined since mount
+ *  - checked && sick   => metadata needs repair
+ *  - checked && !sick  => metadata is ok
+ *  - !checked && sick  => errors have been observed during normal operation,
+ *                         but the metadata has not been checked thoroughly
+ *  - !checked && !sick => has not been examined since mount
  */
 
 struct xfs_mount;
@@ -97,24 +99,38 @@ struct xfs_fsop_geom;
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT)
 
-/* These functions must be provided by the xfs implementation. */
+/*
+ * These functions must be provided by the xfs implementation.  Function
+ * behavior with respect to the first argument should be as follows:
+ *
+ * xfs_*_mark_sick:    set the sick flags and do not set checked flags.
+ * xfs_*_mark_checked: set the checked flags.
+ * xfs_*_mark_healthy: clear the sick flags and set the checked flags.
+ *
+ * xfs_*_measure_sickness: return the sick and check status in the provided
+ * out parameters.
+ */
 
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_fs_mark_checked(struct xfs_mount *mp, unsigned int mask);
 void xfs_fs_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_fs_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_rt_mark_checked(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
+void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
+void xfs_inode_mark_checked(struct xfs_inode *ip, unsigned int mask);
 void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
 void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 		unsigned int *checked);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 83d27cdf579b..a402f9026d5f 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -137,30 +137,34 @@ xchk_update_health(
 	switch (type_to_health_flag[sc->sm->sm_type].group) {
 	case XHG_AG:
 		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
-		if (bad)
+		if (bad) {
 			xfs_ag_mark_sick(pag, sc->sick_mask);
-		else
+			xfs_ag_mark_checked(pag, sc->sick_mask);
+		} else
 			xfs_ag_mark_healthy(pag, sc->sick_mask);
 		xfs_perag_put(pag);
 		break;
 	case XHG_INO:
 		if (!sc->ip)
 			return;
-		if (bad)
+		if (bad) {
 			xfs_inode_mark_sick(sc->ip, sc->sick_mask);
-		else
+			xfs_inode_mark_checked(sc->ip, sc->sick_mask);
+		} else
 			xfs_inode_mark_healthy(sc->ip, sc->sick_mask);
 		break;
 	case XHG_FS:
-		if (bad)
+		if (bad) {
 			xfs_fs_mark_sick(sc->mp, sc->sick_mask);
-		else
+			xfs_fs_mark_checked(sc->mp, sc->sick_mask);
+		} else
 			xfs_fs_mark_healthy(sc->mp, sc->sick_mask);
 		break;
 	case XHG_RT:
-		if (bad)
+		if (bad) {
 			xfs_rt_mark_sick(sc->mp, sc->sick_mask);
-		else
+			xfs_rt_mark_checked(sc->mp, sc->sick_mask);
+		} else
 			xfs_rt_mark_healthy(sc->mp, sc->sick_mask);
 		break;
 	default:
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 8e0cb05a7142..860dc70c99e7 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -100,6 +100,18 @@ xfs_fs_mark_sick(
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_fs_sick |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark per-fs metadata as having been checked. */
+void
+xfs_fs_mark_checked(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
+
+	spin_lock(&mp->m_sb_lock);
 	mp->m_fs_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -143,6 +155,19 @@ xfs_rt_mark_sick(
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_rt_sick |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark realtime metadata as having been checked. */
+void
+xfs_rt_mark_checked(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+	trace_xfs_rt_mark_sick(mp, mask);
+
+	spin_lock(&mp->m_sb_lock);
 	mp->m_rt_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -186,6 +211,18 @@ xfs_ag_mark_sick(
 
 	spin_lock(&pag->pag_state_lock);
 	pag->pag_sick |= mask;
+	spin_unlock(&pag->pag_state_lock);
+}
+
+/* Mark per-ag metadata as having been checked. */
+void
+xfs_ag_mark_checked(
+	struct xfs_perag	*pag,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
+
+	spin_lock(&pag->pag_state_lock);
 	pag->pag_checked |= mask;
 	spin_unlock(&pag->pag_state_lock);
 }
@@ -229,6 +266,18 @@ xfs_inode_mark_sick(
 
 	spin_lock(&ip->i_flags_lock);
 	ip->i_sick |= mask;
+	spin_unlock(&ip->i_flags_lock);
+}
+
+/* Mark inode metadata as having been checked. */
+void
+xfs_inode_mark_checked(
+	struct xfs_inode	*ip,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
+
+	spin_lock(&ip->i_flags_lock);
 	ip->i_checked |= mask;
 	spin_unlock(&ip->i_flags_lock);
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fca65109cf24..27aa143d524b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -555,8 +555,10 @@ xfs_check_summary_counts(
 	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
 	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
 	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
-	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
+	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount)) {
 		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
+		xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
+	}
 
 	/*
 	 * We can safely re-initialise incore superblock counters from the
@@ -1322,6 +1324,7 @@ xfs_force_summary_recalc(
 		return;
 
 	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
+	xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
 }
 
 /*

