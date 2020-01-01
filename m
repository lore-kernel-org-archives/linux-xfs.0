Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECFCC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2621F206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rtWd82iK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgAABKp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:10:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABKp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:10:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118x9N109469
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QvGgXjkq3RhrXEfQ3ML5CTZ0DRVMlZB/f0oTmIKG89s=;
 b=rtWd82iKz+b1DGEKTQ2QLnz593xwxZF08P1CnHrcaWznefbD2kUiV+CdA8P0MkJzGsEE
 MRRE8HHQ3YJkW+406pX1nPxTJvA/OC8Q2Rk8dhGhrzGlF8W8nOdkRh5AzAHShqlP97gL
 GK0AJq4EY2HKive/0eoyNEY6WSB5THPB7HB3tgcyjtF/BAVefzdTcXdAd3Dfkyca0Moc
 MghvRNsvvGnzrLv5kkkXnLB4sI/tc4JJTdo6h9tTYA3fgwf5jVVpmxRnrEZDNTuG6Mfc
 9u0AcsE6DnMQHai0ti8OJ7NBlBg8Gx3yVY3d7xtiNnC8lXzcKpRIvQWtkmbdHvwkxWBq mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk2eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118v8s190299
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrg0qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:43 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011AhgN032074
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:43 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:10:43 -0800
Subject: [PATCH 5/5] xfs: repair summary counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:10:40 -0800
Message-ID: <157784104083.1364003.7208596988159890329.stgit@magnolia>
In-Reply-To: <157784100871.1364003.10658176827446969836.stgit@magnolia>
References: <157784100871.1364003.10658176827446969836.stgit@magnolia>
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

Use the same summary counter calculation infrastructure to generate new
values for the in-core summary counters.   The difference between the
scrubber and the repairer is that the repairer will freeze the fs during
setup, which means that the values should match exactly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                  |    1 +
 fs/xfs/scrub/fscounters.c        |   23 +++++++++++++-
 fs/xfs/scrub/fscounters_repair.c |   63 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h            |    2 +
 fs/xfs/scrub/scrub.c             |    2 +
 fs/xfs/scrub/trace.h             |   18 ++++++++---
 6 files changed, 103 insertions(+), 6 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6f56ebcadeb6..37339d4d6b5b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -165,6 +165,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   bitmap.o \
 				   blob.o \
 				   bmap_repair.o \
+				   fscounters_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   refcount_repair.o \
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 7251c66a82c9..52c72a31e440 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -40,6 +40,10 @@
  * structures as quickly as it can.  We snapshot the percpu counters before and
  * after this operation and use the difference in counter values to guess at
  * our tolerance for mismatch between expected and actual counter values.
+ *
+ * NOTE: If the calling application has permitted us to repair the counters,
+ * we /must/ prevent all other filesystem activity by freezing it.  Since we've
+ * frozen the filesystem, we can require an exact match.
  */
 
 /*
@@ -141,8 +145,19 @@ xchk_setup_fscounters(
 	 * Pause background reclaim while we're scrubbing to reduce the
 	 * likelihood of background perturbations to the counters throwing off
 	 * our calculations.
+	 *
+	 * If we're repairing, we need to prevent any other thread from
+	 * changing the global fs summary counters while we're repairing them.
+	 * This requires the fs to be frozen, which will disable background
+	 * reclaim and purge all inactive inodes.
 	 */
-	xchk_stop_reaping(sc);
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
+		error = xchk_fs_freeze(sc);
+		if (error)
+			return error;
+	} else {
+		xchk_stop_reaping(sc);
+	}
 
 	return xchk_trans_alloc(sc, 0);
 }
@@ -255,6 +270,8 @@ xchk_fscount_aggregate_agcounts(
  * Otherwise, we /might/ have a problem.  If the change in the summations is
  * more than we want to tolerate, the filesystem is probably busy and we should
  * just send back INCOMPLETE and see if userspace will try again.
+ *
+ * If we're repairing then we require an exact match.
  */
 static inline bool
 xchk_fscount_within_range(
@@ -277,6 +294,10 @@ xchk_fscount_within_range(
 	if (curr_value == expected)
 		return true;
 
+	/* We require exact matches when repair is running. */
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+		return false;
+
 	min_value = min(old_value, curr_value);
 	max_value = max(old_value, curr_value);
 
diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
new file mode 100644
index 000000000000..c3d2214133ff
--- /dev/null
+++ b/fs/xfs/scrub/fscounters_repair.c
@@ -0,0 +1,63 @@
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
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "xfs_health.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * FS Summary Counters
+ * ===================
+ *
+ * We correct errors in the filesystem summary counters by setting them to the
+ * values computed during the obligatory scrub phase.  However, we must be
+ * careful not to allow any other thread to change the counters while we're
+ * computing and setting new values.  To achieve this, we freeze the
+ * filesystem for the whole operation if the REPAIR flag is set.  The checking
+ * function is stricter when we've frozen the fs.
+ */
+
+/*
+ * Reset the superblock counters.  Caller is responsible for freezing the
+ * filesystem during the calculation and reset phases.
+ */
+int
+xrep_fscounters(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xchk_fscounters	*fsc = sc->buf;
+
+	/*
+	 * Reinitialize the in-core counters from what we computed.  We froze
+	 * the filesystem, so there shouldn't be anyone else trying to modify
+	 * these counters.
+	 */
+	ASSERT(sc->flags & XCHK_FS_FROZEN);
+	percpu_counter_set(&mp->m_icount, fsc->icount);
+	percpu_counter_set(&mp->m_ifree, fsc->ifree);
+	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 4bfa2d0b0f37..3e65eb8dba24 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -85,6 +85,7 @@ int xrep_quota(struct xfs_scrub *sc);
 #else
 # define xrep_quota			xrep_notsupported
 #endif /* CONFIG_XFS_QUOTA */
+int xrep_fscounters(struct xfs_scrub *sc);
 
 struct xrep_newbt_resv {
 	/* Link to list of extents that we've reserved. */
@@ -200,6 +201,7 @@ xrep_rmapbt_setup(
 #define xrep_symlink			xrep_notsupported
 #define xrep_xattr			xrep_notsupported
 #define xrep_quota			xrep_notsupported
+#define xrep_fscounters			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 84a25647ac43..9a7a040ab2c0 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -348,7 +348,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_fscounters,
 		.scrub	= xchk_fscounters,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_fscounters,
 	},
 	[XFS_SCRUB_TYPE_HEALTHY] = {	/* fs healthy; clean all reminders */
 		.type	= ST_FS,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 4e145055e37e..927c9645cb06 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -949,16 +949,26 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
 		  __entry->refcbt_sz)
 )
 TRACE_EVENT(xrep_reset_counters,
-	TP_PROTO(struct xfs_mount *mp),
-	TP_ARGS(mp),
+	TP_PROTO(struct xfs_mount *mp, int64_t icount_adj, int64_t ifree_adj,
+		 int64_t fdblocks_adj),
+	TP_ARGS(mp, icount_adj, ifree_adj, fdblocks_adj),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(int64_t, icount_adj)
+		__field(int64_t, ifree_adj)
+		__field(int64_t, fdblocks_adj)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
+		__entry->icount_adj = icount_adj;
+		__entry->ifree_adj = ifree_adj;
+		__entry->fdblocks_adj = fdblocks_adj;
 	),
-	TP_printk("dev %d:%d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev))
+	TP_printk("dev %d:%d icount %lld ifree %lld fdblocks %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->icount_adj,
+		  __entry->ifree_adj,
+		  __entry->fdblocks_adj)
 )
 
 DECLARE_EVENT_CLASS(xrep_newbt_extent_class,

