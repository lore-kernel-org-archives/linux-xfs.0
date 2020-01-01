Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B6DC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEF60206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KWJzs2mc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgAABKF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:10:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53538 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABKF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:10:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001190BW109723
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rdJrrCv9R44IPrreqYlmLAFHSbTQguW8PmdguP8zE/o=;
 b=KWJzs2mcCiL42z4vhQ9DzfOjyq4S+3odt+z1Udp/3mMoXXtzx51O2J1ybbWkRu3+blH6
 nYleXoPxDcBeGhwuK3qSw+NYBJlGMZiw0CSqBLnX33YxOtxNFCzq0Wz9Sh21+n93QS72
 PlpVB8Q5uWagChYwy95OQln3MLteWllNNYfdlcSaMJwU1OcgpvZzArxPpBQrgWnTCX4H
 fhn2HGYdlrINcn2VOKMQut86Y7beFfNGvwA8ymIRbgSdr1CGxUwT6xKaYi1JUBXTaA8O
 Woz8ATpm1a1ag4DjhVUn7moj0NWpiY0qdGWrSQSDm1bjEEtXW0onjuv88P7OOY9aH5Eb OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2e0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xA9012518
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8gueeh69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:02 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011A1fl011272
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:01 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:10:01 -0800
Subject: [PATCH 2/3] xfs: remember sick inodes that get inactivated
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:09:58 -0800
Message-ID: <157784099878.1362990.14949831388635955880.stgit@magnolia>
In-Reply-To: <157784098622.1362990.10967551303351018359.stgit@magnolia>
References: <157784098622.1362990.10967551303351018359.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If an unhealthy inode gets inactivated, remember this fact in the
per-fs health summary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h        |    1 +
 fs/xfs/libxfs/xfs_health.h    |    7 +++++--
 fs/xfs/libxfs/xfs_inode_buf.c |    2 +-
 fs/xfs/scrub/health.c         |   12 +++++++++++-
 fs/xfs/xfs_health.c           |    1 +
 fs/xfs/xfs_inode.c            |   30 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h            |    1 +
 7 files changed, 50 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ef95ca07d084..0fcde7b2d89b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -300,6 +300,7 @@ struct xfs_ag_geometry {
 #define XFS_AG_GEOM_SICK_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_AG_GEOM_SICK_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_AG_GEOM_SICK_REFCNTBT (1 << 9)  /* reference counts */
+#define XFS_AG_GEOM_SICK_INODES	(1 << 10) /* bad inodes were seen */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index f899efbfef30..d9bd8996afbe 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -74,6 +74,7 @@ struct xfs_da_args;
 #define XFS_SICK_AG_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_SICK_AG_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_SICK_AG_REFCNTBT	(1 << 9)  /* reference counts */
+#define XFS_SICK_AG_INODES	(1 << 10) /* inactivated bad inodes */
 
 /* Observable health issues for inode metadata. */
 #define XFS_SICK_INO_CORE	(1 << 0)  /* inode core */
@@ -84,6 +85,8 @@ struct xfs_da_args;
 #define XFS_SICK_INO_XATTR	(1 << 5)  /* extended attributes */
 #define XFS_SICK_INO_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_SICK_INO_PARENT	(1 << 7)  /* parent pointers */
+/* Don't propagate sick status to ag health summary during inactivation */
+#define XFS_SICK_INO_FORGET	(1 << 8)
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -118,12 +121,12 @@ struct xfs_da_args;
 #define XFS_SICK_FS_SECONDARY	(0)
 #define XFS_SICK_RT_SECONDARY	(0)
 #define XFS_SICK_AG_SECONDARY	(0)
-#define XFS_SICK_INO_SECONDARY	(0)
+#define XFS_SICK_INO_SECONDARY	(XFS_SICK_INO_FORGET)
 
 /* Evidence of health problems elsewhere. */
 #define XFS_SICK_FS_INDIRECT	(0)
 #define XFS_SICK_RT_INDIRECT	(0)
-#define XFS_SICK_AG_INDIRECT	(0)
+#define XFS_SICK_AG_INDIRECT	(XFS_SICK_AG_INODES)
 #define XFS_SICK_INO_INDIRECT	(0)
 
 /* All health masks. */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 10dab755abe0..dee6ff909c88 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -185,7 +185,7 @@ xfs_imap_to_bp(
 				   &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
-				XFS_SICK_AG_INOBT);
+				XFS_SICK_AG_INODES);
 	if (error) {
 		if (error == -EAGAIN) {
 			ASSERT(buf_flags & XBF_TRYLOCK);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 4d1bea2fc36d..d6345e547422 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -148,7 +148,17 @@ xchk_update_health(
 		if (!sc->ip)
 			return;
 		if (bad) {
-			xfs_inode_mark_sick(sc->ip, sc->sick_mask);
+			unsigned int	mask = sc->sick_mask;
+
+			/*
+			 * If we're coming in for repairs then we don't want
+			 * sickness flags to propagate to the incore health
+			 * status if the inode gets inactivated before we can
+			 * fix it.
+			 */
+			if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+				mask |= XFS_SICK_INO_FORGET;
+			xfs_inode_mark_sick(sc->ip, mask);
 			xfs_inode_mark_checked(sc->ip, sc->sick_mask);
 		} else
 			xfs_inode_mark_healthy(sc->ip, sc->sick_mask);
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 87a8f362cc2e..dc886c14800e 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -406,6 +406,7 @@ static const struct ioctl_sick_map ag_map[] = {
 	{ XFS_SICK_AG_FINOBT,	XFS_AG_GEOM_SICK_FINOBT },
 	{ XFS_SICK_AG_RMAPBT,	XFS_AG_GEOM_SICK_RMAPBT },
 	{ XFS_SICK_AG_REFCNTBT,	XFS_AG_GEOM_SICK_REFCNTBT },
+	{ XFS_SICK_AG_INODES,	XFS_AG_GEOM_SICK_INODES },
 	{ 0, 0 },
 };
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2977086e7374..b45f7bdb6122 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -38,6 +38,7 @@
 #include "xfs_health.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
+#include "xfs_health.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -1985,6 +1986,33 @@ xfs_inode_needs_inactivation(
 	return true;
 }
 
+/*
+ * Save health status somewhere, if we're dumping an inode with uncorrected
+ * errors and online repair isn't running.
+ */
+static inline void
+xfs_inactive_health(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	unsigned int		sick;
+	unsigned int		checked;
+
+	xfs_inode_measure_sickness(ip, &sick, &checked);
+	if (!sick)
+		return;
+
+	trace_xfs_inode_unfixed_corruption(ip, sick);
+
+	if (sick & XFS_SICK_INO_FORGET)
+		return;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	xfs_ag_mark_sick(pag, XFS_SICK_AG_INODES);
+	xfs_perag_put(pag);
+}
+
 /*
  * xfs_inactive
  *
@@ -2017,6 +2045,8 @@ xfs_inactive(
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return;
 
+	xfs_inactive_health(ip);
+
 	/*
 	 * Re-attach dquots prior to freeing EOF blocks or CoW staging extents.
 	 * We dropped the dquot prior to inactivation (because quotaoff can't
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9233f51020af..30341606285a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3497,6 +3497,7 @@ DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
 	TP_ARGS(ip, flags))
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
+DEFINE_INODE_CORRUPT_EVENT(xfs_inode_unfixed_corruption);
 
 TRACE_EVENT(xfs_iwalk_ag,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,

