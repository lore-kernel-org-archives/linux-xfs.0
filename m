Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55288C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 163882080C
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qa9EJdFp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgIQDaM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:30:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50722 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgIQDaL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:30:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Obg4116031;
        Thu, 17 Sep 2020 03:30:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Pw4EiUTAxQBqkuRwqaUyr8x8hgbIL4ugmRNyhdC6Wms=;
 b=Qa9EJdFpqUh4a+2qevQwn4yZzLBPEJxhbT6unxJV5ksDvkApN1CA8q5yyG+aDUTqr5CF
 c8kSO0hgROUMXzQLw8+C+eTj1ITB83qLMxfa+CLhbLobX9k/K7nSH5rKSxjjawrfEOnV
 ruaW8go/P4uTgyGpnydDHGb/upQP3AOrXIWy0KgpAIp+O+OpNf/QzRw5oLUvHZgoJeGJ
 J0c1uFWusujhyQrlrHgR/XHMCP5+m2MmWTCistS1ROxHoMNWWlBPfCq7LPmh3HPlRpao
 IAeBRcvxpPUbeOxcNhoZQuvRu4VJ4j4QiAH1rGeSeHLhzYOYA74XWc+YMO1zM59Wd1+x WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91dr5jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:30:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Pb3K080213;
        Thu, 17 Sep 2020 03:30:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h88a27na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:30:04 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08H3U46e020606;
        Thu, 17 Sep 2020 03:30:04 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:30:03 +0000
Subject: [PATCH 2/3] xfs: periodically relog deferred intent items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 16 Sep 2020 20:30:00 -0700
Message-ID: <160031340007.3624707.16729315375941677948.stgit@magnolia>
In-Reply-To: <160031338724.3624707.1335084348340671147.stgit@magnolia>
References: <160031338724.3624707.1335084348340671147.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=3 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
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
periodically so that we can always move the log tail forward.  We do
this every seven loops, having observed that while most chains never
exceed seven items in length, the rest go far over that and seem to
be involved in most of the stall problems.

Callers are now required to ensure that the transaction reservation is
large enough to handle logging done items and new intent items for the
maximum possible chain length.  Most callers are careful to keep the
chain lengths low, so the overhead should be minimal.

(Note that in the next patch we'll make it so that we only relog on
demand, since 7 is an arbitrary number that I used here to get the basic
mechanics working.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  |   30 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.c     |   25 +++++++++++++++++++++++++
 fs/xfs/xfs_extfree_item.c  |   29 +++++++++++++++++++++++++++++
 fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++++++++++
 fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h         |    1 +
 fs/xfs/xfs_trans.h         |   10 ++++++++++
 7 files changed, 149 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 84a70edd0da1..7938e4d3af90 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -361,6 +361,28 @@ xfs_defer_cancel_list(
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
+		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
+		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
+	}
+
+	return xfs_defer_trans_roll(tpp);
+}
+
 /*
  * Log an intent-done item for the first pending intent, and finish the work
  * items.
@@ -422,6 +444,7 @@ xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
 	struct xfs_defer_pending	*dfp;
+	unsigned int			nr_rolls = 0;
 	int				error = 0;
 	LIST_HEAD(dop_pending);
 
@@ -447,6 +470,13 @@ xfs_defer_finish_noroll(
 		if (error)
 			goto out_shutdown;
 
+		/* Every few rolls we relog all the intent items. */
+		if (!(++nr_rolls % 7)) {
+			error = xfs_defer_relog(tp, &dop_pending);
+			if (error)
+				goto out_shutdown;
+		}
+
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
 		error = xfs_defer_finish_one(*tp, dfp);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 8461285a9dd9..2d4c60776714 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -535,6 +535,30 @@ xfs_bui_item_match(
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
+
+	extp = BUI_ITEM(intent)->bui_format.bui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	budp = xfs_trans_get_bud(tp, BUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
+
+	buip = xfs_bui_init(tp->t_mountp);
+	memcpy(buip->bui_format.bui_extents, extp, sizeof(*extp));
+	atomic_set(&buip->bui_next_extent, 1);
+	xfs_trans_add_item(tp, &buip->bui_item);
+	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
+	return &buip->bui_item;
+}
+
 static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_size	= xfs_bui_item_size,
 	.iop_format	= xfs_bui_item_format,
@@ -542,6 +566,7 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_release	= xfs_bui_item_release,
 	.iop_recover	= xfs_bui_item_recover,
 	.iop_match	= xfs_bui_item_match,
+	.iop_relog	= xfs_bui_item_relog,
 };
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f544ec007c12..7c3eebfd9064 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -648,6 +648,34 @@ xfs_efi_item_match(
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
@@ -655,6 +683,7 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_release	= xfs_efi_item_release,
 	.iop_recover	= xfs_efi_item_recover,
 	.iop_match	= xfs_efi_item_match,
+	.iop_relog	= xfs_efi_item_relog,
 };
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 30e579b5857d..9af7099e2a86 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -566,6 +566,32 @@ xfs_cui_item_match(
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
@@ -573,6 +599,7 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_release	= xfs_cui_item_release,
 	.iop_recover	= xfs_cui_item_recover,
 	.iop_match	= xfs_cui_item_match,
+	.iop_relog	= xfs_cui_item_relog,
 };
 
 /*
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 34dd6b02bdc8..535b0358e0aa 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -589,6 +589,32 @@ xfs_rui_item_match(
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
@@ -596,6 +622,7 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_release	= xfs_rui_item_release,
 	.iop_recover	= xfs_rui_item_recover,
 	.iop_match	= xfs_rui_item_match,
+	.iop_relog	= xfs_rui_item_relog,
 };
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a3a35a2d8ed9..362c155be525 100644
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
index 995c1513693c..e838e8327510 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -78,6 +78,8 @@ struct xfs_item_ops {
 	int (*iop_recover)(struct xfs_log_item *lip,
 			   struct xfs_defer_capture **dfcp);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
+	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
+			struct xfs_trans *tp);
 };
 
 /*
@@ -239,4 +241,12 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
 
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

