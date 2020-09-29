Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A7AC4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B32520936
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:44:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zsaLjFb0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgI2Ro3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:44:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55468 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgI2Ro2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 13:44:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THdxpr060982;
        Tue, 29 Sep 2020 17:44:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=w6EzkweGZ7x/97cGPcroPMlQVLLUJ4bZjsm8JhFRLzY=;
 b=zsaLjFb0lh+p9oFb5uVXx+C4bEjFDxWbGGLsLLdm7tCMXoq+YtQrfa2YlPNwi3nPcb/L
 k/Z+qx1WyzP0iqjm2J6AJRIew6supBjTbue2WmTHGTd2/XP0DqOYd6th9m6eiD/8jlz1
 FiwRp/tkZijA84VlK079sZTLTGhv65OyMy+a9N1GIWmtPHK95eg7+6h+iLUUdNPKDVCt
 sHdvq2CNdy0z9aXdS9PHe74CzVGMPq5i+vHb0cBWs83CizozWpjKlAz+Tq2zDBkIQjJb
 AxwimUL0FHFvGtus3vAEvCoQDf77X/qbGMrb70Vz8RrOahtTxcr3NspzoILC891adtqa xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33su5avcdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:44:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THdjl7098942;
        Tue, 29 Sep 2020 17:44:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33tfjx5y7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:44:24 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08THiNrO028462;
        Tue, 29 Sep 2020 17:44:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 10:44:23 -0700
Subject: [PATCH 2/4] xfs: periodically relog deferred intent items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Tue, 29 Sep 2020 10:44:22 -0700
Message-ID: <160140146229.831337.17465130965848184108.stgit@magnolia>
In-Reply-To: <160140144925.831337.14031530940286104610.stgit@magnolia>
References: <160140144925.831337.14031530940286104610.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=3
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There's a subtle design flaw in the deferred log item code that can lead
to pinning the log tail.  Taking up the defer ops chain examples from
the previous commit, we can get trapped in sequences like this:

Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
chain will look like the following if the transaction rolls succeed:

t1: D0(t0), D1(t0), D2(t0), D3(t0)
t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
t3: d5(t1), D1(t0), D2(t0), D3(t0)
...
t9: d9(t7), D3(t0)
t10: D3(t0)
t11: d10(t10), d11(t10)
t12: d11(t10)

In transaction 9, we finish d9 and try to roll to t10 while holding onto
an intent item for D3 that we logged in t0.

The previous commit changed the order in which we place new defer ops in
the defer ops processing chain to reduce the maximum chain length.  Now
make xfs_defer_finish_noroll capable of relogging the entire chain
periodically so that we can always move the log tail forward.  Most
chains will never get relogged, except for operations that generate very
long chains (large extents containing many blocks with different sharing
levels) or are on filesystems with small logs and a lot of ongoing
metadata updates.

Callers are now required to ensure that the transaction reservation is
large enough to handle logging done items and new intent items for the
maximum possible chain length.  Most callers are careful to keep the
chain lengths low, so the overhead should be minimal.

The decision to relog an intent item is made based on whether the intent
was logged in a previous checkpoint, since there's no point in relogging
an intent into the same checkpoint.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.c     |   27 +++++++++++++++++++++++++++
 fs/xfs/xfs_extfree_item.c  |   29 +++++++++++++++++++++++++++++
 fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++++++++++
 fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++++++++++
 fs/xfs/xfs_stats.c         |    4 ++++
 fs/xfs/xfs_stats.h         |    1 +
 fs/xfs/xfs_trace.h         |    1 +
 fs/xfs/xfs_trans.h         |   10 ++++++++++
 9 files changed, 168 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 81084c34138f..554777d1069c 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -17,6 +17,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_log.h"
 
 /*
  * Deferred Operations in XFS
@@ -345,6 +346,42 @@ xfs_defer_cancel_list(
 	}
 }
 
+/*
+ * Prevent a log intent item from pinning the tail of the log by logging a
+ * done item to release the intent item; and then log a new intent item.
+ * The caller should provide a fresh transaction and roll it after we're done.
+ */
+static int
+xfs_defer_relog(
+	struct xfs_trans		**tpp,
+	struct list_head		*dfops)
+{
+	struct xfs_defer_pending	*dfp;
+
+	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	list_for_each_entry(dfp, dfops, dfp_list) {
+		/*
+		 * If the log intent item for this deferred op is not a part of
+		 * the current log checkpoint, relog the intent item to keep
+		 * the log tail moving forward.  We're ok with this being racy
+		 * because an incorrect decision means we'll be a little slower
+		 * at pushing the tail.
+		 */
+		if (dfp->dfp_intent == NULL ||
+		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
+			continue;
+
+		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
+		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
+		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
+	}
+
+	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
+		return xfs_defer_trans_roll(tpp);
+	return 0;
+}
+
 /*
  * Log an intent-done item for the first pending intent, and finish the work
  * items.
@@ -431,6 +468,11 @@ xfs_defer_finish_noroll(
 		if (error)
 			goto out_shutdown;
 
+		/* Possibly relog intent items to keep the log moving. */
+		error = xfs_defer_relog(tp, &dop_pending);
+		if (error)
+			goto out_shutdown;
+
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
 		error = xfs_defer_finish_one(*tp, dfp);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 0ffbc75bafe1..1cca93d3d743 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -532,6 +532,32 @@ xfs_bui_item_match(
 	return BUI_ITEM(lip)->bui_format.bui_id == intent_id;
 }
 
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_bui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_bud_log_item		*budp;
+	struct xfs_bui_log_item		*buip;
+	struct xfs_map_extent		*extp;
+	unsigned int			count;
+
+	count = BUI_ITEM(intent)->bui_format.bui_nextents;
+	extp = BUI_ITEM(intent)->bui_format.bui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	budp = xfs_trans_get_bud(tp, BUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
+
+	buip = xfs_bui_init(tp->t_mountp);
+	memcpy(buip->bui_format.bui_extents, extp, count * sizeof(*extp));
+	atomic_set(&buip->bui_next_extent, count);
+	xfs_trans_add_item(tp, &buip->bui_item);
+	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
+	return &buip->bui_item;
+}
+
 static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_size	= xfs_bui_item_size,
 	.iop_format	= xfs_bui_item_format,
@@ -539,6 +565,7 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_release	= xfs_bui_item_release,
 	.iop_recover	= xfs_bui_item_recover,
 	.iop_match	= xfs_bui_item_match,
+	.iop_relog	= xfs_bui_item_relog,
 };
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3920542f5736..6c11bfc3d452 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -642,6 +642,34 @@ xfs_efi_item_match(
 	return EFI_ITEM(lip)->efi_format.efi_id == intent_id;
 }
 
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_efi_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_efd_log_item		*efdp;
+	struct xfs_efi_log_item		*efip;
+	struct xfs_extent		*extp;
+	unsigned int			count;
+
+	count = EFI_ITEM(intent)->efi_format.efi_nextents;
+	extp = EFI_ITEM(intent)->efi_format.efi_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	efdp = xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
+	efdp->efd_next_extent = count;
+	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
+	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
+
+	efip = xfs_efi_init(tp->t_mountp, count);
+	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
+	atomic_set(&efip->efi_next_extent, count);
+	xfs_trans_add_item(tp, &efip->efi_item);
+	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
+	return &efip->efi_item;
+}
+
 static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_size	= xfs_efi_item_size,
 	.iop_format	= xfs_efi_item_format,
@@ -649,6 +677,7 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_release	= xfs_efi_item_release,
 	.iop_recover	= xfs_efi_item_recover,
 	.iop_match	= xfs_efi_item_match,
+	.iop_relog	= xfs_efi_item_relog,
 };
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index ad895b48f365..7529eb63ce94 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -560,6 +560,32 @@ xfs_cui_item_match(
 	return CUI_ITEM(lip)->cui_format.cui_id == intent_id;
 }
 
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_cui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_cud_log_item		*cudp;
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_phys_extent		*extp;
+	unsigned int			count;
+
+	count = CUI_ITEM(intent)->cui_format.cui_nextents;
+	extp = CUI_ITEM(intent)->cui_format.cui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	cudp = xfs_trans_get_cud(tp, CUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
+
+	cuip = xfs_cui_init(tp->t_mountp, count);
+	memcpy(cuip->cui_format.cui_extents, extp, count * sizeof(*extp));
+	atomic_set(&cuip->cui_next_extent, count);
+	xfs_trans_add_item(tp, &cuip->cui_item);
+	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
+	return &cuip->cui_item;
+}
+
 static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_size	= xfs_cui_item_size,
 	.iop_format	= xfs_cui_item_format,
@@ -567,6 +593,7 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_release	= xfs_cui_item_release,
 	.iop_recover	= xfs_cui_item_recover,
 	.iop_match	= xfs_cui_item_match,
+	.iop_relog	= xfs_cui_item_relog,
 };
 
 /*
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 1163f32c3e62..7adc996ca6e3 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -583,6 +583,32 @@ xfs_rui_item_match(
 	return RUI_ITEM(lip)->rui_format.rui_id == intent_id;
 }
 
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_rui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_rud_log_item		*rudp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_map_extent		*extp;
+	unsigned int			count;
+
+	count = RUI_ITEM(intent)->rui_format.rui_nextents;
+	extp = RUI_ITEM(intent)->rui_format.rui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	rudp = xfs_trans_get_rud(tp, RUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
+
+	ruip = xfs_rui_init(tp->t_mountp, count);
+	memcpy(ruip->rui_format.rui_extents, extp, count * sizeof(*extp));
+	atomic_set(&ruip->rui_next_extent, count);
+	xfs_trans_add_item(tp, &ruip->rui_item);
+	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
+	return &ruip->rui_item;
+}
+
 static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_size	= xfs_rui_item_size,
 	.iop_format	= xfs_rui_item_format,
@@ -590,6 +616,7 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_release	= xfs_rui_item_release,
 	.iop_recover	= xfs_rui_item_recover,
 	.iop_match	= xfs_rui_item_match,
+	.iop_relog	= xfs_rui_item_relog,
 };
 
 /*
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index f70f1255220b..20e0534a772c 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -23,6 +23,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	uint64_t	xs_xstrat_bytes = 0;
 	uint64_t	xs_write_bytes = 0;
 	uint64_t	xs_read_bytes = 0;
+	uint64_t	defer_relog = 0;
 
 	static const struct xstats_entry {
 		char	*desc;
@@ -70,10 +71,13 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		xs_xstrat_bytes += per_cpu_ptr(stats, i)->s.xs_xstrat_bytes;
 		xs_write_bytes += per_cpu_ptr(stats, i)->s.xs_write_bytes;
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
+		defer_relog += per_cpu_ptr(stats, i)->s.defer_relog;
 	}
 
 	len += scnprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
 			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
+	len += scnprintf(buf + len, PATH_MAX-len, "defer_relog %llu\n",
+			defer_relog);
 	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
 #if defined(DEBUG)
 		1);
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 34d704f703d2..43ffba74f045 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -137,6 +137,7 @@ struct __xfsstats {
 	uint64_t		xs_xstrat_bytes;
 	uint64_t		xs_write_bytes;
 	uint64_t		xs_read_bytes;
+	uint64_t		defer_relog;
 };
 
 #define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index dcdcf99cfa5d..86951652d3ed 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2533,6 +2533,7 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_create_intent);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_cancel_list);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_relog_intent);
 
 #define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 186e77d08cc1..084658946cc8 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -75,6 +75,8 @@ struct xfs_item_ops {
 	int (*iop_recover)(struct xfs_log_item *lip,
 			   struct list_head *capture_list);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
+	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
+			struct xfs_trans *tp);
 };
 
 /* Is this log item a deferred action intent? */
@@ -258,4 +260,12 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
 
 extern kmem_zone_t	*xfs_trans_zone;
 
+static inline struct xfs_log_item *
+xfs_trans_item_relog(
+	struct xfs_log_item	*lip,
+	struct xfs_trans	*tp)
+{
+	return lip->li_ops->iop_relog(lip, tp);
+}
+
 #endif	/* __XFS_TRANS_H__ */

