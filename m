Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBBEC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A19E20718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DeRlezz1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgAABTU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:19:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58618 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABTU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:19:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011ESvQ112747
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=uoUD+XI4nf6Mj16hs2+X8HW4S8b936dNsCjvxs/O2VE=;
 b=DeRlezz1JruadQaiPujatsiJPVI8phh2dyLKjFfM3QUuUY7DvmnyvUGtNOYA3cP9nCFs
 JqnI8wEUJQMDvM+Qn8mEFzq7NfYGZyYV0GcuPR9q0+GF3sRiD4CENp3+UGfg3v8ZkPOQ
 n/T8zTZrKsgLmDjcOAk9/lrp5za6hlNhxGM4R2n/UsShgsnqrGdobPeT7iZa/MO15K65
 +SVS4m2sv37tcE7EqWmkTbUwt0yYg8EKP67kGshAZeAXUEuI+asoOjcu1DCb11ekh7Cm
 9joG4QhVaty439/sK6d4jJXvqKuEHoSM+my0YZj19PUxJsN02HJ7XqeWWYMIOWqlkjP0 lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:19:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011JF5u024814
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:19:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8guefs97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:19:16 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011IEi8014739
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:15 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:18:14 -0800
Subject: [PATCH 18/21] xfs: scrub the realtime rmapbt
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:18:12 -0800
Message-ID: <157784149208.1368137.2698019392269392960.stgit@magnolia>
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
 engine=8.0.1-1911140001 definitions=main-2001010010
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

Check the realtime reverse mapping btree against the rtbitmap, and
modify the rtbitmap scrub to check against the rtrmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    5 ++
 fs/xfs/libxfs/xfs_fs.h     |    4 +-
 fs/xfs/libxfs/xfs_health.h |    4 +-
 fs/xfs/scrub/bmap.c        |    1 
 fs/xfs/scrub/common.h      |    6 ++
 fs/xfs/scrub/health.c      |    1 
 fs/xfs/scrub/rtrmap.c      |  109 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c       |    7 +++
 fs/xfs/scrub/scrub.h       |    6 ++
 fs/xfs/scrub/trace.h       |    4 +-
 fs/xfs/xfs_health.c        |    1 
 11 files changed, 144 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/rtrmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7c3e61cfc7e2..38919c6f1bc5 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -155,7 +155,10 @@ xfs-y				+= $(addprefix scrub/, \
 				   symlink.o \
 				   )
 
-xfs-$(CONFIG_XFS_RT)		+= scrub/rtbitmap.o
+xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rtbitmap.o \
+				   rtrmap.o \
+				   )
 xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 
 # online repair
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 86fd287017ca..558a396c74b3 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -210,6 +210,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
+#define XFS_FSOP_GEOM_SICK_RT_RMAPBT	(1 << 6)  /* realtime rmapbt */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
@@ -684,9 +685,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 #define XFS_SCRUB_TYPE_HEALTHY	25	/* everything checked out ok */
+#define XFS_SCRUB_TYPE_RTRMAPBT	26	/* realtime reverse mapping btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	26
+#define XFS_SCRUB_TYPE_NR	27
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index d9bd8996afbe..e41f60005424 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -62,6 +62,7 @@ struct xfs_da_args;
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
 #define XFS_SICK_RT_SUMMARY	(1 << 1)  /* realtime summary */
+#define XFS_SICK_RT_RMAPBT	(1 << 2)  /* realtime rmapbt */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -95,7 +96,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_PQUOTA)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
-				 XFS_SICK_RT_SUMMARY)
+				 XFS_SICK_RT_SUMMARY | \
+				 XFS_SICK_RT_RMAPBT)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index d8214f156f03..8bb81caf0c6b 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -689,6 +689,7 @@ xchk_bmap(
 	case XFS_DINODE_FMT_UUID:
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_RMAP:
 		/* No mappings to check. */
 		goto out;
 	case XFS_DINODE_FMT_EXTENTS:
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 93b52869daae..6e0ae69fc109 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -97,12 +97,18 @@ int xchk_setup_parent(struct xfs_scrub *sc,
 			   struct xfs_inode *ip);
 #ifdef CONFIG_XFS_RT
 int xchk_setup_rt(struct xfs_scrub *sc, struct xfs_inode *ip);
+int xchk_setup_rtrmapbt(struct xfs_scrub *sc, struct xfs_inode *ip);
 #else
 static inline int
 xchk_setup_rt(struct xfs_scrub *sc, struct xfs_inode *ip)
 {
 	return -ENOENT;
 }
+static inline int
+xchk_setup_rtrmapbt(struct xfs_scrub *sc, struct xfs_inode *ip)
+{
+	return -ENOENT;
+}
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index a8d562753334..b7075edfebb7 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -106,6 +106,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_GQUOTA]		= { XHG_FS,  XFS_SICK_FS_GQUOTA },
 	[XFS_SCRUB_TYPE_PQUOTA]		= { XHG_FS,  XFS_SICK_FS_PQUOTA },
 	[XFS_SCRUB_TYPE_FSCOUNTERS]	= { XHG_FS,  XFS_SICK_FS_COUNTERS },
+	[XFS_SCRUB_TYPE_RTRMAPBT]	= { XHG_RT,  XFS_SICK_RT_RMAPBT },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
new file mode 100644
index 000000000000..9b5d55734a41
--- /dev/null
+++ b/fs/xfs/scrub/rtrmap.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_rtalloc.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+
+/* Set us up with the realtime metadata and AG headers locked. */
+int
+xchk_setup_rtrmapbt(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = sc->mp;
+	int			lockmode;
+	int			error = 0;
+
+	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
+		return -EINVAL;
+
+	error = xchk_setup_fs(sc, ip);
+	if (error)
+		return error;
+
+	lockmode = XFS_ILOCK_EXCL;
+	xfs_ilock(mp->m_rrmapip, lockmode);
+	xfs_trans_ijoin(sc->tp, mp->m_rrmapip, lockmode);
+
+	lockmode = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
+	xfs_ilock(mp->m_rbmip, lockmode);
+	xfs_trans_ijoin(sc->tp, mp->m_rbmip, lockmode);
+
+	return 0;
+}
+
+/* Realtime reverse mapping. */
+
+/* Scrub a realtime rmapbt record. */
+STATIC int
+xchk_rtrmapbt_helper(
+	struct xchk_btree	*bs,
+	union xfs_btree_rec	*rec)
+{
+	struct xfs_mount	*mp = bs->cur->bc_mp;
+	struct xfs_rmap_irec	irec;
+	bool			non_inode;
+	bool			is_bmbt;
+	bool			is_attr;
+	int			error;
+
+	error = xfs_rmap_btrec_to_irec(bs->cur, rec, &irec);
+	if (!xchk_btree_process_error(bs->sc, bs->cur, 0, &error))
+		goto out;
+
+	if (irec.rm_startblock + irec.rm_blockcount <= irec.rm_startblock ||
+	    (!xfs_verify_rtbno(mp, irec.rm_startblock) ||
+	     !xfs_verify_rtbno(mp, irec.rm_startblock +
+				irec.rm_blockcount - 1)))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
+	is_bmbt = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec.rm_flags & XFS_RMAP_ATTR_FORK;
+
+	if (is_bmbt || non_inode || is_attr)
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+out:
+	return error;
+}
+
+/* Scrub the realtime rmap btree. */
+int
+xchk_rtrmapbt(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_owner_info	oinfo;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	cur = xfs_rtrmapbt_init_cursor(mp, sc->tp, mp->m_rrmapip);
+	xfs_rmap_ino_bmbt_owner(&oinfo, mp->m_rrmapip->i_ino, XFS_DATA_FORK);
+	error = xchk_btree(sc, cur, xchk_rtrmapbt_helper, &oinfo, NULL);
+	xfs_btree_del_cursor(cur, error);
+
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 54a524d19948..1b54c2b70369 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -357,6 +357,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.scrub	= xchk_health_record,
 		.repair = xrep_notsupported,
 	},
+	[XFS_SCRUB_TYPE_RTRMAPBT] = {	/* realtime rmapbt */
+		.type	= ST_FS,
+		.setup	= xchk_setup_rtrmapbt,
+		.scrub	= xchk_rtrmapbt,
+		.has	= xfs_sb_version_hasrtrmapbt,
+		.repair	= xrep_notsupported,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index f96fd11eceb1..fb5f0f371cd8 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -116,6 +116,7 @@ int xchk_parent(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
+int xchk_rtrmapbt(struct xfs_scrub *sc);
 #else
 static inline int
 xchk_rtbitmap(struct xfs_scrub *sc)
@@ -127,6 +128,11 @@ xchk_rtsummary(struct xfs_scrub *sc)
 {
 	return -ENOENT;
 }
+static inline int
+xchk_rtrmapbt(struct xfs_scrub *sc)
+{
+	return -ENOENT;
+}
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 927c9645cb06..1a7de36aaf8b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -51,6 +51,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_UQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_GQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTRMAPBT);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -78,7 +79,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
 	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
 	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }, \
-	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }
+	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
+	{ XFS_SCRUB_TYPE_RTRMAPBT,	"rtrmapbt" }
 
 DECLARE_EVENT_CLASS(xchk_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index dc886c14800e..e328b048edb0 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -357,6 +357,7 @@ static const struct ioctl_sick_map fs_map[] = {
 static const struct ioctl_sick_map rt_map[] = {
 	{ XFS_SICK_RT_BITMAP,	XFS_FSOP_GEOM_SICK_RT_BITMAP },
 	{ XFS_SICK_RT_SUMMARY,	XFS_FSOP_GEOM_SICK_RT_SUMMARY },
+	{ XFS_SICK_RT_RMAPBT,	XFS_FSOP_GEOM_SICK_RT_RMAPBT },
 	{ 0, 0 },
 };
 

